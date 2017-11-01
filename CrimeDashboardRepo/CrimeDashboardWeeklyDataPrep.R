# To eliminate duplicative data pulls, this function pulls LERMS data,
# cleans it,
# and saves it as RDS files for the dashboards to read in.
# This will run weekly

library(reshape2)
library(RODBC)
library(tidyverse)

source("Z:/Projects/dashboard/RPDCrimeDashboard/Functions/LERMS_incidents.R")
source("Z:/Projects/dashboard/RPDCrimeDashboard/Functions/pullMCUdata.R")
source("Z:/Projects/dashboard/RPDCrimeDashboard/Functions/loadshootingvictims.R")
source("Z:/Projects/dashboard/RPDCrimeDashboard/Functions/LERMS_getCallsForService.R")
source("Z:/Projects/dashboard/RPDCrimeDashboard/Functions/SPC.R")

simpleCap <- function(x) {
    s <- strsplit(x, " ")[[1]]
    paste(toupper(substring(s, 1,1)), tolower(substring(s, 2)),
          sep="", collapse=" ")
}

curr.year <- as.numeric(format(Sys.Date(), '%Y')) ### This current year to automatically reference the current year
begindate <- paste0(curr.year, '-01-01') ### For CFS to automatically create the begindate based on current year

#sevenDayGroupTable is a lookup table to get the current week (Group) from the date
#Because it uses length(Date) from seq.Date, it should work even in leap years

sevenDayGroupTable <- data.frame(Date = seq.Date(from = as.Date(begindate),
                                                 to = as.Date(paste0(curr.year, "-12-31")),
                                                 by = 1)) %>%
    mutate(DOY = 1:length(Date),
           Group = c(rep(1:51, each = 7), 
                     rep(52, times = length(Date) - 357)))

curr.week <- sevenDayGroupTable$Group[match(as.numeric(format(Sys.Date(), 
                                                              '%j')), 
                                            sevenDayGroupTable$DOY)] - 1

firearm.desc <- c('Prohibited Use of Weapon City Limits', 
                  'Use of Dangerous Weapon', 
                  'Criminal Use Firearm 1st: Commit Violent Class B Felony', 
                  'Discharges Loaded Firearm', 
                  'Use Firearm 1st: Possess a Deadly Weapon-Loaded',
                  'Criminal Use Firearm 2nd: Possess Deadly Weapon: Loaded', 
                  'Use Firearm 1st: Display Firearm', 
                  'Criminal Use Firearm 2nd: Display Firearm')

firearmCrimeTypes <- c("Aggravated Assault", "Robbery", "Homicide", "Rape", "Simple Assault")


#load in RPD's crime data

df <- LERMS_incidents_query(years = curr.year) %>%
    distinct(CaseNumber, FullAddress, ReportDate, Description, .keep_all = TRUE) %>%
    filter(MostSerious == 1, CaseStatusValue != 'Unfounded') %>%
    arrange(ReportDate) %>%
    mutate(CRNum = paste0(substr(CaseNumber, start = 3, stop = 5),
                          substr(CaseNumber, start = 8, stop = 13)),
           Lat = as.numeric(Lat),
           Lon = as.numeric(Lon),
           OffenseDate = as.Date(OffenseDate, format = "%Y-%m-%d"),
           ReportDate = as.Date(ReportDate, format = "%Y-%m-%d"),
           OccurToDate = as.Date(OccurToDate, format = "%Y-%m-%d"),
           OccurFromDate = as.Date(OccurFromDate, format = "%Y-%m-%d"),
           OffenseDOW = factor(OffenseDOW, 
                               levels = c("Sunday", "Monday", "Tuesday", "Wednesday",
                                          "Thursday", "Friday", "Saturday"), 
                               ordered = TRUE),
           OccurToDayOfYear = as.numeric(format(OccurToDate, "%j")),
           GEOBeat = factor(GEOBeat,
                            levels = unique(GEOBeat[order(substr(GEOBeat, 3, 3), 
                                                          substr(GEOBeat, 1, 2))])),
           sec = case_when(.$Section == 1 ~ "Lake", 
                           .$Section == 3 ~ "Genesee", 
                           .$Section == 5 ~ "Goodman", 
                           .$Section == 7 ~ "Clinton", 
                           .$Section == 9 ~ "Central"),
           WeaponGroup = case_when(.$WeaponIBRValue %in% c("01", "02", "03", "04", "05",
                                                           "06", "07", "08", "09", "10") ~ "Firearm",
                                   .$WeaponIBRValue == "11" ~ "Knife/Cutting Instrument",
                                   .$WeaponIBRValue == "12" ~ "Blunt Object",
                                   .$WeaponIBRValue %in% c("14", "15") ~ "Physical",
                                   TRUE ~ "Other"),
           FullAddress = unname(sapply(FullAddress, simpleCap)),
           WeaponIBRValue = as.numeric(WeaponIBRValue),
           Description = trimws(Description),
           Description = trimws(sub(x = Description, pattern = ":.*", replacement = ""))) %>%
    mutate(Firearm = case_when(.$WeaponIBRValue %in% 1:10 &
                                   .$CrimeType %in% firearmCrimeTypes ~ "Firearm",
                               .$CrimeType == "Dangerous Weapons" & 
                                   .$Description %in% firearm.desc ~ "Firearm",
                               TRUE ~ "Non-Firearm")) %>%
    left_join(sevenDayGroupTable, by = c("OccurToDayOfYear" = "DOY")) %>%
    dplyr::select(-Date) %>%
    dplyr::rename("SevenDaysGroup" = Group) %>%
    filter(SevenDaysGroup <= curr.week)

