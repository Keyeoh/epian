# ==============================================================================
library(dplyr)
library(epian)
library(shiny)

# Define server logic ==========================================================
shinyServer(function(input, output) {

  probe_ids = reactive({
    strsplit(input$probe_ids, split = '\n')[[1]]
  })

  test_result = reactive({
    cpgi_annot(
      probe_ids = probe_ids(),
      method = input$method,
      arch = input$arch,
      genome = input$genome
    )
  })

  test_range = reactive({
    test_result() %>%
      ungroup() %>%
      select(contains('Mark')) %>%
      range()
  })

  output$counts_table = DT::renderDataTable(
    datatable(
      test_result() %>%
        select(CPGI_Status, contains('Mark')),
      rownames = FALSE,
      extensions = 'FixedColumns',
      class = 'compact display nowrap',
      options = list(
        scrollX = TRUE,
        scrollY = '50vh',
        scrollCollapse = TRUE,
        paging = FALSE,
        fixedColumns = list(
          leftColumns = 1
        )
      )
    ) %>%
      formatStyle(columns = 'CPGI_Status', color = 'darkblue') %>%
      formatStyle(
        columns = c(
          'Mark_And_SOI',
          'Mark_And_Not_SOI',
          'Not_Mark_And_SOI',
          'No_Mark_Or_SOI'
          ),
        background = styleColorBar(test_range(), 'lightblue')
      )
  )

  output$ratios_table = DT::renderDataTable(
    datatable(
      test_result() %>%
        select(
          CPGI_Status,
          P_SOI,
          P_Background,
          contains('OR', ignore.case = FALSE),
          contains('RR', ignore.case = FALSE)
        ),
      rownames = FALSE,
      extensions = 'FixedColumns',
      class = 'compact display nowrap',
      options = list(
        scrollX = TRUE,
        scrollY = '50vh',
        scrollCollapse = TRUE,
        paging = FALSE,
        fixedColumns = list(
          leftColumns = 1
        )
      )
    ) %>%
      formatStyle(columns = 'CPGI_Status', color = 'darkblue') %>%
      formatRound(
        columns = c(
          'P_SOI',
          'P_Background',
          'OR',
          'Log2_OR',
          'RR',
          'Log2_RR'
        ),
        digits = 4
      ) %>%
      formatStyle(
        columns = c(
          'P_SOI',
          'P_Background'
        ),
        background = styleColorBar(c(0, 1), 'lightgreen')
      ) %>%
      formatStyle(
        columns = c('OR', 'RR'),
        color = styleInterval(c(0.5, 2), c('purple', 'black', 'orange')),
        fontWeight = styleInterval(c(0.5, 2), c('bold', 'normal', 'bold'))
      ) %>%
      formatStyle(
        columns = c('Log2_OR', 'Log2_RR'),
        color = styleInterval(c(-1, 1), c('purple', 'black', 'orange')),
        fontWeight = styleInterval(c(-1, 1), c('bold', 'normal', 'bold'))
      )
  )

  output$sig_table = DT::renderDataTable(
    datatable(
      test_result() %>%
        select(
          CPGI_Status,
          P_Value,
          FDR,
          Bonferroni,
          Method
        ),
      rownames = FALSE,
      extensions = 'FixedColumns',
      class = 'compact display nowrap',
      options = list(
        scrollX = TRUE,
        scrollY = '50vh',
        scrollCollapse = TRUE,
        paging = FALSE,
        fixedColumns = list(
          leftColumns = 1
        )
      )
    ) %>%
      formatStyle(columns = 'CPGI_Status', color = 'darkblue') %>%
      formatRound(
        columns = c('P_Value', 'FDR', 'Bonferroni'),
        digits = 4
      ) %>%
      formatStyle(
        columns = c('P_Value', 'FDR', 'Bonferroni'),
        color = styleInterval(0.05, c('red', 'black')),
        fontWeight = styleInterval(0.05, c('bold', 'normal'))
      )
  )
})
