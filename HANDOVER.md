# ECON 490 — Project Handover (authoritative English version)

Last updated: 14 November 2026 (local time, MST).
This is the single current handover. It replaces the Chinese-language handover
that was previously uploaded to this repository. `README.md` carries the reading
order and the closed decisions; this file carries the detail; then use
`docs/HANDOVER_INDEX.md` for the document map.

Everything here is written for an assistant that has **only this repository**:
no access to the team's course folder, no chat history, and no special tooling.
Where a rule comes from a course document or a website, the filename or URL is
given so it can be checked independently.

---

## 1. What this repository is, and is not

This GitHub repository (`hansenlin05/econ490_project`) is an **information-sync
mirror** between the teammates and their AI assistants. It is **not** a course
submission. The 18 Nov 2026 "Econometric Files" and the 11 Dec 2026 final paper
are submitted from the team's OneDrive project folder to Canvas.

Standing instruction: changes are synced to OneDrive by default. This GitHub
mirror is updated only when the user explicitly asks. Do not treat a GitHub
commit as evidence that anything was submitted to Canvas.

People: Hansen and Neal own the Stata code; Sultana owns the paper text and the
formatted tables.

---

## 2. Research question and direction (frozen)

Question: does longer **father-specific paid leave** reduce the gender
employment gap (male minus female employment rate, percentage points)?
Hypothesis H1 predicts a negative coefficient on the leave variable.

Two independent panels, **never pooled**:

| Sample | Countries | Years | N | Outcome source |
|---|---|---|---|---|
| Primary | 23 European OECD countries | 2006-2019 | 295 | Eurostat `lfst_hhacwnc`, ages 25-54, youngest child under 6 |
| Extension | 26 OECD countries | 2000-2024 | 477 | ILOSTAT household series, child under 6 |

The outcome definitions differ between the two sources, which is why they are
estimated and reported separately. The main explanatory variable is
`lag_fatherweeks10` (lagged father-specific paid leave, in 10-week units).
Every regression includes `lag_lngdp` (lagged log real GDP per capita), which is
the course's required convergence variable. Full control set:
`lag_lngdp lag_gdp_growth leave_gdp`.

Specification: two-way (country and year) fixed effects, with heteroskedasticity
and serial-correlation correction; DiD and an event study are supplementary
checks inside the same framework. Estimates are associations, not causal
effects. The `weeks x pay_c` interaction is deliberately **not** in the main
model (the five reasons are in `README.md` section 7).

**Conclusion to write up:** no robustly significant policy effect; report a
conditional association only. All historically significant p-values are
retired — never roll a specification back to obtain stars.

---

## 3. Current state and progress (as of 15 Nov 2026)

The OneDrive submission package contains exactly nine delivery directories:
`do_files/` (5), `log_files/` (4), `tables/` (10), `figures/` (5),
`data_raw/` (8), `data_final/` (10), plus empty `literature/`, `paper/`,
`slides/`. Nothing else is allowed at the project root — no changelogs, no
handover files, no Chinese notes.

Chain: `do_files/0_master_261109.do` sets paths and calls, in order,
`1_build_data_261109.do`, `2_descriptive_261109.do`, `3_results_261109.do`,
`4_tables_261109.do`. Step 0 of `1_build_data` rebuilds both locked panels
directly from the frozen files in `data_raw/`, so a single master run reproduces
everything from raw inputs. Each numbered do-file opens and closes its own
numbered log. The fifth do-file exists only to keep every log under the
assignment's 25-page limit (see `docs/COURSE_REQUIREMENTS.md`).

Latest verification (15 Nov 2026, full rerun from `data_raw`):
no `r()` errors anywhere; all four analysis CSVs and the 2019 summary-table
CSV keep their md5; every headline coefficient, SE, p-value and N in
`3_results_261109.log` is unchanged. Log sizes are 737 / 354 / 858 / 1087
lines. With 80-character wrapping and a conservative 50 display lines per page
that is about 14.7 / 7.3 / 17.9 / 22.6 pages, all under 25. The quadratic and
winsorized checks were moved from `3_results_261109.do` into
`4_tables_261109.do` to keep both logs under the page limit, so the older
"2396 floats in `3_results`" figure no longer applies; those numbers now live
in `log_files/4_tables_261109.log`.

All 100-point rubric gaps on the code side are closed: five official data
citations in the do-file; a 2019 single-year summary table restricted to rows
with the main regressor, exported as `.csv`, `.xlsx` and `.docx`; a four-column
build-up table with all columns on the same 358 observations; a three-column
subset table whose all-countries column uses 473 observations so 359 + 114
closes; an overlapping two-subset histogram; a full 1/99 winsorized repeat of
all five continuous variables; and the required comments on unmatched merges,
winsorization preference and non-linearity.

