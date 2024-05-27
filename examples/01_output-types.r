library("shiny")

shinyApp(
  ui=fluidPage(
    titlePanel("Example - Different output types"),
    sidebarLayout(
      sidebarPanel(
        textInput("text_input",
                  label="Text input", 
                  value="Type text here"),
        selectInput("select_align", 
                    label="Select column alignment", 
                    choices=c("l","c","r"))
      ),
      mainPanel(
        verbatimTextOutput("verbatim_text_output"),
        tableOutput("table_output"),
        plotOutput("plot_output",width="400px",height="400px")))),
  server=function(input, output) {
    output$verbatim_text_output <- renderText({input$text_input})
    output$table_output <- renderTable({mtcars[1:10,1:6]}, 
                                        align = reactive({input$select_align}), 
                                        width = "200%")
    output$plot_output <- renderPlot({plot(mtcars[,1],mtcars[,6], main = input$text_input)}, 
                                     width = 1000)
  })