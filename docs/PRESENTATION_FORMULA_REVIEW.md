# Review of Presentation1.pptx (9 slides)

- Slide 1: Shannon/Pielou SEtot = H/log(S) is a legitimate *different* evenness index, not Byg & Balslev (2001) SEtot. App provides both separately.
- Slide 2: CUT expression TU/(Ut*S) lacks clear source and operational definitions; not promoted.
- Slide 3: IP = P1-P2 already implemented; no duplicate calculator.
- Slide 4: conflates PC with FIC/FL, which are distinct. Retain existing source-based PC definition.
- Slide 5: SEi = SDi/SDi,max; implemented using original Byg & Balslev inverse-Simpson definition.
- Slide 6: Vs has no definitive equation; remains held.
- Slide 7: weighted major/minor UV describes researcher-defined 1/0.5/0 weights but does not verify a historical standardized UV; optional function added without marking index 47 ready.
- Slide 8: ICS = sum(quality*intensity*exclusivity); implemented with mandatory researcher-supplied scoring and duplicate safeguards; status conditional until scoring rubric validated.
- Slide 9: conservation framework lacks explicit formula; existing Campos–Albuquerque CPI retained, not replaced.

Sources: Byg & Balslev (2001), Biodiversity and Conservation 10:951–970, Tables 1 and 3; Wulandari et al. (2024), International Journal of Design & Nature and Ecodynamics 19:69–80; Campos & Albuquerque (2021), Ecological Indicators 121:106993.

Runtime testing not performed in this environment. The included R tests should be executed before release.
