

## -----
## ui.R
## -----

library(shiny)
library(markdown)

available_formats <- c(
  'Sep por Comas'   = 'csv',
  'Excel (>=2007)'    = 'xlsx',
  'JSON'              = 'json',
  'R'                 = 'rds',
  'SAS (sas7bdat)'    = 'sas7bdat',
  'SAS (.csv + .sas)' = 'sas_plus_csv',
  'SPSS'              = 'sav',
  'Stata'             = 'dta',
  'Separado por Tabulaciones'     = 'tsv'
)

shinyUI(fluidPage(sidebarLayout(
  
  sidebarPanel(fileInput('infile', label = "Datos en Stata (Máx. 30 MB)", buttonLabel = "Subir..."),
               selectInput('output_format',
                           label = h3('Formato de Salida'), 
                           choices = available_formats,
                           selectize = FALSE,
                           size = length(available_formats)),
               downloadButton('download_data', 'Download')
  ),
  
  mainPanel(
    h3("Muestra de Datos"),
    tableOutput("preview1")
  )
  
)))