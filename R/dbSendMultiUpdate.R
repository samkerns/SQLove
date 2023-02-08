dbSendMultiUpdate <- function(connection, sql_file_path){

  #Reading in the SQL file
  sql_file <- readr::read_file(sql_file_path)

  #Removing all comments /* and --
  sql_file <- gsub("/\\*.*?\\*/", "", sql_file)
  sql_file <- gsub("--.*?\\r", "\\\r", sql_file)

  #Extracting all the separate queries by semicolons
  sql_list <- strsplit(sql_file, "(?<=[;])", perl = T)

  #Evaluating the length of the list
  query_length <- lengths(sql_list)

  #Running the appropriate query approach based on list length
  for (i in c(1:(query_length))){

      RJDBC::dbSendUpdate(conn, sql_list[[1]][[i]], immediate = T)

    }

  }
