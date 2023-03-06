#' Run multiple SQL query actions within the DB environment.
#' @description Requires a DBI workflow that creates a connection with a relational database per DBI: https://dbi.r-dbi.org/. This function is an extension of the RJDBC::dbSendUpdate function.
#' @param connection A database connection object
#' @param sql_file_path Character vector pointing to SQL script
#' @returns No object returned - for production automation
#' @usage
#' dbSendMultiUpdate(connection, sql_file_path)
#' @export

dbSendMultiUpdate <- function(connection, sql_file_path){

  #Reading in the SQL file
  sql_file <- readr::read_file(sql_file_path)

  #Removing all comments /* and --
  sql_file <- base::gsub("/\\*.*?\\*/", "", sql_file)
  sql_file <- base::gsub("--.*?\\r", "\\\r", sql_file)

  #Extracting all the separate queries by semicolons
  sql_list <- base::strsplit(sql_file, "(?<=[;])", perl = T)

  #Evaluating the length of the list
  query_length <- base::lengths(sql_list)

  #Running the appropriate query approach based on list length
  for (i in c(1:(query_length))){

      RJDBC::dbSendUpdate(conn, sql_list[[1]][[i]], immediate = T)

      print(paste("Statement", i, "of", query_length, "complete"))

    }

  }
