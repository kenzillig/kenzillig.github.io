### iny App for the SalMap project.

library(shiny)
library(shinyBS)
library(shinythemes)
library(leaflet)

salmap.dat <- read_csv("SalMap/SalMapTest1.csv")
species_list <- salmap.dat$SPECIES

## User Interface ----
ui <- shinyUI(navbarPage(theme=shinytheme("yeti"),
                      title=HTML('<div><a href="http://kenzillig.github.io" target="_blank">'),
                      
                      tabPanel("SalMap",value="salMap"),
                      tabPanel("Data View", value="datView"),
                      #tabPanel("About", value="about"),
                      
                      windowTitle="SalMap",
                      collapsible=TRUE,
                      id="tab",
                      tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
                      
                      # First panel, SalMap
                      conditionalPanel("input.tab=='salMap'",
                                       fluidRow(
                                         column(4, h2("SalMap"), h3("Data with Destinations")),  # title, subtitle
                                         column(8, h3("Salmonid Publications"), # Title over second colum
                                                fluidRow(
                                                  column(4,
                                                         checkboxGroupInput("species", label = "species",  # selection box
                                                                     selected = NULL, # starts with nothing selected
                                                                     choices = c("All", species_list), ## passes it a vector of options
                                                                     width="100%") # doesnt allow multiple selections
                                                  )
                                                ))
                                       ),
                                       #bsTooltip is a window that provides informaiton when the user hovers over the object
                                       bsTooltip(id = "station", title = "Select a species", placement = "top", options = list(container="body")),
                                       fluidRow(
                                         column(4, leafletOutput("map")),  ## this puts the map on the right hand side
                                         column(8, plotOutput("plotRange")) ## this places the other plot on the left hand side
                                       )
                      ),
                      # Second Panel, Data View
                      conditionalPanel("input.tab=='datView'",
                                       fluidRow(
                                         column(4, h2(HTML("<a href='http://www.dfg.ca.gov/delta/projects.asp?ProjectID=ZOOPLANKTON' target=_blank>Zoop IEP Data</a>")), ## this links to another website
                                                h3("Explore IEP CB Variables")), ## this is the subtitle
                                         column(8, 
                                                fluidRow(
                                                  column(6,
                                                         checkboxGroupInput("variables",
                                                                     label = "Select Species of Interest",
                                                                     selected = NULL, # starts with nothing selected
                                                                     choices = c("All", species_list), ## passes it a vector of options
                                                                     width="100%")
                                                  ),
                                                  column(2, 
                                                         sliderInput("date_range", label = 'Publication Year', ### change this input method to user input date
                                                                     min = 1900, max = 2020, value = c(1900,2020))
                                                  )
                                                #   column(2,
                                                #          selectInput('end_date', label= 'End Date', 
                                                #                      choices=c(None=".", Year="Year", Survey="Survey"))
                                                #   )
                                                # )#,
                                                # fluidRow(
                                                #   column(4,
                                                #          selectInput("yr_range", label = "Year Range",
                                                #                      choices = c(seq(1972,2017,1)),
                                                #                      selected = 1978, multiple = TRUE)
                                                #   ),
                                                #   column(4,
                                                #          selectInput("mon_range", label = "Month Range", 
                                                #                      choices = c(seq(1,12,1)), selected = 3,
                                                #                      multiple = TRUE)
                                                #   )
                                                # )
                                         )
                                       ),
                                       bsTooltip("variables", "Select a salmonid species", "top", options = list(container="body")),
                                       #bsTooltip("logscale", "Check this box to log scale the data.", "top", options = list(container="body")),
                                       bsTooltip("date_range", "Select range for publications", "top", options = list(container="body")),
                                       #bsTooltip("end_date", "Select the months of interest.", "top", options = list(container="body")),
                                       fluidRow(
                                         #column(4, plotOutput("map2")),  ## will plot a map on the left
                                         #column(8, plotOutput("plotData")) ### will plot the graphs on the right
                                       )
                      ),)))
                      ## Third Panel About
                      #conditionalPanel("input.tab=='about'", source("about.R",local=T)$value))))  ## need to make an about.R file which contians the information to be dispalyed on this page
                      
                      



