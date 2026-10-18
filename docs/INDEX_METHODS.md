# the application scientific and data notes

## Branding
The original user-provided EthnoQuant logo is stored unchanged at `www/ethnoquant_logo.png` and appears in the application header and browser icon.

## EIV
For habitat h, EIV(h) = sum_s salience(s) * n(h,s)/sum_h n(h,s). Counts must cover all habitats in the comparison. `salience` is an externally derived species score (e.g., free-list salience); the app does not infer it.

## Sex-specific reports
`citation_reports/eligible_n` is a report-based rate, not the event-averaged Phillips–Gentry UV. Denominators must include eligible non-citers. The `sex` field in the citation CSV must match the `sex` field in the group denominator CSV.

## Known issues and publication safeguards
Original-source equations and scoring rules for some of the 69 numbered indices are unresolved. The app does not calculate these as verified indices. R was not available in the build environment; R tests and Shiny launch remain unexecuted. In addition, citation-level data cannot reconstruct repeated interview events. Never treat consensus as proof of efficacy.
