library(shiny)
library(tidyverse)
######################################## ui #######################################

animals <- c("dog", "cat", "mouse", "bird", "other", "I hate animals")


ui <- fluidPage(
  ####################################################################################################
  # INPUT #
  # selectInput() # Using dataset list
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  
  # selectInput()  # state.name is provided by R
  selectInput("state", "what's your favorite state?", state.name),
  
  # selectInput() # multiple = TRUE
  selectInput("state", "What's your favorite state?", state.name, multiple = TRUE),
  
  
  # textInput()
  textInput("name", "What's your name?"),
  
  # passwordInput()
  passwordInput("password", "What's your password?"),
  
  # textAreaInput()
  textAreaInput("story", "Tell me about yourself", rows = 3),

  # numericInput()
  numericInput("num", "Number one", value = 0, min = 0, max = 100),
                
  # sliderInput()
  sliderInput("num2", "Number two", value = 50, min = 0, max = 100),
  sliderInput("rng", "Range", value = c(10, 20), min = 0, max = 100), # value is default setup
  
  # dateInput()
  dateInput("dob", "When were you born?"),
  
  # dateRangeInput()
  dateRangeInput("holiday", "When do you want to go on a vacation next?"),
  
  # radioButtons()
  radioButtons("animal", "What's your favorite animal?", animals),

  # radioButtons() advanced
  radioButtons("rb", "Choose one:", 
               choiceNames = list(
                 icon("angry"),
                 icon("smile"),
                 icon("sad-tear")
               ),
               choiceValues = list("angry", "happy", "sad")),
  
  # checkboxGroupInput
  checkboxGroupInput("animal", "What animals do you like?", animals),
  
  # checkboxInput
  checkboxInput("cleanup", "Clean up?", value = TRUE),
  checkboxInput("shutdown", "Shutdown?"),
  
  # fileInput  - it requires special handling on the server side.
  fileInput("upload", NULL),
  
  
  # Action  Buttons #
  # actionButton
  actionButton("click", "Click me!", class = "btn-danger"),
  actionButton("drink", "Drink me!", icon = icon("cocktail"), class = "btn-lg btn-success"),
  actionButton("eat", "Eat me!", class = "btn-block"), 
  
  ###################################################################################################
  # OUTPUT #    (verbatimTextOutput pair with renderPrint), (tableOutput pair with rednerTable)
  verbatimTextOutput("summary"),
  tableOutput("table"),
  
  # textOutput  (textOutput pair with renderText), (verbatimTextOutput pair with renderPrint)
  textOutput("text"),
  verbatimTextOutput("code"),
  
  # dataTableOutput (pair with renderDataTable)
  dataTableOutput("dynamic"),
  
  # tableOutput (pair with renderTable)
  tableOutput("static"),
  
  # dataTableOutput (pair with renderDataTable)
  dataTableOutput("dynamic_2"),
  
  # plotOutput (pair with renderPlot)
  plotOutput("plot", width = "400px")
)



######################################## server #######################################

server <- function(input, output, session){
  # Create a reactive expression 
  
  dataset <- reactive(get(input$dataset, "package:datasets"))
  
  output$summary <- renderPrint(
    # Use a reactive expression by calling it like a function
    summary(dataset())
  )
  
  output$table <- renderTable(dataset())
  
  output$text <- renderText("Hello Friend!")
  output$code <- renderPrint(summary(1:10))
  
  output$dynamic <- renderDataTable(mtcars)
  
  # renderTable for tableOutput
  output$static <- renderTable(head(mtcars))
  
  # renderDataTable for dataTableOutput
  output$dynamic_2 <- renderDataTable(mtcars, options = list(pageLength = 5))
  
  # renderPolt for plotOutput
  output$plot <- renderPlot(ggplot2::ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
                              ggplot2::geom_point())  # recommend always setting as res = 96
}



############################### excetue ###################################
shinyApp(ui, server)

