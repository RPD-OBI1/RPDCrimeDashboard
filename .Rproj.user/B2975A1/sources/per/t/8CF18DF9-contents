
start <- Sys.time()

## Data prep

source("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimeDashboardWeeklyDataPrep.R")

## Citywide dashboards

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceCitywide.RMD",
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  quiet = TRUE)

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesCitywide.RMD",
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  quiet = TRUE)

## Section crime dashboards

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Lake"),
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  output_file = "LakeCrimeDashboard.html",
                  quiet = TRUE)

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Genesee"),
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  output_file = "GeneseeCrimeDashboard.html",
                  quiet = TRUE)

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Goodman"),
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  output_file = "GoodmanCrimeDashboard.html",
                  quiet = TRUE)

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Clinton"),
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  output_file = "ClintonCrimeDashboard.html",
                  quiet = TRUE)

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                  params = list(sectionname = "Central"),
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  output_file = "CentralCrimeDashboard.html",
                  quiet = TRUE)

## Section CFS dashboards

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Lake"),
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  output_file = "LakeCFSDashboard.html",
                  quiet = TRUE)

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Genesee"),
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  output_file = "GeneseeCFSDashboard.html",
                  quiet = TRUE)

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Goodman"),
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  output_file = "GoodmanCFSDashboard.html",
                  quiet = TRUE)

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Clinton"),
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  output_file = "ClintonCFSDashboard.html",
                  quiet = TRUE)

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CallsForServiceSection.RMD", 
                  params = list(sectionname = "Central"),
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  output_file = "CentralCFSDashboard.html",
                  quiet = TRUE)

## Patrol section overview

rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/SectionOverlook.RMD",
                  output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                  quiet = TRUE)

end <- Sys.time()
took <- difftime(end, start)

took