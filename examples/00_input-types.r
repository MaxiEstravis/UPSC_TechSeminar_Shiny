library("shiny")

ui=fluidPage(
  titlePanel("Example - Different input types"),
  sidebarLayout(
    sidebarPanel(
             fileInput("file-input", label="File Input"),
             selectInput("select-input", label="Select Input", choices=c("A","B","C")),
             numericInput("numeric-input",label="Numeric Input", value=5, min=1, max=10),
             sliderInput("slider-input", label="Slider Input", value=5, min=1, max=10),
             textInput("text-input", label="Text Input"),
             textAreaInput("text-area-input", label="Text Area Input"),
             dateInput("date-input", label="Date Input"),
             dateRangeInput("date-range-input", label="Date Range Input"),
             radioButtons("radio-button", label="Radio Buttons", choices=c("A","B","C"), inline=T),
             checkboxInput("checkbox", label="Checkbox Input", value=FALSE),
             actionButton("action-button","Action Button")),
    mainPanel()
  ))
  server=function(input,output) {
  }
shinyApp(ui=ui,server=server)