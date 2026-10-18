# Scientific and technical validation — the application

## Current scientific scope
The app contains 69 indexed method records, **not** 69 operationally verified calculators. Implemented citation-based results are descriptive proxies where the published method requires interview-event records. In particular `UV_reports_per_eligible` and derived `FUV` are **not** published Phillips–Gentry event-averaged UV and should not be reported as such. Some original equations remain unavailable or ambiguous and are intentionally not enabled.

## Fixed in the application
1. Reject contradictory species–family mappings at the point of input validation.
2. Reject informants assigned to multiple sex groups and observed group counts exceeding supplied eligible group sizes.
3. Reject zero-total-abundance species and noninteger abundance in habitat EIV rather than silently omit them.
4. Add the application regression tests and a single test-runner script.
5. Correct application version and provenance text.

## Testing and release gates
- Run `Rscript tests/run_all.R` from the app root on a machine with R installed. Inspect and resolve every failed assertion.
- Launch with `shiny::runApp('.')`, upload each template and test empty, duplicated, missing, and malformed data.
- Confirm ZIP export works on the target operating system; base `utils::zip()` may require a system zip executable.
- Validate each formula against its original publication and an independently computed example, with versioned input data.
- Document sampling units, missing values, category taxonomies, denominator definitions and participant consent/data governance.
- Record R/package versions and an executed test log before labeling a release production-ready.

## Important scientific cautions
- EIV is an abundance-weighted salience measure for **all included habitats**; habitat omissions affect the denominator.
- Sex-specific results are citation-report rates per eligible group member, not event-based UV.
- Causal therapeutic efficacy, conservation status, and statistical significance cannot be inferred from these descriptive indices.
- ICD chapter count is user-defined; document the coding edition and taxonomy before cross-study comparison.
