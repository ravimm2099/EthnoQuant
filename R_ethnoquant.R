# EthnoQuant — consolidated analytical engine
# Single-source release; contains all functions from the supplied original modules.
# The function implementations below are retained; no mathematical algorithms have been altered.


# ========================================================================
# CORE ETHNOBOTANICAL CALCULATIONS
# ========================================================================

# EthnoQuant reproducible core: one row = one informant/species/use-category/use-type citation.
# Explicitly declared eligible respondent denominator, no imputation, zero denominator -> NA.
eq_div <- function(a,b) ifelse(is.na(b) | b <= 0, NA_real_, a/b)
eq_validate <- function(d, N) {
  required <- c('informant_id','species','family','use_category','use_type','ailment','plant_part','collection_site','collection_period','preparation')
  missing <- setdiff(required,names(d)); if(length(missing)) stop('Missing required columns: ',paste(missing,collapse=', '))
  if(!is.numeric(N) || length(N)!=1 || !is.finite(N) || N < 1 || N != as.integer(N)) stop('Eligible respondent count must be a positive integer')
  if(nrow(d)==0) stop('No observations')
  for(nm in required) {d[[nm]]<-trimws(as.character(d[[nm]]));d[[nm]][d[[nm]]=='']<-NA_character_}
  if(anyNA(d$informant_id) || anyNA(d$species)) stop('Informant ID and species cannot be missing')
  if(length(unique(d$informant_id))>N) stop('Observed unique informants exceed eligible respondent count')
  if(anyDuplicated(d[c('informant_id','species','use_category','use_type','ailment','plant_part','collection_site','collection_period','preparation')])) stop('Duplicate citation rows detected: remove exact duplicates or define a unique event/citation identifier')
  # Every species must map to no more than one nonmissing family.
  fam <- unique(d[!is.na(d$family), c('species','family'),drop=FALSE])
  if(anyDuplicated(fam$species)) stop('Conflicting family assignments for species')
  d
}
eq_species <- function(d,N) {
  species <- sort(unique(d$species))
  out <- lapply(species,function(s){z<-d[d$species==s,,drop=FALSE]; fc<-length(unique(z$informant_id)); cats<-length(unique(na.omit(z$use_category)));types<-length(unique(na.omit(z$use_type))); data.frame(species=s,reports=nrow(z),FC=fc,RFC=fc/N,UV_reports_per_eligible=nrow(z)/N,category_count=cats,use_type_count=types,stringsAsFactors=FALSE)})
  do.call(rbind,out)
}
eq_icf <- function(d) {
  z<-d[!is.na(d$ailment),,drop=FALSE]; if(!nrow(z))return(data.frame())
  groups<-split(z,z$ailment);do.call(rbind,lapply(names(groups),function(g){v<-groups[[g]];nur<-nrow(v);nt<-length(unique(v$species));data.frame(ailment=g,Nur=nur,Nt=nt,FIC=if(nur>1)(nur-nt)/(nur-1) else NA_real_)}))
}
eq_fl <- function(d) {
  z<-unique(d[!is.na(d$ailment),c('informant_id','species','ailment')]); if(!nrow(z))return(data.frame())
  bysp<-table(unique(d[c('informant_id','species')])$species)
  groups<-split(z,interaction(z$species,z$ailment,drop=TRUE));do.call(rbind,lapply(groups,function(v){s<-v$species[1];data.frame(species=s,ailment=v$ailment[1],Np=nrow(v),N=as.integer(bysp[s]),FL=100*nrow(v)/as.integer(bysp[s]))}))
}
eq_ci <- function(d,N) {
  z<-unique(d[!is.na(d$use_category),c('informant_id','species','use_category')]);if(!nrow(z))return(data.frame())
  v<-table(z$species);data.frame(species=names(v),category_informant_citations=as.integer(v),CI=as.integer(v)/N)
}
eq_fuv <- function(d,species_tbl) {
  fam<-unique(d[c('species','family')]);fam<-fam[!is.na(fam$family),];if(anyDuplicated(fam$species))stop('A species has multiple family assignments')
  x<-merge(fam,species_tbl[,c('species','UV_reports_per_eligible')],by='species');a<-aggregate(UV_reports_per_eligible~family,x,mean);names(a)[2]<-'FUV';a
}
eq_ri <- function(sp) {
  a<-sp$category_count;b<-sp$use_type_count
  if(max(a)==0 || max(b)==0) return(data.frame(species=sp$species,RI_BP=NA_real_))
  data.frame(species=sp$species,RI_BP=a/max(a)+b/max(b),RI_BP_percent=50*(a/max(a)+b/max(b)))
}
eq_ri_citation <- function(sp) {
  if(max(sp$FC)==0 || max(sp$category_count)==0)return(data.frame(species=sp$species,RI_citation=NA_real_))
  data.frame(species=sp$species,RI_citation=(sp$FC/max(sp$FC)+sp$category_count/max(sp$category_count))/2)
}
eq_part <- function(d,field) {
  z<-d[!is.na(d[[field]]),c('species',field),drop=FALSE];if(!nrow(z))return(data.frame())
  names(z)[2]<-'attribute';x<-as.data.frame(table(z$species,z$attribute),stringsAsFactors=FALSE);names(x)<-c('species','attribute','citations');x<-x[x$citations>0,];x$share<-x$citations/ave(x$citations,x$species,FUN=sum);x
}
eq_diversity <- function(d,field) {
  z<-d[!is.na(d[[field]]),c('species',field),drop=FALSE];if(!nrow(z))return(data.frame())
  bysp<-split(z,z$species);do.call(rbind,lapply(names(bysp),function(s){x<-as.numeric(table(bysp[[s]][[field]]));p<-x/sum(x);k<-length(x);id<-1/sum(p^2);data.frame(species=s,dimension=field,categories=k,inverse_simpson=id,equitability=id/k)}))
}
eq_mav <- function(d,total_chapters=20) {
  if(!('icd_chapter' %in% names(d)))return(data.frame())
  if(!is.finite(total_chapters)||total_chapters<1)stop('Invalid chapter count')
  z<-d[!is.na(d$icd_chapter)&trimws(as.character(d$icd_chapter))!='',];if(!nrow(z))return(data.frame())
  a<-tapply(as.character(z$icd_chapter),z$species,function(x)length(unique(x)));if(any(a>total_chapters))stop('More distinct ICD chapters than denominator');data.frame(species=names(a),distinct_chapters=as.integer(a),MAV=as.numeric(a)/total_chapters)
}
eq_run <- function(d,N,chapters=20) {
 d<-eq_validate(d,N);sp<-eq_species(d,N)
 list(species=sp,consensus_FIC=eq_icf(d),fidelity_FL=eq_fl(d),cultural_importance=eq_ci(d,N),family_use_value=eq_fuv(d,sp),RI_Bennett_Prance=eq_ri(sp),RI_citation_categories=eq_ri_citation(sp),plant_part=eq_part(d,'plant_part'),collection_site=eq_part(d,'collection_site'),collection_period=eq_part(d,'collection_period'),preparation=eq_part(d,'preparation'),use_category=eq_part(d,'use_category'),use_diversity=eq_diversity(d,'use_category'),informant_diversity=eq_diversity(d,'informant_id'),MAV=eq_mav(d,chapters))
}

