library(shiny)
library(GrowthSDS)

shinyUI(fluidPage(
  title = 'CrescNet hGH Treatment Evaluation App',
  titlePanel(title = div(img(src = 'logo.svg', height = '50'), span('hGH Treatment Evaluation App', style = 'vertical-align:bottom'))),
  'Please insert the most recent patient data as well as parental height values on the left site. The evaluation will be displayed on the right site.',
  
  tags$h3('Disclaimer'),
  'This tool is not approved as a medicinal product for clinical use, and should be used for research purposes only.',
  
  hr(),
  
  sidebarLayout(
    sidebarPanel(
      selectInput('reference', 'Reference', setNames(standardReferences()$Item, standardReferences()$Title)),
      uiOutput('ageSlider'),
      radioButtons('sex', 'Sex', choices = c('female', 'male'), inline = TRUE),
      numericInput('height', 'Height (cm)', NULL, min = 0, max = 250),
      numericInput('motherHeight', 'Mother height (cm)', NULL, min = 0, max = 250),
      numericInput('fatherHeight', 'Father height (cm)', NULL, min = 0, max = 250)
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