**What is still open is human work, not code work** — see
`docs/SUBMISSION_STATUS.md`. In short: the actual Canvas upload, the Canvas
comments, editing the exported Word tables (the assignment explicitly says the
exported table needs editing afterwards), the empty `literature/` and `paper/`
folders, and the 11 Dec paper itself.

---

## 4. Headline numbers (authority: `log_files/3_results_261109.log`)

Europe main table N = 272 / 272 / 272 / 295 / 272 / 295.
OECD extension N = 358 / 358 / 473.

Three `test lag_fatherweeks10 = 0` lines print the exact p-values in the log, so
the numbers quoted in the paper and in the Canvas comments are traceable to a
test rather than read off a table: LSDV clustered `F(1,22) = 3.77`,
`Prob > F = 0.0651`; Europe AR(1) PCSE `chi2(1) = 7.29`, `p = 0.0069`; OECD
AR(1) PCSE `chi2(1) = 0.03`, `p = 0.8599`.

- `lag_fatherweeks10` = +0.668; FE p=0.016, robust p=0.054,
  country-clustered p=0.065; AR(1) PCSE +0.560 (p=0.007).
- DiD -0.626 (p=0.653); event-study periods p=0.878 / 0.815 / 0.817 / 0.603.
- OECD extension columns p=0.846 / 0.860 / 0.467.
- Diagnostics: year-FE `testparm` significant; `xttest3` (heteroskedasticity)
  and `xtserial` (serial correlation) both reject; Hausman favours FE.

Country-clustered standard errors are the reference inference, because the
course note `Preparing for Panel Data Analysis` says to always cluster standard
errors. With only 23 country clusters — below the same note's rough 30-50 floor —
even p=0.065 is optimistic; PCSE is a sensitivity check, not the headline.
Note that both p=0.054 and p=0.065 are country-clustered: `xtreg ..., fe
vce(robust)` is automatically clustered by the panel variable once `xtset` is
set (SE 0.329, p=0.054), while the explicit LSDV `regress ..., vce(cluster
country_id)` gives SE 0.344, p=0.065. The difference is the estimator and
degrees-of-freedom correction, not a clustered-versus-unclustered distinction.
Any document whose numbers disagree with these logs is wrong. Subset and
build-up table numbers live in `log_files/4_tables_261109.log`.

---

## 5. Course rules that are explicitly written down

Primary documents (cite these by filename; do not paraphrase them from memory):

- `Econometric Files for Final Paper.pdf` — Canvas assignment export for the
  18 Nov drop. Contains the 100-point rubric, the ten required items, the
  allowed file types and the 25-page log limit.
- `Final Paper Checklist_ ECON_V 490 003 2026W1 Seminar in Applied Economics.pdf`
  — the 11 Dec paper checklist, 50 points, with four mandatory Stata Files
  gates ("NO PAPER GRADED IF INCOMPLETE").
- `ECON 490 Course Outline.pdf`, p.14 — deadlines and "One set of do, log,
  data, and image files will be uploaded per team to Canvas according to the
  posted checklist."
- `START_HERE_Research_Context.txt` — publication-quality figures/tables and
  the requirement that the do-file rebuilds logs, tables, figures and results.
- `Final Paper Instructions` — at least eight peer-reviewed economics journal
  articles and an AER-style bibliography.
- `18 - Stata Workflow Guide – COMET.pdf` — Workflow Guide 18, the master /
  numbered do-file structure.

The two `...Checklist...` and `Econometric Files...` PDFs are **different
documents with different scopes**. An earlier working note claimed there was
only one checklist and no separate 18 Nov requirements; that conclusion is
retired and must not be revived. Also note that the Canvas PDF still says
"March 23rd" in its body while its header says "Due No Due Date"; that is a
leftover from an older term. The deadline is 18 Nov 2026 per the Course Outline.

Full item-by-item breakdown, points and file-type rules:
`docs/COURSE_REQUIREMENTS.md`.

---

## 6. Course rules that are implicit (not written as one list, but binding)

These are conventions the team derived from the course's own Stata handouts and
lecture notes. They are easy to miss and have caused real rework.

