options(shiny.maxRequestSize = 30*1024^2)
## --------
## server.R
## --------

library(rio)
library(shiny)
library(tools)
library(foreign)
library(janitor)
library(lubridate)


server <- function(input, output) {
    getData <- reactive({
    inFile <- input$infile
    if (is.null(input$infile))
      return(NULL)
    haven::read_dta(inFile$datapath, encoding = "latin1")
  })
    getData_proc <- reactive({
      if (is.null(input$infile))
        return(NULL)
      janitor::clean_names(getData())
      #names(eso) <- gsub("-|\\.|\\/|'|\\[|\\]","",names(eso))
      #names(eso) <- gsub(" ","_",names(eso))
      })
  output$contents <- renderTable(
    head(getData_proc())
  )
  output$downloadData <- downloadHandler(
    filename = paste0("data_",format(Sys.time(), '%Y_%m_%d'),"_",hour(Sys.time()),"_",minute(Sys.time()),".sav"),
    content = function(x) {
   #   getData_proc()
      #rio::convert(getData(), "mtcars.sav")
      #https://www.rdocumentation.org/packages/rio/versions/0.5.16/topics/export
      #https://stackoverflow.com/questions/57493392/how-to-fix-file-not-found-when-using-the-downloadhandler
      rio::export(getData_proc(),file=x)
    }
)
  
}

