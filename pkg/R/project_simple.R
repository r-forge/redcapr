
populate_project_simple <- function( batch = FALSE ) {
  if( !require(testthat) ) stop("The function REDCapR:::populate_project_simple() cannot run if the `testthat` package is not installed.  Please install it and try again.")
  #Declare the server & user information
  uri <- "https://bbmc.ouhsc.edu/redcap/api/"
  token <- "D70F9ACD1EDD6F151C6EA78683944E98" #For `UnitTestPhiFree` account and the simple project (pid 213)
  # token <- "9A81268476645C4E5F03428B8AC3AA7B" #For `UnitTestPhiFree` account and the simple project (pid 153)
  project <- REDCapR::redcap_project$new(redcap_uri=uri, token=token)
  path_in_simple <- base::file.path(devtools::inst(name="REDCapR"), "test_data/simple.csv")
 
  #Write the file to disk (necessary only when you wanted to change the data).  Don't uncomment; just run manually.
  # returned_object <- redcap_read_oneshot(redcap_uri=uri, token=token, raw_or_label="raw")
  # write.csv(returned_object$data, file=path_in_simple, row.names=FALSE)
    
  #Read in the data in R's memory from a csv file.
  dsToWrite <- utils::read.csv(file=path_in_simple, stringsAsFactors=FALSE)
  
  #Remove the calculated variables.
  dsToWrite$age <- NULL
  dsToWrite$bmi <- NULL
  
  #Import the data into the REDCap project
  testthat::expect_message(
    if( batch ) {
      returned_object <- REDCapR::redcap_write(ds=dsToWrite, redcap_uri=uri, token=token, verbose=TRUE)
    }
    else {
      returned_object <- REDCapR::redcap_write_oneshot(ds=dsToWrite, redcap_uri=uri, token=token, verbose=TRUE)
    }
  )
  
  #Print a message and return a boolean value
  base::message(base::sprintf("populate_project_simple success: %s.", returned_object$success))
  return( list(is_success=returned_object$success, redcap_project=project) )
}
clear_project_simple <- function( ) {
  if( !require(testthat) ) stop("The function REDCapR:::populate_project_simple() cannot run if the `testthat` package is not installed.  Please install it and try again.")
  pathDeleteTestRecord <- "https://bbmc.ouhsc.edu/redcap/plugins/redcapr/delete_redcapr_simple.php"
  # httr::url_ok(pathDeleteTestRecord)
  
  #Returns a boolean value if successful
  (was_successful <- httr::url_success(pathDeleteTestRecord))
  
  #Print a message and return a boolean value
  base::message(base::sprintf("clear_project_simple success: %s.", was_successful))
  return( was_successful )
}

clean_start_simple <- function( batch = FALSE ) {
  if( !require(testthat) ) stop("The function REDCapR:::populate_project_simple() cannot run if the `testthat` package is not installed.  Please install it and try again.")
  testthat::expect_message(
    clear_result <- clear_project_simple(),
    regexp = "clear_project_simple success: TRUE."   
  )
  testthat::expect_true(clear_result, "Clearing the results from the simple project should be successful.")
  
  testthat::expect_message(
    populate_result <- populate_project_simple(batch=batch),
    regexp = "populate_project_simple success: TRUE."    
  )
  testthat::expect_true(populate_result$is_success, "Population the the simple project should be successful.")
  return( populate_result )
}

# populate_project_simple()
# populate_project_simple(batch=TRUE)
# clear_project_simple()
# clean_start_simple()
# clean_start_simple(batch=TRUE)