1. **Command vocabulary is restricted.** Only syntax literally demonstrated in
   the course's Stata handouts may appear in a do-file:
   `StataCheatSheet_analysis_19.pdf`, the COMET notebooks (including
   `18 - Stata Workflow Guide – COMET.pdf`), the Stata Test do-files
   (Test One-Seven) and the quiz do-files. Banned examples: `reghdfe`,
   `csdid`, `eventdd`, `bacondecomp`. The two local indexes are
   `docs/CODE_CONVENTIONS.md` §7, which records the course module or
   handout in which each permitted command is demonstrated. Panel lags/leads use
   `L1.` / `F1.` after `encode` + `xtset` + `sort`.
2. **Workflow 18 structure.** Master starts with `/* Project info */`, then
   `clear`, directory settings, project settings, and ordered
   `capture noisily do` calls. `clear all` inside a sub-do-file would erase the
   globals defined by the master and break the chain. Star `*` comments are
   printed into the log, which is what "fully annotated log" needs.
3. **Comment style.** One short `* ` line per block, saying only what the block
   does. No change logs, dates, version notes, references to course module
   numbers, paper-writing advice, or justifications of command syntax.
   `display` is not a workflow requirement; it survives only where an `r()`
   count must be written into the log. The full restatement, with the permitted
   command list and the four documented exceptions, is
   `docs/CODE_CONVENTIONS.md`.
4. **Reproducibility.** Inputs are frozen local snapshots in `data_raw/`. A
   proposed change that read five official endpoints at run time was rejected:
   live revisions would make the submitted log irreproducible, and two of the
   endpoints were unreliable on this machine. Official sites are used for
   citation provenance only.
5. **Precision over byte-identity.** Removing two import options changed only
   float/double storage (max 1.03e-05 pp in Europe); coefficients, SEs, p-values
   and N were unchanged. The team's rule: when a change affects only storage
   precision, prefer full command-whitelist compliance over identical CSV md5.
6. **Root cleanliness.** The OneDrive project root holds only the nine delivery
   directories. Notes, changelogs and handover documents live in the local
   working folder, never in the submission root.
7. **Number authority.** Primary course PDFs > original logs and data >
   official web sources > any earlier AI conclusion (verify each one). Never
   judge a file's version by filename or timestamp: compare bytes. Never treat a
   summary as primary evidence. Keep statistical denominators closed. Do not
   infer agreement from silence.

---

## 7. Pitfalls we already hit (do not repeat)

- **"The European subsample gives more meaningful p-values" is wrong.** The
  Test7 subsample condition is high-income countries and includes Chile and
  Colombia. Earlier wage-gap / 17-industry / 26-country significant results came
  from a research direction retired on 21 Oct.
- **A "new" Test7 do-file was byte-identical to the old one** (md5 + diff).
  Always compare content, not names or timestamps.
- **The first TWFE do-files had no controls and no clustered SEs.** Both were
  added.
- **Winsorization was reported as "handled" when all four `replace` commands
  returned `0 real changes made`.** The current chain uses
  `generate` -> `recast double` -> `replace` and explicitly counts real changes.
- **GDP lag was taken inside the research panel**, dropping the first year and
  the year before gaps. Taking the lag on the full annual WDI series before the
  merge restored 295/295 Europe and 477/477 OECD coverage. The previously
  significant event-study and DiD numbers from the broken version are retired;
  the significance came from sample selection.
- **`generate double` is not in the permitted vocabulary.** The three-step
  `generate` / `recast double` / `replace` version preserves full precision.
- **`etable drop()` is invalid; use `keep()`.** `dtable` does not produce
  min/max; `collapse` + `export excel` does.
- **`inlist()` with 19 string arguments hangs Stata.** Split the country list
  into several `replace` lines.
- **Six added regressions pushed a log past 25 pages.** The table work moved to
  a fifth numbered do-file with its own log; Workflow Guide 18 §18.2.2 allows a
  separate do-file for tables.
- **Live endpoint reads are unreliable and would break reproducibility.** The
  ILOSTAT API endpoint returned HTTP 200 with 0 bytes for both `.csv` and
  `.csv.gz`, and the Eurostat SDMX 3.0 response was 12.7 MB and did not finish
  in 20 s. The ILOSTAT bulk download does work — a 15 November re-download was
  byte-identical to the snapshot — so the reason to ship frozen snapshots is
  that a live revision would change the reported numbers, not that the sources
  cannot be fetched.
- **The non-European subset column is weak** (7 country groups, 114
  observations, coefficient 20.247). It is kept because the rubric requires
  three columns and the split is theory-driven; the table note says explicitly
  that it must not be read as a policy effect. See `docs/RESEARCH_DECISIONS.md`.
- **Canvas file types exclude `.xlsx` and `.dta`.** The summary table is
  exported as both `.csv` and `.docx`; data are uploaded as `.csv`.

