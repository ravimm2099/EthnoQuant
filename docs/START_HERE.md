# EthnoQuant — Startup and user guide

## 1. Install and launch
1. Install current R and RStudio.
2. Extract the complete application ZIP into a folder (do not run the Word source-code appendix).
3. In RStudio set the working directory to the extracted `EthnoQuant` folder.
4. Install packages: `install.packages(c("shiny", "readxl", "vegan", "ggplot2", "ggVennDiagram", "zip"))`. Optional dependencies may vary by module.
5. Run `shiny::runApp(".", launch.browser=TRUE)`.

## 2. Recommended workflow
- **01 About EthnoQuant:** software scope, operational analyses, methodological registry and development caveats.
- **02 Data types & templates:** choose an analysis, inspect raw columns / wide matrix structure, download example CSV.
- **03 My study:** upload CSV/XLS/XLSX; map `informant_id` and `species`; provide eligible informant count including non-citers; click Validate & calculate.
- **04 My results:** inspect calculated tables and download CSV.
- **05 Charts:** descriptive figures.
- **06 Habitat EIV:** separate salience and habitat count files.
- **07 Group comparison:** supply eligible denominators for every observed group.
- **08 Formula library:** browse 69 reference records; listing does not imply implementation.
- **08a Advanced indices guide:** methodological guidance.
- **08b Source-based indices:** upload IP/PC citation data. The current combined action may require both ailment and use_type.
- **08c Conservation priority:** upload species-level CPI file with Brazil-specific policy flags.
- **08d Evenness and ICS:** upload informant-species reports or separately scored ICS rows.
- **09 Quality & export:** inspect audit and export reproducibility package.
- **10 Study objectives:** record objectives and hypotheses.
- **11 Multivariate analysis:** PCA, CCA, clustering, and Venn; use matching sample IDs for CCA.
- **12 Statistical tests:** upload numeric observations; verify independence and assumptions.

## 3. Interpreting methods and limitations
The 69-entry formula catalog is a methodological bibliography, **not 69 validated working calculators**. Use the About tab's explicit operational inventory and development registry. Additional source verification, binary presence/absence data, longitudinal interview records, scored use matrices, or other specialized inputs may be required for individual formulas. Unverified or incomplete formulas must not be interpreted as executable.

For citation-level calculations, one row represents a distinct informant–species–use report. `UV_reports_per_eligible` is a report-rate proxy, not interview-event-based Use Value. The Brazilian Campos–Albuquerque CPI is not interchangeable with unrelated ICP/CPI formulas. ICS scores must be supplied using a declared scoring protocol.

## 4. Troubleshooting
If the app fails, start it from the folder containing `app.R` and `R_ethnoquant.R`; preserve `data/`, `reference/`, `www/` and `docs/`. If a calculation reports missing columns, open 02 Data types & templates and compare exact column headings. Restart RStudio after extracting a new release to avoid running an older app.

## 5. Before publication
Run `source("tests/run_all.R")`, test all tabs with the provided templates, and independently verify numerical outputs against published worked examples. The source bundle is not independently R-runtime-tested in this environment.
