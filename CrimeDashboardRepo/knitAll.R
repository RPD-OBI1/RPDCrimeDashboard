
start <- Sys.time()

## Data prep

source("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimeDashboardWeeklyDataPrep.R")

## Citywide dashboards

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceCitywide.RMD",
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/")

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesCitywide.RMD",
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/")

## Section crime dashboards

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Lake"),
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/",
                  output_file = "LakeCrimeDashboard.html")

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Genesee"),
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/",
                  output_file = "GeneseeCrimeDashboard.html")

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Goodman"),
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/",
                  output_file = "GoodmanCrimeDashboard.html")

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Clinton"),
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/",
                  output_file = "ClintonCrimeDashboard.html")

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Central"),
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/",
                  output_file = "CentralCrimeDashboard.html")

## Section CFS dashboards

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Lake"),
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/",
                  output_file = "LakeCFSDashboard.html")

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Genesee"),
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/",
                  output_file = "GeneseeCFSDashboard.html")

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Goodman"),
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/",
                  output_file = "GoodmanCFSDashboard.html")

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Clinton"),
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/",
                  output_file = "ClintonCFSDashboard.html")

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Central"),
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/",
                  output_file = "CentralCFSDashboard.html")

## Patrol section overview

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/SectionOverlook.RMD",
                  output_dir = "Z:/Projects/dashboard/RPDCrimeDashboard/")

end <- Sys.time()
took <- difftime(end, start)

took