"""
Paper recommendation script — Fetches candidate papers from Semantic Scholar across three tiers.
Search terms are dynamically read from search_config.json, maintained by Claude.

Usage:
  python scripts/recommend.py          # 5 papers per tier
  python scripts/recommend.py --n 8   # 8 papers per tier
"""

import urllib.request
import urllib.parse
import json
import argparse
import os
import time

S2_BASE = "https://api.semanticscholar.org/graph/v1/paper/search"
FIELDS = "title,year,citationCount,journal,authors,externalIds,openAccessPdf,publicationVenue"

_cfg_path = os.path.join(os.path.dirname(__file__), "..", "config.json")
with open(_cfg_path, encoding="utf-8") as _f:
    _cfg = json.load(_f)

HEADERS = {
    "User-Agent": "LitBase/1.0",
    "x-api-key": _cfg.get("s2_api_key", ""),
}
CONFIG_PATH = os.path.join(os.path.dirname(__file__), "..", "search_config.json")


def load_config():
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        config = json.load(f)
    print(f"Config updated: {config.get('last_updated', '?')}")
    print(f"Based on notes: {', '.join(config.get('based_on_notes', []))}")
    print(f"Update reason: {config.get('update_reason', '-')}\n")
    return config["tiers"]


def search_s2(query, n=5, retries=3):
    params = urllib.parse.urlencode({
        "query": query,
        "fields": FIELDS,
        "limit": n,
    })
    url = f"{S2_BASE}?{params}"
    for attempt in range(retries):
        try:
            req = urllib.request.Request(url, headers=HEADERS)
            with urllib.request.urlopen(req, timeout=15) as resp:
                return json.loads(resp.read()).get("data", [])
        except urllib.error.HTTPError as e:
            if e.code == 429 and attempt < retries - 1:
                wait = 10 * (attempt + 1)
                print(f"  [Rate limited, retrying in {wait}s] {query[:40]}...")
                time.sleep(wait)
            else:
                raise
        except Exception as e:
            print(f"  [Error] {query[:40]}: {e}")
            time.sleep(5)
    return []


def format_paper(p, rank):
    title = p.get("title", "N/A")
    year = p.get("year", "?")
    citations = p.get("citationCount", 0)

    venue = p.get("publicationVenue") or p.get("journal") or {}
    journal = venue.get("name", "N/A") if isinstance(venue, dict) else "N/A"

    authors = p.get("authors", [])
    author_names = [a.get("name", "") for a in authors[:3]]
    author_str = ", ".join(author_names)
    if len(authors) > 3:
        author_str += " et al."

    doi = (p.get("externalIds") or {}).get("DOI", "")
    oa_pdf = p.get("openAccessPdf") or {}
    oa_url = oa_pdf.get("url", "")
    oa_str = f"OA: {oa_url}" if oa_url else "Subscription required"
    doi_url = f"https://doi.org/{doi}" if doi else "N/A"

    return (
        f"  [{rank}] {title}\n"
        f"      {author_str} ({year}) | {journal}\n"
        f"      Citations: {citations} | {oa_str}\n"
        f"      DOI: {doi_url}"
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--n", type=int, default=5, help="Number of papers to show per tier")
    args = parser.parse_args()

    tiers = load_config()

    for _, tier_data in tiers.items():
        label = tier_data["label"]
        description = tier_data["description"]
        queries = tier_data["terms"]

        print(f"\n{'='*60}")
        print(f"  {label}  --  {description}")
        print(f"{'='*60}")

        time.sleep(5)  # pause between tiers to avoid rate limiting

        seen = set()
        papers = []
        for q in queries:
            try:
                results = search_s2(q, args.n)
                for p in results:
                    pid = p.get("paperId")
                    if pid and pid not in seen:
                        seen.add(pid)
                        papers.append(p)
                time.sleep(8)  # S2 free API rate limit — keep pace slow
            except Exception as e:
                print(f"  [Search failed] {q}: {e}")

        papers.sort(key=lambda x: x.get("citationCount") or 0, reverse=True)
        papers = papers[:args.n]

        for i, p in enumerate(papers, 1):
            print(format_paper(p, i))
            print()

    print("\n" + "="*60)
    print("  Candidate papers retrieved. Ready for Claude to filter and rank.")
    print("="*60)


if __name__ == "__main__":
    main()
