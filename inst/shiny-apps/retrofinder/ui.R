library(shiny)
library(shinydashboard)
#library(semantic.dashboard)

ui <- function(request) {

  dashboardPage(skin = "green",

  dashboardHeader(title = "Återfynd", 
    tags$li(
        a(href = 'https://alternativ.nu/butik', target = '_blank',
				img(src = "alpha.png", height = 30, width = 30),
				title = "Åter!",
				style = "padding-top:10px; padding-bottom:10px;"),
        class = "dropdown")),
  
  dashboardSidebar(disable = FALSE, #width = 300,
    # sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
    #               label = "Fritextsök..."),
    # sidebarMenu(
    #   menuItem("Artikelregister", tabName = "toc", icon = icon("table")),
    #   menuItem("Sökresultat", tabName = "hits", icon = icon("list"))
    # ),
    
          selectizeInput(inputId = "group", label = strong("Ämnesområde(n)"),
        multiple = TRUE, 
        choices = c("Välj ett eller flera ämnen" = "", unique(articles$topic)),
        selected = unique(articles$topic)[1]
        ),
      
#      selectizeInput(inputId = "category", label = strong("Kategori"),
#        multiple = TRUE, choices = unique(articles$category)),

      selectInput(inputId = "availability", label = strong("Tillgänglighet"),
        choices = c(unique(articles$availability), 
          "Köpt via prenumeration", "Ej köpt, i lager"),
        selected = "Tryckt"),
            
      # dateRangeInput("date", strong("Utgivningsår"), 
      #    start = sprintf("%s-01-01", min(articles$year)), 
      #    end = sprintf("%s-01-01", max(articles$year)),
      #    min = sprintf("%s-01-01", min(articles$year)), 
      #    max = sprintf("%s-01-01", max(articles$year)))),

      sliderInput("date", strong("Utgivningsår"), pre = "År ", sep = "",
         value = c(min(articles$year), max(articles$year)),
         min = min(articles$year),
         max = max(articles$year)),

#      recaptcha_shiny_ui("test", sitekey = "6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI"),
#      uiOutput("subscribers_only"),
      textInput("subscriber", "Prenumerantkod")#,
      #textOutput("credits")

#      bookmarkButton(label = "Bokmärke ...")
    
  ),
  dashboardBody(
#    tabItems(
      # First tab content 
#      tabItem(tabName = "hits",
      # Boxes need to be put in a row (or column)
#        fluidRow(box(
#      valueBox(textOutput("credits"), "", 
#       icon = icon("credit-card"), width = NULL, color = "green"))),
    fluidRow(valueBoxOutput("credits")),
dataTableOutput("table1")
#        )))
#      ),  
     # Second tab content
#      tabItem(tabName = "toc",
#        fluidRow(box
#          dataTableOutput("toc1")
#        )              
#      )
#    )
  )
)

# https://github.com/CannaData/shinyCAPTCHA

# tags$head(tags$script(src="https://www.google.com/recaptcha/api.js")),
# tags$div(class = "g-recaptcha", id="google-captcha", 
#          `data-sitekey` = "site-key: insert your own"),

# library(shinyAce)
# library(mailR)
# textInput("contact_name", "Name*", placeholder = "Ed Snow"
# textInput("contact_email", "Email*", placeholder = "eddie@lubyanka.com")
# aceEditor(outputId = "contact_message", value = "...", fontSize = 13)
# checkboxInput("contact_not_a_robot", "I'm not a robot*", value = FALSE), # !!! actionButton("contact_click_send", "Send")
  
}