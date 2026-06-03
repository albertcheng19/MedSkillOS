#!/usr/bin/env python3
"""
Journal Matchmaker - Recommend journals based on abstract content.

Analyzes paper abstracts and matches them with suitable journals based on:
- Research field and scope alignment
- Impact factor requirements
- Journal aims and scope descriptions
- Study design / methodology tolerance
- Tier 1 (high ambition) / Tier 2 (good fit) / Tier 3 (safe target) classification
"""

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass, asdict
from collections import Counter
import math


IF_DISCLAIMER = (
    "\n⚠️  Impact factors shown are approximate (training-knowledge/database snapshot). "
    "Verify current IF at Clarivate JCR (https://jcr.clarivate.com) or the journal's official "
    "website before submission. Acceptance cannot be predicted or guaranteed."
)


@dataclass
class Journal:
    """Represents a journal with its metadata."""
    name: str
    abbreviation: str
    impact_factor: float
    fields: List[str]
    scope: str
    publisher: str
    issn: Optional[str] = None
    open_access: bool = False

    def to_dict(self) -> Dict:
        return asdict(self)


@dataclass
class Recommendation:
    """Represents a journal recommendation with relevance score."""
    journal: Journal
    relevance_score: float
    match_reasons: List[str]
    tier: str = "Tier 2"

    def to_dict(self) -> Dict:
        d = {
            "journal": self.journal.to_dict(),
            "relevance_score": round(self.relevance_score, 3),
            "match_reasons": self.match_reasons,
            "tier": self.tier,
        }
        return d


def score_to_tier(score: float) -> str:
    """Map relevance score to Tier 1/2/3 label.
    Thresholds calibrated to the actual Jaccard-based score distribution
    (pure Jaccard similarity between short abstracts and scope text rarely exceeds 0.50).
    Tier 1: top ambition tier (≥ 0.40); Tier 2: realistic fit (≥ 0.28); Tier 3: safe target (< 0.28).
    """
    if score >= 0.40:
        return "Tier 1"
    elif score >= 0.28:
        return "Tier 2"
    else:
        return "Tier 3"


