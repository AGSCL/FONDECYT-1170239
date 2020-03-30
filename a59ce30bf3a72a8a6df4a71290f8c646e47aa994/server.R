options(shiny.maxRequestSize = 30*1024^2)
## --------
## server.R
## --------

library(rio)
library(shiny)
library(tools)
library(foreign)

server <- function(input, output) {
    getData <- reactive({
    inFile <- input$infile
    if (is.null(input$infile))
      return(NULL)
      rio::import(inFile$datapath)
  })
    getData_proc <- reactive({
      rio::export(file= "data.sav", x=getData())
      })
  output$contents <- renderTable(
    head(getData())
  )
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data", Sys.Date(), ".sav", sep="")
    },
    content = function(x) {
   #   rio::convert(input$infile$datapath, "mtcars.sav")
      #https://www.rdocumentation.org/packages/rio/versions/0.5.16/topics/export
      #https://stackoverflow.com/questions/57493392/how-to-fix-file-not-found-when-using-the-downloadhandler
      rio::export(getData(),file=x)
    }
)
  
}

