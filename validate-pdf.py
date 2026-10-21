#!/usr/bin/env python3
import os
import sys

A4_WIDTH_PT = 595.28
A4_HEIGHT_PT = 841.89
TOLERANCE_PT = 2.0
MAX_PAGES = 2


def main():
    root = os.path.dirname(os.path.abspath(__file__))
    pdf_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(root, "MichaelTrullasGarciaCV.pdf")

    if not os.path.isfile(pdf_path):
        print(f"FAIL: PDF not found: {pdf_path}")
        sys.exit(1)

    try:
        import pypdf
    except ImportError:
        print("FAIL: pypdf is not installed. Run: pip install pypdf")
        sys.exit(1)

    reader = pypdf.PdfReader(pdf_path)
    pages = reader.pages
    errors = []

    if len(pages) > MAX_PAGES:
        errors.append(f"page count is {len(pages)} (must be <= {MAX_PAGES})")

    for i, page in enumerate(pages):
        w = float(page.mediabox.width)
        h = float(page.mediabox.height)
        if abs(w - A4_WIDTH_PT) > TOLERANCE_PT or abs(h - A4_HEIGHT_PT) > TOLERANCE_PT:
            errors.append(
                f"page {i + 1} size is {w:.1f} x {h:.1f} pt (expected A4 {A4_WIDTH_PT} x {A4_HEIGHT_PT} pt)"
            )
        text = (page.extract_text() or "").strip()
        print(f"--- page {i + 1} ({len(text)} chars) ---")
        print(f"  starts: {text[:100]!r}")
        print(f"  ends:   {text[-100:]!r}")

    if errors:
        for e in errors:
            print(f"FAIL: {e}")
        sys.exit(1)

    print(f"PASS: {os.path.basename(pdf_path)} is A4 with {len(pages)} page(s) (max {MAX_PAGES}). Check the previews above for broken page splits.")


if __name__ == "__main__":
    main()
