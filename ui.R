
######      create shiny webpage      ######

shinyUI(
  fluidPage(
    
    ### title ###
    titlePanel(title = tags$em(h1("Crop Variaties Ranking in Nicaragua ", align = "center"))),

    ### map ###
    leafletOutput("mymap", width = "100%", height = 400),
    br(),
    dateRangeInput(inputId = "time",label = "Time Range", width = 200),
    selectInput("country", "Please select the country:", choices = c("Nicaragua" = 1, "Ethiopia" = 2, "India" = 3),width = 200),

    ### sidebar panel ###
    titlePanel(title = h4("Select Covariates", align = "left")),
    # sidebarLayout(
    #   sidebarPanel(
    #     selectInput("temp", "1. night temperature", choices = c("0-10" = 1, "11-20" = 2, "21-30" = 3)),
    #     sliderInput("bins", "2. altitude", min = 5, max = 1000, value = 15),
    #     textInput(inputId = "slope", label = "3. slope"),
    #     selectInput(inputId = "var", label =  "4. season", choices = c("spring" = 1, "summer" = 2, "fall" = 3, "winter" = 4)),
    #     selectInput("var", "5. soil type", choices = c("asd" = 1, "wer" = 2, "ert" = 3))),
    #
   
    
    checkboxGroupInput("covariates",NULL,   c("season" = "season", "soil type" = "soil","max_night_temp" = "maxNT_VEG")),
 
    mainPanel(  
        tabsetPanel(type = "tab",
                    tabPanel("BarChart"),
                    radioButtons(inputId = "text", label= "Select the file type", choices = list("png", "pdf")),
                    actionButton(inputId = "downloadtext", label = "download", icon = icon("download")),
                    tabPanel("PieChart"),
                    tabPanel("PLmodelTree",plotOutput("tree",width = "100%", height = "400")),
                    # plotOutput(tree, width = "100%", height = "400px", click = NULL,
                    #            dblclick = NULL, hover = NULL, hoverDelay = NULL,
                    #            hoverDelayType = NULL, brush = NULL, clickId = NULL, hoverId = NULL,
                    #            inline = FALSE),
                    tabPanel("text", tableOutput("soil")
                     ))))
      )
  

