

## -----
## ui.R
## -----

library(shiny)
library(markdown)

shinyUI(fluidPage(sidebarLayout(
  
  sidebarPanel(fileInput('infile', label = "Datos en Stata (Máx. 30 MB)", buttonLabel = "Subir..."),
               downloadButton('downloadData', 'Bajar Base')
  ),
  mainPanel(
    h3("Muestra de Datos"),
    tableOutput("contents")
    )
)))