source('R_ethnoquant.R')
d <- read.csv('data/sample_citations_with_sex.csv', stringsAsFactors=FALSE)
g <- read.csv('data/sample_group_denominators.csv', stringsAsFactors=FALSE)
x <- eq_sex_uv_stage3(eq_validate(d,6),g)
stopifnot(nrow(x)>0, all(is.finite(x$reports_per_eligible_informant)))
# Conflicting group assignments are rejected.
bad <- d; ids <- which(bad$informant_id == bad$informant_id[1]); stopifnot(length(ids)>1); bad$sex[ids[1]] <- if(bad$sex[ids[1]]=='M') 'F' else 'M'
stopifnot(inherits(try(eq_sex_uv_stage3(eq_validate(bad,6),g),silent=TRUE),'try-error'))
# Conflicting family assignments are rejected.
badfam <- d; badfam$family[1] <- 'Incorrect family'
stopifnot(inherits(try(eq_validate(badfam,6),silent=TRUE),'try-error'))
# Empty species abundance is an error, not silently dropped from EIV.
s <- data.frame(species=c('A','B'),salience=c(.7,.5))
h <- data.frame(habitat=c('H1','H1'),species=c('A','B'),individuals=c(3,0))
stopifnot(inherits(try(eq_eiv(s,h),silent=TRUE),'try-error'))
# Exact EIV numerical reference.
h$individuals[2] <- 1
v <- eq_eiv(s,h)
stopifnot(abs(v$by_habitat$EIV[1]-1.2)<1e-12)
cat('Module assertions passed\n')
