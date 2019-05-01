library(shiny)
library(tibble)
library(dplyr)
library(retrosearch)
library(shinythemes)
library(lubridate)
library(RSQLite)

toc <- retrosearch_toc()
search <- retrosearch_search()

server <- function(input, output, session) {
 
  values <- reactiveValues()
  values$df <- tibble()
  values$toc <- toc
  
  # do <- eventReactive(input$searchButton, {input$searchText})
  # 
  # observe({
  #   if (input$searchButton > 0) {
  #     isolate({
  #       wq <- reactive({ retrosearch_search(term = do()) })
  #       values$df <- wq()
  #     })
  #   }
  # })
  
  rdt <- function(df) { 
    renderDataTable(df, 
      #rownames = FALSE, 
      escape = FALSE, 
      options = list(
        dom = "fpt", pageLength = 4,
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
      ), expr = out() 
    )}
  
    out <- reactive({
      req(input$date)
      req(input$group)
      validate(need(!is.na(input$date[1]) & !is.na(input$date[2]), "Error: Please provide both a start and an end date."))
      validate(need(input$date[1] < input$date[2], "Error: Start date should be earlier than end date."))
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

      res <- res %>%
          mutate(pub = sprintf("%s-%s", year, nr)) %>%
          arrange(desc(year)) %>%
          mutate(`Källa` = paste(publication, "s.", page)) %>%
#          mutate(Artikel = Source) %>%
          mutate(Artikel = paste0(title, " av ", author, " (", `Källa`, ")")) %>%
          mutate(Sammanfattning = ifelse(is.na(ingress), title, ingress)) %>%
          mutate(`Åternummer` = ifelse(is.na(Thumb), `Källa`, Thumb)) %>%
          mutate(Artikel = ifelse(is.na(Source), Artikel, Source)) %>%
          select(Sammanfattning, `Åternummer`, Artikel)
        # TODO för Artikel, om source är NA använd istället nedanstående
        # TODO för Åternummer, om Thumb är NA använd `Källa`
        # TODO för Sammanfattning, om ingress är NA använd "ingress saknas"

      res
    })

    # observeEvent(input$contact_click_send, {
    # 
    #   if( is.null(input$contact_click_send) || input$contact_click_send==0 
    #       || !input$contact_not_a_robot){ # !!! <---
    #         return(NULL)
    #   }
    # 
    #   send.mail(from = "kremlin@gmail.com",
    #             to = "trumptower@gmail.com",
    #             subject = "Shower time!",
    #             body = input$contact_message,
    #             smtp = list(host.name = "smtp.gmail.com"
    #                         , port = 465
    #                         , user.name = "kremlin@gmail.com"
    #                         , passwd = "DONALD_BIG_HANDS123"
    #                         , ssl = TRUE),
    #             authenticate = TRUE,
    #             html = TRUE, send = TRUE)
    # 
    # 
    #   # reset form
    #   updateTextInput(session, "contact_name",  value = "")
    #   updateTextInput(session, "contact_email", value = "")
    #   updateAceEditor(session, "contact_message", value = "Message sent succesfully!")
    #   updateCheckboxInput(session, "contact_not_a_robot", value = FALSE)
    #   updateActionButton(session, "contact_click_send", icon = icon("check"))
    # })
    # 
    
#  output$table1 <- rdt(values$df)

#  output$toc1 <- rdt(values$toc)

    output$table1 <- rdt(out())
    output$toc1 <- rdt(out())

#    result <- callModule(recaptcha_shiny_module, "test", secret = "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe")
  
    # output$subscribers_only <- renderUI({
    #   req(result()$success)
    #   tags$h1(result()$hostname)
    #   textInput("subscriber", "Prenumerantkod")
    # })    
  
    credits <- reactive({
      
      req(input$subscriber)
      
      validate(need(!is.na(input$subscriber) & 
        input$subscriber %in% subscriber_pnrs(), 
          "Fel: Ange en giltig prenumerantkod"))
      
      subscriber_credit(input$subscriber)
      
    })
    
#    output$credits <- renderText(credits())
    
    output$credits <- renderValueBox({
      valueBox(
        value = formatC(credits(), digits = 4, format = "d"),
        subtitle = "Saldo",
        icon = icon("credit-card"),
        color = "green"
      )
    })
    
}
