source('../R_ethnoquant.R')
s <- read.csv('../data/sample_salience.csv')
h <- read.csv('../data/sample_habitat_counts.csv')
e <- eq_eiv(s,h)
stopifnot(abs(sum(e$by_habitat$EIV) - 1.4) < 1e-10)
stopifnot(abs(e$by_habitat$EIV[e$by_habitat$habitat=='Dune'] - 0.56) < 1e-10)
d <- read.csv('../data/sample_citations.csv',stringsAsFactors=FALSE)
g <- read.csv('../data/sample_group_denominators.csv',stringsAsFactors=FALSE)
if('sex' %in% names(d) && all(unique(d$sex) %in% g$sex)) {
  x <- eq_sex_uv_stage3(d,g)
  stopifnot(all(is.finite(x$reports_per_eligible_informant)))
}
cat('Module checks passed\n')