#dynamic_server ----             
server <- shinyServer(function(input, output, session) {
    salmap.dat <- read_csv("SalMap/SalMapTest1.csv") # read in the dataset.
    # Tab1: get stations ## first panel
    salmap.dat.1 <- reactive({  
      switch(input$species,
             salmap.dat.t <- dplyr::filter(salmap.dat, SPECIES==input$species))
    })
    
    # for Tab1 Reactive Map  ## first panel
    observeEvent(input$species, {  ### takes in the information from the selection of station
      x <- input$species
      if(!is.null(x) && x!=""){  ## i think this is just an error code? I am not sure
        sink("siteLog.txt", append=TRUE, split=FALSE)
        cat(paste0(x, "\n"))
        sink()
      }
    })
    # Make Leaflet Map    Firsth panel###
    output$map <- renderLeaflet({
      leaflet() %>%
        setView(-121.75, lat=38.07, zoom = 9) %>%
        addProviderTiles("Esri.WorldImagery", group = "ESRI Aerial") %>%
        addProviderTiles("Esri.WorldTopoMap", group = "Topo") %>%
        addProviderTiles("OpenStreetMap.BlackAndWhite", group = "OpenBW") %>%
        addProviderTiles("Esri.WorldGrayCanvas", group="ESRI Canvas") %>%
        
        # add scale bar
        addMeasure(position = "topright",
                   primaryLengthUnit = "meters",
                   primaryAreaUnit = "sqmeters",
                   activeColor = "#3D535D",
                   completedColor = "#7D4479") %>%
        
        # add markers
        addCircleMarkers(data=salmap.dat.1, group="SPECIES",
                         layerId = ~SPECIES,
                         radius = 8, color = "white", fillColor = "purple",
                         weight= 1, fillOpacity=0.7,
                         popup = paste0("Species: ", salmap.dat.1$SPECIES,  ## these provide the pop information on each point on the map
                                        "<br> Lon: ", salmap.dat.1$LONG,
                                        "<br> Lat: ", salmap.dat.1$LAT,
                                        "<br> Type: ", salmap.dat.1$LOCATION)) %>%
        
        addLayersControl(
          baseGroups = c("ESRI Canvas", "OpenBW",
                         "Topo","ESRI Aerial"),
          overlayGroups = c("Species"),
          options = layersControlOptions(collapsed = T))
    })
    
    # # create a click event for Map
    # observeEvent(input$map_marker_click, {  ## this code allows someone to click on the map and have it respond with the other graph.
    #   p <- input$map_marker_click
    #   if(p$id=="Selected"){
    #     leafletProxy("map") %>% removeMarker(layerId="Selected")
    #   } else {
    #     leafletProxy("map") %>% setView(lng=p$lng, lat=p$lat, input$map_zoom) %>% addCircleMarkers(p$lng, p$lat, radius=10, color="black", fillColor="orange", fillOpacity=1, opacity=1, stroke=TRUE, layerId="Selected")
    #   }
    # })
    # 
    # # make a second event to update future clicks depending on if something has been changed or selected in the se
    # observeEvent(input$map_marker_click, {
    #   p <- input$map_marker_click
    #   if(!is.null(p$id)){
    #     if(is.null(input$station)) updateSelectInput(session, "station", selected=p$id)
    #     if(!is.null(input$station) && input$station!=p$id) updateSelectInput(session, "station", selected=p$id)
    #   }
    # })
    # 
    # observeEvent(input$station, {
    #   p <- input$map_marker_click
    #   p2 <- subset(cb_filt_stations, Station==input$station)
    #   if(nrow(p2)==0){
    #     leafletProxy("map") %>% removeMarker(layerId="Selected")
    #   } else if(is.null(p$id) || input$station!=p$id){
    #     leafletProxy("map") %>% setView(lng=p2$lon, lat=p2$lat, input$map_zoom) %>% addCircleMarkers(p2$lon, p2$lat, radius=10, color="black", fillColor="orange", fillOpacity=1, opacity=1, stroke=TRUE, layerId="Selected")
    #   }
    # })
    
    
    # Tab1: plot date range of available data for station
    output$plotRange <- renderPlot({  ## Makes the graph for the right hand side of the slide.
      
      p1 <- ggplot() + 
        geom_linerange(data=salmap.dat, aes(x=PUBLICATION_YEAR, ymin=input$date_range[1], ymax=input$date_range[2]), color="gray50", alpha=0.6) +
        #geom_linerange(data=datasetInput(), aes(x=Station, ymin=minDate, ymax=maxDate), color="orange", lwd=1.5) + ## this highlights the selected value in the plot
        coord_flip() #+
        #scale_y_date(date_breaks = "10 years",date_labels = "%Y", 
                     # limits = c(as.Date("1972-01-10", "%Y-%m-%d"), 
                     #            as.Date("2018-01-01", "%Y-%m-%d")))
      
      print(p1)
    })
    
    # Tab2: Select columns
    # df_sel <- reactive({ ### this filters the dataset to be to the users specifications
    #   switch(input$variables,
    #          salmap.dat %>% select(PUBLICATION_YEAR, LOCATION, LAT, LONG, SPECIES, CITATION) #%>% ## input$variables is the species that was selected
    #            #dplyr::filter(PUBL %in% input$yr_range, Survey %in% input$mon_range, input$variables>0) %>% ## this filters teh data by the input variable, the given data range, 
    #            #mutate(Year = as.factor(Year), Survey=as.factor(Survey))
    #   )
    # })

    # output$plotData <- renderPlot({  ## this plots the data based upon the dataset that the user defined above. 
    #   plot2 <- ggplot(df_sel(), aes_string(x="Survey", y=input$variables, fill="Year")) + 
    #     geom_boxplot(position=position_dodge(width=1))
    #   scale_fill_viridis_d()
    #   
    #   if (input$logscale) ## this adjusts the plot to be log scale
    #     plot2 <- plot2 + scale_y_log10()
    #   
    #   facets <- paste(input$facet_row, '~', input$facet_col)
    #   if (facets != '. ~ .')
    #     plot2 <- plot2 + facet_grid(facets, scales = "free")
    #   
    #   print(plot2)
    #   
    # })
    
    # output$map2 <- renderPlot({
    #   ggplot() + geom_sf(data=df_sel(), pch=21, fill="orange") + 
    #     theme_light()
    # })
    
    
  })

shinyApp(ui, server)