class AbstractAnalyzer:
    """Analyzes paper abstracts to extract key information."""

    STOPWORDS = {
        'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
        'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'were', 'be',
        'been', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would',
        'could', 'should', 'may', 'might', 'can', 'this', 'that', 'these',
        'those', 'we', 'our', 'us', 'it', 'its', 'they', 'them', 'their',
        'paper', 'study', 'research', 'propose', 'proposed', 'present',
        'demonstrate', 'show', 'results', 'approach', 'method', 'methods'
    }

    # Study design keywords for methodology scoring
    CLINICAL_TRIAL_KEYWORDS = [
        'randomized controlled trial', 'rct', 'clinical trial', 'randomized',
        'double-blind', 'placebo-controlled', 'multicenter', 'multi-center',
        'patients', 'patient', 'participants', 'adverse events', 'primary endpoint',
        'secondary endpoint', 'overall survival', 'progression-free', 'hazard ratio',
        'confidence interval', 'p-value', 'efficacy', 'safety'
    ]

    BASIC_SCIENCE_KEYWORDS = [
        'in vitro', 'in vivo', 'cell line', 'mouse model', 'murine', 'knockout',
        'transfection', 'plasmid', 'crispr', 'gene editing', 'stem cell',
        'western blot', 'flow cytometry', 'immunofluorescence', 'pcr',
        'molecular mechanism', 'signaling pathway', 'protein expression'
    ]

    COMPUTATIONAL_KEYWORDS = [
        'algorithm', 'simulation', 'model', 'dataset', 'benchmark', 'accuracy',
        'precision', 'recall', 'f1', 'auc', 'neural network', 'deep learning',
        'machine learning', 'training', 'inference', 'computation'
    ]

    # Paradigm-shift / broad-interest language → boosts multidisciplinary journals
    MULTIDISCIPLINARY_BOOST_KEYWORDS = [
        'paradigm shift', 'paradigm-shift', 'cross-disciplinary', 'interdisciplinary',
        'transformative', 'breakthrough', 'fundamental discovery', 'broad implications',
        'wide implications', 'general interest', 'transformative implications',
        'cross-field', 'first report', 'first demonstration'
    ]

    FIELD_KEYWORDS = {
        'nlp': [
            'natural language processing', 'text classification', 'named entity recognition',
            'question answering', 'language model', 'sentiment analysis', 'tokenization',
            'text mining', 'information extraction', 'nlu', 'nle', 'dialogue system',
            'machine translation', 'language understanding', 'language generation',
            'parsing', 'coreference', 'semantic role', 'dependency parsing',
            'word embedding', 'bert', 'gpt', 'attention mechanism', 'transformer',
            'nlp benchmark'
        ],
        'computer_vision': [
            'image recognition', 'object detection', 'image segmentation',
            'visual recognition', 'convolutional neural network', 'cnn', 'resnet',
            'image classification', 'video understanding', 'face recognition',
            'optical flow', 'scene understanding', 'image synthesis', '3d reconstruction'
        ],
        'computer_science': [
            'algorithm', 'computational', 'software', 'hardware', 'programming',
            'cloud computing', 'distributed', 'cybersecurity', 'blockchain',
            'database', 'network protocol', 'operating system', 'compiler'
        ],
        'artificial_intelligence': [
            'machine learning', 'deep learning', 'neural network', 'reinforcement learning',
            'large language model', 'ai', 'artificial intelligence', 'generative',
            'classification', 'prediction', 'optimization', 'sparse attention',
            'knowledge graph', 'graph neural', 'multi-modal'
        ],
        'biology': [
            'gene', 'protein', 'cell', 'molecular', 'genome', 'dna', 'rna',
            'organism', 'species', 'ecosystem', 'evolution', 'biological',
            'biochemistry', 'microbiology', 'genetics', 'physiology', 'crispr',
            'stem cell', 'chromatin', 'epigenetic', 'transcription'
        ],
        'medicine': [
            'patient', 'clinical', 'treatment', 'disease', 'diagnosis', 'therapy',
            'medical', 'health', 'healthcare', 'hospital', 'drug', 'medicine',
            'surgery', 'symptom', 'prognosis', 'epidemiology', 'oncology',
            'immunotherapy', 'biomarker', 'survival', 'randomized'
        ],
        'physics': [
            'quantum', 'particle', 'energy', 'thermodynamics', 'electromagnetic',
            'optics', 'mechanics', 'relativity', 'condensed matter', 'astrophysics',
            'nuclear', 'plasma', 'atomic', 'superconductor', 'superconducting',
            'superconductivity', 'density functional', 'variational quantum',
            'quantum eigenvalue', 'phonon', 'critical temperature', 'eigenvalue'
        ],
        'materials_science': [
            'material', 'nanomaterial', 'composite', 'ceramic', 'metal',
            'alloy', 'semiconductor', 'graphene', 'nanotechnology', 'fabrication',
            'crystal structure', 'thin film', 'room-temperature superconductor',
            'high-throughput screening', 'density functional theory', 'dft'
        ],
        'chemistry': [
            'molecule', 'compound', 'reaction', 'catalysis', 'organic chemistry',
            'inorganic chemistry', 'analytical chemistry', 'physical chemistry',
            'polymer', 'spectroscopy', 'synthesis', 'chemical bond', 'reagent',
            'solvent', 'electrochemistry', 'photocatalysis'
        ],
        'environmental_science': [
            'climate change', 'environmental pollution', 'sustainability',
            'conservation', 'renewable energy', 'carbon emission', 'biodiversity',
            'atmospheric', 'ocean', 'water quality', 'climate', 'pollution',
            'ecosystem services', 'deforestation', 'greenhouse'
        ],
        'multidisciplinary': [
            'paradigm shift', 'cross-disciplinary', 'interdisciplinary',
            'transformative', 'breakthrough', 'broad implications', 'general interest',
            'wide implications', 'cross-field', 'paradigm-shifting'
        ],
        'economics': [
            'economic', 'market', 'finance', 'policy', 'trade', 'growth',
            'investment', 'banking', 'monetary', 'fiscal', 'development',
            'behavioral economics', 'econometrics'
        ],
        'psychology': [
            'cognitive', 'behavioral', 'mental', 'psychological', 'neuroscience',
            'perception', 'memory', 'emotion', 'social psychology',
            'clinical psychology'
        ]
    }

    def __init__(self):
        self.field_scores = {}

    def extract_keywords(self, abstract: str, top_n: int = 20) -> List[Tuple[str, float]]:
        text = abstract.lower()
        text = re.sub(r'[^\w\s]', ' ', text)
        words = text.split()
        words = [w for w in words if w not in self.STOPWORDS and len(w) > 2]
        word_freq = Counter(words)
        total_words = len(words)
        tf_scores = {word: count / total_words for word, count in word_freq.items()}
        phrases = []
        for i in range(len(words) - 1):
            bigram = f"{words[i]} {words[i+1]}"
            phrases.append(bigram)
        phrase_freq = Counter(phrases)
        phrase_scores = {phrase: count / max(len(phrases), 1) * 2 for phrase, count in phrase_freq.items()}
        all_terms = {**tf_scores, **phrase_scores}
        sorted_terms = sorted(all_terms.items(), key=lambda x: x[1], reverse=True)
        return sorted_terms[:top_n]

    def detect_field(self, abstract: str) -> List[Tuple[str, float, List[str]]]:
        text = abstract.lower()
        field_scores = {}
        for field, keywords in self.FIELD_KEYWORDS.items():
            score = 0
            matched_keywords = []
            for keyword in keywords:
                count = len(re.findall(r'\b' + re.escape(keyword) + r'\b', text))
                if count > 0:
                    score += count
                    matched_keywords.append(keyword)
            if score > 0:
                field_scores[field] = {'score': score, 'keywords': matched_keywords}
        sorted_fields = sorted(
            [(f, data['score'], data['keywords']) for f, data in field_scores.items()],
            key=lambda x: x[1],
            reverse=True
        )
        return sorted_fields

    def detect_study_design(self, abstract: str) -> str:
        """Detect study design from abstract. Returns 'clinical_trial', 'basic_science', 'computational', or 'other'."""
        text = abstract.lower()
        ct_score = sum(1 for kw in self.CLINICAL_TRIAL_KEYWORDS
                       if re.search(r'\b' + re.escape(kw) + r'\b', text))
        bs_score = sum(1 for kw in self.BASIC_SCIENCE_KEYWORDS
                       if re.search(r'\b' + re.escape(kw) + r'\b', text))
        comp_score = sum(1 for kw in self.COMPUTATIONAL_KEYWORDS
                         if re.search(r'\b' + re.escape(kw) + r'\b', text))
        max_score = max(ct_score, bs_score, comp_score, 0)
        if max_score == 0:
            return 'other'
        if ct_score == max_score:
            return 'clinical_trial'
        if bs_score == max_score:
            return 'basic_science'
        return 'computational'

    def has_paradigm_shift_language(self, abstract: str) -> bool:
        text = abstract.lower()
        return any(kw in text for kw in self.MULTIDISCIPLINARY_BOOST_KEYWORDS)

    def extract_methods(self, abstract: str) -> List[str]:
        method_patterns = [
            r'using ([\w\s]+?)(?:method|approach|technique|algorithm)',
            r'(propose|present|develop) ([\w\s]+?)(?:method|approach|framework)',
            r'(?:based on|via|through) ([\w\s]+?)(?:analysis|learning|modeling)',
            r'([\w]+? learning)',
            r'([\w]+? network)',
        ]
        methods = []
        text = abstract.lower()
        for pattern in method_patterns:
            matches = re.findall(pattern, text)
            for match in matches:
                if isinstance(match, tuple):
                    match = match[-1]
                match = match.strip()
                if 3 < len(match) < 50:
                    methods.append(match)
        return list(set(methods))


