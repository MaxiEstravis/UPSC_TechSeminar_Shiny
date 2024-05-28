library(shiny)
library(leaflet)
library(dplyr)
library(readr)
library(RColorBrewer)

ui <- fluidPage(
  titlePanel("Sample Locations"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload CSV File", accept = c(".csv")),
      actionButton("reset", "Reset Selection"),
      downloadButton("downloadData", "Download Selected Data"),
      verbatimTextOutput("hoverInfo")
    ),
    mainPanel(
      leafletOutput("map"),
      tableOutput("selectedTable")
    )
  )
)

server <- function(input, output, session) {
  
  # Reactive expression to read the uploaded file
  data <- reactive({
    req(input$file)
    read_csv(input$file$datapath)
  })
  
  # Reactive expression to store selected points
  selected_points <- reactiveVal(data.frame())
  
  # Reactive value to store hover info
  hover_info <- reactiveVal("")
  
  # Render Leaflet map
  output$map <- renderLeaflet({
    req(data())
    
    # Create a color palette for the species
    species <- unique(data()$Species)
    palette <- colorFactor(brewer.pal(min(length(species), 9), "Set1"), domain = species)
    
    leaflet(data()) %>%
      addTiles() %>%
      addCircleMarkers(
        ~Longitude, ~Latitude,
        layerId = ~Name,
        color = ~palette(Species)
      )
  })
  
  # Observe map click event
  observeEvent(input$map_marker_click, {
    click <- input$map_marker_click
    new_point <- data() %>%
      filter(Name == click$id)
    current_selection <- selected_points()
    if (nrow(current_selection) == 0 || !any(current_selection$Name == new_point$Name)) {
      selected_points(rbind(current_selection, new_point))
    } else {
      selected_points(current_selection %>% filter(Name != new_point$Name))
    }
  })
  
  # Observe map mouseover event
  observeEvent(input$map_marker_mouseover, {
    hover <- input$map_marker_mouseover
    if (!is.null(hover)) {
      hover_data <- data() %>%
        filter(Name == hover$id)
      hover_info(paste("Name:", hover_data$Name, "\nSpecies:", hover_data$Species, "\nLatitude:", hover_data$Latitude, "\nLongitude:", hover_data$Longitude))
    }
  })
  
  # Observe map mouseout event
  observeEvent(input$map_marker_mouseout, {
    hover_info("")
  })
  
  # Render hover information
  output$hoverInfo <- renderText({
    hover_info()
  })
  
  # Render selected points table
  output$selectedTable <- renderTable({
    selected_points()
  })
  
  # Handle file download
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("selected_samples", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write_csv(selected_points(), file)
    }
  )
  
  # Reset selection button
  observeEvent(input$reset, {
    selected_points(data.frame())
  })
}

shinyApp(ui = ui, server = server)
