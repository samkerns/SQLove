#' Query a database with multiple query actions and one, final, select statement.
#' @description Requires a DBI workflow that creates a connection with a relational database per DBI: https://dbi.r-dbi.org/. This function is an extension of the DBI::dbGetQuery and RJDBC::dbSendUpdate functions.
#' @param connection A database connection object
#' @param sql_file_path Character vector pointing to SQL script
#' @param pattern A character object you would like to substitute in the SQL script - this is not required and defaults to NULL. Calls gsub under the hood, so use regex for pattern identification
#' @param replacement A character vector replacing the pattern specified - this is not required and defaults to NULL. Calls gsub under the hood, so use regex for pattern identification
#' @returns A data object
#' @examples
#' \dontrun{
#' SQLove::dbGetMultiQuery(conn, "~/path_to/file.sql")
#' SQLove::dbGetMultiQuery(conn, "~/path_to/file.sql", pattern = "state = [A-Z](2)", replacement = "state = MD")
#' }

dbGetMultiQuery <- function(connection, sql_file_path, pattern = NULL, replacement = NULL){

  #Reading in the SQL file
  sql_file <- readr::read_file(sql_file_path)

  #Removing all comments /* and --
  sql_file <- base::gsub("/\\*.*?\\*/", "", sql_file)
  sql_file <- base::gsub("--.*?\\r", "\\\r", sql_file)

  #String replacement for data pull
  if (is.null(pattern) & is.null(replacement)){
    sql_file <- sql_file
  } else {
    sql_file <- base::gsub(pattern = pattern, replacement = replacement, sql_file)
  }

  #Extracting all the separate queries by semicolons
  sql_list <- base::strsplit(sql_file, "(?<=[;])", perl = T)

  #Evaluating the length of the list
  query_length <- base::lengths(sql_list)

  #Running the appropriate query approach based on list length

  #If only 1 query is available, it's a SELECT statement, use DBI::dbGetQuery
  if (query_length == 1){

    df <- DBI::dbGetQuery(conn, sql_list[[1]][[1]])

  #If more than 1 query is available, dbSendUpdate for all but final statement
  } else{

    for (i in c(1:(query_length-1))){

      RJDBC::dbSendUpdate(conn, DBI::SQL(sql_list[[1]][[i]]), immediate = T)

    }

    #Create dataframe from final query statement
    df <- DBI::dbGetQuery(conn, sql_list[[1]][[query_length]])

  }
}
