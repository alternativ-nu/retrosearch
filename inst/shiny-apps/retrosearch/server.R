#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(RSQLite)
library(tibble)
library(dplyr)
library(retrosearch)

toc <- retrosearch_toc()
search <- retrosearch_search()

server <- function(input, output, session) {
 
  values <- reactiveValues()
  values$df <- tibble()
  values$toc <- toc
  
  do <- eventReactive(input$searchButton, {input$searchText})
  
  observe({
    if (input$searchButton > 0) {
      isolate({
        wq <- reactive({ retrosearch_search(term = do()) })
        values$df <- wq()
      })
    }
  })
  
  rdt <- function(df) { 
    renderDataTable(df, 
      #rownames = FALSE, 
      escape = FALSE, 
      options = list(
        dom = "fpt",
#        columns = list(sPlaceHolder = "head:before"),
        scrollX = TRUE,
        info = FALSE,
        lengthChange = FALSE,
        language = list(
          search = "Sök", 
          paginate = list(
            first = "Första sidan", 
            last = "Sista sidan", 
            `next` = "Nästa sida", 
            previous = "Föregående sida"))
      )
    )}
  
  output$table1 <- rdt(values$df)

  output$toc1 <- rdt(values$toc)
    
  
}
