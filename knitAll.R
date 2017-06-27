
start <- Sys.time()

## Citywide dashboards

rmarkdown::render("citywidedashboard.RMD")
rmarkdown::render("citywideCFSdashboard.RMD")

## Section crime dashboards

rmarkdown::render("SectionCrimeDashboard.RMD", 
                  params = list(sectionname = "Lake"),
                  output_file = "LakeCrimeDashboard.html")

rmarkdown::render("SectionCrimeDashboard.RMD", 
                  params = list(sectionname = "Genesee"),
                  output_file = "GeneseeCrimeDashboard.html")

rmarkdown::render("SectionCrimeDashboard.RMD", 
                  params = list(sectionname = "Goodman"),
                  output_file = "GoodmanCrimeDashboard.html")

rmarkdown::render("SectionCrimeDashboard.RMD", 
                  params = list(sectionname = "Clinton"),
                  output_file = "ClintonCrimeDashboard.html")

rmarkdown::render("SectionCrimeDashboard.RMD", 
                  params = list(sectionname = "Central"),
                  output_file = "CentralCrimeDashboard.html")

## Section CFS dashboards

rmarkdown::render("SectionCFSDashboard.RMD", 
                  params = list(sectionname = "Lake"),
                  output_file = "LakeCFSDashboard.html")

rmarkdown::render("SectionCFSDashboard.RMD", 
                  params = list(sectionname = "Genesee"),
                  output_file = "GeneseeCFSDashboard.html")

rmarkdown::render("SectionCFSDashboard.RMD", 
                  params = list(sectionname = "Goodman"),
                  output_file = "GoodmanCFSDashboard.html")

rmarkdown::render("SectionCFSDashboard.RMD", 
                  params = list(sectionname = "Clinton"),
                  output_file = "ClintonCFSDashboard.html")

rmarkdown::render("SectionCFSDashboard.RMD", 
                  params = list(sectionname = "Central"),
                  output_file = "CentralCFSDashboard.html")


end <- Sys.time()
took <- difftime(end, start)

fileConn <- file(paste0("HowLongItTook/", Sys.Date(), "took.txt"))
writeLines(paste(Sys.Date(), took, " ", units(took)), fileConn)
close(fileConn)
