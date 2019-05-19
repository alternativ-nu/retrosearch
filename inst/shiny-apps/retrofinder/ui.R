library(shiny)
library(shinydashboard)

ui <- function(request) {

  dashboardPage(skin = "green",

    dashboardHeader(title = "Återfynd", 
      tags$li(
          a(href = 'https://alternativ.nu/butik', target = '_blank',
  				img(src = "alpha.png", height = 30, width = 30),
  				title = "Åter!",
  				style = "padding-top:10px; padding-bottom:10px;"),
          class = "dropdown")),
    
    dashboardSidebar(disable = FALSE, 
      
      #sidebarMenu(
      #  menuItem("Artikelregister", tabName = "tab1", icon = icon("table"))
      #),
  
      selectizeInput(inputId = "group", label = strong("Ämnesområde(n)"),
        multiple = TRUE, 
        choices = c("Välj ett eller flera ämnen" = "", unique(articles$topic)),
        selected = unique(articles$topic)[1]
      ),
        
      selectInput(inputId = "availability", label = strong("Tillgänglighet"),
        choices = c(unique(articles$availability), 
          "Köpt via prenumeration", "Ej köpt, i lager"),
        selected = "Tryckt"
      ),
              
      sliderInput("date", strong("Utgivningsår"), pre = "År ", sep = "",
         value = c(min(articles$year), max(articles$year)),
         min = min(articles$year),
         max = max(articles$year)
      ),
  
      textInput("subscriber", "Prenumerantkod")
  
    ),
    
    dashboardBody(
#      tabItem(tabName = "tab1",
        fluidRow(valueBoxOutput("credits")),
        fluidRow(box(width = 12, DT::dataTableOutput("table1")))
#      )
    )
  )
}
