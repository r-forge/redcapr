# library(testthat)
library(REDCapR)

packages <- utils::installed.packages()
testthatVersion <- packages[packages[, 1]=="testthat", "Version"]
message("testthat package version: ", testthatVersion)

if(  testthatVersion >= "0.8" ) {
#   testthat::test_check("REDCapR")
  testthat::test_package("REDCapR")
}
rm(packages)

#   devtools::test()