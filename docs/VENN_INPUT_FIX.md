# Venn analysis: corrected set selection

Open **11 · Multivariate analysis**, choose **Venn / set intersections**, and upload a CSV with exactly the required `set,item` fields (additional fields are ignored). The set selector populates automatically from the uploaded file. Choose **2–5 sets**, then press **Run multivariate analysis**. Files containing 12 or more sets are supported as inputs; only the selected 2–5 sets enter each diagram. Repeated set–item pairs are deduplicated.

The Venn analysis does not require informant identifiers, a study upload, or study column mapping. If a notification about mapping informant IDs appears, it belongs to the independent My Study validation and should not be interpreted as a Venn data-format requirement.

For a rendered Venn diagram, install `ggVennDiagram` and `ggplot2` in R. Exact intersection counts can be exported even when the optional plotting libraries are missing. Geometric overlap areas are not necessarily proportional to intersection counts.

This change was source-inspected but **not tested with an R runtime** in the preparation environment. Test the application in RStudio before publication.
