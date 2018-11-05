

######      server      ######

server <- function(input,output, session){
   data <- reactive({
     x <- cb
   })
   
 
  output$text <- renderTable({
     head(cb$soil)
   })
  
  
  ####  create map ###  
  output$mymap <- renderLeaflet({
    cb <- data()
     m<- leaflet(data = cb) %>%
       addTiles() %>%
     
       addMarkers (lng = ~lon,
                   lat = ~lat,
                   popup = paste ("crop", cb$crop,"<br>",
                                  "PlantingDate:",cb$planting_date))
  })
  

  
  
    ####  create PLmodel Tree ###
  
    library(PlackettLuce)
    
    example("beans", package = "PlackettLuce")
    G<- grouped_rankings(R, rep(seq_len(nrow(beans)),4))
    format(head(G,2),width = 50)
    
    beans$year <- factor(beans$year)
    tree <- pltree(G ~., data = beans[c("season", "year", "maxTN")],
                   minsize = 0.05*n, maxdepth = 3)
                 
    tree
    output$tree <- renderPlot({

      plot(tree)

   })
}






#############   CUSTOMIZE icon #####################
    #   greenLeafIcon <- makeIcon(
    #     iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-green.png",
    #     iconWidth = 38, iconHeight = 95,
    #     iconAnchorX = 22, iconAnchorY = 94,
    #     shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
    #     shadowWidth = 50, shadowHeight = 64,
    #     shadowAnchorX = 4,shadowAnchorY = 62
    #     
    #   )
    # leaflet(data = cb[1:2,])%>% addTiles() %>%
    #   addMarkers(~lon,~lat,icon = greenLeafIcon)
############123
     