

if (!require("sf")) { install.packages("sf", repos="http://cran.us.r-project.org") }
library(sf)
if (!require("xlsx")) { install.packages("xlsx", repos="http://cran.us.r-project.org") }
library(xlsx)
if (!require("gstat")) { install.packages("gstat", repos="http://cran.us.r-project.org") }
library(gstat)
if (!require("raster")) { install.packages("raster", repos="http://cran.us.r-project.org") }
library(raster)

if (!require("rgdal")) { install.packages("rgdal", repos="http://cran.us.r-project.org") }
library(rgdal)
if (!require("sirad")) { install.packages("sirad", repos="http://cran.us.r-project.org") }
library(sirad)







 #extraterrestrial radiation

################      waterbalance (wb) calculation:  ETo = 0.0023 Ra (TC + 17.8) TR ^0.50   #####################
################  Ra(extraterritrial radiation), TC(temp difference), TR(mean temp) need to be calculated  #####################


#directory
homefolder <- "D:/zm_Thesis/Thesis/R/Rcode"
resultfolder <- "D:/zm_Thesis/Thesis/R/Rcode/Data"
setwd(homefolder)

#Projection
proj = crs("+proj=utm +zone=17 +ellps=WGS84 +datum=WGS84 +units=m +no_defs ")

#IMport observations


### need to build a dataframe because each day is a "layer"
observations_total = read.csv("Data/commonbean.csv", 1)
observations = observations_total[,20:21]

observations_df = st_as_sf(observations, coords = c("lon", "lat"))
observations_df <- as(observations_df, "Spatial")
#plot(observations_df)

#temp difference, daily
temp_daily = read.csv("Data/POWER_Regional_Daily_20150910_20170430_6416713c.csv")
temp_daily_df = st_as_sf(temp_daily, coords = c("LON", "LAT"))
temp_daily_df$T2M_DIFF = abs(temp_daily_df$T2M_MAX - temp_daily_df$T2M_MIN )
temp_daily_df<-as(temp_daily_df, "Spatial")
temp_daily_df@proj4string = proj
# plot(temp_daily_df)


#Creation of GRID for interpolation
bbox = st_bbox(temp_daily_df)
bbox = bbox +c(-0.25, -0.25, 0.25, 0.25)     
xx= seq(from = bbox['xmin'], to= bbox['xmax'], by = 0.01)
yy= seq(from = bbox['ymin'], to= bbox['ymax'], by = 0.01)
grd = expand.grid(xx,yy)
colnames(grd) = c("X", "Y")
coordinates(grd) = ~ X + Y
gridded(grd) = TRUE



#projection
proj4string(grd) = proj

#(Tc)
#IDW calculation - interpolate temperature difference (final_df)
#because temperature difference will use in WB calculation 
##in order to get temperature data for all observations (888 points) from daliy temperature dataset(9 points)
##here use IDW (Inverse Distance Weighting Interpolation) 

#for each year, and for each day in said year:
i = 0

for (year in sort(unique(temp_daily_df$YEAR))){
  year_df = temp_daily_df[temp_daily_df$YEAR == year,]
  
  for (day in sort(unique(year_df$DOY))){
    day_df = year_df[year_df$DOY == day,]
    
    idw_diff = idw(formula = T2M_DIFF ~ 1, locations = day_df, newdata=grd)
    idw_raster = raster(idw_diff)
    
    feature_name = paste0(toString(year), toString(day))
    extracted_values = extract(idw_raster, observations_df)
    extracted_values = data.frame(extracted_values)
    colnames(extracted_values) = feature_name
    temp_df = SpatialPointsDataFrame(coords = observations_df@coords, data =extracted_values )
    
    
    if (i == 0){
      daily_temp_diff = temp_df
    } else {
      daily_temp_diff = cbind(daily_temp_diff, temp_df)
    }
    i = i + 1
  }
}

#add projection
daily_temp_diff@proj4string = proj

