##This is a resubmission as of 2/14/23

## R CMD check results
There were no ERRORs or WARNINGs

There were 2 NOTEs:

❯ checking R code for possible problems ... NOTE
  dbGetMultiQuery: no visible binding for global variable 'conn'
  dbGetMultiQuery: no visible global function definition for 'SQL'
  dbSendMultiUpdate: no visible binding for global variable 'conn'
  Undefined global functions or variables:
    SQL conn

❯ checking Rd line widths ... NOTE
  Rd file 'dbGetMultiQuery.Rd':
    \examples lines wider than 100 characters:
       SQLove::dbGetMultiQuery(conn, "~/path_to/file.sql", pattern = "state = [A-Z](2)", replacement = "state = MD")