library(shiny)
library(maps)
library(mapproj)

# source helper function
source("helpers.R")
# Load data
counties <- readRDS("data/counties.rds")

# User interface
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
               information from the 2010 US Census."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", 
                              "Percent Black",
                              "Percent Hispanic", 
                              "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(
      textOutput("selected_var"),
      textOutput("selected_range"),
      plotOutput("map")
    )
  ))


#Server logic
server <- function(input, output) {
  
  output$selected_var <- renderText({ 
    paste("You have selected", input$var)
  })
  output$selected_range <- renderText({
    paste("You have chosen a range that goes from", input$range[1], "to", input$range[2])
    })
  
  output$map <- renderPlot({
    
    data <- switch(input$var,
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    color <- switch(input$var,
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "orange",
                    "Percent Asian" = "purple")
    title <- switch(input$var,
                    "Percent White" = "[%] white",
                    "Percent Black" = "[%] black",
                    "Percent Hispanic" = "[%] hispanic",
                    "Percent Asian" = "[%] asian")
    
    percent_map(var = data, color = color, legend.title = title, max = input$range[2], min = input$range[1])
    })
}

#Run App
shinyApp(ui = ui, server = server)


