
start <- Sys.time()
rmarkdown::render("citywidedashboard.RMD")
rmarkdown::render("LakeCrimeDashBoard.RMD")
rmarkdown::render("GeneseeCrimeDashBoard.RMD")
rmarkdown::render("GoodmanCrimeDashBoard.RMD")
rmarkdown::render("ClintonCrimeDashBoard.RMD")
rmarkdown::render("CentralCrimeDashBoard.RMD")
end <- Sys.time()
took <- difftime(end, start)

fileConn <- file("took.txt")
writeLines(paste(Sys.Date(), took, " seconds"), fileConn)
close(fileConn)
