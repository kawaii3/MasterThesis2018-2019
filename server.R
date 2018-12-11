

######      server      ######

server <- function(input,output, session){
   data <- reactive({
     x <- cb
   })

  ###  output text ###
  output$text <- DT::renderDataTable({
    print(cb)
   })
  ###  create map ###
  # output$mymap <- renderLeaflet({
  #   cb <- data()
  #    m<- leaflet(data = cb) %>%
  #      addTiles() %>%
  #      addMarkers (lng = ~lon,
  #                  lat = ~lat,
  #                  popup = paste ("crop", cb$crop,"<br>",
  #                                 "PlantingDate:",cb$planting_date))
  # })
  react <- reactive({
    req(input$input1)
    #req(input$year)
    df <- d[d$T_name == input$input1 ,]
    df
  })

  output$mymap <- renderLeaflet({ 
    if (req(input$input1) == "Nicaragua"){
    cb <- data()
       m<- leaflet(data = cb,options = leafletOptions(minZoom = 2, maxZoom =7)) %>%
         addTiles() %>%
          addMarkers (lng = ~lon[1],
                     lat = ~lat[1],
                     popup = paste ("crop", cb$crop,"<br>",
                                    "PlantingDate:",cb$planting_date))}
    else if(input$input1 == "India"){
      cb <- data()
      m<- leaflet(data = cb,options = leafletOptions(minZoom = 0, maxZoom =3)) %>%
        addTiles() %>%
        addMarkers (lng = 77.216721,
                    lat = 28.644800,
                    popup = paste ("crop", cb$crop,"<br>",
                                   "PlantingDate:",cb$planting_date))}
         m
  })
   # ###  create PLmodel Tree ###
   
    library(PlackettLuce)

    output$tree <- renderPlot({
      example("beans", package = "PlackettLuce")
      G <- grouped_rankings(R, rep(seq_len(nrow(beans)),4))
      format(head(G,2),width = 50)
      
     # beans$year <- factor(beans$year)
     # data1 <- subset(beans,input$select)
      data1 <- select(beans,input$select)
      tree <- pltree(G ~ ., data1 ,minsize = 0.05*n, maxdepth = 3)
      
        plot(tree)

   })


      output$download_pltree <-  downloadHandler(
      filename = "pltree_model.png",
      content = function(file){
        save.image(input$tree,file)
    # output$text <-  downloadHandler(
    #   filename = ".png",
    #   content = function(file){
      }
    )
  }

 






     