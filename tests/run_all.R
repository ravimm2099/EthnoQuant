# Run from the EthnoQuant project directory.
stopifnot(file.exists('R_ethnoquant.R'))
source('R_ethnoquant.R')
for (f in c('test_core.R','test_citation_metrics.R','test_group_rates.R',
            'test_input_safeguards.R','test_research_utilities.R',
            'test_column_mapping.R','test_advanced_analytics.R')) {
  cat('Running:', f, '\n')
  old <- getwd()
  tryCatch({
    if (f %in% c('test_core.R','test_citation_metrics.R','test_group_rates.R')) {
      setwd('tests')
      source(f, local=FALSE)
    } else {
      source(file.path('tests',f),local=FALSE)
    }
  }, finally=setwd(old))
}
cat('All available EthnoQuant tests completed.\n')