# These are not substitutes for event-level UV or original-source validation.
eq_quality <- function(d, N) {
  issues <- character()
  if (anyNA(d$family) || any(!nzchar(ifelse(is.na(d$family),'',d$family)))) issues <- c(issues,'Missing family: affected species excluded from family summaries')
  fam <- unique(d[,c('species','family')]); fam <- fam[!is.na(fam$family),,drop=FALSE]
  if (anyDuplicated(fam$species)) issues <- c(issues,'Conflicting family assignments: calculation will stop')
  for (field in c('use_category','use_type','ailment','plant_part','collection_site','collection_period','preparation')) {
    n <- sum(is.na(d[[field]]) | !nzchar(ifelse(is.na(d[[field]]),'',d[[field]])))
    if(n>0) issues <- c(issues,paste0(field,': ',n,' missing values; excluded from relevant summaries'))
  }
  data.frame(check=c('Input rows','Distinct informants','Declared eligible informants','Distinct species','Distinct families','Missing cells','Exact duplicate citations','Quality notes'),value=c(nrow(d),length(unique(d$informant_id)),N,length(unique(d$species)),length(unique(na.omit(d$family))),sum(is.na(d)),sum(duplicated(d[c('informant_id','species','use_category','use_type','ailment','plant_part','collection_site','collection_period','preparation')])),if(length(issues))paste(issues,collapse=' | ') else 'No missing attributes detected'),stringsAsFactors=FALSE)
}
eq_ou <- function(d) {
  z <- d[!is.na(d$plant_part) & !is.na(d$use_type),c('species','plant_part','use_type'),drop=FALSE]
  if(!nrow(z))return(data.frame())
  a <- aggregate(rep(1L,nrow(z)),z,sum);names(a)[4]<-'specific_reports'
  total <- as.data.frame(table(d$species),stringsAsFactors=FALSE);names(total)<-c('species','total_species_reports')
  part <- aggregate(specific_reports~species+plant_part,a,sum);names(part)[3]<-'part_reports'
  x <- merge(merge(a,part,by=c('species','plant_part')),total,by='species')
  x$PPV <- x$part_reports/x$total_species_reports
  x$IUV <- x$specific_reports/x$part_reports
  x$OUV <- x$PPV*x$IUV
  x[order(x$species,x$plant_part,x$use_type),,drop=FALSE]
}
eq_use_shares <- function(d) {
  x <- eq_part(d,'use_category')
  if(nrow(x))names(x)[names(x)=='share'] <- 'category_use_share'
  x
}
eq_sex_uv_proxy <- function(d,N_by_sex) {
  if(!('sex' %in% names(d)))stop('Optional sex column is required')
  if(!is.data.frame(N_by_sex) || !all(c('sex','eligible_n') %in% names(N_by_sex)))stop('N_by_sex must contain sex and eligible_n')
  z<-d[!is.na(d$sex)&nzchar(trimws(as.character(d$sex))),,drop=FALSE]
  if(!nrow(z))return(data.frame())
  observed<-aggregate(informant_id~sex,z,function(x)length(unique(x)));names(observed)[2]<-'observed_informants'
  x<-aggregate(rep(1L,nrow(z)),z[c('species','sex')],sum);names(x)[3]<-'citation_reports'
  x<-merge(x,N_by_sex,by='sex');x<-merge(x,observed,by='sex')
  if(any(!is.finite(x$eligible_n)|x$eligible_n<1|x$eligible_n!=floor(x$eligible_n)|x$observed_informants>x$eligible_n))stop('Invalid group denominators')
  x$reports_per_eligible_informant<-x$citation_reports/x$eligible_n
  x
}
eq_eiv <- function(salience,habitat_counts) {
  if(!all(c('species','salience')%in%names(salience)))stop('Salience needs species,salience')
  if(!all(c('habitat','species','individuals')%in%names(habitat_counts)))stop('Habitat data needs habitat,species,individuals')
  if(anyDuplicated(salience$species) || anyDuplicated(habitat_counts[c('habitat','species')]))stop('Duplicate salience or habitat/species key')
  if(anyNA(salience$species) || anyNA(habitat_counts$species) || anyNA(habitat_counts$habitat))stop('Species and habitat identifiers cannot be missing')
  if(any(!is.finite(salience$salience)|salience$salience<0) || any(!is.finite(habitat_counts$individuals)|habitat_counts$individuals<0))stop('Invalid salience or counts')
  if(any(habitat_counts$individuals != floor(habitat_counts$individuals)))stop('Individual abundance must be a whole-number count')
  if(!all(habitat_counts$species %in% salience$species))stop('Habitat species missing salience')
  totals<-aggregate(individuals~species,habitat_counts,sum);names(totals)[2]<-'total_individuals'
  x<-merge(merge(habitat_counts,totals,by='species'),salience,by='species')
  if(any(x$total_individuals==0))stop('A species has zero individuals across all supplied habitats; EIV is undefined for it')
  x$relative_abundance<-x$individuals/x$total_individuals
  x$weighted_salience<-x$salience*x$relative_abundance
  byhab<-aggregate(weighted_salience~habitat,x,sum)
  names(byhab)[2]<-'EIV';list(by_habitat=byhab,contributions=x)
}
eq_run_stage2 <- function(d,N,chapters=20) {
  cleaned <- eq_validate(d,N)
  if(any(!is.na(cleaned$family) & nzchar(cleaned$family))) {
    fam<-unique(cleaned[!is.na(cleaned$family),c('species','family')]);
    if(anyDuplicated(fam$species))stop('Conflicting family assignments for species')
  }
  out <- eq_run(cleaned,N,chapters)
  out$quality_audit <- eq_quality(cleaned,N)
  out$overall_use_value <- eq_ou(cleaned)
  out$use_category_share <- eq_use_shares(cleaned)
  out
}

