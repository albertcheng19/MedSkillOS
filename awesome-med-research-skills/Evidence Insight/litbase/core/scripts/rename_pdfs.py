"""
rename_pdfs.py — Automatically rename academic PDF files.

Strategy:
  1. Read embedded metadata via pdfinfo (local, no network requests)
  2. If metadata is incomplete, supplement via CrossRef API (free, no key required)
  3. If both fail, skip the file — never rename blindly

Usage:
  python rename_pdfs.py                # process default directory
  python rename_pdfs.py --dry-run      # preview only, no actual renaming
  python rename_pdfs.py --dir PATH     # specify a directory
"""

import subprocess
import json
import urllib.request
import urllib.parse
import re
import os
import argparse
import time

CONFIG_PATH = os.path.join(os.path.dirname(__file__), "..", "config.json")
with open(CONFIG_PATH, encoding="utf-8") as _f:
    _cfg = json.load(_f)
PDF_DIR = _cfg["data_dir"]


def is_already_renamed(filename):
    """Check if filename already follows the Author_YYYY_Keywords.pdf format."""
    return bool(re.search(r'_\d{4}_', filename))


def run_pdfinfo(path):
    """Read embedded PDF metadata via pdfinfo."""
    try:
        result = subprocess.run(
            ["pdfinfo", path],
            capture_output=True, text=True, timeout=10
        )
        info = {}
        for line in result.stdout.splitlines():
            if ":" in line:
                key, _, val = line.partition(":")
                info[key.strip()] = val.strip()
        return info
    except Exception:
        return {}


def query_crossref(title):
    """Query CrossRef by title, return first result metadata."""
    params = urllib.parse.urlencode({
        "query.title": title,
        "rows": 1,
        "select": "title,author,published"
    })
    url = f"https://api.crossref.org/works?{params}"
    headers = {"User-Agent": "LitBase/1.0 (academic research tool)"}
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, timeout=10) as resp:
            items = json.loads(resp.read()).get("message", {}).get("items", [])
            return items[0] if items else None
    except Exception:
        return None


def parse_year(date_str):
    """Extract a four-digit year from various date string formats."""
    m = re.search(r'(19|20)\d{2}', date_str or "")
    return m.group(0) if m else None


def make_filename(authors, year, title):
    """Generate Author1_Author2_YYYY_Key1_Key2_Key3.pdf"""
    # Take up to the first two author surnames
    last_names = []
    for a in authors[:2]:
        if isinstance(a, dict):
            name = a.get("family") or a.get("name") or ""
        else:
            # "Last, First" or "First Last" format
            parts = str(a).replace(",", "").split()
            name = parts[-1] if parts else ""
        name = re.sub(r"[^a-zA-Z]", "", name).capitalize()
        if name:
            last_names.append(name)

    author_str = "_".join(last_names) or "Unknown"

    # Title keywords: skip stopwords, take first 4
    stopwords = {
        "a", "an", "the", "of", "in", "on", "at", "to", "for",
        "and", "or", "but", "with", "by", "from", "as", "is", "are",
        "its", "their", "this", "that", "it", "be", "has", "have",
    }
    words = re.findall(r"[a-zA-Z]+", title or "")
    keywords = [w.capitalize() for w in words if w.lower() not in stopwords][:4]
    keyword_str = "_".join(keywords) or "Paper"

    return f"{author_str}_{year}_{keyword_str}.pdf"


def process_pdf(path, dry_run=False):
    filename = os.path.basename(path)

    if is_already_renamed(filename):
        print(f"  [skip — already renamed] {filename}")
        return

    print(f"\n  {filename}")

    # Step 1: pdfinfo
    info = run_pdfinfo(path)
    title      = info.get("Title", "").strip()
    author_raw = info.get("Author", "").strip()
    year       = parse_year(info.get("CreationDate", "") or info.get("ModDate", ""))

    authors = []
    if author_raw:
        # Split multiple authors: "A and B" or "A; B"
        for part in re.split(r"\s+and\s+|;\s*", author_raw):
            part = part.strip()
            if part:
                authors.append({"family": part.split()[-1], "given": ""})

    # Step 2: CrossRef (only when metadata is incomplete)
    if title and (not year or not authors):
        print(f"    incomplete metadata, querying CrossRef...")
        time.sleep(0.5)  # polite rate limiting for CrossRef
        cr = query_crossref(title)
        if cr:
            if not authors:
                authors = cr.get("author", [])
            if not year:
                parts = cr.get("published", {}).get("date-parts", [[]])
                if parts and parts[0]:
                    year = str(parts[0][0])
            cr_titles = cr.get("title", [])
            if cr_titles:
                title = cr_titles[0]

    # Step 3: Validate
    if not authors:
        print(f"    could not determine authors — skipping (manual handling required)")
        return
    if not year or not (1900 <= int(year) <= 2030):
        print(f"    could not determine year — skipping (manual handling required)")
        return
    if not title:
        title = re.sub(r"[_\-]+", " ", os.path.splitext(filename)[0])

    new_name = make_filename(authors, year, title)
    new_path = os.path.join(os.path.dirname(path), new_name)

    print(f"    -> {new_name}")

    if not dry_run:
        os.rename(path, new_path)
        print(f"    renamed successfully")
    else:
        print(f"    (dry-run, not executed)")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dir", default=PDF_DIR, help="Directory containing PDFs")
    parser.add_argument("--dry-run", action="store_true", help="Preview only, no actual renaming")
    args = parser.parse_args()

    pdfs = sorted(f for f in os.listdir(args.dir) if f.lower().endswith(".pdf"))
    print(f"Directory: {args.dir}")
    print(f"Found {len(pdfs)} PDF(s)\n")

    for f in pdfs:
        process_pdf(os.path.join(args.dir, f), dry_run=args.dry_run)

    print("\nDone.")


if __name__ == "__main__":
    main()
