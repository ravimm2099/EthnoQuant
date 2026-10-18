# Scientific and technical release gates

1. **Source audit** — For each of 69 records, obtain original publications; mark original equation, corrected equation, citation unit, denominator, range, missing-value policy and evidence location. Do not enable unresolved formulas.
2. **Independent gold standards** — Hand-calculate at least one ordinary, zero-denominator, duplicated-record and missing-data example for each enabled method. Compare within numeric tolerance.
3. **Event-aware UV** — Add interview_event_id and a separate events table with actual interview dates; do not derive repeated interviews from duplicate citation rows. Require explicitly defined eligible informants.
4. **Schema separation** — Maintain citation, informant, event, species taxonomy, habitat counts, salience, quality scores, and conservation surveys as separate joinable datasets.
5. **R testing** — Run both included test scripts and launch Shiny on target OS; verify CSV uploads, invalid data handling, charts, ZIP exports and filenames. Install and configure ZIP utilities where needed.
6. **Reproducibility** — Record package versions, input schema version, index definition version, study metadata and a reproducible analysis manifest.
7. **Publication and deployment** — Perform ethics/privacy review, limit upload size, configure access controls, avoid server-side persistence of informant identifiers, and independently review scientific interpretation.

## Known blockers
- Some source formulas missing or ambiguous (notably SIV, relational efficacy, knowledge sharing and conservation composites).
- RI variants and event-based UV require separate definitions.
- ICD denominator must match a versioned coding scheme.
- R interpreter is unavailable in this packaging environment, so no runtime assertions can be claimed.
