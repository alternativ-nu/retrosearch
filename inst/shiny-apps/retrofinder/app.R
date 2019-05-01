library(shiny)
library(shinythemes)
library(dplyr)
library(retrosearch)
library(lubridate)

available_pubs <- retrosearch:::available_pubs

topics0 <- 
  retrosearch_excel() %>%
  count() %>%
  mutate(topic = paste0("Alla ämnesgrupper - Allt (", n, ")"))

topics1 <- 
  retrosearch_excel() %>% 
  count(group) %>%
  mutate(topic = paste0(group, " - Allt (", n, ")")) 

topics2 <- 
  retrosearch_excel() %>% 
  count(group, category) %>%
  mutate(topic = paste0(group, " - ", category, " (", n, ")")) 

articles <- 
  bind_rows(
    retrosearch_excel() %>% mutate(topic = topics0$topic),
    topics1 %>% right_join(retrosearch_excel()),
    topics2 %>% right_join(retrosearch_excel())
  ) %>% 
  filter(!is.na(availability)) %>%
  arrange(-desc(topic)) %>%
  left_join(available_pubs, by = c("publication")) %>%
  mutate(Thumb = ifelse(!is.na(thumb), 
        paste0("<a href='", "https://www.alternativ.nu/butik/åter/åter-", q, y, ".html","'><img height=100 src='", thumb, "'/></a>"),
        NA))

ui <- fluidPage(theme = shinytheme("lumen"),
                
  titlePanel("Återfynd"),
         tags$a(href = "https://www.alternativ.nu/butik", "Hitta artiklar och gör ett Återköp i webbutiken på Alternativ.nu!", target = "_blank"),

  sidebarLayout(
    
    sidebarPanel(
  
      selectizeInput(inputId = "group", label = strong("Ämnesområde(n)"),
        multiple = TRUE, 
        choices = c("Välj ett eller flera ämnen" = "", unique(articles$topic))#,
        #selected = unique(articles$topic)[1]
        ),
      
#      selectizeInput(inputId = "category", label = strong("Kategori"),
#        multiple = TRUE, choices = unique(articles$category)),

      selectInput(inputId = "availability", label = strong("Tillgänglighet"),
        choices = unique(articles$availability),
        selected = "Tryckt"),
            
      # dateRangeInput("date", strong("Utgivningsår"), 
      #    start = sprintf("%s-01-01", min(articles$year)), 
      #    end = sprintf("%s-01-01", max(articles$year)),
      #    min = sprintf("%s-01-01", min(articles$year)), 
      #    max = sprintf("%s-01-01", max(articles$year)))),

      sliderInput("date", strong("Utgivningsår"), pre = "År ", sep = "",
         value = c(min(articles$year), max(articles$year)),
         min = min(articles$year),
         max = max(articles$year))),
      
    # Output: Description, lineplot, and reference
    mainPanel(
      #textOutput(outputId = "desc"),
      dataTableOutput(outputId = "table")
    )
  )
)

# Define server function
server <- function(input, output) {

  out <- reactive({
    req(input$date)
    req(input$group)
    validate(need(!is.na(input$date[1]) & !is.na(input$date[2]), "Error: Please provide both a start and an end date."))
    validate(need(input$date[1] < input$date[2], "Error: Start date should be earlier than end date."))
    res <- articles %>% filter(
      availability == input$availability,
      year >= as.numeric(input$date[1]) & year <= as.numeric(input$date[2])
#      ymd(sprintf("%s-01-01", year)) > as.POSIXct(input$date[1]) & ymd(sprintf("%s-01-01", year)) < as.POSIXct(input$date[2])
    )
    if (length(input$group) > 0)
      res <- res %>% filter(topic %in% input$group)
#    if (length(input$category) > 0)
#      res <- res %>% filter(category %in% input$category)
    
    res   
    
  })


  # Create table object the datatableOutput function is expecting
  output$table <- renderDataTable(escape = FALSE, options = list(
        dom = "ftp", pageLength = 5,
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
            previous = "Föregående sida"))),
    expr = out() %>% 
      mutate(pub = sprintf("%s-%s", year, nr)) %>%
      arrange(desc(year)) %>%
      mutate(`Källa` = paste(pub, page)) %>%
      mutate(Artikel = paste0(title, " av ", author, " (", `Källa`, ")")) %>%
      select(`Åternummer` = Thumb, Artikel, Sammanfattning = ingress)
)

  # Pull in description of trend
  output$desc <- renderText({
    paste("hello world")
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)
