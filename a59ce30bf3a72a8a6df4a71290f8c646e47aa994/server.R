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
  output$contents <- renderTable(
    head(getData())
  )
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".sav", sep="")
    },
    content = function(x) {
   #   rio::convert(input$infile$datapath, "mtcars.sav")
export(file= "data.sav", x=data())
    }
)
  
}

shinyApp(ui = ui, server = server)