sectiondflist <- list(
    Lake = df %>% filter(Section == 1),
    Genesee = df %>% filter(Section == 3),
    Goodman = df %>% filter(Section == 5),
    Clinton = df %>% filter(Section == 7),
    Central = df %>% filter(Section == 9)
)
saveRDS(object = sectiondflist, 
        file = "Z:/Projects/dashboard/RPDCrimeDashboard/Objects/sectiondflist.RDS", 
        compress = FALSE)
saveRDS(object = df, 
        file = "Z:/Projects/dashboard/RPDCrimeDashboard/Objects/citywidedf.RDS", 
        compress = FALSE)

# Calls for service

cfs.df <- LERMS_CFS_query(begindate = begindate, 
                          enddate = max(sevenDayGroupTable$Date[sevenDayGroupTable$Group == curr.week])) %>%
    mutate(RPD_Priority = case_when(.$RPD_Priority == 1 ~ "Critical",
                                    .$RPD_Priority == 2 ~ "Urgent", 
                                    .$RPD_Priority == 3 ~ "Normal", 
                                    TRUE ~ "Discretionary")) %>%
    mutate(RPD_Priority = factor(RPD_Priority,
                                 levels = c("Critical", "Urgent", "Normal", "Discretionary")),
           eventdate = as.Date(eventdate, format = "%Y-%m-%d"),
           eventDOY = format(eventdate, format = "%j") %>% as.numeric()) %>%
    left_join(sevenDayGroupTable, by = c("eventDOY" = "DOY")) %>%
    dplyr::select(-Date) %>%
    dplyr::rename("SevenDaysGroup" = Group)

sectioncfslist <- list(
    Lake = cfs.df %>% filter(IncidentSection == "Lake"),
    Genesee = cfs.df %>% filter(IncidentSection == "Genesee"),
    Goodman = cfs.df %>% filter(IncidentSection == "Goodman"),
    Clinton = cfs.df %>% filter(IncidentSection == "Clinton"),
    Central = cfs.df %>% filter(IncidentSection == "Central")
)
saveRDS(object = sectioncfslist, 
        file = "Z:/Projects/dashboard/RPDCrimeDashboard/Objects/sectioncfslist.RDS",
        compress = FALSE)
saveRDS(object = cfs.df,
        file = "Z:/Projects/dashboard/RPDCrimeDashboard/Objects/citywidecfs.RDS",
        compress = FALSE)

# SPC objects

PropVals <- read.csv("Z:/Projects/dashboard/RPDCrimeDashboard/Objects/ProportionsAndCounts.csv", 
                     header= T)
ShootingControlLimits <- read.csv("Z:/Projects/dashboard/RPDCrimeDashboard/Objects/3YrWeightedControlLimitsShootings.csv")
ShootingProps <- read.csv("Z:/Projects/dashboard/RPDCrimeDashboard/Objects/ProportionsAndCountsShootings.csv", 
                          stringsAsFactors = FALSE)
ShootingPropsFull <- ShootingProps

histdata <- read.csv(file = "Z:/Projects/dashboard/RPDCrimeDashboard/Objects/historicaldata.csv", 
                     stringsAsFactors = FALSE, 
                     header = TRUE)

controllimits <- read.csv(file = "Z:/Projects/dashboard/RPDCrimeDashboard/Objects/3YrWeightedControlLimits.csv", 
                          header = TRUE)

controllimits <- rbind(data.frame(controllimits, Year = 2017),
                       data.frame(controllimits, Year = 2018),
                       data.frame(controllimits, Year = 2019))

