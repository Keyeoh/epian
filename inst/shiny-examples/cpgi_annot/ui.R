# ==============================================================================
library(DT)
library(shiny)

# Define UI for CPGI Annotation application ====================================
shinyUI(fluidPage(

  # Application title
  titlePanel("CpG Island annotation"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
       textAreaInput(
         'probe_ids',
         label = 'Probe identifiers',
         value = paste(
           'cg20293725',
           'cg06464744',
           'cg26717016',
           'cg03401324',
           'cg08796898',
           'cg13836627',
           'cg19351350',
           'cg24248680',
           'cg16943083',
           'cg25920279',
           sep = '\n'
         )
       ),
       selectInput(
         'method',
         label = 'Method',
         choices = list('chisq', 'fisher'),
         selected = 'chisq'
       ),
       selectInput(
         'arch',
         label = 'Architecture',
         choices = list('hm450'),
         selected = 'hm450'
       ),
       selectInput(
         'genome',
         label = 'Genome',
         choices = list('hg19'),
         selected = 'hg19'
       )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tags$h3('Counts'),
      DT::dataTableOutput('counts_table'),
      tags$h3('Ratios'),
      DT::dataTableOutput('ratios_table'),
      tags$h3('Significance'),
      DT::dataTableOutput('sig_table')
    )
  )
))
