dbGetMultiQuery <- function(connection, sql_file_path, pattern = NULL, replacement = NULL){

  #Reading in the SQL file
  sql_file <- readr::read_file(sql_file_path)

  #Removing all comments /* and --
  sql_file <- gsub("/\\*.*?\\*/", "", sql_file)
  sql_file <- gsub("--.*?\\r", "\\\r", sql_file)

  #String replacement for data pull
  if (is.null(pattern) & is.null(replacement)){
    sql_file <- sql_file
  } else {
    sql_file <- gsub(pattern = pattern, replacement = replacement, sql_file)
  }

  #Extracting all the separate queries by semicolons
  sql_list <- strsplit(sql_file, "(?<=[;])", perl = T)

  #Evaluating the length of the list
  query_length <- lengths(sql_list)

  #Running the appropriate query approach based on list length

  #If only 1 query is available, it's a SELECT statement, use DBI::dbGetQuery
  if (query_length == 1){

    df <- DBI::dbGetQuery(conn, sql_list[[1]][[1]])

  #If more than 1 query is available, dbSendUpdate for all but final statement
  } else{

    for (i in c(1:(query_length-1))){

      RJBDC::dbSendUpdate(conn, SQL(sql_list[[1]][[i]]), immediate = T)

    }

    #Create dataframe from final query statement
    df <- DBI::dbGetQuery(conn, SQL(sql_list[[1]][[query_length]]))

  }
}