mculist <- pullMCUdata()
MCUhoms <- mculist[[1]]
person <- mculist[[2]]
rm(mculist)
MCUhoms <- MCUhoms %>%
    mutate(CrimeType = "Homicide",
           DateOfEvent = as.Date(DateOfEvent, format = "%Y-%m-%d"),
           DOYofEvent = as.numeric(format(DateOfEvent, "%j")),
           YearofEvent = as.numeric(format(DateOfEvent, "%Y")),
           CaseStatus = unname(sapply(CaseStatus, simpleCap))) %>%
    filter(YearofEvent == curr.year) %>%
    dplyr::rename(sec = Section,
                  Lat = Latitude,
                  Lon = Longitude,
                  FullAddress = Address) %>%
    left_join(sevenDayGroupTable, by = c("DOYofEvent" = "DOY")) %>%
    select(-Date) %>%
    dplyr::rename("SevenDaysGroup" = Group)

personincident <- left_join(MCUhoms, person, by = "CaseNumber")

sv <- loadshootingvictims()
drops <- c("Lat", "Lon")
svjoined <- left_join(x = sv, y = df, by = c("CaseNumber" = "CRNum")) %>%
    select(-one_of(drops)) %>%
    rename(Lat = Latitude, Lon = Longitude)

PropValsLake <- filter(PropVals, Section == "Lake")
PropValsGenesee <- filter(PropVals, Section == "Genesee")
PropValsGoodman <- filter(PropVals, Section == "Goodman")
PropValsClinton <- filter(PropVals, Section == "Clinton")
PropValsCentral <- filter(PropVals, Section == "Central")

df.Lake <- filter(df, sec == "Lake")
df.Genesee <- filter(df, sec == "Genesee")
df.Goodman <- filter(df, sec == "Goodman")
df.Clinton <- filter(df, sec == "Clinton")
df.Central <- filter(df, sec == "Central")

ShootingProps.Lake <- filter(ShootingPropsFull, Section == "Lake") #To avoid having to change the SPC function...
ShootingProps.Genesee <- filter(ShootingPropsFull, Section == "Genesee")
ShootingProps.Goodman <- filter(ShootingPropsFull, Section == "Goodman")
ShootingProps.Clinton <- filter(ShootingPropsFull, Section == "Clinton")
ShootingProps.Central <- filter(ShootingPropsFull, Section == "Central")

