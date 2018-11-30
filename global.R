# 
# if (!file.exists("project1")){
# dir.create("~/project1")
# }

hf <- "M:/Thesis/R/Rcode"
setwd(hf)

# file.create("global.R")
# file.create("server.R")
# file.create("ui.R")

#file.edit("global.R")

######      load libraries    ######
if (!require("ECharts2Shiny")) { install.packages("ECharts2Shiny", repos="http://cran.us.r-project.org") }
library(ECharts2Shiny)
if (!require("shiny")) { install.packages("shiny", repos="http://cran.us.r-project.org") }
library(shiny)
if (!require("leaflet")) { install.packages("leaflet", repos="http://cran.us.r-project.org") }
library(leaflet)
if (!require("dplyr")) { install.packages("dplyr", repos="http://cran.us.r-project.org") }
library(dplyr)

if (!require("xlsx")) { install.packages("xlsx", repos="http://cran.us.r-project.org") }
library(dplyr)

######      save common bean data in to variables   ######

cb = read.xlsx("Data/commonbean.xlsx",sheetIndex = 1 ,stringsAsFactors = F)





######      edit server     ######

#file.edit("server.R")

if (!require("PlackettLuce")) { install.packages("PlackettLuce", repos="http://cran.us.r-project.org") }
library(PlackettLuce)