#options( java.parameters = "-Xmx8g" )
#write.csv(daily_temp_diff, "Data/daily_temp_diff.csv")


#(TR)
#IDW calculation - interpolate temperature average (final_df_aver)
#because temperature average will use in WB calculation 

#for each year, and for each day in said year:
i = 0

temp_daily_df$T2M_aver = (temp_daily_df$T2M_MAX + temp_daily_df$T2M_MIN)/2

for (year in sort(unique(temp_daily_df$YEAR))){
  year_df = temp_daily_df[temp_daily_df$YEAR == year,]
  
  for (day in sort(unique(year_df$DOY))){
    day_df = year_df[year_df$DOY == day,]
    
    idw_aver = idw(formula = T2M_aver ~ 1, locations = day_df, newdata=grd)
    idw_raster_aver = raster(idw_aver)
    
    feature_name_aver = paste0(toString(year), toString(day),"average")
    extracted_values_aver = extract(idw_raster_aver, observations_df)
    #print(extracted_values_aver)
    extracted_values_aver = data.frame(extracted_values_aver)
    colnames(extracted_values_aver) = feature_name_aver
    temp_df_aver = SpatialPointsDataFrame(coords = observations_df@coords, data =extracted_values_aver )
    #print(temp_df_aver)
    
    if (i == 0){
      daily_temp_mean = temp_df_aver
    } else {
      daily_temp_mean= cbind(daily_temp_mean, temp_df_aver)
    }
    i = i + 1
  }
}

#write.csv(daily_temp_mean, "Data/daily_temp_mean.csv")


####### precipitation data #############
##crop precipitation data

# dir.create(file.path("Data", "crop"))
# 
# pre_list = list.files("M:/Thesis/R/delete/precipitationData",pattern = glob2rx('*.tif'))
# 
# e <- as(extent(-86.25, -84.25, 12.75, 14.75), 'SpatialPolygons')
# for(f in pre_list){
#   DTM = raster(f)
#   out = crop(DTM, e) # whatever
#   writeRaster(out, file.path("crop",f), overwrite = TRUE)
# }


setwd(homefolder)
crop_list <- list.files("Data/crop_0")

i = 0
precipitation = as.numeric()
for(i in crop_list){
 
  layer = raster(i)
  pre_extract = extract(layer, observations)
  #pre_extract_df = t(data.frame(pre_extract))
  #write.table(pre_extract_df, file="precipitation.csv", append=T, sep = ",")
  #precipitation <- rbind(pre_extract_df)
#write.table(pre_extract_df, "precipitation.csv", sep = ",", col.names = T, append = T)
 
  precipitation= cbind(precipitation, pre_extract)
      
  }

#write.csv(precipitation, "Data/precipitation.csv")

#######################   (Ra)   ############################
#http://solardat.uoregon.edu/SolarRadiationBasics.html
#ExtraTerrestrial Solar Radiation calculation
#ExtraTerrestrial Solar Radiation Daliy (extraTSRadiation_df)
a  = matrix(nrow =  length(observations$lat) , ncol =length(seq(1:366)))
colnames(a)<- c(paste0("day",unique(temp_daily_df$DOY)))
#rownames(a)<- c(observations$lat)
#a = cbind(a,c(observations$lat), colnames(a))
d <- as.data.frame(a)
d[is.na(d)] <- 0
#d[2,3] <- d[2,3] + extrat(245,50)[[1]]


for (i in 1:dim(d)[1]){
  lat = observations$lat[i]
   for (j in 1:dim(d)[2]){
     day = seq(1:366)[j]
    extraTerrestrial = extrat(day, radians(lat))[[1]]
     d[i, j] = extraTerrestrial
     }
 }

 write.csv(d, "Data/extraterristrial1.csv")

### extraterristrial output from last step need to be modified in excel
#setwd(homefolder)
ra <- read.csv("Data/extraterristrial1.csv")

