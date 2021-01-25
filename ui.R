library(shiny)
library(GrowthSDS)

shinyUI(fluidPage(
  tags$head(
    tags$style('.tab-content { margin-top: 1rem }')
  ),
  
  title = 'CrescNet hGH Treatment Evaluation App',
  titlePanel(title = div(img(src = 'logo.svg', height = '50'), span('hGH Treatment Evaluation App', style = 'vertical-align:bottom'))),
  'Please insert the patient data on the left site. The evaluation will be displayed on the right site.',
  
  h3('Disclaimer'),
  'This tool is not approved as a medicinal product for clinical use, and should be used for research purposes only.',
  
  hr(),
  
  tabsetPanel(
    type = 'tabs',
  
    tabPanel(
      'Target Height',
      sidebarLayout(
        sidebarPanel(
          selectInput('reference', 'Reference', setNames(standardReferences()$Item, standardReferences()$Title)),
          
          dateInput('birthDate', 'Birth date', startview = 'decade', max = Sys.Date()),
          radioButtons('sex', 'Sex', choices = c('female', 'male'), inline = TRUE),
          
          dateInput('observationDate', 'Observation date', max = Sys.Date()),
          numericInput('height', 'Height (cm)', NULL, min = 0, max = 250),
          numericInput('motherHeight', 'Mother height (cm)', NULL, min = 0, max = 250),
          numericInput('fatherHeight', 'Father height (cm)', NULL, min = 0, max = 250)
        ),
        
        mainPanel(
          wellPanel(tags$h4('Height SDS:', uiOutput('heightCentile', inline = TRUE))),
          wellPanel(
            h4('Target height:'),
            textOutput('targetHeightDifference'),
            span(textOutput('targetHeightDifferenceResult'), style = 'color:red'),
            br(),
            tableOutput('targetHeightTable')
          )
        )
      )
    ),
    
    tabPanel(
      'SGA',
      sidebarLayout(
        sidebarPanel(
          radioButtons('birthSex', 'Sex', choices = c('female', 'male'), inline = TRUE),
          # radioButtons('isTwin', 'Twin', selected = FALSE, choiceNames = c('no'), choiceValues = c(FALSE), inline = TRUE),
          
          numericInput('gestationalAge', 'Gestational age (wk.d, 20.0-43.0)', NA, min = 20, max = 43),
          
          numericInput('birthLength', 'Length (cm)', NULL, min = 0, max = 70),
          numericInput('birthWeight', 'Weight (kg)', NULL, min = 0, max = 7000)
        ),
        
        mainPanel(
          uiOutput('birthLengthEvaluation'),
          uiOutput('birthWeightEvaluation')
        )
      ),
    )
  ),
  
  tags$footer(
    hr(),
    tags$small('Source code of this Shiny app is available at: ',
          a('GitHub', href = 'https://github.com/CrescNet/hgh-treatment-evaluation')
    ), align = 'center'
  )
))

