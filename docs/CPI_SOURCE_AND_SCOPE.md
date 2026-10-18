# Source-verified Conservation Priority Index (CPI)

**Reference:** Campos, J. L. A. & Albuquerque, U. P. (2021). Indicators of conservation priorities for medicinal plants from seasonal dry forests of northeastern Brazil. *Ecological Indicators*, 121, 106993. https://doi.org/10.1016/j.ecolind.2020.106993

Source: uploaded ICP.pdf, page 2, Materials and methods §2.1 and Table 1 on page 3.

NSC = NSCE / max(NSCE), NP = NPE / max(NPE), RI = NSC + NP, CPI = RI + 0.5 I(RENISUS) + 0.5 I(ANVISA). Maximum CPI=3. Counts and maxima refer to the analyzed species set. Missing counts or flags are rejected, not assumed to be zero. The published Brazilian indicators are not interchangeable with Indian institutional lists without declaring a new adapted method. The paper does not define universal categorical thresholds.

**Critical registry distinction:** Method #59 'Index of Conservation Priority' is a *different* composite method (HEI, HDI, HMI, WF) with incomplete source equation; it remains on hold. The published Campos CPI is provided as an additional, explicitly attributed executable method and is not represented as proof that #59 has been resolved. Likewise method #63 uses a different scoring scheme and is not silently replaced.

ICS.pdf concerns cultural significance (quality × intensity × exclusivity) and imp.pdf concerns palm-use importance/equitability; neither supplies the missing composite #59 ICP equation.

**Testing:** Run `source("tests/test_campos_cpi.R")` in R at the project root. Runtime execution was not available in the build environment.
