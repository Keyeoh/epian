# Create CpG Island annotation for Infinium 450k and hg19 ======================

# Necessary packages ===========================================================
library(dplyr)
library(FDb.InfiniumMethylation.hg19)
library(purrr)
library(readr)

# Get the CpG Islands definition ===============================================
data(hg19.islands)

cpgi_regions = list(
  'N_Shelf' = flank(shift(hg19.islands, -2000), 2000),
  'S_Shelf' = flank(shift(hg19.islands, 2000), 2000, start = FALSE),
  'N_Shore' = flank(hg19.islands, 2000),
  'S_Shore' = flank(hg19.islands, 2000, start = FALSE),
  'CGI' = hg19.islands
)

# Get ranges from Infinium 450k ================================================
hm450 = get450k()

# Compute the annotation table =================================================
cpgi_hm450_hg19 = map_df(cpgi_regions, ~ countOverlaps(hm450, .x) > 0) %>%
  mutate(Open_Sea = !reduce(., ~ .x | .y)) %>%
  mutate(Probe_ID = names(hm450)) %>%
  dplyr::select(Probe_ID, CGI, N_Shore, S_Shore, N_Shelf, S_Shelf, Open_Sea)

# Store results ================================================================
write_tsv(cpgi_hm450_hg19, path = 'data-raw/cpgi_hm450_hg19.tsv.gz')
devtools::use_data(cpgi_hm450_hg19, overwrite = TRUE)
