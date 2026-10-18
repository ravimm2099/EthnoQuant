# Light-colour Venn display and converted medicinal records

Window 11 > Venn / set intersections accepts a CSV with columns `set,item`.

The attached ethnomedicinal records contained 228 source rows and no genuine informant IDs. The Venn datasets preserve plant names and observed ailment/plant-part associations. Duplicates of the same set and plant were removed; no respondent IDs were invented.

The all-ailments file has 71 categories. Choose 2–5 using the selection control in Window 11. The top 2–5 examples are based on the most frequently represented distinct plant–ailment associations: Flatulence, Constipation, Antidote, Fever, Cough. The plant-part file is a separate optional way to examine overlaps.

Light colours use pastel set outlines and a pale mint-to-ivory intersection gradient. The numeric intersection counts remain exact, but the area of the plotted regions is not proportional to their counts.

Install `ggVennDiagram` and `ggplot2` if not installed. Full R runtime verification has not been performed.
