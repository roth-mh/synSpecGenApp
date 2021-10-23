#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(sp)
library(sf)
library(locfit)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Synthetic Species Generator!"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      actionButton("isZoomed",
                   "Zoom In"),
      
      sliderInput("numObs",
                  "Number of Observations:",
                  min = 100,
                  max = 5000,
                  value = 400),
      
      sliderInput("numHotspots",
                  "Number of Hotspots:",
                  min = 0,
                  max = 10,
                  value = 2),
      
      actionButton("show", "Show modal dialog"),
      
      sliderInput("occ0",
                  "occupancy intercept coefficient:",
                  min = -1.5,
                  max = 1.5,
                  value = runif(1, -1.5, 1.5)),
      
      sliderInput("occ1",
                  "TCB coefficient:",
                  min = -1.5,
                  max = 1.5,
                  value = runif(1, -1.5, 1.5)),
      
      sliderInput("occ2",
                  "TCG coefficient:",
                  min = -1.5,
                  max = 1.5,
                  value = runif(1, -1.5, 1.5)),
      
      sliderInput("occ3",
                  "TCW coefficient:",
                  min = -1.5,
                  max = 1.5,
                  value = runif(1, -1.5, 1.5)),
      
      sliderInput("occ4",
                  "TCA coefficient:",
                  min = -1.5,
                  max = 1.5,
                  value = runif(1, -1.5, 1.5)),
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      # plotOutput("envVars"),
      plotOutput("specObs"),
      # plotOutput("detProb"),
      # plotOutput("occProb"),
    )
  )
))