- **The build-up table mixed two estimation samples.** The first three columns
  used 443 observations and the fourth 333, because `leave_gdp` is missing for
  110 country-years. Interpreting the coefficient changes as the effect of
  adding controls was therefore invalid. All four columns now use one 358-observation
  sample; the subset table keeps a separate 473-observation all-countries column
  so its two subsets still add up.
- **"All variables winsorized" was only half done.** The original repeat
  winsorized the outcome and lagged log GDP only. The current repeat covers all
  five continuous variables and records that lagged leave weeks changes 0
  observations under a 1/99 rule (its distribution has a mass at zero).
- **Canvas comments quoted N=295 next to a 272-observation coefficient.** 295 is
  the input panel (and the DiD / event-study N); every main FE regression uses
  272. The draft now separates the two.

Full list with evidence: `docs/PITFALLS_AND_CORRECTIONS.md`.

---

## 8. Frozen research decisions

| Decision | Reason |
|---|---|
| Europe primary, OECD extension, never pooled | Different outcome definitions; see `docs/ECON490_SAMPLE_SCOPE_NOTE_261112.txt` |
| 26-country OECD panel is the "all countries" column | Team agreement for the 18 Nov subset table |
| 2019 is the representative year | Latest year with broad coverage for the single-year summary table |
| Subsets: 19 European vs 7 non-European OECD members | Institutional difference in supranational leave mandates; EU Directive (EU) 2019/1158 is listed in the "Further Reading" of `PF2_5_Trends_in_leave_entitlements_around_childbirth.pdf` |
| Keep the non-European column | Rubric demands three columns and overlapping subset histograms; deleting it loses points. Disclosed as low-power |
| Subset table uses the core controls without `leave_gdp` | SOCX coverage is sparse outside Europe; full controls would leave 33 observations there |
| Unwinsorized specification preferred | 1/99 winsorization changes only 4 outcome + 4 lagged-GDP rows and does not move the main coefficient |
| No quadratic or interaction term in the main model | Neither improves fit; the assignment permits non-linearity only when it does |
| Fifth numbered do-file | Keeps every log under 25 pages; the quadratic and winsorized checks also live there so `3_results` stays short |
| Build-up table on one fixed sample | All four columns use the same 358 observations; the subset table keeps its own 473-observation all-countries column so 359 + 114 closes |
| 2019 summary table as `.docx` | Rubric says "Excel or Word document" but Canvas rejects `.xlsx`; the `.csv` and `.xlsx` remain as the content authority |
| Full 1/99 winsorized repeat | Covers all five continuous variables; changes 4 / 0 / 4 / 5 / 5 observations and moves the main coefficient +0.560 -> +0.571 without changing sign or significance |
| Access date 14 November 2026 for all five data sources | Set by the team on the day the final citations were written |

Full rationale: `docs/RESEARCH_DECISIONS.md`. Citation strings and the official
"How to cite" rules: `docs/DATA_CITATIONS.md`.

---

## 9. Reproduce on a fresh machine

1. Install Stata 17 or newer (developed on StataNow/SE 19) and the user-written
   commands `xttest3`, `xtserial`, `coefplot`.
2. Copy the whole `econ490_project` folder, including `data_raw/` — the chain
   does not download anything.
3. Set the working directory to the project root. There is no `cd` line to
   edit: the master uses `global proj_main "."` and every path is relative, so
   the folder can be renamed or moved without touching the code.
4. From the project root run the master; it calls the four numbered do-files.
5. Compare `log_files/` with this repository. Any differing coefficient means
   the reproduction failed.

On a brand-new Stata session `clear` and `clear all` are equivalent for the
first master run; the real portability risks are the `cd` line, missing ado
packages, a Stata version below 17, and a missing `data_raw/`.

---

## 10. Evidence limits and open items

This handover is a secondary document. Re-verify against the course PDFs,
Canvas announcements and the logs after any course-page or code change. The
team's literature PDFs are listed by filename in `docs/LITERATURE_SOURCES.md`;
only those file names, not their full text, are available here.

Open items: Canvas upload and comments; post-export editing of the Word tables
(especially adding explicit "Year FE yes / Country FE yes" rows); opening each
log in Word to confirm the rendered page count; a written group freeze of the
final model including the instructor's verbal "OECD only" suggestion; empty
`literature/` and `paper/` folders; wording for the 23-cluster limitation in
the paper; whether to ask the TA about three minor command extensions; 2 Dec
and 7 Dec poster requirements; 11 Dec final paper.

See `docs/SUBMISSION_STATUS.md` for the actionable checklist and the ready-to-
paste Canvas comments.
