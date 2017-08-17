# Create CpG Island annotation for Infinium 450k and hg19 ======================

# Necessary packages ===========================================================
library(dplyr)
library(FDb.InfiniumMethylation.hg19)
library(purrr)
library(readr)
library(tibble)
library(tidyr)

# Get the CpG Islands definition ===============================================
data(hg19.islands)

cpgi_regions <- list(
  'N_Shelf' = flank(shift(hg19.islands, -2000), 2000),
  'S_Shelf' = flank(shift(hg19.islands, 2000), 2000, start = FALSE),
  'N_Shore' = flank(hg19.islands, 2000),
  'S_Shore' = flank(hg19.islands, 2000, start = FALSE),
  'CGI' = hg19.islands
)

# Get ranges from Infinium 450k ================================================
hm450 = get450k()

# Compute the annotation table =================================================
cpgi_hm450_hg19 = map(
  cpgi_regions, ~ subsetByOverlaps(hm450, .x) %>%
    names()) %>%
  enframe(name = 'CPGI_Status', value = 'Probe_ID') %>%
  unnest(Probe_ID) %>%
  dplyr::select(Probe_ID, CPGI_Status)

# Store results ================================================================
write_tsv(cpgi_hm450_hg19, path = 'data-raw/cpgi_hm450_hg19.tsv.gz')
devtools::use_data(cpgi_hm450_hg19, overwrite = TRUE)