eq_sex_uv_stage3 <- function(d,N_by_sex) {
  if (!('sex' %in% names(d))) stop('Citation CSV needs sex column')
  if (!all(c('sex','eligible_n') %in% names(N_by_sex))) stop('Denominator CSV needs sex,eligible_n')
  if (anyNA(N_by_sex$sex) || anyDuplicated(N_by_sex$sex) || any(!nzchar(trimws(as.character(N_by_sex$sex))))) stop('Denominator groups must be unique and nonmissing')
  if (any(!is.finite(N_by_sex$eligible_n) | N_by_sex$eligible_n < 1 | N_by_sex$eligible_n != floor(N_by_sex$eligible_n))) stop('Invalid eligible_n')
  observed <- unique(as.character(d$sex[!is.na(d$sex) & nzchar(trimws(as.character(d$sex)))]))
  if (!all(observed %in% N_by_sex$sex)) stop('Missing eligible denominator for observed sex group')
  # Each informant belongs to exactly one declared group.
  pairs <- unique(d[!is.na(d$sex) & nzchar(trimws(as.character(d$sex))),c('informant_id','sex'),drop=FALSE])
  if(anyDuplicated(pairs$informant_id)) stop('An informant is assigned to multiple sex groups')
  counts <- table(pairs$sex)
  if(any(as.numeric(counts) > N_by_sex$eligible_n[match(names(counts),N_by_sex$sex)])) stop('Observed informants exceed group denominator')
  eq_sex_uv_proxy(d,N_by_sex)
}


# ========================================================================
# RESEARCH UTILITIES
# ========================================================================

eq_safe_filename <- function(x) {
  x <- gsub('[^A-Za-z0-9_-]+', '_', as.character(x))
  x <- substr(x,1,80)
  if (!nzchar(x)) 'study' else x
}
eq_make_zip <- function(destination, directory) {
  files <- list.files(directory, all.files=FALSE)
  if (!length(files)) stop('No export files')
  if (requireNamespace('zip',quietly=TRUE)) {
    zip::zipr(zipfile=destination,files=file.path(directory,files),root=directory)
  } else {
    old <- setwd(directory); on.exit(setwd(old),add=TRUE)
    utils::zip(zipfile=destination,files=files)
  }
  if (!file.exists(destination)) stop('ZIP creation failed; install.packages("zip")')
  invisible(destination)
}


# ========================================================================
# DATA IMPORT AND COLUMN MAPPING
# ========================================================================

# CSV/Excel mapping: preserve original values; no invented respondent records.
eq_read_csv <- function(path) {
  d <- utils::read.csv(path,stringsAsFactors=FALSE,check.names=FALSE,fileEncoding='UTF-8-BOM',na.strings=c('', 'NA'))
  if (!nrow(d)) stop('CSV contains no data rows')
  names(d) <- trimws(names(d))
  if (anyDuplicated(names(d))) stop('CSV has duplicate column headers')
  d
}
eq_guess_column <- function(headers, field) {
  aliases <- list(
    informant_id=c('informant_id','informant','respondent_id','respondent','interviewee_id','participant_id','participant','id','interviewer_id'),
    species=c('species','species_name','plant_species','scientific_name','botanical_name','taxon','plant_name'),
    family=c('family','plant_family','botanical_family'),
    use_category=c('use_category','category','use_class','use_group'),
    use_type=c('use_type','specific_use','use','indication','purpose'),
    ailment=c('ailment','disease','disease_category','illness','condition','body_system'),
    plant_part=c('plant_part','part_used','parts_used','part','used_part'),
    collection_site=c('collection_site','collection_location','site','source_site'),
    collection_period=c('collection_period','season','harvest_season','collection_season'),
    preparation=c('preparation','preparation_method','mode_of_preparation'),
    icd_chapter=c('icd_chapter','icd_category','icd_code_group'),
    sex=c('sex','gender','respondent_sex','informant_sex'))
  norm <- function(x) gsub('[^a-z0-9]+','_',tolower(trimws(x)))
  idx <- match(norm(aliases[[field]]),norm(headers))
  idx <- idx[!is.na(idx)]
  if(length(idx)) headers[idx[1]] else ''
}
eq_map_columns <- function(d,mapping) {
  fields <- c('informant_id','species','family','use_category','use_type','ailment','plant_part','collection_site','collection_period','preparation','icd_chapter','sex')
  picks <- vapply(fields,function(f){x<-mapping[[f]];if(is.null(x)||!length(x)||is.na(x)) '' else as.character(x)[1]},character(1))
  if(any(!nzchar(picks[1:2]))) stop('Map both informant_id and species before calculating')
  nonempty <- picks[nzchar(picks)]
  if(anyDuplicated(nonempty)) {
    dup <- unique(nonempty[duplicated(nonempty)])
    stop('The same source column is assigned more than once: ', paste(dup, collapse=', '), '. Select Not available for optional fields that do not have separate source columns.')
  }
  if(!all(nonempty %in% names(d))) stop('Column mapping refers to an unknown CSV field')
  out <- data.frame(matrix(NA_character_,nrow=nrow(d),ncol=length(fields)),stringsAsFactors=FALSE)
  names(out) <- fields
  for(f in fields) if(nzchar(picks[f])) out[[f]] <- as.character(d[[picks[f]]])
  out
}


