
start <- Sys.time()

## Data prep

source("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimeDashboardWeeklyDataPrep.R")

## Citywide dashboards

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceCitywide.RMD",
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  quiet = TRUE)

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesCitywide.RMD",
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  quiet = TRUE)

## Section crime dashboards

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Lake"),
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  output_file = "LakeCrimeDashboard.html",
                  quiet = TRUE)

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Genesee"),
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  output_file = "GeneseeCrimeDashboard.html",
                  quiet = TRUE)

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Goodman"),
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  output_file = "GoodmanCrimeDashboard.html",
                  quiet = TRUE)

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Clinton"),
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  output_file = "ClintonCrimeDashboard.html",
                  quiet = TRUE)

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Central"),
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  output_file = "CentralCrimeDashboard.html",
                  quiet = TRUE)

## Section CFS dashboards

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Lake"),
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  output_file = "LakeCFSDashboard.html",
                  quiet = TRUE)

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Genesee"),
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  output_file = "GeneseeCFSDashboard.html",
                  quiet = TRUE)

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Goodman"),
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  output_file = "GoodmanCFSDashboard.html",
                  quiet = TRUE)

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Clinton"),
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  output_file = "ClintonCFSDashboard.html",
                  quiet = TRUE)

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Central"),
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  output_file = "CentralCFSDashboard.html",
                  quiet = TRUE)

## Patrol section overview

rmarkdown::render("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/SectionOverlook.RMD",
                  output_dir = "//cor.local/RPD/Shared/OBI-Analytics/Crime and CFS Dashboards",
                  quiet = TRUE)

end <- Sys.time()
took <- difftime(end, start)

took