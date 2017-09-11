
# To eliminate duplicative data pulls for crime dashboards
# This is a one-time run

library(knitr)
library(flexdashboard)
library(RColorBrewer)
library(stringr)
library(ggplot2)
library(plotly)
library(KernSmooth)
library(raster)
library(leaflet)
library(reshape2)
library(jsonlite)
library(tidyr)
library(DT)
library(RODBC)
library(treemap)
library(d3treeR)
library(tidyverse)

source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/aoristicDayWeek.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/guntablenest.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/kerntorast.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/hotspotMap.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/hotspotMapSV.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/LERMS_incidents.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/nestedbeattable.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/plotlyhmap.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/SPC.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/pullMCUdata.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/loadshootingvictims.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/LERMS_getCallsForService.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/CFSloc.R")
source("Y:/Projects/dashboard/RPDCrimeDashboard/Functions/cfsHotspotMap.R")

simpleCap <- function(x) {
    s <- strsplit(x, " ")[[1]]
    paste(toupper(substring(s, 1,1)), tolower(substring(s, 2)),
          sep="", collapse=" ")
}

#read in section JSON
sectionJSON <- readLines("https://opendata.arcgis.com/datasets/772f3621fa354ec9abf3ba33f3ace59e_0.geojson") %>%
    paste(collapse = "\n") %>%
    fromJSON(simplifyVector = FALSE)
beatsJSON <- readLines("https://opendata.arcgis.com/datasets/61ebab2e63ae4371a998bcb202b3bed4_2.geojson") %>%
    paste(collapse = "\n") %>%
    fromJSON(simplifyVector = FALSE)

#gather section names and set color palettes for sections and beats
secNames <- sapply(sectionJSON$features, function(x) x$properties$Section)
sectionpal <- colorFactor(palette = colorspace::sequential_hcl(5),
                          domain = secNames)

sectionJSON$features <- lapply(sectionJSON$features, function(x) {
    x$properties$style <- list(
        fillColor = sectionpal(x$properties$Section)
        )
    x
    })

LakebeatsJSON <- beatsJSON$features[lapply(beatsJSON$features, 
                                           function(x) {x$properties$Section}) 
                                    == "Lake"]
GeneseebeatsJSON <- beatsJSON$features[lapply(beatsJSON$features, 
                                           function(x) {x$properties$Section}) 
                                    == "Genesee"]
GoodmanbeatsJSON <- beatsJSON$features[lapply(beatsJSON$features, 
                                           function(x) {x$properties$Section}) 
                                    == "Goodman"]
ClintonbeatsJSON <- beatsJSON$features[lapply(beatsJSON$features, 
                                           function(x) {x$properties$Section}) 
                                    == "Clinton"]
CentralbeatsJSON <- beatsJSON$features[lapply(beatsJSON$features, 
                                           function(x) {x$properties$Section}) 
                                    == "Central"]
sectionsmatch <- data.frame(section = c(1, 3, 5, 7, 9),
                            sectionname = c("Lake", "Genesee", "Goodman", "Clinton", "Central"),
                            lng1 = c(-77.617488, -77.604633, -77.615712, -77.575370, -77.592894),
                            lat1 = c(43.158172, 43.114570, 43.124344, 43.159093, 43.138862),
                            lng2 = c(-77.668684, -77.686093, -77.522970, -77.626865, -77.635598),
                            lat2 = c(43.264020, 43.159699, 43.237813, 43.257633, 43.165201),
                            stringsAsFactors = FALSE)
sectionmaplist <- list(
    Lake = leaflet() %>%
        addProviderTiles("CartoDB.Positron") %>%
        fitBounds(lng1 = sectionsmatch$lng1[1], 
                  lat1 = sectionsmatch$lat1[1], 
                  lng2 = sectionsmatch$lng2[1], 
                  lat2 = sectionsmatch$lat2[1]) %>%
        addGeoJSON(LakebeatsJSON, fillOpacity = .1),
    Genesee = leaflet() %>%
        addProviderTiles("CartoDB.Positron") %>%
        fitBounds(lng1 = sectionsmatch$lng1[2], 
                  lat1 = sectionsmatch$lat1[2], 
                  lng2 = sectionsmatch$lng2[2], 
                  lat2 = sectionsmatch$lat2[2]) %>%
        addGeoJSON(GeneseebeatsJSON, fillOpacity = .1),
    Goodman = leaflet() %>%
        addProviderTiles("CartoDB.Positron") %>%
        fitBounds(lng1 = sectionsmatch$lng1[3], 
                  lat1 = sectionsmatch$lat1[3], 
                  lng2 = sectionsmatch$lng2[3], 
                  lat2 = sectionsmatch$lat2[3]) %>%
        addGeoJSON(GoodmanbeatsJSON, fillOpacity = .1),
    Clinton = leaflet() %>%
        addProviderTiles("CartoDB.Positron") %>%
        fitBounds(lng1 = sectionsmatch$lng1[4], 
                  lat1 = sectionsmatch$lat1[4], 
                  lng2 = sectionsmatch$lng2[4], 
                  lat2 = sectionsmatch$lat2[4]) %>%
        addGeoJSON(ClintonbeatsJSON, fillOpacity = .1),
    Central = leaflet() %>%
        addProviderTiles("CartoDB.Positron") %>%
        fitBounds(lng1 = sectionsmatch$lng1[5], 
                  lat1 = sectionsmatch$lat1[5], 
                  lng2 = sectionsmatch$lng2[5], 
                  lat2 = sectionsmatch$lat2[5]) %>%
        addGeoJSON(CentralbeatsJSON, fillOpacity = .1)
    )
saveRDS(sectionmaplist, 
        file = "Z:/Projects/dashboard/RPDCrimeDashboard/Objects/sectionmaplist.RDS", 
        compress = FALSE)

#Create city base map

citymap <- leaflet() %>% 
    addProviderTiles("CartoDB.Positron") %>% 
    fitBounds(lng1 = -77.55, lat1 = 43.11, lng2 = -77.668684, lat2 = 43.264020) %>%
    addGeoJSON(sectionJSON, fillOpacity = .1)

saveRDS(citymap, file = "Z:/Projects/dashboard/RPDCrimeDashboard/Objects/citymap.RDS", compress = FALSE)