class JournalDatabase:
    """Manages journal metadata database."""

    def __init__(self, data_dir: Optional[Path] = None):
        if data_dir is None:
            data_dir = Path(__file__).parent.parent / "references"
        self.data_dir = data_dir
        self.journals: List[Journal] = []
        self.load_journals()

    def load_journals(self):
        journals_file = self.data_dir / "journals.json"
        if not journals_file.exists():
            self._create_default_database()
        with open(journals_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        self.journals = [
            Journal(
                name=j.get('name', ''),
                abbreviation=j.get('abbreviation', ''),
                impact_factor=j.get('impact_factor', 0.0),
                fields=j.get('fields', []),
                scope=j.get('scope', ''),
                publisher=j.get('publisher', ''),
                issn=j.get('issn'),
                open_access=j.get('open_access', False)
            )
            for j in data.get('journals', [])
        ]

    def _create_default_database(self):
        journals_file = self.data_dir / "journals.json"
        default_journals = {
            "journals": [
                # Multidisciplinary (always eligible for high-impact findings)
                {"name": "Nature", "abbreviation": "Nature", "impact_factor": 64.8, "fields": ["multidisciplinary"], "scope": "Publishes the finest peer-reviewed research in all fields of science and technology", "publisher": "Nature Publishing Group", "open_access": False},
                {"name": "Science", "abbreviation": "Science", "impact_factor": 56.9, "fields": ["multidisciplinary"], "scope": "Original scientific research and cutting-edge research news", "publisher": "AAAS", "open_access": False},
                {"name": "Nature Communications", "abbreviation": "Nat Commun", "impact_factor": 16.6, "fields": ["multidisciplinary"], "scope": "High-quality research across all natural sciences", "publisher": "Nature Publishing Group", "open_access": True},
                {"name": "Science Advances", "abbreviation": "Sci Adv", "impact_factor": 13.6, "fields": ["multidisciplinary"], "scope": "Open access multidisciplinary research", "publisher": "AAAS", "open_access": True},
                {"name": "PNAS", "abbreviation": "PNAS", "impact_factor": 11.1, "fields": ["multidisciplinary"], "scope": "Broad multidisciplinary research across all sciences", "publisher": "NAS", "open_access": False},

                # Nature Subject Journals
                {"name": "Nature Medicine", "abbreviation": "Nat Med", "impact_factor": 58.7, "fields": ["medicine", "biology"], "scope": "Research and review articles in biomedical sciences and clinical medicine", "publisher": "Nature Publishing Group", "open_access": False},
                {"name": "Nature Methods", "abbreviation": "Nat Methods", "impact_factor": 48.0, "fields": ["biology", "methods"], "scope": "New methods and significant improvements in life sciences", "publisher": "Nature Publishing Group", "open_access": False},
                {"name": "Nature Biotechnology", "abbreviation": "Nat Biotechnol", "impact_factor": 46.9, "fields": ["biology", "biotechnology"], "scope": "Biological research with commercial applications", "publisher": "Nature Publishing Group", "open_access": False},
                {"name": "Nature Machine Intelligence", "abbreviation": "Nat Mach Intell", "impact_factor": 25.0, "fields": ["artificial_intelligence", "computer_science"], "scope": "Machine learning, robotics and AI research", "publisher": "Nature Publishing Group", "open_access": False},
                {"name": "Nature Cancer", "abbreviation": "Nat Cancer", "impact_factor": 23.5, "fields": ["medicine", "biology"], "scope": "Cancer research across all disciplines", "publisher": "Nature Publishing Group", "open_access": False},
                {"name": "Nature Materials", "abbreviation": "Nat Mater", "impact_factor": 47.9, "fields": ["materials_science", "physics", "chemistry"], "scope": "Materials science research including superconductors, nanomaterials, and functional materials", "publisher": "Nature Publishing Group", "open_access": False},
                {"name": "Nature Physics", "abbreviation": "Nat Phys", "impact_factor": 19.6, "fields": ["physics"], "scope": "Pure and applied physics research including condensed matter, quantum physics", "publisher": "Nature Publishing Group", "open_access": False},
                {"name": "Nature Climate Change", "abbreviation": "Nat Clim Chang", "impact_factor": 29.6, "fields": ["environmental_science"], "scope": "Climate change research and Earth science", "publisher": "Nature Publishing Group", "open_access": False},

                # Science Subject Journals
                {"name": "Science Translational Medicine", "abbreviation": "Sci Transl Med", "impact_factor": 17.1, "fields": ["medicine", "biology"], "scope": "Translational medical research", "publisher": "AAAS", "open_access": False},

                # Cell Family
                {"name": "Cell", "abbreviation": "Cell", "impact_factor": 64.5, "fields": ["biology", "basic_science"], "scope": "Fundamental research in cell biology, molecular biology, and biochemistry — primarily basic science", "publisher": "Cell Press", "open_access": False},
                {"name": "Cell Research", "abbreviation": "Cell Res", "impact_factor": 44.1, "fields": ["biology", "basic_science"], "scope": "Cell biology and molecular cell biology — primarily basic science", "publisher": "Nature Publishing Group", "open_access": False},
                {"name": "Cancer Cell", "abbreviation": "Cancer Cell", "impact_factor": 48.8, "fields": ["medicine", "biology"], "scope": "Molecular and cellular aspects of cancer biology", "publisher": "Cell Press", "open_access": False},

                # Clinical / Medical Journals
                {"name": "The Lancet", "abbreviation": "Lancet", "impact_factor": 168.9, "fields": ["medicine"], "scope": "General medical research and clinical trials; flagship for large RCTs", "publisher": "Elsevier", "open_access": False},
                {"name": "New England Journal of Medicine", "abbreviation": "NEJM", "impact_factor": 91.2, "fields": ["medicine"], "scope": "Clinical medicine and landmark clinical trials; premier venue for RCTs", "publisher": "NEJM Group", "open_access": False},
                {"name": "JAMA", "abbreviation": "JAMA", "impact_factor": 120.7, "fields": ["medicine"], "scope": "Medical sciences, clinical trials, and public health", "publisher": "American Medical Association", "open_access": False},
                {"name": "BMJ", "abbreviation": "BMJ", "impact_factor": 105.7, "fields": ["medicine"], "scope": "Clinical medicine, clinical trials, and systematic reviews", "publisher": "BMJ Publishing Group", "open_access": False},
                {"name": "Journal of Clinical Oncology", "abbreviation": "JCO", "impact_factor": 42.1, "fields": ["medicine"], "scope": "Clinical oncology, clinical trials in cancer treatment", "publisher": "ASCO", "open_access": False},
                {"name": "Annals of Internal Medicine", "abbreviation": "Ann Intern Med", "impact_factor": 39.2, "fields": ["medicine"], "scope": "Internal medicine research, clinical evidence, and guidelines", "publisher": "ACP", "open_access": False},
                {"name": "JAMA Network Open", "abbreviation": "JAMA Netw Open", "impact_factor": 13.8, "fields": ["medicine"], "scope": "Open access general medicine, clinical research, public health", "publisher": "American Medical Association", "open_access": True},
                {"name": "eClinicalMedicine", "abbreviation": "eClinMed", "impact_factor": 15.1, "fields": ["medicine"], "scope": "Clinical medicine and health sciences, fully open access", "publisher": "Elsevier / The Lancet", "open_access": True},

                # AI / ML Journals (general)
                {"name": "IEEE Transactions on Pattern Analysis and Machine Intelligence", "abbreviation": "IEEE TPAMI", "impact_factor": 20.8, "fields": ["computer_vision", "artificial_intelligence"], "scope": "Pattern recognition, machine intelligence, computer vision applications", "publisher": "IEEE", "open_access": False},
                {"name": "International Journal of Computer Vision", "abbreviation": "IJCV", "impact_factor": 19.5, "fields": ["computer_vision"], "scope": "Computer vision theory and applications", "publisher": "Springer", "open_access": False},
                {"name": "IEEE Transactions on Neural Networks and Learning Systems", "abbreviation": "IEEE TNNLS", "impact_factor": 10.4, "fields": ["artificial_intelligence", "neural_networks"], "scope": "Neural networks and machine learning systems", "publisher": "IEEE", "open_access": False},
                {"name": "Neural Networks", "abbreviation": "Neural Netw", "impact_factor": 7.8, "fields": ["artificial_intelligence", "neural_networks"], "scope": "Neural network research and applications", "publisher": "Elsevier", "open_access": False},
                {"name": "Machine Learning", "abbreviation": "Mach Learn", "impact_factor": 5.0, "fields": ["artificial_intelligence", "machine_learning"], "scope": "Machine learning algorithms and theory", "publisher": "Springer", "open_access": False},
                {"name": "Journal of Machine Learning Research", "abbreviation": "JMLR", "impact_factor": 4.3, "fields": ["artificial_intelligence", "machine_learning"], "scope": "Machine learning research", "publisher": "JMLR", "open_access": True},

                # NLP / Computational Linguistics
                {"name": "Computational Linguistics", "abbreviation": "Comput Linguist", "impact_factor": 8.6, "fields": ["nlp", "computational_linguistics"], "scope": "Computational approaches to linguistics, NLP, language analysis", "publisher": "MIT Press", "open_access": False},
                {"name": "Transactions of the Association for Computational Linguistics", "abbreviation": "TACL", "impact_factor": 6.0, "fields": ["nlp", "computational_linguistics"], "scope": "Natural language processing and computational linguistics research", "publisher": "ACL", "open_access": True},
                {"name": "IEEE Transactions on Knowledge and Data Engineering", "abbreviation": "IEEE TKDE", "impact_factor": 8.9, "fields": ["data_mining", "computer_science", "artificial_intelligence"], "scope": "Knowledge and data engineering, information systems", "publisher": "IEEE", "open_access": False},

                # Environmental / Earth Science
                {"name": "Environmental Science & Technology", "abbreviation": "Environ Sci Technol", "impact_factor": 11.4, "fields": ["environmental_science", "chemistry"], "scope": "Environmental science, pollution, environmental chemistry and engineering", "publisher": "ACS", "open_access": False},
                {"name": "Global Change Biology", "abbreviation": "Glob Change Biol", "impact_factor": 13.9, "fields": ["environmental_science", "biology"], "scope": "Biological impacts of climate change and environmental change", "publisher": "Wiley", "open_access": False},

                # Materials Science / Physics
                {"name": "Advanced Materials", "abbreviation": "Adv Mater", "impact_factor": 29.4, "fields": ["materials_science", "nanotechnology", "chemistry"], "scope": "Materials science and engineering, nanomaterials, functional materials", "publisher": "Wiley", "open_access": False},
                {"name": "Physical Review Letters", "abbreviation": "Phys Rev Lett", "impact_factor": 8.0, "fields": ["physics"], "scope": "Brief reports of significant physics research including condensed matter and quantum physics", "publisher": "APS", "open_access": False},
                {"name": "Physical Review X", "abbreviation": "PRX", "impact_factor": 15.6, "fields": ["physics", "multidisciplinary"], "scope": "High-impact physics research across all areas; open access", "publisher": "APS", "open_access": True},
                {"name": "npj Quantum Materials", "abbreviation": "npj Quantum Mater", "impact_factor": 9.1, "fields": ["materials_science", "physics"], "scope": "Quantum materials, superconductors, topological materials", "publisher": "Nature Publishing Group", "open_access": True},
            ]
        }
        self.data_dir.mkdir(parents=True, exist_ok=True)
        with open(journals_file, 'w', encoding='utf-8') as f:
            json.dump(default_journals, f, indent=2, ensure_ascii=False)

    def filter_by_field(self, fields: List[str]) -> List[Journal]:
        filtered = []
        for journal in self.journals:
            if any(f in journal.fields for f in fields):
                filtered.append(journal)
        return filtered

    def filter_by_impact_factor(self, min_if: float = 0.0, max_if: Optional[float] = None) -> List[Journal]:
        return [
            j for j in self.journals
            if j.impact_factor >= min_if and (max_if is None or j.impact_factor <= max_if)
        ]

    def get_multidisciplinary(self) -> List[Journal]:
        return [j for j in self.journals if 'multidisciplinary' in j.fields]

    def get_all(self) -> List[Journal]:
        return self.journals


class JournalMatchmaker:
    """Main class for journal recommendation."""

    # Journals that primarily publish basic-science studies (not clinical trials/large cohorts)
    BASIC_SCIENCE_ONLY_JOURNALS = {
        "Cell", "Cell Research", "Nature Methods", "Nature Biotechnology",
    }

    def __init__(self):
        self.analyzer = AbstractAnalyzer()
        self.database = JournalDatabase()

    def calculate_scope_similarity(self, abstract: str, journal: Journal) -> float:
        abstract_keywords = set([k[0] for k in self.analyzer.extract_keywords(abstract, 30)])
        scope_text = journal.scope.lower()
        scope_keywords = set(re.findall(r'\b\w+\b', scope_text))
        if not abstract_keywords or not scope_keywords:
            return 0.0
        intersection = abstract_keywords & scope_keywords
        union = abstract_keywords | scope_keywords
        return len(intersection) / len(union) if union else 0.0

    def calculate_field_match_score(self, detected_fields: List[Tuple[str, float, List[str]]], journal: Journal) -> float:
        if not detected_fields:
            return 0.5
        score = 0.0
        weights = [0.50, 0.30, 0.20]
        for i, (field, field_score, _) in enumerate(detected_fields[:3]):
            w = weights[i] if i < len(weights) else 0.10
            if field in journal.fields:
                score += field_score * w
        return min(score, 1.0)

    def calculate_methodology_penalty(self, study_design: str, journal: Journal) -> float:
        """
        Return a penalty factor (0.0–1.0) to multiply the relevance score by.
        1.0 = no penalty; 0.1 = severe mismatch.
        """
        # Clinical trials should not rank basic-science-only journals highly
        if study_design == 'clinical_trial' and journal.name in self.BASIC_SCIENCE_ONLY_JOURNALS:
            return 0.2  # Heavy penalty

        # Basic science papers should not rank clinical journals at top
        if study_design == 'basic_science' and 'medicine' in journal.fields and 'biology' not in journal.fields:
            # Clinical-only journals (NEJM, Lancet, JAMA) should score lower for pure basic science
            return 0.5

        return 1.0

    def calculate_method_match_score(self, methods: List[str], journal: Journal) -> float:
        if not methods:
            return 0.5
        journal_scope = journal.scope.lower()
        matches = sum(1 for m in methods if m.lower() in journal_scope)
        return min(matches / len(methods), 1.0)

    def recommend(self, abstract: str, field: Optional[str] = None,
                  min_if: float = 0.0, max_if: Optional[float] = None,
                  count: int = 5, open_access_only: bool = False) -> List[Recommendation]:
        keywords = self.analyzer.extract_keywords(abstract, 20)
        detected_fields = self.analyzer.detect_field(abstract)
        methods = self.analyzer.extract_methods(abstract)
        study_design = self.analyzer.detect_study_design(abstract)
        has_paradigm_shift = self.analyzer.has_paradigm_shift_language(abstract)

        # Determine target fields — merge user-specified field with auto-detected
        target_fields = []
        if field:
            user_field = field.lower().replace(' ', '_')
            # Always combine user-specified field with auto-detected top fields
            auto_fields = [f[0] for f in detected_fields[:2]]
            target_fields = list(dict.fromkeys([user_field] + auto_fields))  # dedup, preserve order
        elif detected_fields:
            target_fields = [f[0] for f in detected_fields[:2]]

        # Build candidate pool
        if target_fields:
            field_filtered = self.database.filter_by_field(target_fields)
        else:
            field_filtered = self.database.get_all()

        # Always include multidisciplinary journals (Nature, Science, etc.)
        multidisciplinary = self.database.get_multidisciplinary()
        seen_names = set()
        candidates = []
        for j in field_filtered + multidisciplinary:
            if j.name not in seen_names:
                seen_names.add(j.name)
                candidates.append(j)

        # Apply IF filter
        candidates = [
            j for j in candidates
            if j.impact_factor >= min_if and (max_if is None or j.impact_factor <= max_if)
        ]

        # Apply OA filter
        if open_access_only:
            candidates = [j for j in candidates if j.open_access]

        # Score each journal
        recommendations = []
        for journal in candidates:
            scope_sim = self.calculate_scope_similarity(abstract, journal)
            field_match = self.calculate_field_match_score(detected_fields, journal)
            method_match = self.calculate_method_match_score(methods, journal)
            # Normalize IF to [0,1] (cap at 200)
            if_norm = min(journal.impact_factor / 200.0, 1.0)

            total_score = (
                scope_sim * 0.35 +
                field_match * 0.30 +
                method_match * 0.15 +
                if_norm * 0.20
            )

            # Apply methodology penalty (scale down mismatched journals)
            penalty = self.calculate_methodology_penalty(study_design, journal)
            total_score *= penalty

            # Boost multidisciplinary journals when paradigm-shift language detected
            if has_paradigm_shift and 'multidisciplinary' in journal.fields:
                total_score = min(total_score * 1.25, 1.0)

            # Generate match reasons
            reasons = []
            top_fields = [f[0] for f in detected_fields[:2]]
            matched = [f for f in top_fields if f in journal.fields]
            if matched:
                reasons.append(f"Field alignment: {', '.join(matched)}")
            if scope_sim > 0.08:
                reasons.append("Scope keyword overlap")
            if journal.open_access:
                reasons.append("Open access")
            if penalty < 0.5:
                reasons.append(f"⚠️ Methodology mismatch (study design: {study_design})")
            elif journal.impact_factor >= 30:
                reasons.append(f"High impact ({journal.impact_factor:.1f})")

            tier = score_to_tier(total_score)

            recommendations.append(Recommendation(
                journal=journal,
                relevance_score=total_score,
                match_reasons=reasons if reasons else ["Scope overlap detected"],
                tier=tier
            ))

        recommendations.sort(key=lambda x: x.relevance_score, reverse=True)
        return recommendations[:count]

    def format_output(self, recommendations: List[Recommendation], output_format: str = 'table') -> str:
        if output_format == 'json':
            data = [r.to_dict() for r in recommendations]
            result = json.dumps(data, indent=2, ensure_ascii=False)
            result += f"\n// {IF_DISCLAIMER.strip()}"
            return result

        elif output_format == 'markdown':
            lines = ["# Journal Recommendations\n"]
            current_tier = None
            for i, rec in enumerate(recommendations, 1):
                if rec.tier != current_tier:
                    current_tier = rec.tier
                    tier_desc = {
                        "Tier 1": "High ambition (highly competitive; consider if evidence strength supports it)",
                        "Tier 2": "Good fit (solid IF, good scope match, realistic acceptance)",
                        "Tier 3": "Safe target (reliable acceptance for this design and evidence level)",
                    }.get(rec.tier, "")
                    lines.append(f"## {rec.tier} — {tier_desc}\n")
                j = rec.journal
                lines.append(f"### {i}. {j.name} `[{rec.tier}]`")
                lines.append(f"- **Abbreviation**: {j.abbreviation}")
                lines.append(f"- **Impact Factor**: ~{j.impact_factor} *(approximate — verify at JCR)*")
                lines.append(f"- **Publisher**: {j.publisher}")
                lines.append(f"- **Open Access**: {'Yes' if j.open_access else 'No (or Hybrid)'}")
                lines.append(f"- **Relevance Score**: {rec.relevance_score:.3f}")
                lines.append(f"- **Match Reasons**: {', '.join(rec.match_reasons)}")
                lines.append(f"- **Scope**: {j.scope}\n")
            lines.append("---")
            lines.append(IF_DISCLAIMER)
            return '\n'.join(lines)

        else:  # table format
            lines = [
                "=" * 130,
                f"{'Rank':<5} {'Tier':<8} {'Journal':<42} {'IF':<8} {'Score':<7} {'OA':<4} {'Key Match Reasons'}",
                "-" * 130
            ]
            for i, rec in enumerate(recommendations, 1):
                j = rec.journal
                reasons_str = ', '.join(rec.match_reasons[:2])
                oa = 'Yes' if j.open_access else 'No'
                lines.append(
                    f"{i:<5} {rec.tier:<8} {j.name[:41]:<42} {j.impact_factor:<8.1f} "
                    f"{rec.relevance_score:<7.3f} {oa:<4} {reasons_str}"
                )
            lines.append("=" * 130)
            lines.append(f"\nTotal: {len(recommendations)} recommendations")
            lines.append(IF_DISCLAIMER)
            return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(
        description='Journal Matchmaker — Recommend journals by abstract analysis',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python main.py --abstract "Your abstract text here"
  python main.py --abstract abstract.txt --file --min-if 5.0
  python main.py --abstract "..." --field medicine --open-access --count 5
        """
    )

    parser.add_argument('--abstract', required=True,
                        help='Paper abstract text or path to file containing abstract')
    parser.add_argument('--file', action='store_true',
                        help='Treat --abstract as file path')
    parser.add_argument('--field',
                        help='Research field (e.g., medicine, biology, nlp, physics, materials_science)')
    parser.add_argument('--min-if', type=float, default=0.0,
                        help='Minimum impact factor threshold (default: 0.0)')
    parser.add_argument('--max-if', type=float, default=None,
                        help='Maximum impact factor threshold (optional)')
    parser.add_argument('--count', type=int, default=5,
                        help='Number of recommendations (default: 5)')
    parser.add_argument('--format', choices=['table', 'json', 'markdown'], default='table',
                        help='Output format (default: table)')
    parser.add_argument('--open-access', action='store_true',
                        help='Restrict recommendations to fully open-access journals only')

    args = parser.parse_args()

    if args.file:
        with open(args.abstract, 'r', encoding='utf-8') as f:
            abstract = f.read()
    else:
        abstract = args.abstract

    if len(abstract) < 50:
        print("Error: Abstract too short. Please provide a complete abstract (at least 50 characters).",
              file=sys.stderr)
        sys.exit(1)

    matchmaker = JournalMatchmaker()

    print("Analyzing abstract...")
    print(f"Length: {len(abstract)} characters")

    analyzer = AbstractAnalyzer()
    detected_fields = analyzer.detect_field(abstract)
    study_design = analyzer.detect_study_design(abstract)
    if detected_fields:
        print(f"Detected fields: {', '.join([f[0] for f in detected_fields[:3]])}")
    print(f"Detected study design: {study_design}")

    print(f"\nSearching journals (IF >= {args.min_if}"
          + (f", open-access only" if args.open_access else "") + ")...\n")

    recommendations = matchmaker.recommend(
        abstract=abstract,
        field=args.field,
        min_if=args.min_if,
        max_if=args.max_if,
        count=args.count,
        open_access_only=args.open_access
    )

    if not recommendations:
        print("No matching journals found. Try relaxing your criteria (lower --min-if or remove --open-access).")
        sys.exit(0)

    output = matchmaker.format_output(recommendations, args.format)
    print(output)


if __name__ == '__main__':
    main()
