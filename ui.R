
######      create shiny webpage      ######

shinyUI(
  fluidPage(
    
    titlePanel("crop variaties ranking in Nicaragua "),
    
    mainPanel(leafletOutput("mymap"))
  )
)