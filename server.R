######      server      ######


server <- function(input,output, session){
   data <- reactive({
     x <- cb
   })
  output$mymap <- renderLeaflet({
    cb <- data()
    
     m<- leaflet(data = cb) %>%
       addTiles() %>%
       addMarkers (lng = ~lon,
                   lat = ~lat,
                   popup = paste ("crop", cb$crop,"<br>",
                                  "PlantingDate:",cb$planting_date))
       clusterId = "best"           
     
     m
     
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
     