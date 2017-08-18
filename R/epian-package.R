# .onLoad = function(libname, pkgname) {
#   data(
#     'cpgi_hm450_hg19',
#     package = pkgname,
#     envir = parent.env(environment())
#   )
# }

# Declare global variables =====================================================
if(getRversion() >= "2.15.1")  {
  utils::globalVariables(c(
    '.',
    'Architecture',
    'CPGI_Status',
    'FALSE_FALSE',
    'FALSE_TRUE',
    'Genome',
    'Mark_And_SOI',
    'Mark_And_Not_SOI',
    'n',
    'No_Mark_Or_SOI',
    'Not_Mark_And_SOI',
    'O_Background',
    'O_SOI',
    'OR',
    'Overlap',
    'p.value',
    'P_Background',
    'P_SOI',
    'P_Value',
    'Probe_ID',
    'RR',
    'SOI',
    'SOI_Overlap',
    'TRUE_FALSE',
    'TRUE_TRUE'
  ))
}