# ========================================================================
# MULTIVARIATE AND INFERENTIAL STATISTICS
# ========================================================================

eq7_read <- function(path) read.csv(path, stringsAsFactors=FALSE, check.names=FALSE)
eq7_matrix <- function(d, id='sample_id') {
  if (!id %in% names(d)) stop('A sample_id column is required.')
  ids <- trimws(as.character(d[[id]]))
  if (anyNA(ids) || any(!nzchar(ids)) || anyDuplicated(ids)) stop('sample_id must be unique and nonempty.')
  x <- d[,setdiff(names(d),id),drop=FALSE]
  if (ncol(x)<2L || nrow(x)<3L) stop('At least 3 samples and 2 numerical variables are required.')
  if (!all(vapply(x,is.numeric,logical(1)))) stop('All measurement columns must be numeric; check the uploaded file.')
  if (any(!is.finite(as.matrix(x)))) stop('Missing, NaN or infinite measurements are not permitted. Resolve them in the source data.')
  rownames(x) <- ids
  as.matrix(x)
}
eq7_pca <- function(d) {
  x <- eq7_matrix(d)
  keep <- apply(x,2,sd)>0
  if (sum(keep)<2) stop('PCA requires at least two variables with nonzero variance.')
  excluded <- colnames(x)[!keep]
  p <- prcomp(x[,keep,drop=FALSE],center=TRUE,scale.=TRUE)
  scores <- data.frame(sample_id=rownames(p$x),p$x[,seq_len(min(3,ncol(p$x))),drop=FALSE],check.names=FALSE)
  loadings <- data.frame(variable=rownames(p$rotation),p$rotation[,seq_len(min(3,ncol(p$rotation))),drop=FALSE],check.names=FALSE)
  variance <- data.frame(component=paste0('PC',seq_along(p$sdev)),explained_pct=100*p$sdev^2/sum(p$sdev^2))
  list(scores=scores,loadings=loadings,variance=variance,excluded=excluded)
}
eq7_cluster <- function(d, method='ward.D2',distance='euclidean') {
  x<-eq7_matrix(d)
  keep<-apply(x,2,sd)>0
  if (!any(keep)) stop('No varying numeric variables for clustering.')
  x<-scale(x[,keep,drop=FALSE]); hc<-hclust(dist(x,method=distance),method=method)
  list(tree=hc,order=data.frame(order=seq_along(hc$order),sample_id=hc$labels[hc$order]))
}
eq7_cca <- function(species, environment) {
  if (!requireNamespace('vegan',quietly=TRUE)) stop('CCA requires the vegan package. Run install.packages("vegan").')
  y<-eq7_matrix(species); e<-eq7_matrix(environment)
  if (any(y<0)) stop('Species abundance data must be nonnegative.')
  if (any(rowSums(y)==0)) stop('Remove zero-total samples from the species matrix.')
  if (any(colSums(y)==0)) stop('Remove species with zero abundance across all samples.')
  if (!setequal(rownames(y),rownames(e))) stop('Species and environment sample_id values must match exactly.')
  e<-e[rownames(y),,drop=FALSE]
  keep<-apply(e,2,sd)>0
  if (!any(keep)) stop('At least one varying environmental predictor is required.')
  e<-e[,keep,drop=FALSE]
  if (nrow(y)<=ncol(e)+1) stop('Too few samples for the number of environmental predictors.')
  fit<-vegan::cca(y~.,data=as.data.frame(e))
  if (is.null(fit$CCA) || fit$CCA$rank<1) stop('CCA has no constrained axes for these data.')
  sc<-vegan::scores(fit,display='sites',choices=seq_len(min(2,fit$CCA$rank)),scaling=2)
  scores<-data.frame(sample_id=rownames(sc),sc,check.names=FALSE)
  list(model=fit,scores=scores,summary=capture.output(summary(fit)))
}
eq7_venn <- function(d, selected_sets=NULL) {
  required<-c('set','item');if(!all(required%in%names(d)))stop('Venn input requires set and item columns.')
  d<-unique(d[,required,drop=FALSE]);d$set<-trimws(as.character(d$set));d$item<-trimws(as.character(d$item))
  if(anyNA(d$set)||anyNA(d$item)||any(!nzchar(d$set))||any(!nzchar(d$item)))stop('Empty set or item values are not allowed.')
  available_sets<-sort(unique(d$set))
  if(!is.null(selected_sets)) {
    sets<-intersect(available_sets,as.character(selected_sets))
  } else {
    sets<-available_sets
  }
  if(length(sets)<2||length(sets)>5)stop('Select 2–5 sets using the Venn set selector.')
  d<-d[d$set %in% sets,,drop=FALSE]
  memberships<-lapply(sets,function(s)unique(d$item[d$set==s]));names(memberships)<-sets
  items<-sort(unique(d$item));codes<-vapply(items,function(item)paste(as.integer(vapply(memberships,function(z)item%in%z,logical(1))),collapse=''),character(1))
  combos<-as.data.frame(table(codes),stringsAsFactors=FALSE);names(combos)<-c('membership','count');combos<-combos[combos$count>0,,drop=FALSE]
  combos$sets<-vapply(combos$membership,function(code)paste(sets[strsplit(code,'')[[1]]=='1'],collapse=' & '),character(1))
  combos<-combos[order(-combos$count,combos$sets),c('sets','count','membership'),drop=FALSE]
  list(sets=sets,intersections=combos,unique_items=length(items),memberships=memberships)
}
eq7_ttest <- function(d,paired=FALSE,mu=0,conf=.95) {
  if (!all(c('group','value')%in%names(d))) stop('T-test input needs group and value columns.')
  if(!is.numeric(d$value)||any(!is.finite(d$value)))stop('value must contain finite numeric observations.')
  groups<-unique(as.character(d$group));if(length(groups)!=2)stop('Exactly two groups are required.')
  if(paired){
    if(!'pair_id'%in%names(d))stop('Paired t-test requires pair_id.')
    if(anyDuplicated(paste(d$group,d$pair_id)))stop('Duplicate group and pair_id combination.')
    a<-d[d$group==groups[1],c('pair_id','value')];b<-d[d$group==groups[2],c('pair_id','value')]
    if(!setequal(a$pair_id,b$pair_id))stop('Both groups must contain identical pair_id values.')
    b<-b[match(a$pair_id,b$pair_id),,drop=FALSE]
    if(nrow(a)<2)stop('At least two pairs are required.')
    fit<-t.test(a$value,b$value,paired=TRUE,mu=mu,conf.level=conf)
  } else {
    if(any(table(d$group)<2))stop('At least two observations per group are required.')
    fit<-t.test(value~group,data=d,mu=mu,conf.level=conf)
  }
  data.frame(test=if(paired)'Paired t-test' else 'Welch two-sample t-test',statistic=unname(fit$statistic),df=unname(fit$parameter),p_value=fit$p.value,estimate=paste(round(fit$estimate,5),collapse='; '),ci_lower=fit$conf.int[1],ci_upper=fit$conf.int[2])
}
eq7_ztest <- function(d,sigma,mu=0,conf=.95) {
  if(!'value'%in%names(d)||!is.numeric(d$value))stop('Z-test requires a numeric value column.')
  x<-d$value;if(length(x)<2||any(!is.finite(x)))stop('At least two finite observations are required.')
  if(length(sigma)!=1||!is.finite(sigma)||sigma<=0)stop('Known population standard deviation sigma must be positive.')
  n<-length(x);se<-sigma/sqrt(n);z<-(mean(x)-mu)/se;p<-2*pnorm(-abs(z));crit<-qnorm(1-(1-conf)/2)
  data.frame(test='One-sample Z-test (known population SD)',n=n,mean=mean(x),null_mean=mu,sigma=sigma,z=z,p_value=p,ci_lower=mean(x)-crit*se,ci_upper=mean(x)+crit*se)
}
eq7_anova <- function(d) {
  if(!all(c('group','value')%in%names(d)))stop('ANOVA requires group and value columns.')
  if(!is.numeric(d$value)||any(!is.finite(d$value)))stop('value must contain finite numeric observations.')
  d$group<-as.factor(d$group)
  if(nlevels(d$group)<2||nrow(d)<=nlevels(d$group))stop('ANOVA requires two or more groups and residual degrees of freedom.')
  fit<-aov(value~group,data=d);a<-as.data.frame(summary(fit)[[1]]);a$term<-rownames(a);rownames(a)<-NULL
  list(table=a,means=aggregate(value~group,d,function(x)c(n=length(x),mean=mean(x),sd=sd(x))),model=fit)
}
eq7_obj_ui <- function() tabPanel('10 · Study objectives',fluidRow(column(6,wellPanel(h4('Research objectives'),textAreaInput('objectives','Study objectives (one per line)',value='1. Quantify species use and informant consensus.\n2. Examine multivariate patterns in ethnobotanical observations.\n3. Compare groups using suitable statistical tests.',rows=8),textAreaInput('hypotheses','Research hypotheses / questions','',rows=5),downloadButton('objectives_download','Download objectives (TXT)'))),column(6,h4('Study design and interpretation'),div(class='eq-note',p('Describe the observational unit, sampling design, predictors, outcomes and independence of samples. PCA and clustering describe structure; CCA is constrained ordination; inferential tests require appropriate sampling assumptions.'),p('Study objectives are descriptive metadata and do not automatically validate a statistical test.')))))
eq7_multi_ui <- function() tabPanel('11 · Multivariate analysis',fluidRow(column(4,wellPanel(selectInput('multi_method','Analysis',c('PCA'='pca','Hierarchical clustering'='cluster','CCA (species × environment)'='cca','Venn / set intersections'='venn')),fileInput('multi_data','Numeric matrix or set membership CSV',accept='.csv'),conditionalPanel("input.multi_method == 'cca'",fileInput('multi_env','Environmental matrix CSV',accept='.csv')),conditionalPanel("input.multi_method == 'venn'",selectInput('venn_sets','Choose 2–5 sets for the Venn diagram',choices=character(0),multiple=TRUE),p('For datasets containing more than five categories, choose any 2–5. Repeated set–item pairs are removed automatically.')),conditionalPanel("input.multi_method == 'cluster'",selectInput('cluster_method','Linkage',c('Ward D2'='ward.D2','Complete'='complete','Average'='average'))),actionButton('multi_run','Run multivariate analysis',class='btn-primary'),hr(),downloadButton('multi_template','Download input template'),downloadButton('multi_export','Download results CSV'),downloadButton('multi_png','Download plot PNG'),p('Use one row per independent sample. Numerical matrix must have sample_id plus numeric columns; no missing values. CCA uses nonnegative species abundances and matching environmental sample_id.'))),column(8,h4('Multivariate output'),verbatimTextOutput('multi_note'),plotOutput('multi_plot',height='460px'),div(class='table-responsive',tableOutput('multi_table')))))
eq7_tests_ui <- function() tabPanel('12 · Statistical tests',fluidRow(column(4,wellPanel(selectInput('stat_method','Statistical method',c('Independent Welch t-test'='t','Paired t-test'='paired','One-sample Z-test (known population SD)'='z','One-way ANOVA'='anova')),fileInput('stat_data','Observations CSV',accept='.csv'),conditionalPanel("input.stat_method == 'z'",numericInput('known_sigma','Known population standard deviation',1,min=.000001),numericInput('null_mu','Null-hypothesis mean',0)),conditionalPanel("input.stat_method == 't' || input.stat_method == 'paired'",numericInput('t_mu','Null-hypothesis difference',0)),actionButton('stat_run','Run statistical test',class='btn-primary'),hr(),downloadButton('stat_template','Download test template'),downloadButton('stat_export','Download results CSV'),p('Do not treat multiple use citations from one informant as independent respondents. For repeated measures, use paired observations or a suitable mixed model.'))),column(8,h4('Statistical results'),verbatimTextOutput('stat_note'),div(class='table-responsive',tableOutput('stat_table')),plotOutput('stat_plot',height='400px'),tags$p(class='eq-warning','Check independence, distribution, outliers, variance and sampling design before interpreting p-values. Z-test is only appropriate with known population SD.'))))
eq7_server <- function(input,output,session) {
  output$objectives_download<-downloadHandler('EthnoQuant_Study_Objectives.txt',function(file)writeLines(c(paste('Study:',input$study),paste('Researcher:',input$investigator),paste('Region:',input$site),'','OBJECTIVES',input$objectives,'','HYPOTHESES',input$hypotheses),file))
  output$multi_template<-downloadHandler(filename=function()paste0('EthnoQuant_',input$multi_method,'_template.csv'),content=function(file){name<-switch(input$multi_method,pca='pca_matrix.csv',cluster='pca_matrix.csv',cca='cca_species.csv',venn='venn_membership.csv');file.copy(file.path('data/advanced',name),file)})
  observeEvent(list(input$multi_data,input$multi_method),{
    if(!identical(input$multi_method,'venn')||is.null(input$multi_data))return()
    d<-tryCatch(eq7_read(input$multi_data$datapath),error=function(e)NULL)
    if(is.null(d)||!all(c('set','item') %in% names(d))) {
      updateSelectInput(session,'venn_sets',choices=character(0),selected=character(0))
      return()
    }
    available<-sort(unique(trimws(as.character(d$set))))
    available<-available[!is.na(available)&nzchar(available)]
    old<-isolate(input$venn_sets)
    chosen<-intersect(old,available)
    if(length(chosen)<2||length(chosen)>5)chosen<-head(available,5)
    updateSelectInput(session,'venn_sets',choices=available,selected=chosen)
  },ignoreInit=FALSE)
  multi<-eventReactive(input$multi_run,{tryCatch({req(input$multi_data);d<-eq7_read(input$multi_data$datapath);switch(input$multi_method,pca=eq7_pca(d),cluster=eq7_cluster(d,input$cluster_method),cca={req(input$multi_env);eq7_cca(d,eq7_read(input$multi_env$datapath))},venn=eq7_venn(d,input$venn_sets))},error=function(e){showNotification(paste('Multivariate analysis:',conditionMessage(e)),type='error',duration=12);NULL})})
  output$multi_note<-renderPrint({req(multi());if(input$multi_method=='pca'){cat('PCA: standardized variables; explained variance (%):\n');print(multi()$variance);if(length(multi()$excluded))cat('Excluded zero-variance variables:',paste(multi()$excluded,collapse=', '),'\n')} else if(input$multi_method=='cca'){cat('CCA constrained ordination. Sample IDs aligned exactly.\n');cat(paste(head(multi()$summary,14),collapse='\n'))}else if(input$multi_method=='venn')cat('Distinct items:',multi()$unique_items,'; sets:',paste(multi()$sets,collapse=', '),'\n') else cat('Clustering: standardized numeric columns; Euclidean distance.\n')})
  output$multi_table<-renderTable({req(multi());switch(input$multi_method,pca=multi()$scores,cluster=multi()$order,cca=multi()$scores,venn=multi()$intersections)},digits=5)
  draw_multi<-function(){req(multi());m<-multi();method<-input$multi_method
    if(method=='cluster'){plot(m$tree,main='Hierarchical clustering',xlab='',sub='');return(invisible(NULL))}
    if(method=='venn'){if(requireNamespace('ggVennDiagram',quietly=TRUE)&&requireNamespace('ggplot2',quietly=TRUE)){v<-ggVennDiagram::ggVennDiagram(m$memberships,label='count',label_alpha=0,edge_size=1.0,set_size=4,set_color=c('#B78DB9','#E8AC77','#8BC6BC','#93ADD6','#BDD69B')[seq_along(m$memberships)])+ggplot2::scale_fill_gradient(low='#FFFCF8',high='#D9EAE6',name='Intersection count')+ggplot2::ggtitle('Set intersections (2–5 sets)')+ggplot2::theme_void();print(v)}else{plot.new();text(.5,.6,'Venn display requires ggVennDiagram',cex=1.1);text(.5,.48,'Run install.packages(c("ggVennDiagram","ggplot2"))',cex=.85);text(.5,.36,'Exact intersection counts remain available in the results table.',cex=.75)};return(invisible(NULL))}
    x<-m$scores;if(ncol(x)<3){plot.new();text(.5,.5,'Only one ordination axis available');return(invisible(NULL))}
    plot(x[[2]],x[[3]],pch=19,col='#1d8164',xlab=names(x)[2],ylab=names(x)[3],main=if(method=='pca')'PCA scores' else 'CCA site scores');text(x[[2]],x[[3]],labels=x$sample_id,pos=3,cex=.75)
  }
  output$multi_plot<-renderPlot(draw_multi())
  output$multi_png<-downloadHandler('EthnoQuant_multivariate.png',function(file){req(multi());png(file,width=1500,height=1100,res=170);on.exit(dev.off(),add=TRUE);draw_multi()})
  output$multi_export<-downloadHandler('EthnoQuant_multivariate.csv',function(file){req(multi());d<-switch(input$multi_method,pca=multi()$scores,cluster=multi()$order,cca=multi()$scores,venn=multi()$intersections);write.csv(d,file,row.names=FALSE)})
  output$stat_template<-downloadHandler(filename=function()paste0('EthnoQuant_',input$stat_method,'_template.csv'),content=function(file){name<-switch(input$stat_method,t='two_groups.csv',paired='paired_groups.csv',z='z_observations.csv',anova='anova_groups.csv');file.copy(file.path('data/advanced',name),file)})
  stat<-eventReactive(input$stat_run,{tryCatch({req(input$stat_data);d<-eq7_read(input$stat_data$datapath);switch(input$stat_method,t=eq7_ttest(d,FALSE,input$t_mu),paired=eq7_ttest(d,TRUE,input$t_mu),z=eq7_ztest(d,input$known_sigma,input$null_mu),anova=eq7_anova(d))},error=function(e){showNotification(paste('Statistical test:',conditionMessage(e)),type='error',duration=12);NULL})})
  output$stat_table<-renderTable({req(stat());if(input$stat_method=='anova')stat()$table else stat()},digits=6)
  output$stat_note<-renderPrint({req(stat());cat('Method:',input$stat_method,'\n');if(input$stat_method=='anova')cat('One-way ANOVA; inspect residual diagnostics and group sizes.\n')else cat('Two-sided test; p-values assume an appropriate sampling design.\n')})
  output$stat_plot<-renderPlot({req(stat(),input$stat_data);d<-eq7_read(input$stat_data$datapath);if(input$stat_method=='z'){hist(d$value,col='#268967',main='Observed values',xlab='Value')}else{boxplot(value~group,data=d,col='#b7dec6',main='Observed values by group',ylab='Value')}})
  output$stat_export<-downloadHandler('EthnoQuant_statistical_results.csv',function(file){req(stat());d<-if(input$stat_method=='anova')stat()$table else stat();write.csv(d,file,row.names=FALSE)})
}

