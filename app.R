library(shiny)
######################################## ui #######################################

ui <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
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
}
 


############################### excetue ###################################
shinyApp(ui, server)