sectionSPClist <- list(
    Lake = list(
        Firearm = firearmSPC.Lake <- SPC(crimetype = "Firearm", Prop.Vals = PropValsLake, dataf = df.Lake),
        SV = svSPC.Lake <- SPC(crimetype = "Shooting", 
                               Prop.Vals = ShootingProps.Lake,
                               dataf = filter(svjoined, sec == "Lake")),
        Homicide = homicideSPC.Lake <- SPC(crimetype = "Homicide", Prop.Vals = PropValsLake, dataf = df.Lake),
        Rape = rapeSPC.Lake <- SPC(crimetype = "Rape", Prop.Vals = PropValsLake, dataf = df.Lake),
        Rob = robSPC.Lake <- SPC(crimetype = "Robbery", Prop.Vals = PropValsLake, dataf = df.Lake),
        Aslt = asltSPC.Lake <- SPC(crimetype = "Aggravated Assault", Prop.Vals = PropValsLake, dataf = df.Lake),
        Burg = burgSPC.Lake <- SPC(crimetype = "Burglary", Prop.Vals = PropValsLake, dataf = df.Lake),
        Larc = larcSPC.Lake <- SPC(crimetype = "Larceny", Prop.Vals = PropValsLake, dataf = df.Lake)
    ),
    Genesee = list(
        Firearm = firearmSPC.Genesee <- SPC(crimetype = "Firearm", Prop.Vals = PropValsGenesee, dataf = df.Genesee),
        SV = svSPC.Genesee <- SPC(crimetype = "Shooting", 
                                  Prop.Vals = ShootingProps.Genesee,
                                  dataf = filter(svjoined, sec == "Genesee")),
        Homicide = homicideSPC.Genesee <- SPC(crimetype = "Homicide", Prop.Vals = PropValsGenesee, dataf = df.Genesee),
        Rape = rapeSPC.Genesee <- SPC(crimetype = "Rape", Prop.Vals = PropValsGenesee, dataf = df.Genesee),
        Rob = robSPC.Genesee <- SPC(crimetype = "Robbery", Prop.Vals = PropValsGenesee, dataf = df.Genesee),
        Aslt = asltSPC.Genesee <- SPC(crimetype = "Aggravated Assault", Prop.Vals = PropValsGenesee, dataf = df.Genesee),
        Burg = burgSPC.Genesee <- SPC(crimetype = "Burglary", Prop.Vals = PropValsGenesee, dataf = df.Genesee),
        Larc = larcSPC.Genesee <- SPC(crimetype = "Larceny", Prop.Vals = PropValsGenesee, dataf = df.Genesee)
    ),
    Goodman = list(
        Firearm = firearmSPC.Goodman <- SPC(crimetype = "Firearm", Prop.Vals = PropValsGoodman, dataf = df.Goodman),
        SV = svSPC.Goodman <- SPC(crimetype = "Shooting", 
                                  Prop.Vals = ShootingProps.Goodman,
                                  dataf = filter(svjoined, sec == "Goodman")),
        Homicide = homicideSPC.Goodman <- SPC(crimetype = "Homicide", Prop.Vals = PropValsGoodman, dataf = df.Goodman),
        Rape = rapeSPC.Goodman <- SPC(crimetype = "Rape", Prop.Vals = PropValsGoodman, dataf = df.Goodman),
        Rob = robSPC.Goodman <- SPC(crimetype = "Robbery", Prop.Vals = PropValsGoodman, dataf = df.Goodman),
        Aslt = asltSPC.Goodman <- SPC(crimetype = "Aggravated Assault", Prop.Vals = PropValsGoodman, dataf = df.Goodman),
        Burg = burgSPC.Goodman <- SPC(crimetype = "Burglary", Prop.Vals = PropValsGoodman, dataf = df.Goodman),
        Larc = larcSPC.Goodman <- SPC(crimetype = "Larceny", Prop.Vals = PropValsGoodman, dataf = df.Goodman)
    ),
    Clinton = list(
        Firearm = firearmSPC.Clinton <- SPC(crimetype = "Firearm", Prop.Vals = PropValsClinton, dataf = df.Clinton),
        SV = svSPC.Clinton <- SPC(crimetype = "Shooting", 
                                  Prop.Vals = ShootingProps.Clinton,
                                  dataf = filter(svjoined, sec == "Clinton")),
        Homicide = homicideSPC.Clinton <- SPC(crimetype = "Homicide", Prop.Vals = PropValsClinton, dataf = df.Clinton),
        Rape = rapeSPC.Clinton <- SPC(crimetype = "Rape", Prop.Vals = PropValsClinton, dataf = df.Clinton),
        Rob = robSPC.Clinton <- SPC(crimetype = "Robbery", Prop.Vals = PropValsClinton, dataf = df.Clinton),
        Aslt = asltSPC.Clinton <- SPC(crimetype = "Aggravated Assault", Prop.Vals = PropValsClinton, dataf = df.Clinton),
        Burg = burgSPC.Clinton <- SPC(crimetype = "Burglary", Prop.Vals = PropValsClinton, dataf = df.Clinton),
        Larc = larcSPC.Clinton <- SPC(crimetype = "Larceny", Prop.Vals = PropValsClinton, dataf = df.Clinton)
    ),
    Central = list(
        Firearm = firearmSPC.Central <- SPC(crimetype = "Firearm", Prop.Vals = PropValsCentral, dataf = df.Central),
        SV = svSPC.Central <- SPC(crimetype = "Shooting", 
                                  Prop.Vals = ShootingProps.Central,
                                  dataf = filter(svjoined, sec == "Central")),
        Homicide = homicideSPC.Central <- SPC(crimetype = "Homicide", Prop.Vals = PropValsCentral, dataf = df.Central),
        Rape = rapeSPC.Central <- SPC(crimetype = "Rape", Prop.Vals = PropValsCentral, dataf = df.Central),
        Rob = robSPC.Central <- SPC(crimetype = "Robbery", Prop.Vals = PropValsCentral, dataf = df.Central),
        Aslt = asltSPC.Central <- SPC(crimetype = "Aggravated Assault", Prop.Vals = PropValsCentral, dataf = df.Central),
        Burg = burgSPC.Central <- SPC(crimetype = "Burglary", Prop.Vals = PropValsCentral, dataf = df.Central),
        Larc = larcSPC.Central <- SPC(crimetype = "Larceny", Prop.Vals = PropValsCentral, dataf = df.Central)
    )
)

saveRDS(sectionSPClist, 
        "Z:/Projects/dashboard/RPDCrimeDashboard/Objects/sectionSPClist.RDS", 
        compress = FALSE)
