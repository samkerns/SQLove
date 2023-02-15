##This is a resubmission as of 2/15/23

## R CMD check results
There were 0 ERRORs, 0 WARNINGs, and 0 NOTES

##Feedback as of 2/15/23, 7:21AM EST
Please always write package names, software names and API (application
programming interface) names in single quotes in title and description.
e.g: --> 'SQL'; 'R'
Please note that package names are case sensitive.

COMPLETED


If there are references describing the methods in your package, please
add these in the description field of your DESCRIPTION file in the form
authors (year) <doi:...>
authors (year) <arXiv:...>
authors (year, ISBN:...)
or if those are not available: <https:...>
with no space after 'doi:', 'arXiv:', 'https:' and angle brackets for
auto-linking. (If you want to add a title as well please put it in
quotes: "Title")

COMPLETED

Please always explain all acronyms in the description text. -> DBI

COMPLETED

You have examples for unexported functions. Please either omit these
examples or export these functions.
Examples for unexported function
   dbGetMultiQuery() in:
      dbGetMultiQuery.Rd

COMPLETED - Functions exported

Please add small executable examples in your Rd-files to illustrate the
use of the exported function but also enable automatic testing.

FIXED - Switched from example to usage, package requires upstream code. Detailed in vignette
Note - please advise if this is not acceptable, writing example requires large code block
and may be better served in vignette format.
