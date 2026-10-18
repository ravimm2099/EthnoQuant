# Run this file from RStudio with Source, or paste its contents into Console.
# Locates app.R from the current script if possible; otherwise select the app.R file.
if (!requireNamespace("shiny", quietly=TRUE)) stop("Install shiny: install.packages('shiny')")
app_file <- file.choose()
if (basename(app_file) != "app.R") stop("Select app.R inside the extracted EthnoQuant folder")
app_dir <- dirname(normalizePath(app_file, winslash="/"))
stopifnot(file.exists(file.path(app_dir, "R_ethnoquant.R")), file.exists(file.path(app_dir,"reference/formula_catalog.csv")))
shiny::runApp(appDir=app_dir, launch.browser=TRUE)
