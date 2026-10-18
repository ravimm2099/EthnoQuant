# EthnoQuant — GitHub and Zenodo unified source release candidate

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23448854.svg)](https://doi.org/10.5281/zenodo.23448854)
  

**EthnoQuant** is an R Shiny toolkit for quantitative ethnobotany, including citation-based descriptive indices, research metadata, exploratory multivariate analyses (PCA, CCA, clustering, set intersections) and statistical tests (t, Z, ANOVA).

**Researcher:** Dr. Manish Mathur, CTO  
**Affiliation:** ICAR-Central Arid Zone Research Institute, Jodhpur, India  
**Contact:** eco5320@gmail.com

## Start the application

1. Download the ZIP and extract it completely (do not run from inside ZIP).
2. Open RStudio, and set working directory to the `EthnoQuant` directory containing `app.R`.
3. Install dependencies once:

```r
install.packages(c("shiny", "readxl", "vegan"))
```

4. Start:

```r
shiny::runApp(".", launch.browser = TRUE)
```

The application uses local files. For a hosted deployment, review privacy/security implications before allowing uploads of participant-level data.

## Verify

```r
source("tests/run_all.R")
source("tests/test_advanced_analytics.R")
```

All supplied tests passing does **not** certify every formula's scientific validity. The catalog includes provisional/unverified formulas and should not be described as 69 validated calculators. Runtime tests **have not been executed in this packaging environment**.

## Interface artwork

`www/ethnoquant_header.png` is a cropped display header based on the user-approved illustrated design. `www/ethnoquant_full_design_reference.png` is the original full design reference, whose drawn navigation labels are **not clickable**. The actual 10 navigation tabs are functional Shiny tabs, separately styled using CSS. `www/ethnoquant_scientific_logo.png` is the supplied scientific symbol, used as favicon.

## Publish

See [GitHub/Zenodo instructions](../GITHUB_ZENODO_RELEASE_GUIDE.md). Before public release, decide and document the software license and verify artwork rights and research-data privacy. Do not commit real participant-identifying records.

## Unified source structure

The application is the first unified EthnoQuant research release. The former development modules have been consolidated into **`R_ethnoquant.R`**; `app.R` loads only that file. Internal function names originating during development are retained to avoid changing validated call sites. No prior development stages are exposed as separate software editions.

The designation **1.0.0-rc1** identifies a *release candidate*, not a scientifically validated production release. Remove `-rc1` only after successful R runtime tests, benchmark calculations and scientific review.

## Conservation priority (published CPI)
Use the '06c · Conservation priority (CPI)' tab, download the input template, and upload species-level data. See docs/CPI_SOURCE_AND_SCOPE.md. This published CPI is distinct from unresolved registry methods #59 and #63.


## Source-review update: equitability and ICS
Window 06d adds Byg–Balslev inverse-Simpson SEtot/SEi, separately labeled Shannon–Pielou J, and Turner-style ICS from user-scored uses. See docs/PRESENTATION_FORMULA_REVIEW.md. Run tests/test_presentation_indices.R in RStudio.


## New startup and methodological guides

Open `docs/START_HERE.md` for the updated 01–12 navigation, `docs/INDEX_IMPLEMENTATION_POLICY.md` for the 69-method registry interpretation, and `docs/GITHUB_ZENODO_PUBLICATION.md` for release preparation. The first app tab presents this information interactively.
