# shiny app
library(shiny)

OR.init <- stack("../occ and grouping checklists/TassledCapOR/OR_tasscap_summer_2011_cropped.tif")
names(OR.init) <- c("TCB", "TCG", "TCW", "TCA")

us <- raster::getData('GADM', country = 'US', level = 1)
oregon <- us[us$NAME_1 == "Oregon",]

sampling_region <- readRDS("../occ and grouping checklists/TassledCapOR/sampling_region")

det_df <- read.delim("~/Documents/Oregon State/Research/ICB General/data generation/2017_UPDATED_COVS_df.csv", header=TRUE, sep = ",")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$specObs <- renderPlot({
    in.data <- df()
    plot(oregon)
    points(in.data$longitude, in.data$latitude)
  })
  
  observeEvent(input$isZoomed, {
    if (input$isZoomed %% 2 == 1) {
      txt <- "Zoom Out"
      output$specObs <- renderPlot({
        in.data <- df()
        plot(sampling_region)
        points(in.data$longitude, in.data$latitude)
      })
    } else {
      txt <- "Zoom In"
      output$specObs <- renderPlot({
        in.data <- df()
        plot(oregon)
        points(in.data$longitude, in.data$latitude)
      })
    }
    updateActionButton(inputId = "isZoomed", label = txt)
  })
  
  
  
    df <- reactive({
      genSpecies(
        numObservationLocations = input$numObs,
        numHotspots = input$numHotspots,
        OR.env = OR.init,
        sp_region = sampling_region,
        det.df = det_df,
      )
    })
    
    pop.df <- reactive({
      addOcc.Det.probs(
        df(), 
        true_det_coeff = c(input$det0, input$det1, input$det2, input$det3, input$det4, input$det5),
        true_occ_coeff = c(input$occ0, input$occ1, input$occ2, input$occ3, input$occ4),
      )
    })
    
  
    output$detProb <- renderPlot({
      in.data <- pop.df()
      hist(in.data$det_prob)

    })

    output$occProb <- renderPlot({
      in.data <- pop.df()
      hist(in.data$occ_prob)

    })

})
