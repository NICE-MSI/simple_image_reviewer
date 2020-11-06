#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# To run accross the local network navigate to te msi_reviewer folder and run
#
# 
# shiny::runApp(port = 1234, host = "0.0.0.0")
#
# This can then be accessed at http://computer_name:1234 or http://computer_ip_address:1234
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Load required libraries
library(shiny)
library(tidyverse)

# Define UI for application
ui <- fluidPage(
   
   # Application title
   titlePanel("MSI single ion image reviewer"),
   
   # Sidebar with inputs for folder selection and rating 
   sidebarLayout(
      sidebarPanel(
        strong("Instructions"),
        p("Provide a path to a folder that the host will have write permissions to."),
        p("All .png images in this folder, and subolders will be displayed for rating"),
        p("Stop and click finish when you get to Bugs Bunny!"),
        hr(),
        textInput("dir", "Load data", value =  paste0(getwd(), "\\test_data")),
        #actionButton("load", "load images from path"),
        #actionButton("nextimg", "Next image"),
        hr(),
        strong("Rate ion images"),
        p("Rate the ion image based on single ion image and peak shape."),
        actionButton("good", "Good", style="color: #fff; background-color: green; border-color: green"),
        actionButton("unsure", "Unsure", style="color: #fff; background-color: orange; border-color: orange"),
        actionButton("bad", "Bad", style="color: #fff; background-color: red; border-color: red"),
        hr(),
        strong("Finish and save"),
        p("When no further images appear press \"Click to finish\""),
        actionButton("save", "Click to finish"),
        p("Results are saved as a csv in the folder with the images")
      ),
      
      # Show the current image
      mainPanel(
         imageOutput("plot")
      )
   )
)


# Define server logic required
server <- function(input, output) {

  # Set default values  
  appVals <- reactiveValues(
    i = 1,
    current_file = NA,
    swipes = tibble())
  
  # List images in the folder
  images <- reactive({list.files(input$dir, pattern = ".png|.jpg", full.names = TRUE, recursive = TRUE)})

  
  # Display the current image - when you get to the end display the closing title
current_image <- reactive({
    current_image <- images()
    current_image <- ifelse(is.na(current_image[appVals$i]), 
                            paste0(getwd(), "/thats_all_folks.jpg"),
                            current_image[appVals$i])
    return(current_image)
  })

   # Render the current imaage
output$plot <- renderImage({

  list(src = current_image(), width = 1200)


}, deleteFile = FALSE)

# If the next image is triggered increace the count by 1
observeEvent(input$nextimg, {
  appVals$i <- appVals$i + 1
  
})

# If the score is goood write the result to a table and move to the next image
observeEvent(input$good, {
  appVals$swipes <- bind_rows(
    tibble(image_number = appVals$i, image_name = current_image(), swipe = "good"), 
    appVals$swipes)
  appVals$i <- appVals$i + 1
})

# If the score is bad write the result to a table and move to the next image
observeEvent(input$bad, {
  appVals$swipes <- bind_rows(
    tibble(image_number = appVals$i, image_name = current_image(), swipe = "bad"),
    appVals$swipes)
  appVals$i <- appVals$i + 1
  })

# If the score is unsure write the result to a table and move to the next image
observeEvent(input$unsure, {
  appVals$swipes <- bind_rows(
    tibble(image_number = appVals$i, image_name = current_image(), swipe = "unsure"), 
    appVals$swipes)
  appVals$i <- appVals$i + 1

})

# If the user triggers a save of the data, format the tibble and save the csv - attempts to use  a rege to extract mz, molecule name and adduct from file name

observeEvent( input$save,{
  temp_name <- tempfile(paste0("ShinyScores_"), fileext = ".csv", 
                        tmpdir = input$dir)
  appVals$swipes %>%
    mutate(image_name = str_extract(image_name, "(?<=\\/).+"),
           mz = str_extract(image_name, "\\/(\\d+.?\\d+)_") %>% parse_number(),
           name = str_extract(image_name, "(?<=_).+(?=\\[)"),
           adduct = str_extract(image_name, "\\[.+\\][+-]")) %>%
    write_csv(temp_name)

})

}

# Run the application 
shinyApp(ui = ui, server = server)

