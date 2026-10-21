# AGENTS.md

This repository contains the CV (curriculum vitae) of Michael Trullas Garcia.

## Files

- `index.html` — the CV in HTML.
- `styles.css` — all styling, including print styles.
- `logos/` — company logos referenced by `index.html`.
- `MichaelTrullasGarciaCV.pdf` — the generated PDF (deliverable).
- `MichaelTrullasGarciaCV.docx` — legacy Word export.

## Rules

- The CV MUST be in **A4 format** (210mm × 297mm). Do not change `@page { size: A4; }` in `styles.css`.
- Keep the page margins in `@page` (20mm top/bottom, 15mm left/right) and the matching `.page` padding.
- The CV should be at most **2 pages** when printed. If content overflows, condense it instead of enlarging fonts.
- Keep `break-inside: avoid` on `.experience`, `.two-col` and small `.section`s so entries never split across pages. The long Work Experience section must stay splittable between entries (`.section:has(.experience) { break-inside: auto; }`) or it gets pushed to page 2 and the CV overflows to 3 pages.
- Base font size is 10pt with `Segoe UI`; keep the blue accent color `#2b5797`. Do not introduce new fonts or colors without a reason.
- When editing the CV, keep the structure: Header (name, contact, links) → Summary → Work Experience (newest first) → Opensource contributions → Languages / More information.
- Do not add code comments unless explicitly asked.

## Generating the PDF

After any change to `index.html` or `styles.css`, regenerate and validate from the repo root:

```powershell
.\generate-pdf.ps1
python validate-pdf.py
```

- `generate-pdf.ps1` prints `index.html` to PDF with headless Chrome (falls back to Edge), honoring the `@page` A4 size and `--no-pdf-header-footer`, and atomically replaces `MichaelTrullasGarciaCV.pdf` (via `cv_tmp.pdf`) to avoid OneDrive file locks.
- `validate-pdf.py` checks the PDF is A4 (595.28 × 841.89 pt ±2) and ≤ 2 pages, and prints the first/last 100 chars of each page so you can eyeball page splits. Requires `pip install pypdf`.
- Open the PDF to verify it looks correct and has no broken page splits.
