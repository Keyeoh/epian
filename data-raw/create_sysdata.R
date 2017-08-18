# Load the objects created in data-raw and save them ===========================
library(readr)

# CPGI Status ==================================================================
cpgi_hm450_hg19 = read_tsv(file = 'data-raw/cpgi_hm450_hg19.tsv.gz')

# Store data ===================================================================
devtools::use_data(
  cpgi_hm450_hg19,
  internal = TRUE
)
