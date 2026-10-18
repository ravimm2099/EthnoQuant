# EthnoQuant unified application — consolidation report

## Source provenance

Consolidated from the user-supplied `EthnoQuant App Manish Mathur.zip` without altering mathematical function bodies. The original `R_core.R`, `R_stage5.R`, `R_stage6.R` and `R_stage7.R` were concatenated, with labeled functional sections, into **`R_ethnoquant.R`**. The app now sources only the consolidated file.

## Changes

- Replaced four module imports in `app.R` with one.
- Removed obsolete module files to prevent conflicting edits.
- Replaced legacy development-stage labels in user-visible export metadata and instructions.
- Renamed test scripts to descriptive names and updated the test runner.
- Renamed the example folder to `data/advanced` and updated file references.
- Retained original user artwork, formula registry, sample data, and all ten Shiny windows.
- Set the **first unified release candidate** identifier to `1.0.0-rc1`; this is not a claim of scientific certification.

## Validation limitations

ZIP integrity, required-file presence, and source reference checks are performed during packaging. R is not installed in the packaging environment, so Shiny startup and runtime test results cannot be claimed. Run `source("tests/run_all.R")` and launch the app in RStudio before public release. The 69-method registry is not equivalent to 69 validated calculators.