# Source-verified supplementary calculations (see docs/SOURCE_FORMULA_REVIEW.md)
eq_source_performance_index <- function(d) {
  needed <- c("species", "ailment")
  if (!all(needed %in% names(d))) stop("IP requires species and ailment columns")
  x <- d[!is.na(d$species) & nzchar(trimws(as.character(d$species))) & !is.na(d$ailment) & nzchar(trimws(as.character(d$ailment))),needed,drop=FALSE]
  if (!nrow(x)) stop("No complete species–ailment citations")
  x[] <- lapply(x,as.character)
  total <- nrow(x)
  sp <- table(x$species); al <- table(x$ailment)
  pairs <- as.data.frame(table(x$species,x$ailment),stringsAsFactors=FALSE)
  names(pairs) <- c("species","ailment","C1")
  pairs <- pairs[pairs$C1>0,,drop=FALSE]
  pairs$C2 <- as.numeric(sp[pairs$species]); pairs$C3 <- as.numeric(al[pairs$ailment]); pairs$C4 <- total
  pairs$P1 <- pairs$C1/pairs$C2; pairs$P2 <- pairs$C3/pairs$C4
  pairs$D <- pairs$P1-pairs$P2
  pairs$IP <- ifelse(pairs$D<=0,0L,ifelse(pairs$D<=1/3,1L,ifelse(pairs$D<=2/3,2L,3L)))
  pairs
}
eq_source_purpose_consensus <- function(d) {
  if (!all(c("species","use_type") %in% names(d))) stop("PC requires species and use_type columns")
  x <- d[!is.na(d$species)&nzchar(trimws(as.character(d$species)))&!is.na(d$use_type)&nzchar(trimws(as.character(d$use_type))),c("species","use_type"),drop=FALSE]
  if (!nrow(x)) stop("No complete species–use-type reports")
  x[] <- lapply(x,as.character)
  by_species <- split(x$use_type,x$species)
  do.call(rbind,lapply(names(by_species),function(s) {
    counts <- as.numeric(table(by_species[[s]])); p <- counts/sum(counts); S <- length(counts)
    data.frame(species=s,reports=sum(counts),S=S,PC=sum(p^2)/S,stringsAsFactors=FALSE)
  }))
}


