#' Run CPGI Annotation interactive tool.
#'
#' Run an interactive Shiny tool providing a user interface to the cpgi_annot()
#' function. Thus, a user without experience may annotate a given set of probe
#' identifiers without effort.
#'
#' @return This function normally does not return unless interrupted.
#' @export
#'
run_cpgi = function() {
  app_dir = system.file('shiny-examples', 'cpgi_annot', package = 'epian')
  if (app_dir == '') {
    stop('Could not find example directory. Try re-installing `epian`.',
         call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = 'normal')
}
