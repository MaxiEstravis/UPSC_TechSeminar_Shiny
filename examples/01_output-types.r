library("shiny")

shinyApp(
  ui=fluidPage(
    titlePanel("Example - Different output types"),
    sidebarLayout(
      sidebarPanel(
        textInput("text_output",label="Text input", value="Type text here")
      ),
      mainPanel(
        verbatimTextOutput("verbatim_text_output"),
        tableOutput("table_output"),
        plotOutput("plot_output",width="400px",height="400px")))),
  server=function(input, output) {
    output$text_output <- renderText({input$text_output})
    output$verbatim_text_output <- renderText({input$text_output})
    output$table_output <- renderTable({mtcars[1:10,1:6]})
    output$plot_output <- renderPlot({plot(mtcars[,1],mtcars[,6],main = input$text_output)})
  })