# Campos & Albuquerque (2021), Ecological Indicators 121:106993.
# This published CPI is distinct from the registry's unresolved composite ICP (#59).
eq_campos_cpi <- function(d) {
  required <- c('species','NSCE','NPE','RENISUS','ANVISA')
  if (!all(required %in% names(d))) stop(paste('Missing columns:',paste(setdiff(required,names(d)),collapse=', ')))
  d <- d[,required,drop=FALSE]
  d$species <- trimws(as.character(d$species))
  if (!nrow(d) || anyNA(d) || any(!nzchar(d$species)) || anyDuplicated(d$species)) stop('Provide unique nonblank species and complete data; no missing values.')
  for (nm in c('NSCE','NPE')) {
    z <- suppressWarnings(as.numeric(as.character(d[[nm]])))
    if (any(!is.finite(z)) || any(z<0) || any(z!=floor(z))) stop(paste(nm,'must contain nonnegative integer counts'))
    d[[nm]] <- z
  }
  for (nm in c('RENISUS','ANVISA')) {
    z <- tolower(trimws(as.character(d[[nm]])))
    if (!all(z %in% c('0','1','true','false','yes','no'))) stop(paste(nm,'must be yes/no or 0/1'))
    d[[nm]] <- as.integer(z %in% c('1','true','yes'))
  }
  if (!max(d$NSCE)>0 || !max(d$NPE)>0) stop('Both maxima must be positive.')
  d$NSCEV <- max(d$NSCE); d$NPEV <- max(d$NPE)
  d$NSC <- d$NSCE/d$NSCEV; d$NP <- d$NPE/d$NPEV
  d$RI <- d$NSC+d$NP
  d$RENISUS_score <- 0.5*d$RENISUS
  d$ANVISA_score <- 0.5*d$ANVISA
  d$CPI <- d$RI+d$RENISUS_score+d$ANVISA_score
  d <- d[order(-d$CPI,d$species),,drop=FALSE]
  rownames(d) <- NULL
  d
}


