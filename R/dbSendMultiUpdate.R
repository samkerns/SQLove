#' Run multiple SQL query actions within the DB environment.
#' @description Requires a DBI workflow that creates a connection with a relational database per DBI: https://dbi.r-dbi.org/. This function is an extension of the RJDBC::dbSendUpdate function.
#' @param conn A database connection object
#' @param conn_type A string indicating if the connection type is a JDBC or ODBC connection - accepts "JDBC" or "ODBC" as arguments, defaults to "JDBC"
#' @param sql_path Character vector pointing to SQL script
#' @returns No object returned - for production automation
#' @usage
#' dbSendMultiUpdate(conn, conn_type = "JDBC", sql_path)
#' @export

dbSendMultiUpdate <- function(conn, conn_type = "JDBC", sql_path){

  #Reading in the SQL file
  sql_file <- readr::read_file(sql_path)

  #Removing all comments /* and --
  sql_file <- base::gsub("/\\*.*?\\*/", "", sql_file)
  sql_file <- base::gsub("--.*?\\r", "\\\r", sql_file)

  #Removing whitespace at the end of the sql script
  sql_file <- base::gsub("\\s+$", "", sql_file)

  #Extracting all the separate queries by semicolons
  sql_list <- base::strsplit(sql_file, "(?<=[;])", perl = T)

  #Evaluating the length of the list
  query_length <- base::lengths(sql_list)

  #Running the appropriate query approach based on list length
  if (conn_type == "JDBC"){

    for (i in c(1:(query_length))){

      RJDBC::dbSendUpdate(conn, sql_list[[1]][[i]], immediate = T)

      print(paste("Statement", i, "of", query_length, "complete"))

    }

  } else if (conn_type == "ODBC"){

    for (i in c(1:(query_length))){

      DBI::dbExecute(conn, sql_list[[1]][[i]])

      print(paste("Statement", i, "of", query_length, "complete"))
    }

  } else {

    #Create a little error message for if something other than JDBC or ODBC is selected
    print("Whoops, you need to be using a JDBC or ODBC connection. Make sure you check that conn_type is defined correctly in the dbGetMultiQuery function")

    }
}
