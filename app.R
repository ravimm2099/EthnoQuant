if (!requireNamespace('shiny', quietly=TRUE)) stop('Install shiny: install.packages("shiny")')
library(shiny)
source('R_ethnoquant.R', local=TRUE)
example <- read.csv('data/sample_citations.csv', stringsAsFactors=FALSE, check.names=FALSE)
reference <- read.csv('reference/formula_catalog.csv', stringsAsFactors=FALSE, check.names=FALSE)
css <- 'body{background:#f3f8f7;color:#173c34;font-family:Arial,sans-serif}.container-fluid{max-width:1800px;padding-left:16px;padding-right:16px}.eq-banner{margin:4px 0 14px;border-radius:18px;overflow:hidden;border:1px solid #c7e5d7;box-shadow:0 4px 18px #124d3830;background:#fff}.eq-banner img{display:block;width:100%;height:auto}.nav-tabs{display:flex;flex-wrap:wrap;gap:6px;border-bottom:0;margin-bottom:15px}.nav-tabs>li{float:none;margin:0;flex:1 1 145px}.nav-tabs>li>a{border:0!important;border-radius:12px!important;color:white!important;font-weight:700;text-align:center;min-height:49px;display:flex;align-items:center;justify-content:center;padding:10px 9px;box-shadow:0 3px 9px #00000015;transition:filter .15s,transform .15s}.nav-tabs>li:nth-child(10n+1)>a{background:linear-gradient(110deg,#6825ad,#a542d0)}.nav-tabs>li:nth-child(10n+2)>a{background:linear-gradient(110deg,#085ec9,#18a3e0)}.nav-tabs>li:nth-child(10n+3)>a{background:linear-gradient(110deg,#087e9b,#0bbcb3)}.nav-tabs>li:nth-child(10n+4)>a{background:linear-gradient(110deg,#137e46,#39b36e)}.nav-tabs>li:nth-child(10n+5)>a{background:linear-gradient(110deg,#e9790d,#f5b03d)}.nav-tabs>li:nth-child(10n+6)>a{background:linear-gradient(110deg,#c52834,#f25d52)}.nav-tabs>li:nth-child(10n+7)>a{background:linear-gradient(110deg,#be1b85,#ed5bb6)}.nav-tabs>li:nth-child(10n+8)>a{background:linear-gradient(110deg,#5636b4,#8c61e0)}.nav-tabs>li:nth-child(10n+9)>a{background:linear-gradient(110deg,#0953bd,#2674ed)}.nav-tabs>li:nth-child(10n+10)>a{background:linear-gradient(110deg,#087a42,#42ac40)}.nav-tabs>li.active>a,.nav-tabs>li>a:hover,.nav-tabs>li>a:focus{filter:brightness(.87);transform:translateY(-2px);box-shadow:0 4px 0 #143d2b55,0 4px 14px #00000020}.well{background:white;border:1px solid #dce9e3;border-radius:14px;box-shadow:0 2px 7px #1c61410b}.btn-primary{background:#176f55;border-color:#176f55}.eq-note{background:#eaf4ed;padding:12px;border-radius:8px;margin:12px 0}.eq-warning{color:#8b490c}.table-responsive{overflow-x:auto}table{background:white}@media(max-width:720px){.nav-tabs>li{flex:1 1 120px}.nav-tabs>li>a{font-size:12px;min-height:45px}.eq-banner{border-radius:8px}}'
ui <- fluidPage(
  tags$head(tags$link(rel='icon', type='image/png', href='ethnoquant_scientific_logo.png'), tags$style(HTML(css))),
  tags$div(class='eq-banner',tags$img(src='ethnoquant_header.png',alt='EthnoQuant — A Comprehensive Toolkit for Quantitative Ethnobotany Analysis. Dr. Manish Mathur, CTO, ICAR-Central Arid Zone Research Institute, Jodhpur, India; eco5320@gmail.com')),
  tabsetPanel(id='main_tabs',

    tabPanel('01 · About EthnoQuant',fluidRow(
      column(5,wellPanel(h3('Welcome to EthnoQuant'),p('A local R Shiny research toolkit for quantitative ethnobotany, exploratory multivariate analysis and statistical testing.'),
        h4('Start here — six steps'),tags$ol(
          tags$li('Install R and RStudio; install required R packages (see README).'),
          tags$li('Open the extracted EthnoQuant folder in RStudio and run shiny::runApp(".", launch.browser=TRUE).'),
          tags$li('Open 02 · Data types & templates; download the example for your intended analysis.'),
          tags$li('Open 03 · My study; upload raw CSV/Excel, map columns, set the eligible informant count, then validate.'),
          tags$li('Inspect 04 · My results or open the independent analytical windows with their own uploads.'),
          tags$li('Export tables and plots, and document sampling assumptions and formula provenance before publication.')),
        downloadButton('startup_guide','Download complete startup guide'),
        p('This application processes local data. Example datasets are synthetic; do not report them as field observations.'))),
      column(7,wellPanel(h3('Methods and scientific readiness'),
        p('The formula registry contains 69 indexed methodological records. Registry inclusion does not mean an executable or validated calculator.'),
        h4('Calculations exposed by the current software'),
        tableOutput('about_operational'),
        h4('Under development / additional data required'),
        p('Browse the complete list of registry methods, abbreviations and recorded formulas below. Methods may require binary presence/absence, repeated interviews, scored-use matrices, original reference definitions or local policy indicators.'),
        selectInput('about_status','Show registry methods',c('Full registry with implementation caveats'='all')),
        div(class='table-responsive',tableOutput('about_registry')),
        downloadButton('about_registry_csv','Download annotated registry CSV'),
        p('Missing or ambiguous source formulas are identified explicitly, not reconstructed by guesswork.'))))),
    tabPanel('02 · Data types & templates',fluidRow(
      column(4,wellPanel(h4('Analysis input guide'),p('Choose an analysis to view its raw-data structure, required column names and an example file. All templates are CSV; open in Excel if preferred.'),selectInput('guide_analysis','Analysis',choices=character(0)),downloadButton('guide_sample','Download selected example CSV'),downloadButton('guide_dictionary','Download full data dictionary CSV'),hr(),p('Use exact column names for analysis-specific uploads. For Window 01, use the column-mapping controls.'),p('The example files are illustrative, not field observations.'))),
      column(8,wellPanel(h4('Required file structure'),tableOutput('guide_details'),h4('Preview: actual example columns and rows'),div(class='table-responsive',tableOutput('guide_preview')),p('Long format: repeated observations in rows. Wide matrix: one sample per row, with numeric measurements in separate columns. CCA requires two aligned wide matrices.'))))),
    tabPanel('03 · My study',fluidRow(
      column(4,wellPanel(h4('Study details'),textInput('study','Study title','My ethnobotanical survey'),textInput('investigator','Researcher / institute',''),textInput('site','Study region',''),selectInput('dataset_type','Dataset type',c('Informant-based survey (respondent citations)'='survey','Compiled species–use records (no respondent IDs)'='compiled')),conditionalPanel(condition="input.dataset_type == 'survey'",selectInput('unit','Citation data structure',c('One row per unique informant–species–use report'='citation'))),hr(),fileInput('csv','Upload survey data (CSV, XLSX or XLS)',accept=c('.csv','.xlsx','.xls')),uiOutput('sheet_selector'),checkboxInput('demo','Use demonstration dataset when no file is uploaded',TRUE),uiOutput('data_source'),uiOutput('column_mapping'),conditionalPanel(condition="input.dataset_type == 'survey'",numericInput('N','Total eligible informants (including non-citers)',6,min=1,step=1)),numericInput('chapters','Number of ICD categories in study coding scheme',20,min=1,step=1),actionButton('calculate','Validate & calculate',class='btn-primary'),hr(),downloadButton('template','Download citation template'),tags$p(class='eq-warning','Uploaded CSV or Excel always takes priority. Select the worksheet and map columns before calculating. Aggregate respondent-count tables cannot be treated as individual citations.'))),
      column(8,h4('Data preview'),div(class='table-responsive',tableOutput('preview')),h4('Study diagnostics'),verbatimTextOutput('diagnostics'),uiOutput('validation_status'),h4('Input field guide'),tags$p('Minimum required: respondent/informant ID and plant species. Map the fields in the left panel. Other missing columns are kept blank, so calculations needing them may be unavailable. Each row must represent one distinct use report, not a survey participant.'),tags$p('Upload CSV or Excel with column headings. The original values are retained. Use one row per individual informant–species–use report; aggregated respondent counts need a separate method. Check counting units and denominator.')))),
    tabPanel('04 · My results',fluidRow(column(4,wellPanel(uiOutput('metric_picker'),uiOutput('species_filter'),downloadButton('csv_result','Download selected table'),hr(),uiOutput('method_info'))),column(8,h4('Analysis results'),div(class='table-responsive',tableOutput('results')),verbatimTextOutput('result_note')))),
    tabPanel('05 · Charts',fluidRow(column(4,wellPanel(selectInput('plot_metric','Metric',c('RFC','FC','reports','category_count','use_type_count','UV_reports_per_eligible')),numericInput('top_n','Top species',12,min=1,max=100,step=1),downloadButton('chart_png','Download chart (PNG)'),p('Exploratory visualization; no inferential test is implied.'))),column(8,plotOutput('species_plot',height='500px')))),
    tabPanel('06 · Habitat EIV',fluidRow(column(4,wellPanel(fileInput('eiv_salience','Species salience CSV',accept='.csv'),fileInput('eiv_habitat','Habitat abundance CSV',accept='.csv'),actionButton('eiv_run','Calculate habitat EIV',class='btn-primary'),hr(),downloadButton('eiv_sal_template','Salience template'),downloadButton('eiv_hab_template','Habitat template'),downloadButton('eiv_download','Export habitat results'))),column(8,h4('EIV by habitat'),tableOutput('eiv_results'),h4('Species contributions'),div(class='table-responsive',tableOutput('eiv_contributions')),verbatimTextOutput('eiv_note')))),
    tabPanel('07 · Group comparison',fluidRow(column(4,wellPanel(fileInput('sex_denoms','Eligible informants per group CSV',accept='.csv'),actionButton('sex_run','Calculate group-specific rates',class='btn-primary'),hr(),downloadButton('sex_template','Group denominator template'),downloadButton('sex_download','Export group results'),p('Citation dataset must include a sex column and all eligible group sizes must be supplied.'))),column(8,h4('Citation reports per eligible respondent'),tableOutput('sex_results'),verbatimTextOutput('sex_note')))),
    tabPanel('08 · Formula library',fluidRow(column(4,wellPanel(textInput('search','Search method, equation or status',''),selectInput('status_filter','Verification filter',c('All'='all','Ready / implementable'='ready','Blocked / provisional'='blocked')),p('A formula in this reference library is not necessarily an executable calculator.'))),column(8,h4('69 indexed formula records'),div(class='table-responsive',tableOutput('catalog'))))),
    tabPanel('08a · Advanced indices guide',fluidRow(
      column(5,wellPanel(h4('Advanced indices: data upload and navigation'),
        p('Use 08b for Performance Index (IP) and Purpose Consensus (PC); 08c for conservation priority; 08d for species evenness and cultural significance.'),
        p('For 08b upload a CSV with species, ailment, use_type and optionally informant_id. For 08c and 08d use the separate uploads in those tabs.'),
        downloadButton('advanced_template','Download 06b sample CSV'),
        tags$p('Each row must represent a genuine citation report; do not duplicate or expand aggregated reports.'))),
      column(7,wellPanel(h4('Available calculation windows'),
        tags$p('08b — Performance Index and Purpose Consensus (separate upload available).'),
        tags$p('08c — Published Campos–Albuquerque CPI (species-level upload).'),
        tags$p('08d — Total/informant species equitability, Shannon–Pielou and ICS (separate uploads).'),
        tags$p('06 — Formula library includes reference-only methods that are not executable.'))))),
    tabPanel('08b · Source-based indices',fluidRow(column(4,wellPanel(h4('Source-based indices'),p('Upload a CSV containing species, ailment and use_type. If no file is uploaded here, the active study dataset from 01 is used. IP requires ailment; PC requires use_type.'),fileInput('source_csv','Upload IP / PC citations (CSV)',accept='.csv'),downloadButton('source_template','Download IP / PC sample CSV'),actionButton('source_run','Calculate IP and PC',class='btn-primary'),downloadButton('source_ip_csv','Download IP'),downloadButton('source_pc_csv','Download PC'))),column(8,h4('Performance Index (IP)'),tableOutput('source_ip'),h4('Purpose Consensus (PC)'),tableOutput('source_pc'),verbatimTextOutput('source_note')))),
    tabPanel('08c · Conservation priority (CPI)',fluidRow(
      column(4,wellPanel(h4('Published CPI — Campos & Albuquerque (2021)'),
        p('Upload one row per species with counts of medicinal body systems (NSCE), medicinal properties (NPE), and binary RENISUS and ANVISA flags.'),
        fileInput('cpi_csv','Species-level CPI data (CSV)',accept='.csv'),
        downloadButton('cpi_template','Download CPI input template'),
        actionButton('cpi_run','Calculate published CPI',class='btn-primary'),
        downloadButton('cpi_download','Download CPI results'),
        tags$p(class='eq-warning','RENISUS and ANVISA are Brazil-specific criteria. For studies elsewhere, a locally adapted index requires an explicit new definition and cannot be called the unmodified published CPI.'))),
      column(8,h4('Conservation Priority Index — published method'),
        p('RI = NSCE/max(NSCE) + NPE/max(NPE); CPI = RI + 0.5*RENISUS + 0.5*ANVISA. Higher scores indicate greater relative priority under the study criteria, not an IUCN threat category.'),
        tableOutput('cpi_results'),verbatimTextOutput('cpi_note'),
        p('Source: Campos, J. L. A., & Albuquerque, U. P. (2021). Indicators of conservation priorities for medicinal plants from seasonal dry forests of northeastern Brazil. Ecological Indicators, 121, 106993. DOI: 10.1016/j.ecolind.2020.106993'),
        p('This CPI is not equivalent to the unresolved composite ICP equation catalogued as index 59.')))),
    tabPanel('08d · Species evenness and ICS',fluidRow(
      column(4,wellPanel(h4('Byg–Balslev species equitability'),p('Upload one row per informant–species use report. SEtot and SEi use inverse-Simpson diversity; Shannon–Pielou J is shown separately.'),fileInput('evenness_csv','Informant–species CSV',accept='.csv'),downloadButton('evenness_template','Evenness template'),actionButton('evenness_run','Calculate equitability',class='btn-primary'),downloadButton('evenness_export','Export informant equitability'),hr(),h4('Index of Cultural Significance (ICS)'),p('Supply one scored row per species–use. Quality, intensity and exclusivity must be assigned according to a documented research protocol; the app does not invent scores.'),fileInput('ics_csv','ICS scored uses CSV',accept='.csv'),downloadButton('ics_template','ICS template'),actionButton('ics_run','Calculate ICS',class='btn-primary'),downloadButton('ics_export','Export ICS'))),
      column(8,h4('Overall equitability'),tableOutput('evenness_overall'),h4('Per-informant equitability'),tableOutput('evenness_people'),h4('ICS by species'),tableOutput('ics_results'),p('Presentation slides are secondary explanatory material. Byg & Balslev (2001) and the documented Turner-style ICS formula govern these implementations.')))),
    tabPanel('09 · Quality & export',h4('Quality audit'),div(class='table-responsive',tableOutput('quality')),hr(),downloadButton('all_results','Download study analysis package (ZIP)'),h4('Reproducibility and scientific scope'),tags$p('Uploaded files take priority over demonstration data. Exports include study metadata, input diagnostics, calculation tables, the formula registry and a reproducibility note. The app uses local files and does not upload survey data to an external server.'),tags$p('Use-value report rates are proxies, not interview-event averaged Phillips–Gentry Use Values. A formula registry record does not imply source verification. The app does not infer clinical efficacy or conservation management priorities.'),tags$p('Run tests/run_all.R and tests/test_research_utilities.R. Scientific source verification and complete manual validation remain release requirements.')),
    eq7_obj_ui(),
    eq7_multi_ui(),
    eq7_tests_ui()
  )
)
server <- function(input, output, session) {
  operational <- data.frame(
    category=c('Citation and consensus','Citation and consensus','Citation and consensus','Citation and consensus','Species importance','Use patterns','Habitat','Group comparisons','Source-based','Source-based','Conservation','Diversity / evenness','Cultural scoring','Multivariate','Statistics'),
    methods=c('FC; RFC; report-count UV proxy','FIC; FL','CI; RI (two variants)','MAV; family report-rate proxy','Report totals; category and use-type richness','Plant part, use, site, season and preparation shares; inverse-Simpson diversity','Habitat EIV','Group-specific report rates','IP','PC','Campos–Albuquerque CPI','SEtot; SEi; Shannon–Pielou J','ICS from supplied q, i, e scores','PCA; CCA; hierarchical clustering; 2–5-set Venn','Welch t; paired t; known-SD Z; one-way ANOVA'),
    window=c('04','04','04','04','04','04','06','07','08b','08b','08c','08d','08d','11','12'),stringsAsFactors=FALSE)
  output$about_operational <- renderTable(operational,striped=TRUE,rownames=FALSE)
  registry_notes <- reference
  registry_notes$software_classification <- 'Under development / requires data or source verification'
  # An operational calculation does not establish numerical equivalence to a similarly named registry record.
  registry_notes$software_note <- 'Reference-only until explicitly linked and numerically validated against this application.'
  output$about_registry <- renderTable({if(identical(input$about_status,'all')) registry_notes else registry_notes},striped=TRUE,rownames=FALSE)
  output$about_registry_csv <- downloadHandler('EthnoQuant_registry_development.csv',function(file)write.csv(registry_notes,file,row.names=FALSE,na=''))
  output$startup_guide <- downloadHandler('EthnoQuant_START_HERE.md',function(file)file.copy('docs/START_HERE.md',file,overwrite=TRUE))
  guide_dict <- read.csv('data/ANALYSIS_DATA_DICTIONARY.csv',stringsAsFactors=FALSE,check.names=FALSE)
  observe({updateSelectInput(session,'guide_analysis',choices=setNames(guide_dict$analysis,guide_dict$analysis),selected=guide_dict$analysis[1])})
  guide_row <- reactive({req(input$guide_analysis);guide_dict[guide_dict$analysis==input$guide_analysis,,drop=FALSE]})
  output$guide_details <- renderTable({req(guide_row());guide_row()[,c('data_type','required_columns','row_or_matrix_structure','app_window'),drop=FALSE]},rownames=FALSE)
  output$guide_preview <- renderTable({req(guide_row());path<-guide_row()$example_file[1];req(file.exists(path));utils::head(read.csv(path,check.names=FALSE,stringsAsFactors=FALSE),6)},rownames=FALSE)
  output$guide_sample <- downloadHandler(filename=function()basename(guide_row()$example_file[1]),content=function(file){src<-guide_row()$example_file[1];if(!file.copy(src,file,overwrite=TRUE))stop('Example file missing')})
  output$guide_dictionary <- downloadHandler(filename='EthnoQuant_Analysis_Data_Dictionary.csv',content=function(file)file.copy('data/ANALYSIS_DATA_DICTIONARY.csv',file,overwrite=TRUE))
  eq7_server(input,output,session)
  output$sheet_selector <- renderUI({
    req(input$csv)
    ext <- tolower(tools::file_ext(input$csv$name))
    if (!ext %in% c('xls','xlsx')) return(NULL)
    if (!requireNamespace('readxl', quietly=TRUE))
      return(tags$div(class='eq-warning', 'Excel support needs the readxl package: install.packages("readxl")'))
    sheets <- tryCatch(readxl::excel_sheets(input$csv$datapath),error=function(e) character())
    if (!length(sheets)) return(tags$div(class='eq-warning','Unable to inspect workbook sheets.'))
    selectInput('excel_sheet','Excel worksheet',choices=sheets,selected=sheets[1])
  })
  uploaded <- reactive({
    if (is.null(input$csv)) return(NULL)
    ext <- tolower(tools::file_ext(input$csv$name))
    tryCatch({
      if (ext %in% c('xls','xlsx')) {
        if (!requireNamespace('readxl',quietly=TRUE)) stop('Install Excel reader: install.packages("readxl")')
        sheets <- readxl::excel_sheets(input$csv$datapath)
        sheet <- if (!is.null(input$excel_sheet) && input$excel_sheet %in% sheets) input$excel_sheet else sheets[1]
        d <- as.data.frame(readxl::read_excel(input$csv$datapath,sheet=sheet),check.names=FALSE,stringsAsFactors=FALSE)
        if (!nrow(d)) stop('Selected Excel worksheet contains no data rows')
        if (anyDuplicated(names(d))) stop('Worksheet contains duplicate column headings')
        return(d)
      }
      if (ext == 'csv') return(eq_read_csv(input$csv$datapath))
      stop('Unsupported extension: ',ext,'. Please upload CSV, XLS or XLSX.')
    },error=function(e){
      showNotification(paste('Import failed:',conditionMessage(e)),type='error',duration=12)
      NULL
    })
  })
  input_source <- reactive({
    if (!is.null(input$csv)) return('Uploaded file')
    if (isTRUE(input$demo)) return('Demonstration data')
    'No dataset selected'
  })
  output$data_source <- renderUI({
    tags$div(class='eq-note',tags$b('Active data source: '),input_source(),
      if(!is.null(input$csv)) tags$p(paste('File:',input$csv$name,'— uploaded data takes precedence over demonstration data.')))
  })
  original <- reactive({
    if (!is.null(input$csv)) return(uploaded())
    if (isTRUE(input$demo)) return(example)
    NULL
  })
  output$column_mapping <- renderUI({
    d <- original()
    if (is.null(d) || is.null(input$csv)) return(NULL)
    fields <- c('informant_id','species','family','use_category','use_type','ailment','plant_part','collection_site','collection_period','preparation','icd_chapter','sex')
    tags$div(tags$h4('Match your dataset columns'),tags$p(if(identical(input$dataset_type,'compiled')) 'Compiled mode: species required; informant ID is ignored.' else 'Survey mode: informant ID and species required; others optional.'),
      lapply(fields,function(f) {
        candidate <- eq_guess_column(names(d),f)
        selectInput(paste0('map_',f),f,choices=c('— Not available —'='',names(d)),selected=candidate)
      }))
  })
  raw <- reactive({
    d <- original()
    if (is.null(d)) return(NULL)
    if (is.null(input$csv)) return(d)
    if (is.null(input$map_species) || (identical(input$dataset_type,'survey') && is.null(input$map_informant_id))) return(NULL)
    mapping <- setNames(lapply(c('informant_id','species','family','use_category','use_type','ailment','plant_part','collection_site','collection_period','preparation','icd_chapter','sex'),function(f) input[[paste0('map_',f)]]),c('informant_id','species','family','use_category','use_type','ailment','plant_part','collection_site','collection_period','preparation','icd_chapter','sex'))
    eq_map_columns(d,mapping)
  })
  output$preview <- renderTable({req(original());head(original(),12)},striped=TRUE)
  output$diagnostics <- renderPrint({d<-original();req(d);cat('Source:',if(!is.null(input$csv)) input$csv$name else 'Demonstration dataset','\nRows:',nrow(d),'\nColumns:',paste(names(d),collapse=', '),'\nNote: source column names may differ from EthnoQuant fields; see mapping controls.\n')})
  calc <- reactiveVal(NULL)
  observeEvent(list(input$csv, input$excel_sheet, input$demo, input$N, input$chapters, lapply(c('informant_id','species','family','use_category','use_type','ailment','plant_part','collection_site','collection_period','preparation','icd_chapter','sex'),function(f) input[[paste0('map_',f)]])),{
    calc(NULL)
  },ignoreInit=TRUE)
  observeEvent(input$dataset_type,{calc(NULL)},ignoreInit=TRUE)
  observeEvent(input$calculate,{
    result <- tryCatch({
      d <- raw()
      if (is.null(d)) stop('No readable data. Upload CSV/Excel or enable demonstration data.')
      if(identical(input$dataset_type,'compiled')) eq_compiled_results(d) else eq_run_stage2(d,input$N,input$chapters)
    },error=function(e){
      showNotification(paste('Validation failed:',conditionMessage(e)),type='error',duration=NULL)
      NULL
    })
    calc(result)
  },ignoreInit=TRUE)
  output$validation_status <- renderUI({if(is.null(calc()))div(class='eq-note','Click Validate & calculate to generate study-specific results. If a mapping is invalid, correct it and retry.') else div(class='eq-note',strong('Validation successful. '),paste(length(calc()),if(identical(input$dataset_type,'compiled')) 'descriptive tables (no informant-based metrics) generated from' else 'analysis tables generated from',if(!is.null(input$csv))input$csv$name else 'demonstration data','.'))})
  output$metric_picker <- renderUI({req(calc());selectInput('result','Calculation table',choices=names(calc()),selected='species')})
  output$species_filter <- renderUI({req(calc(),input$result);d<-calc()[[input$result]];if(!is.data.frame(d)||!('species'%in%names(d)))return(NULL);selectInput('species_selected','Filter species',c('All species',sort(unique(as.character(d$species)))))})
  selected <- reactive({req(calc(),input$result);d<-calc()[[input$result]];if(is.data.frame(d)&&'species'%in%names(d)&&!is.null(input$species_selected)&&input$species_selected!='All species')d<-d[d$species==input$species_selected,,drop=FALSE];d})
  output$results <- renderTable({selected()},striped=TRUE,digits=5)
  output$result_note <- renderText({req(input$result);if(identical(input$dataset_type,'compiled')) 'Descriptive compiled-record frequencies only; no informant-based indices or denominators.' else if(input$result=='species')'RFC = distinct citing informants / eligible informants. UV_reports_per_eligible is a report-count proxy, not event-based UV.' else if(input$result=='family_use_value')'Family mean is based on the report-count proxy; do not label it as validated Phillips–Gentry FUV.' else if(input$result=='MAV')'MAV requires the optional icd_chapter column and the declared number of ICD categories.' else 'Each method uses the counting conventions documented in the package.'})
  output$method_info <- renderUI({req(input$result);tags$div(class='eq-note',tags$b('Interpretation caution'),tags$p('Calculated outputs are descriptive. Refer to the formula registry and scientific validation document before publication.'))})
  draw_plot <- function(){req(calc());d<-calc()$species;key<-if(identical(input$dataset_type,'compiled')) 'reports' else input$plot_metric;validate(need(key%in%names(d),'Metric unavailable'));d<-d[is.finite(d[[key]]),,drop=FALSE];validate(need(nrow(d)>0,'No valid data for this chart'));d<-head(d[order(d[[key]],decreasing=TRUE),,drop=FALSE],input$top_n);par(mar=c(5,13,4,2));barplot(rev(d[[key]]),names.arg=rev(d$species),horiz=TRUE,las=1,col='#248b66',border=NA,xlab=key,cex.names=.82,main=paste(input$study,'—',key))}
  output$species_plot <- renderPlot(draw_plot(),height=500)
  output$chart_png <- downloadHandler(filename=function()paste0('EthnoQuant_',input$plot_metric,'.png'),content=function(file){grDevices::png(file,width=1700,height=1100,res=180);on.exit(grDevices::dev.off(),add=TRUE);draw_plot()})
  eiv_calc <- eventReactive(input$eiv_run,{tryCatch({req(input$eiv_salience,input$eiv_habitat);eq_eiv(read.csv(input$eiv_salience$datapath,stringsAsFactors=FALSE),read.csv(input$eiv_habitat$datapath,stringsAsFactors=FALSE))},error=function(e){showNotification(conditionMessage(e),type='error',duration=10);NULL})})
  output$eiv_results <- renderTable({req(eiv_calc());eiv_calc()$by_habitat},striped=TRUE,digits=5)
  output$eiv_contributions <- renderTable({req(eiv_calc());eiv_calc()$contributions},striped=TRUE,digits=5)
  output$eiv_note <- renderText('EIV = sum over species of salience × (individuals in habitat / total individuals across sampled habitats).')
  output$eiv_sal_template <- downloadHandler('EthnoQuant_salience.csv',function(file)file.copy('data/sample_salience.csv',file))
  output$eiv_hab_template <- downloadHandler('EthnoQuant_habitat_counts.csv',function(file)file.copy('data/sample_habitat_counts.csv',file))
  output$eiv_download <- downloadHandler('EthnoQuant_EIV.csv',function(file){req(eiv_calc());write.csv(eiv_calc()$by_habitat,file,row.names=FALSE)})
  sex_calc <- eventReactive(input$sex_run,{tryCatch({req(input$sex_denoms);eq_sex_uv_stage3(eq_validate(raw(),input$N),read.csv(input$sex_denoms$datapath,stringsAsFactors=FALSE))},error=function(e){showNotification(conditionMessage(e),type='error',duration=10);NULL})})
  output$sex_results <- renderTable({req(sex_calc());sex_calc()},striped=TRUE,digits=5)
  output$sex_note <- renderText('These are citation report rates by group, not interview-event averaged use values.')
  output$sex_template <- downloadHandler('EthnoQuant_group_denominators.csv',function(file)file.copy('data/sample_group_denominators.csv',file))
  output$sex_download <- downloadHandler('EthnoQuant_group_rates.csv',function(file){req(sex_calc());write.csv(sex_calc(),file,row.names=FALSE)})
  source_calcs <- eventReactive(input$source_run,{tryCatch({d<-if(!is.null(input$source_csv)) read.csv(input$source_csv$datapath,stringsAsFactors=FALSE,check.names=FALSE) else raw();req(d);list(ip=eq_source_performance_index(d),pc=eq_source_purpose_consensus(d))},error=function(e){showNotification(conditionMessage(e),type='error',duration=12);NULL})})
  output$source_template <- downloadHandler('EthnoQuant_IP_PC_sample.csv',function(file)file.copy('data/ip_pc_sample.csv',file))
  output$advanced_template <- downloadHandler('EthnoQuant_IP_PC_sample.csv',function(file)file.copy('data/ip_pc_sample.csv',file))
  output$source_ip <- renderTable({req(source_calcs());source_calcs()$ip},digits=5)
  output$source_pc <- renderTable({req(source_calcs());source_calcs()$pc},digits=5)
  output$source_note <- renderText('IP: P1=C1/C2, P2=C3/C4, D=P1-P2; four performance classes. PC: sum_u(p_u^2)/S. Source-based equations; input completeness and citation-unit assumptions must be checked.')
  output$source_ip_csv <- downloadHandler('EthnoQuant_IP.csv',function(file){req(source_calcs());write.csv(source_calcs()$ip,file,row.names=FALSE)})
  output$source_pc_csv <- downloadHandler('EthnoQuant_PC.csv',function(file){req(source_calcs());write.csv(source_calcs()$pc,file,row.names=FALSE)})
  output$cpi_template <- downloadHandler('EthnoQuant_CPI_input_template.csv',function(file)file.copy('data/cpi_input_template.csv',file))
  cpi_result <- eventReactive(input$cpi_run,{tryCatch({req(input$cpi_csv);eq_campos_cpi(read.csv(input$cpi_csv$datapath,stringsAsFactors=FALSE,check.names=FALSE))},error=function(e){showNotification(paste('CPI:',conditionMessage(e)),type='error',duration=12);NULL})})
  output$cpi_results <- renderTable({req(cpi_result());cpi_result()},digits=4,striped=TRUE)
  output$cpi_note <- renderText({req(cpi_result());paste(nrow(cpi_result()),'species scored. Reference maxima are computed from the uploaded species set. CPI has no source-defined universal priority thresholds.')})
  output$cpi_download <- downloadHandler('EthnoQuant_Campos_CPI.csv',function(file){req(cpi_result());write.csv(cpi_result(),file,row.names=FALSE)})
  output$evenness_template <- downloadHandler('EthnoQuant_evenness_template.csv',function(file)file.copy('data/evenness_template.csv',file))
  output$ics_template <- downloadHandler('EthnoQuant_ICS_template.csv',function(file)file.copy('data/ics_scores_template.csv',file))
  evenness_result <- eventReactive(input$evenness_run,{tryCatch({req(input$evenness_csv);eq_species_evenness(read.csv(input$evenness_csv$datapath,stringsAsFactors=FALSE))},error=function(e){showNotification(conditionMessage(e),type='error',duration=12);NULL})})
  ics_result <- eventReactive(input$ics_run,{tryCatch({req(input$ics_csv);eq_ics_scores(read.csv(input$ics_csv$datapath,stringsAsFactors=FALSE))},error=function(e){showNotification(conditionMessage(e),type='error',duration=12);NULL})})
  output$evenness_overall <- renderTable({req(evenness_result());evenness_result()$overall},digits=5)
  output$evenness_people <- renderTable({req(evenness_result());evenness_result()$per_informant},digits=5)
  output$ics_results <- renderTable({req(ics_result());ics_result()},digits=5)
  output$evenness_export <- downloadHandler('EthnoQuant_SEi.csv',function(file){req(evenness_result());write.csv(evenness_result()$per_informant,file,row.names=FALSE)})
  output$ics_export <- downloadHandler('EthnoQuant_ICS.csv',function(file){req(ics_result());write.csv(ics_result(),file,row.names=FALSE)})
  output$catalog <- renderTable({q<-tolower(trimws(input$search));x<-reference;if(nzchar(q))x<-x[apply(x,1,function(r)any(grepl(q,tolower(as.character(r)),fixed=TRUE))),,drop=FALSE];if(input$status_filter=='ready')x<-x[grepl('ready|implementable|corrected',x$verification_status,ignore.case=TRUE),,drop=FALSE];if(input$status_filter=='blocked')x<-x[grepl('hold|block|provision|source|clarif|missing',x$verification_status,ignore.case=TRUE),,drop=FALSE];x},striped=TRUE)
  output$quality <- renderTable({req(calc());calc()$quality_audit},striped=TRUE)
  output$template <- downloadHandler('EthnoQuant_citation_template.csv',function(file)file.copy('data/sample_citations.csv',file))
  output$csv_result <- downloadHandler(filename=function()paste0('EthnoQuant_',input$result,'.csv'),content=function(file){req(selected());write.csv(selected(),file,row.names=FALSE,na='')})
  output$all_results <- downloadHandler(filename=function()paste0('EthnoQuant_',eq_safe_filename(input$study),'_results.zip'),content=function(file){req(calc());td<-tempfile('ethnoquant_');dir.create(td);on.exit(unlink(td,recursive=TRUE),add=TRUE);for(nm in names(calc()))write.csv(calc()[[nm]],file.path(td,paste0(nm,'.csv')),row.names=FALSE,na='');file.copy('reference/formula_catalog.csv',file.path(td,'formula_catalog.csv'));meta<-data.frame(field=c('study','investigator','region','source','eligible_informants','icd_categories','generated_at','software_version'),value=c(input$study,input$investigator,input$site,if(!is.null(input$csv))input$csv$name else 'demonstration',if(identical(input$dataset_type,'compiled')) 'not applicable' else input$N,input$chapters,as.character(Sys.time()),'EthnoQuant'),stringsAsFactors=FALSE);write.csv(meta,file.path(td,'study_metadata.csv'),row.names=FALSE);writeLines(c('EthnoQuant — Excel/CSV research candidate',if(identical(input$dataset_type,'compiled')) 'Compiled species-use records: no genuine informant IDs; do not interpret as respondent citations.' else 'One row = one unique citation report.','RFC and FL use distinct informant counts.','UV_reports_per_eligible is a report-count proxy, not published event-averaged UV.','Scientific source verification pending for selected formulas.','Only tables computed by the current calculation engine are exported.'),file.path(td,'METHODS_AND_LIMITATIONS.txt'));eq_make_zip(file,td)})
}
shinyApp(ui,server)
