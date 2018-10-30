
######      load libraries    ######

library(shiny)
library(leaflet)



######      save common bean data in to variables   ######

cb = read.csv("M:/Thesis/data/commonbean.csv",stringsAsFactors = F)



######      edit server     ######

file.edit("server.R")