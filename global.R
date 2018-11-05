
######      load libraries    ######
if (!require("ECharts2Shiny")) { install.packages("ECharts2Shiny", repos="http://cran.us.r-project.org") }
library(ECharts2Shiny)
library(shiny)
library(leaflet)

######      save common bean data in to variables   ######

cb = read.csv("M:/Thesis/data/commonbean.csv",stringsAsFactors = F)

######      edit server     ######

file.edit("server.R")


if (!require("PlackettLuce")) { install.packages("PlackettLuce", repos="http://cran.us.r-project.org") }
library(PlackettLuce)

#performance <- read.soc("M:/Thesis/data/commonbean.csv")
