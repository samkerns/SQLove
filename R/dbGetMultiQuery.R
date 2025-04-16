#' Query a database with multiple query actions and one, final, select statement.
#' @description Requires a DBI workflow that creates a connection with a relational database per DBI: https://dbi.r-dbi.org/. This function is an extension of the DBI::dbGetQuery and RJDBC::dbSendUpdate functions.
#' @param conn A database connection object
#' @param conn_type A string indicating if the connection type is a JDBC or ODBC connection - accepts "JDBC" or "ODBC" as arguments, defaults to "JDBC"
#' @param sql_path Character vector pointing to SQL script
#' @param pattern A character object you would like to substitute in the SQL script - this is not required and defaults to NULL. Calls gsub under the hood, so use regex for pattern identification. You may provide a single string or a vector of strings equal in length to the vector of strings in the replacement field.
#' @param replacement A character vector replacing the pattern specified - this is not required and defaults to NULL. Calls gsub under the hood, so use regex for pattern identification. You may provide a single string or a vector of strings equal in length to the vector of strings in the replacement field.
#' @returns A data object
#' @usage
#' dbGetMultiQuery(conn, conn_type = "JDBC", sql_path, pattern = NULL, replacement = NULL)
#' @export

dbGetMultiQuery <- function(conn, conn_type = "JDBC", sql_path, pattern = NULL, replacement = NULL){

  #Reading in the SQL file
  sql_file <- readr::read_file(sql_path)

  #Removing all comments /* and --
  sql_file <- base::gsub("/\\*.*?\\*/", "", sql_file)
  sql_file <- base::gsub("--.*?\\r", "\\\r", sql_file)

  #Removing whitespace at the end of the sql script
  sql_file <- base::gsub("\\s+$", "", sql_file)

  #String replacement for data pull
  if (is.null(pattern) & is.null(replacement)){
    sql_file <- sql_file
  } else {

    #Creating a df of the mappings
    gsub_map <- as.data.frame(pattern, replacement)

    #Looping over the dataframe for all the gsub replacements
    for (i in c(1:nrow(gsub_map))){

      #Replacing all the pattern/replacement elements
      sql_file <- base::gsub(pattern = gsub_map$pattern[i, 1], replacement = gsub_map$replacement[i, 2], sql_file)

      #Creating a simple log to show the replacement has been made
      print(paste("Replaced", pattern[i,1], "with", replacement[i,2]))

    }

  }

  #Extracting all the separate queries by semicolons
  sql_list <- base::strsplit(sql_file, "(?<=[;])", perl = T)

  #Evaluating the length of the list
  query_length <- base::lengths(sql_list)

  #Running the appropriate query approach based on list length

  #If only 1 query is available, it's a SELECT statement, use DBI::dbGetQuery
  if (query_length == 1){

    df <- DBI::dbGetQuery(conn, sql_list[[1]][[1]])

  #If more than 1 query is available and JDBC connection, dbSendUpdate for all but final statement
  } else if (conn_type == "JDBC"){

    for (i in c(1:(query_length-1))){

      RJDBC::dbSendUpdate(conn, DBI::SQL(sql_list[[1]][[i]]), immediate = T)

      print(paste("Statement", i, "of", query_length, "complete"))

    }

    #Create dataframe from final query statement
    df <- DBI::dbGetQuery(conn, sql_list[[1]][[query_length]])

  #If more than 1 query is available and ODBC connection, dbExecute for all but final statement
  } else if (conn_type == "ODBC"){

    for (i in c(1:(query_length-1))){

      DBI::dbExecute(conn, DBI::SQL(sql_list[[1]][[i]]))

      print(paste("Statement", i, "of", query_length, "complete"))

    }

    #Create dataframe from final query statement
    df <- DBI::dbGetQuery(conn, sql_list[[1]][[query_length]])

  } else {

    #Create a little error message for if something other than JDBC or ODBC is selected
    print("Whoops, you need to be using a JDBC or ODBC connection. Make sure you check that conn_type is defined correctly in the dbGetMultiQuery function")

  }
}
