library(shiny)
library(bslib)
library(modeldata)
library(DataExplorer)
library(plotly)
library(tidyverse)

# dataset loading
utils::data("stackoverflow", "car_prices", "Sacramento", package = "modeldata")

data_list = list(
  "StackOverflow" = stackoverflow,
  "Car Prices"    = car_prices,
  "Sacramento Housing" = Sacramento
)

# user interface
ui <- navbarPage(
  title = "Data Explorer",
  theme = bslib::bs_theme(version = 4, bootswatch = "minty"),
  tabPanel(
    title = "Explore",
    sidebarLayout(
      sidebarPanel(
        width = 3,
        h1("Explore a Dataset"),
        
        shiny::selectInput(
          inputId = "dataset_choice",
          label   = "Data Connection",
          choices = c("StackOverflow", "Car Prices", "Sacramento Housing")
        ),
        
        hr(),
        h3("Apps by Business Science"),
        p("Go from beginner to building full-stack shiny apps."),
        p("Learn Shiny Today!") %>%
          a(
            href = 'https://www.business-science.io/',
            target = "_blank",
            class = "btn btn-lg btn-primary"
          ) %>%
          div(class = "text-center")
      ),
      
      mainPanel(
        h1("Correlation"),
        plotlyOutput("corrplot", height = 700)
      )
    )
    
  )
  
  
)

# server ----
server <- function(input, output) {
  rv <- reactiveValues()
  observe({
    rv$data_set <- data_list %>% pluck(input$dataset_choice)
  })
  output$corrplot <- renderPlotly({
    g <- DataExplorer::plot_correlation(rv$data_set)
    plotly::ggplotly(g)
  })
}

# run the app
shinyApp(ui = ui, server = server)
