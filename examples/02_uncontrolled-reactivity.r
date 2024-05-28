library("shiny")

ui=fluidPage(
    titlePanel("Example - (Un)controlled reactivity"),
    sidebarLayout(
      sidebarPanel(
        textInput("text_input", label="Text input", value="Type text here")),
      mainPanel(
        plotOutput("plot_output",width="400px",height="400px"))))

server=function(input, output) {
    output$plot_output <- renderPlot({
      plot(mtcars[,1],mtcars[,6], main = input$text_input)
      random_number <- sample(1:1000, 1)
      legend("topright", legend = random_number, pch = 1)
      })}

shinyApp(ui=ui,server=server)
