

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
    h5("Los datos se obtendrán en formato Año_Mes_Día_hora_minutos, con los nombres normalizados para que sean leídos por SPSS."),
    h6("Desarrollador: Andrés González Santa Cruz"),
    htmlOutput("contents")
    )
)))