# Published Byg & Balslev (2001) inverse-Simpson species equitability.
eq_species_evenness <- function(d) {
  if (!all(c('informant','species') %in% names(d))) stop('Required columns: informant, species')
  if (anyNA(d[,c('informant','species')]) || any(!nzchar(trimws(as.character(d$species)))) || any(!nzchar(trimws(as.character(d$informant))))) stop('Missing informant/species')
  if (!nrow(d)) stop('No reports supplied')
  count <- table(as.character(d$species)); ps <- as.numeric(count)/sum(count); S <- length(count)
  sd_tot <- 1/sum(ps^2)
  overall <- data.frame(S=S,SDtot=sd_tot,SEtot=sd_tot/S,Shannon_H=-sum(ps*log(ps)),Pielou_J=if(S>1) -sum(ps*log(ps))/log(S) else NA_real_)
  groups <- split(as.character(d$species),as.character(d$informant))
  per <- do.call(rbind,lapply(names(groups),function(id){ t <- table(groups[[id]]); q<-as.numeric(t)/sum(t); k<-length(t); sd<-1/sum(q^2); data.frame(informant=id,number_species=k,SDi=sd,SEi=sd/k)}))
  rownames(per)<-NULL
  list(overall=overall,per_informant=per)
}

# Turner-style ICS from explicitly supplied, non-inferred use-level scores.
eq_ics_scores <- function(d) {
  required<-c('species','use','quality','intensity','exclusivity')
  if (!all(required %in% names(d))) stop(paste('Required columns:',paste(required,collapse=', ')))
  if (!nrow(d)) stop('No scored uses supplied')
  if (anyNA(d[,required]) || any(!nzchar(trimws(as.character(d$species)))) || any(!nzchar(trimws(as.character(d$use))))) stop('Missing scores/species/use')
  for (v in c('quality','intensity','exclusivity')) {
    if (!is.numeric(d[[v]]) || any(!is.finite(d[[v]])) || any(d[[v]]<0)) stop(paste(v,'must contain nonnegative numeric scores'))
  }
  if (anyDuplicated(d[,c('species','use')])) stop('Duplicate species-use rows: score each use once')
  d$ICS_component <- d$quality*d$intensity*d$exclusivity
  ans<-aggregate(ICS_component~species,d,sum); names(ans)[2]<-'ICS'; ans[order(-ans$ICS,ans$species),,drop=FALSE]
}

