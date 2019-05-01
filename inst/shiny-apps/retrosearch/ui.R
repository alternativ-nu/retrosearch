#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
#library(semantic.dashboard)

ui <- dashboardPage(skin = "green",

  dashboardHeader(title = "Återsök", 
    tags$li(
        a(href = 'https://alternativ.nu/butik', target = '_blank',
				img(src = "alpha.png", height = 30, width = 30),
				title = "Åter!",
				style = "padding-top:10px; padding-bottom:10px;"),
        class = "dropdown")),
  dashboardSidebar(disable = TRUE,
    sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                  label = "Fritextsök..."), 
    sidebarMenu(
      menuItem("Artikelregister", tabName = "toc", icon = icon("table")),
      menuItem("Sökresultat", tabName = "hits", icon = icon("list"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content 
      tabItem(tabName = "hits",
      # Boxes need to be put in a row (or column)
#        fluidRow(column(12, box(
          dataTableOutput("table1")
#        )))
      ),  
     # Second tab content
      tabItem(tabName = "toc",
#        fluidRow(box
          dataTableOutput("toc1")
#        )              
      )
    )
  )
)