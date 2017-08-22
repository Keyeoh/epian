#' CPGI Status annotation
#'
#' @param probe_ids A character vector containing the Illumina probe identifiers
#' to be tested.
#' @param method A character scalar indicating the testing method.
#' @param arch A character scalar indicating the array architecture.
#' @param genome A character scalar indicating the reference genome.
#' @param soi_id A character scalar describing the subset of interest being
#' tested. A value of NULL does not even add a column with the identifier.
#'
#' @return A data.frame containing the test results.
#'
#' @importFrom broom tidy
#' @importFrom dplyr %>% mutate group_by tally do ungroup inner_join everything
#' select
#' @importFrom stats chisq.test fisher.test p.adjust
#' @importFrom tidyr gather spread
#' @export
#'
cpgi_annot = function(
  probe_ids,
  method = c('chisq', 'fisher'),
  arch = 'hm450',
  genome = 'hg19',
  soi_id = NULL
) {
  method = match.arg(method)
  arch = match.arg(arch)
  genome = match.arg(genome)

  cpgi_data_str = paste('cpgi', arch, genome, sep = '_')

  cpgi_data = get(cpgi_data_str)

  count_data = cpgi_data %>%
    mutate(SOI = Probe_ID %in% probe_ids) %>%
    gather(CPGI_Status, Overlap, -Probe_ID, -SOI) %>%
    group_by(CPGI_Status, SOI, Overlap) %>%
    tally() %>%
    group_by(CPGI_Status) %>%
    mutate(SOI_Overlap = paste(SOI, Overlap, sep = '_')) %>%
    select(-SOI, -Overlap) %>%
    spread(SOI_Overlap, n, fill = 0) %>%
    mutate(Architecture = arch) %>%
    mutate(Genome = genome) %>%
    select(
      Architecture,
      Genome,
      CPGI_Status,
      Mark_And_SOI = TRUE_TRUE,
      Mark_And_Not_SOI = FALSE_TRUE,
      Not_Mark_And_SOI = TRUE_FALSE,
      No_Mark_Or_SOI = FALSE_FALSE
    ) %>%
    mutate(O_SOI = Mark_And_SOI / Not_Mark_And_SOI) %>%
    mutate(O_Background = Mark_And_Not_SOI / No_Mark_Or_SOI) %>%
    mutate(OR = O_SOI / O_Background) %>%
    mutate(Log2_OR = log(OR, 2)) %>%
    mutate(P_SOI = Mark_And_SOI / (Mark_And_SOI + Not_Mark_And_SOI)) %>%
    mutate(P_Background = Mark_And_Not_SOI /
             (Mark_And_Not_SOI + No_Mark_Or_SOI)) %>%
    mutate(RR = P_SOI / P_Background) %>%
    mutate(Log2_RR = log(RR, 2))

  test_fun = function(xx, method) {
    test_m = matrix(c(
      xx[['Mark_And_SOI']],
      xx[['Not_Mark_And_SOI']],
      xx[['Mark_And_Not_SOI']],
      xx[['No_Mark_Or_SOI']]),
      ncol = 2,
      nrow = 2
    )

    test_fs = list(
      chisq = function(xx) chisq.test(xx, simulate.p.value = TRUE),
      fisher = fisher.test
    )

    result = test_fs[[method]](test_m)

    return(result)
  }

  test_data = count_data %>%
    do(test_fun(., method) %>% tidy()) %>%
    select(Method = method, P_Value = p.value) %>%
    ungroup() %>%
    mutate(FDR = p.adjust(P_Value, method = 'fdr')) %>%
    mutate(Bonferroni = p.adjust(P_Value, method = 'bonferroni'))

  results = count_data %>%
    inner_join(test_data)

  if (!is.null(soi_id)) {
    results = results %>%
      mutate(SOI = soi_id) %>%
      select(SOI, everything())
  }

  return(results)
}