# Optional exploratory weighted use-report metric, not a source-validated UV index.
eq_weighted_report_rate <- function(d,N) {
  if (!all(c('species','use_weight') %in% names(d))) stop('Required columns: species,use_weight')
  if (length(N)!=1 || !is.finite(N) || N<=0) stop('N must be positive eligible informant count')
  if (!nrow(d) || anyNA(d) || any(!d$use_weight %in% c(0,0.5,1))) stop('Weights must be 0, 0.5 or 1 with no missing values')
  out<-aggregate(use_weight~species,d,sum);names(out)[2]<-'weighted_reports';out$weighted_reports_per_eligible<-out$weighted_reports/N;out
}


# Descriptive-only workflow for literature/compiled species-use entries.
# Deliberately does not construct artificial informant IDs or citation metrics.
eq_compiled_results <- function(d) {
  if (!is.data.frame(d) || !nrow(d)) stop('Compiled dataset has no records')
  if (!('species' %in% names(d))) stop('Compiled dataset requires a species column')
  d$species <- trimws(as.character(d$species))
  d <- d[!is.na(d$species) & nzchar(d$species),,drop=FALSE]
  if (!nrow(d)) stop('No nonempty species names found')
  for (nm in c('family','use_category','use_type','ailment','plant_part','preparation')) {
    if (!(nm %in% names(d))) d[[nm]] <- NA_character_
    d[[nm]] <- trimws(as.character(d[[nm]]))
    d[[nm]][!nzchar(d[[nm]])] <- NA_character_
  }
  species <- aggregate(rep(1L,nrow(d)),by=list(species=d$species),FUN=sum)
  names(species)[2] <- 'reports'
  species <- species[order(-species$reports,species$species),,drop=FALSE]
  species$category_count <- vapply(species$species,function(x)length(unique(stats::na.omit(d$use_category[d$species==x]))),integer(1))
  species$use_type_count <- vapply(species$species,function(x)length(unique(stats::na.omit(d$use_type[d$species==x]))),integer(1))
  summaries <- lapply(c('family','use_category','use_type','ailment','plant_part'),function(nm){
    x <- d[[nm]]; x <- x[!is.na(x) & nzchar(x)]
    z <- as.data.frame(table(x),stringsAsFactors=FALSE)
    names(z) <- c(nm,'records')
    z[order(-z$records),,drop=FALSE]
  })
  names(summaries) <- c('families','use_categories','use_types','ailments','plant_parts')
  species_family <- unique(d[,c('species','family'),drop=FALSE])
  list(species=species,species_family=species_family,compiled_records=d,
       families=summaries$families,use_categories=summaries$use_categories,
       use_types=summaries$use_types,ailments=summaries$ailments,plant_parts=summaries$plant_parts,
       quality_audit=data.frame(check=c('Input mode','Records','Species','Informant indices'),
                                result=c('Compiled records',as.character(nrow(d)),
                                         as.character(length(unique(d$species))),'Not calculated')))
}
