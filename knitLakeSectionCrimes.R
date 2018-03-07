
sectiondflistfile <- "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/Objects/sectiondflist.RDS"
if( format(file.info(sectiondflistfile)$mtime, "%Y-%m-%d") == (Sys.Date() - 1) ) {
    rmarkdown::render("Z:/Projects/dashboard/RPDCrimeDashboard/CrimeDashboardRepo/CrimesSection.RMD", 
                      params = list(sectionname = "Lake"),
                      output_dir = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard",
                      output_file = "LakeCrimeDashboard.html",
                      quiet = TRUE)
} else {
        write(x = "The sectiondflist was not exactly one day old", 
              file = paste0("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/FailureMessages/",
                            Sys.Date(),
                            "LakeSectionCrimes.txt"))
    }

if ( 
    format( 
        file.info("//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/LakeCrimeDashboard.html")$mtime, 
        "%Y-%m-%d" 
    ) == Sys.Date() ) {
    write(x = "Lake Crime Dashboard ran successfully on ", Sys.Date(),
          file = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/OutcomeNotify.txt", 
          append = TRUE)
} else {
        write(x = paste0("Lake Crime Dashboard tried but failed on ", Sys.Date()),
              file = "//cor.local/RPD/Chief/OBI/Projects/dashboard/RPDCrimeDashboard/OutcomeNotify.txt",
              append = TRUE)
    }
