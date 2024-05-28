library(shiny)

ui = fluidPage(
  titlePanel("Example - Controlled reactivity"),
  textInput("text_input", label = "Text input", value = "Type text here"),
  actionButton("actButton", "Apply changes:"),
  plotOutput("plot_output", width = 400, height = 400)
)

server = function(input, output) {
  plot_data <- eventReactive(input$actButton, {
    list(
      plotTitle = input$text_input,
      plotLegend = sample(1:1000, 1)
    )
  })
  
  output$plot_output <- renderPlot({
    plot(mtcars[, 1], mtcars[, 6], main = plot_data()$plotTitle)
    legend("topright", legend = plot_data()$plotLegend, pch = 1)
  })
}

shinyApp(ui=ui, server=server)
