# Primary-source formula review — supplied PDF collection

The uploaded archive contains 18 PDF documents plus a presentation PDF. This review uses extracted PDF text; complex equations with corrupted mathematical symbols require page-image verification before faithful implementation.

## Equations implemented in the application

- **35 Performance Index (IP):** The supplied *Performance Index of Medicinal Plants.pdf*, section II, explicitly defines C1=species citations for disease, C2=species citations for all diseases, C3=all species citations for disease, C4=all citations. P1=C1/C2, P2=C3/C4, D=P1-P2. IP classes 0,1,2,3 at 0,1/3,2/3 boundaries. The published example C1=1,C2=2,C3=4,C4=155 gives D≈0.4742, IP=2.
- **37 Purpose Consensus (PC):** *imp.pdf*, Table 2, gives PC_s = sum_u(P_u^2)/S, with P_u the fraction of use reports in use type u and S the number of distinct use types. This differs from the former registry candidate which omitted division by S.

## Additional source findings requiring implementation-specific data

- **3 Relative Use Value:** *imp.pdf*, Table 3, gives RUV_i = [sum_s(UV_is/UV_s)]/n, with n the number of useful species; individual informant–species use counts and species mean uses must be defined. Not enabled because generic report rows do not necessarily represent independently counted uses.
- **12/42 Species diversity/equitability:** *imp.pdf* gives SD_i=1/sum_s(P_s^2) and SE_i=SD_i/SD_i,max; do not equate total species equitability to informant-level SE_i without verifying the total definition.
- **23 Disease Consensus Index:** *DCI.pdf* provides an equation, but its PDF text extraction loses exponent placement and variable formatting; needs visual cross-check and questionnaire response scores, not merely citations.
- **43 Syndromic Importance Value:** *Syndromic Importance Value (SIV).pdf* presents an equation as image/garbled characters; requires exact visual transcription and symptom-association scoring data.
- **55 Index of Cultural Significance:** *ICS.pdf* discusses a scored cultural-significance index; exact score definitions and original scoring convention need checking before calculator release.
- **59/60/61/62/63 conservation-priority methods:** Supplied *ICP.pdf*, conservation and forestry papers may inform scoring, but do not establish one interchangeable formula for distinct named indices; each requires matched source, scoring rules and input template.

## Still unverified against an exact source equation

Indices 7, 21, 45, 47, 58, 64, 66 and any remaining unresolved records require matched equations, definitions, and input schemas. The other papers may provide background but are not evidence that all 20 specific registry formulas are correct.

## Runtime and scientific limitations

This environment does not have Rscript installed, so the new Shiny calculations have **not been executed in R**. Inspect the code, run `tests/test_source_verified.R`, and manually verify both new outputs against independent calculations before publication. Only indices 35 and 37 were integrated in this pass. All other status labels remain unchanged.
