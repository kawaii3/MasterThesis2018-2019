# my_css <- "
#  text {
# background: yellow;
# font-size:10px;
#  }"
#  









d <- data.frame(number = 1:2, 
                #date = c(1600, 1700, 1800, 1900),
                longitude = c( -86.251389, 77.216721),
                latitude = c(12.136389, 28.644800),
                #web= rep("www.whatever.com", 4),
                T_name = c("Nicaragua", "India"))

######      create shiny webpage      ######

ui <- fluidPage (theme = "bootstrap.css",
  titlePanel(title = tags$em(h1("Crop Variaties Ranking in Nicaragua ", align = "center"))),
  sidebarLayout(
    
    sidebarPanel (
    
      leafletOutput("mymap", width = "100%", height = 400),
      br(),
      dateRangeInput(inputId = "time",label = "Time Range", start =  "2015-09-10",
                     end   = "2017-1-10" ,width = 200),
     #selectInput("country", "Please select the country:", 
                 #choices = c("India" = 1, "Nicaragua" = 2 ),width = 200),
      selectInput(inputId = "input1", label = "Select Country" ,choices = unique(d$T_name)),
     # titlePanel(title = h4("Select Covariates", align = "left")),
      #checkboxGroupInput("covariates",NULL,   
                      #  c("season", "soil)_type","max_night_temp" )),
   #radioButtons("covariates","Choose the covariates you want to analysis", choices = c("season","year","maxTN"))),
     # checkboxGroupInput("covariates", label = "Variables to include in model:", 
     #                   choices = c("year", "season", "soiltype", "maxTN"),
     #                   select = "year")),
   selectInput("select","Variables to include in model:",choices = c("year", "season", "soil", "maxTN"),
               selected = c("year","season"),multiple = TRUE)),


mainPanel(
  
  tabsetPanel(
    tabPanel(
      title = "pltree",
      plotOutput("tree"),
      downloadButton("download_pltree", "download.png")
    ),
    tabPanel(
      title = "dataset",
      DT::dataTableOutput("text")
      ),
    tabPanel(
      title = "otherchart"
    )
  )
 )
))
