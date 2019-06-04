library(shiny)
library(tibble)
library(dplyr)
library(retrosearch)
library(shinythemes)
library(lubridate)
library(DT)

server <- function(input, output, session) {
 
  rdt <- function(df) { 
    
    message("here")
    
    # TODO: kolla detta - ska expr wrappas i DT::datatable?????
    DT::renderDataTable(server = TRUE, expr = DT::datatable(out(), 
      escape = FALSE, # TODO: bug with rownames = FALSE param!
      options = list(
         columnDefs = list(list(visible = FALSE, targets = c(3))),
         dom = "ft", 
         pageLength = 100,
         ordering = FALSE,
         language = list(
          search = "Sök",
          paginate = list(
            first = "Första sidan",
            last = "Sista sidan",
            `next` = "Nästa sida",
            previous = "Föregående sida"))
      ))) #, #escape = FALSE), 
      # escape = FALSE, rownames = FALSE, 
      # options = list(
      #   columnDefs = list(list(visible = FALSE, targets = c(3))), 
      #   escape = FALSE,
      #   ordering = FALSE,
      #   dom = "ft", 
      #   pageLength = 100,
      #   autoWidth = TRUE,
      #   scrollX = TRUE,
      #   info = FALSE,
      #   paging = FALSE,
      #   lengthChange = FALSE,

      # ))
}
  
    out <- reactive({

      req(input$date)
      req(input$group)
      
      shiny::validate(need(!is.na(input$date[1]) & !is.na(input$date[2]), 
        "Error: Please provide both a start and an end date."))
      
      shiny::validate(need(input$date[1] < input$date[2], 
        "Error: Start date should be earlier than end date."))
      
      res <- articles %>% filter(
        year >= as.numeric(input$date[1]) & year <= as.numeric(input$date[2])
      )
      
      if (input$availability == "Köpt via prenumeration") {
        res <- res %>% 
          filter(publication %in% subscriber_issues(input$subscriber))
      } else if (input$availability == "Ej köpt, i lager") {
        res <- res %>% 
          filter(publication %in% subscriber_issues_missing(input$subscriber))
      } else {
        res <- res %>% filter(availability == input$availability)
      }

      if (length(input$group) > 0)
        res <- res %>% filter(topic %in% input$group)

      out <- retrosearch_articles_summary(res)
      
      #out %>% tibble::remove_rownames()
      
      #rownames(out) <- NULL
      
    })

    output$table1 <- rdt(out())

    credits <- reactive({
      
      req(input$subscriber)
      
      shiny::validate(need(!is.na(input$subscriber) & 
        input$subscriber %in% subscriber_pnrs(), 
          "Fel: Ange en giltig prenumerantkod"))
    
      subscriber_credit(input$subscriber)
      
    })
    
    output$credits <- renderValueBox({
      valueBox(
        value = formatC(credits(), digits = 4, format = "d"),
        subtitle = "Saldo",
        icon = icon("credit-card"),
        color = "green"
      )
    })
    
}
