# Genetics Guide

Read this file when users ask about specific inheritance patterns, Punnett squares, Mendel's laws in detail, or modern extensions of classical genetics.

---

## 1. Mendel's Three Laws

### Law of Dominance and Uniformity
When two homozygous plants with contrasting traits are crossed, all offspring (F1) express the dominant trait uniformly. The recessive trait is hidden — *latent*, not lost.

**Mendel's original framing**: He called these "dominating" and "recessive" traits. The terminology survives intact.

### Law of Segregation
Each organism carries two alleles for each trait, inherited one from each parent. These alleles separate during gamete formation — each gamete carries only one.

**Key teaching point**: This is why the 3:1 ratio appears in F2 crosses. If F1 is Aa, then self-crossing produces: AA (1/4), Aa (2/4), aa (1/4). Of these, 3 express the dominant phenotype, 1 expresses recessive.

**Mendel's numbers** (actual experimental data):
| Trait | Dominant | Recessive | Ratio |
|-------|----------|-----------|-------|
| Seed shape | 5,474 round | 1,850 wrinkled | 2.96:1 |
| Seed color | 6,022 yellow | 2,001 green | 3.01:1 |
| Pod shape | 882 inflated | 299 constricted | 2.95:1 |
| Flower color | 705 purple | 224 white | 3.15:1 |
| Flower position | 651 axial | 207 terminal | 3.14:1 |
| Plant height | 787 tall | 277 dwarf | 2.84:1 |
| Pod color | 428 green | 152 yellow | 2.82:1 |

These numbers are suspiciously close to 3:1 — R.A. Fisher noted this in 1936. Whether this reflects confirmation bias or careful selection criteria remains debated.

### Law of Independent Assortment
Genes for different traits assort independently during gamete formation (when located on different chromosomes).

**Key nuance**: This law has an important exception Mendel didn't know — **genetic linkage**. Genes on the *same* chromosome tend to be inherited together. Independent assortment only applies to genes on different chromosomes. Mendel happened to choose 7 traits for 7 chromosome pairs — a fortunate (or deliberately chosen) selection.

---

## 2. Punnett Square Construction

**Monohybrid cross** (one trait, both parents Aa):

```
     A        a
A  | AA  |  Aa  |
a  | Aa  |  aa  |

Phenotype ratio: 3 dominant : 1 recessive
Genotype ratio: 1 AA : 2 Aa : 1 aa
```

**Dihybrid cross** (two traits, both parents AaBb):

Expected phenotype ratio: 9:3:3:1
- 9 A_B_ (dominant-dominant)
- 3 A_bb (dominant-recessive)
- 3 aaB_ (recessive-dominant)
- 1 aabb (recessive-recessive)

**Teaching approach**: Always start by establishing parent genotypes before drawing the square. "What are the parents carrying? Only then can we know what the gametes look like."

---

## 3. Extensions of Mendelian Genetics

These are consistent with Mendel's framework but require expansion beyond what he observed with peas:

### Incomplete Dominance
Neither allele is fully dominant. F1 hybrids show an intermediate phenotype.
*Example*: Red × White snapdragons → Pink offspring (F1)

### Codominance
Both alleles are fully expressed simultaneously.
*Example*: AB blood type — both A and B antigens present

### Multiple Alleles
More than two alleles exist in the population for a single gene (though any individual has at most two).
*Example*: ABO blood type system (IA, IB, i alleles)

### Polygenic Inheritance
Multiple genes contribute to a single trait. Result: continuous variation rather than discrete categories.
*Example*: Human height, skin color

**Note from Mendel's perspective**: "My peas were conveniently binary — round or wrinkled, yellow or green. Human traits are rarely so obliging."

### Epistasis
One gene masks or modifies the expression of another gene. Produces unexpected phenotype ratios (9:3:4, 12:3:1, etc.)

### Sex-Linked Inheritance
Genes on sex chromosomes follow modified inheritance patterns. Mendel's peas have no sex chromosomes — this was discovered by Morgan (1910) using *Drosophila*.

---

## 4. Classical Genetics to Modern Biology

**What Mendel called "factors" → Genes → DNA sequences**

The progression:
1. Mendel (1865): Discrete hereditary factors, two per organism, segregate in ratios
2. Sutton & Boveri (1902): Chromosomal theory of heredity — factors are on chromosomes
3. Morgan (1910s): Genes are on chromosomes, linkage exists, sex-linkage
4. Avery et al. (1944): DNA is the hereditary material (not protein)
5. Watson & Crick (1953): Double helix structure explains replication
6. Modern genomics: Whole-genome sequencing, GWAS, regulatory elements

**Key discontinuities** (where classical Mendelism falls short):
- Epigenetics: Gene expression without DNA sequence change
- Non-coding RNA: Regulatory roles Mendel couldn't have imagined
- Quantitative genetics: Polygenic traits require population-level thinking
- Horizontal gene transfer: Breaks the assumption of vertical inheritance

---

## 5. Common Student Confusions

**"Dominant means more common"** — No. Dominant means it's expressed when present. A dominant trait can be rare in a population (e.g., Huntington's disease).

**"Recessive traits skip generations"** — More accurate: recessive alleles can be carried silently for generations and only appear when two carriers mate.

**"Genes determine traits completely"** — Genotype sets the range; environment and gene-gene interactions shape the phenotype within that range.

**"Mendel's laws apply to all genes"** — Only genes on different chromosomes assort independently. Linked genes break the Law of Independent Assortment.

---

## 6. Mendel's Experimental Design Principles

What made his approach revolutionary for its time:

1. **Choice of model organism**: Peas were ideal — binary traits, easy self- or cross-pollination, fast generations
2. **Statistical thinking**: First biologist to use counting and ratios systematically as evidence
3. **Large sample sizes**: 27,000+ plants over 8 years — unprecedented
4. **Multiple generations**: F1, F2, backcrosses — essential for revealing latent traits
5. **Single-variable logic**: Studied one and then two traits at a time before combining
6. **Control crosses**: Self-pollination to establish true-breeding lines before experimenting

"The value of an experiment is determined by the fitness of the material to the purpose for which it is used." — Mendel, 1865
