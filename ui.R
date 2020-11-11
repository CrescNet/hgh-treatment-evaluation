library(shiny)

shinyUI(fluidPage(
  title = 'CrescNet hGH Treatment Evaluation App',
  titlePanel(title = div(img(src = 'logo.svg', height = '50'), span('hGH Treatment Evaluation App', style = 'vertical-align:bottom'))),
  'Please insert the most recent patient data as well as parental height values on the left site. The evaluation will be displayed on the right site.',
  br(),
  'SDS values are calculated with the R package ', a('childsds', href = 'https://cran.r-project.org/package=childsds'), '.',
  
  tags$h3('Disclaimer'),
  'This tool is not approved as a medicinal product for clinical use, and should be used for research purposes only.',
  
  hr(),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons('sex', 'Sex', choices = c('female', 'male'), inline = TRUE),
      sliderInput('age', 'Age (years)', min = 0, max = 20, value = 10, step = .25),
      numericInput('height', 'Height (cm)', NULL, min = 0, max = 250),
      numericInput('motherHeight', 'Mother height (cm)', NULL, min = 0, max = 250),
      numericInput('fatherHeight', 'Father height (cm)', NULL, min = 0, max = 250),
      selectInput('reference', 'Reference', c('cdc', 'kiggs_2003-2006', 'kromeyer-hauschild_et_al', 'merker_et_al', 'xin-nan_zong_et_al', 'zemel_et_al'))
    ),
    
    mainPanel(
      wellPanel(tags$h4('Height SDS:', uiOutput('heightCentile', inline = TRUE))),
      wellPanel(tags$h4('Target heights:'), tableOutput('targetHeightTable')),
      wellPanel(tags$h4('hGH treatment evaluation:'), uiOutput('hghTreatmentEvaluation'))
    )
  ),
  
  tags$footer(
    hr(),
    tags$small('Source code of this Shiny app is available at: ',
               a('GitHub', href = 'https://github.com/CrescNet/hgh-treatment-evaluation')
    ), align = 'center'
  )
))