#############################    Wb   ################################################
#WaterBalance calculation 
#Equation: ETo = 0.0023 Ra (TC + 17.8) TR ^0.50 
#ET0,Har = ET0 estimated by the Hargreaves equation (mm day-1); Ra = extraterrestrial radiation
#(MJ m-2 day-1); Tmax = maximum air temperature (???C); Tmin = minimum air temperature (???C).

#seperate equation into 3 parts canbe easier calculated

#first part: 0.0023*Ra  
#each location has its own ExtraTSRadiation value 
first <- 0.0023 * ra
first <- first[2:(length(first))]
#write.csv(first, "first.csv")



#second part: Tc + 17.8
#each location at different date has one value
second <- (data.frame(daily_temp_diff) +17.8)
second <- second[1:(length(second)-3)]
#write.csv(second, "second.csv")


#third part: TR ^ 0.50
third <- (data.frame(daily_temp_mean)^0.5)
third <- data.frame(third)
third <- third[1:(length(third)-3)]
#write.csv(third, "third.csv")
#write.xlsx(third, "waterbalance_third.xlsx", sheetName="Sheet1")

first_second = first * as.numeric(unlist(second))

et0 = first_second * third

##############  https://www.smart-fertilizer.com/articles/water-requirements-of-crops  ET0 value  
# This file includes WaterBalance data for each observed location and each observed day
#write.csv(et0, "Data/et0.csv")

###############################################################################


tricot_data = observations_total[,16:18]
  #read.xlsx("commonbean_xlsx.xlsx", 1)[ ,c('day', 'month','year')]

firstDate <- as.Date("2015-09-10")
betterdate <- paste0(tricot_data[,3],"-",tricot_data[,2],"-", tricot_data[,1])
betterdate <-  as.Date(betterdate)

et0 <- read.csv("Data/et0.csv", header=T)

dates <- c(firstDate:as.Date("2016-05-09"), 
           as.Date("2016-06-15"):as.Date("2017-04-30"))



colnos <- sapply(betterdate, function(x) which(dates == as.numeric(x))) + 1
et0_test <- as.matrix(et0[1, colnos[1]:(colnos[1]+109)])
# et0_test <- numeric()

for(i in 2:length(betterdate)){
  et0_test <- rbind(et0_test, as.matrix(et0[i, colnos[i]:(colnos[i]+109)]))
}

et0_test <- unname(et0_test)

# change values !!!!!!!!!!!!
cfs <- c(rep(0.35, 20), rep(0.70, 30), rep(1.1, 40), rep(0.3, 20))

etcrop <- et0_test * cfs
write.csv(etcrop, "Data/etcrop.csv")


#########  rainfall
# colnos <- sapply(betterdate, function(x) which(dates == as.numeric(x))) + 1
# 
# pre_test <- as.matrix(precipitation[1, colnos[1]:(colnos[1]+109)])
# pre_test <- t(pre_test)
# 
# for(i in 2:length(betterdate)){
#   pre_test <- rbind(pre_test, t(as.matrix(precipitation[i, colnos[i]:(colnos[i]+109)])))
# }
# 
# colnames(pre_test)<-  seq(1:110)


#write.csv(pre_test, "Data/precrop.csv")
pre_test <- read.csv("Data/precrop.csv")
waterbalance <- pre_test - etcrop
write.csv(waterbalance, "Data/waterbalance1.csv")



# for (i in lengths(year_month_day_str_list)){
#   
#   url <- paste0("ftp://ftp.chg.ucsb.edu/pub/org/chg/products/CHIRPS-2.0/global_daily/tifs/p05/",
#                 downloadyear[[1]][i] ,"/chirps-v2.0.",downloadyear[[1]][i],".",downloadmonth[[1]][i],".",downloadday[[1]][i],".", "tif.gz")
#   print(url)
#   download.file(url, destfile = paste0("/chirps-v2.0.",downloadyear[[1]][i],".",
#                                         downloadmonth[[1]][i],".",downloadday[[1]][i],".", "tif.gz"),method="libcurl",quiet=TRUE)
#   i = i+1
#   }
# 


