EthnoQuant compiled-records correction (18 October 2026)

1. Close all previous running EthnoQuant Shiny sessions.
2. Extract this ZIP to a NEW folder; open that folder/EthnoQuant in RStudio.
3. Run shiny::runApp(".", launch.browser=TRUE).
4. Go to 03 My study; choose Dataset type = Compiled species-use records.
5. Upload data/06_EthnoQuant_Compiled_Records_Ready.csv.
6. Under column mapping choose species=species, family=family, use_category=use_category,
   use_type=use_type, ailment=ailment, plant_part=plant_part, preparation=preparation.
   Informant ID is not needed in compiled mode.
7. Click Validate & calculate; inspect 04 My results.

This mode generates only descriptive tables. It never calculates RFC, FL, UV, ICF or other respondent-based metrics from compiled records.
The file's record_id values are preserved in the CSV, not mapped to informant_id.
No R executable was available in the preparation environment; local runtime verification remains necessary.
