library(shiny)
library(GrowthSDS)

shinyUI(fluidPage(
  tags$head(
    tags$style('.tab-content { margin-top: 1rem }')
  ),
  
  title = 'CrescNet App zur Beurteilung für STH-Therapierung',
  titlePanel(title = div(img(src = 'logo.svg', height = '50'), span('App zur Beurteilung für STH-Therapierung', style = 'vertical-align:bottom'))),
  'Bitte geben Sie die Patientendaten auf der linken Seite ein. Die Auswertung wird auf der rechten Seite angezeigt.',
  
  h3('Disclaimer'),
  'Dieses Tool ist nicht als Arzneimittel für den klinischen Gebrauch zugelassen und sollte nur zu Forschungszwecken verwendet werden.',
  
  hr(),
  
  tabsetPanel(
    type = 'tabs',
  
    tabPanel(
      'Zielgröße',
      sidebarLayout(
        sidebarPanel(
          selectInput('reference', 'Referenz', setNames(standardReferences()$Item, standardReferences()$Title)),
          
          dateInput('birthDate', 'Geburtsdatum', startview = 'decade', max = Sys.Date(), format = 'dd.mm.yyyy', language = 'de'),
          radioButtons('sex', 'Geschlecht', choices = c('männlich' = 'male', 'weiblich' = 'female'), inline = TRUE),
          
          dateInput('observationDate', 'Beobachtungsdatum', max = Sys.Date(), format = 'dd.mm.yyyy', language = 'de'),
          numericInput('height', 'Größe (cm)', NULL, min = 0, max = 250),
          numericInput('motherHeight', 'Größe der Mutter (cm)', NULL, min = 0, max = 250),
          numericInput('fatherHeight', 'Größe des Vaters (cm)', NULL, min = 0, max = 250)
        ),
        
        mainPanel(
          wellPanel(tags$h4('Größen-SDS:', uiOutput('heightCentile', inline = TRUE))),
          wellPanel(
            h4('Zielgröße:'),
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
          radioButtons('birthSex', 'Geschlecht', choices = c('männlich' = 'male', 'weiblich' = 'female'), inline = TRUE),
          # radioButtons('isTwin', 'Zwilling', selected = FALSE, choicees = c('nein' = FALSE), inline = TRUE),
          
          numericInput('gestationalAge', 'Gestationsalter (wk.d, 20.0-43.0)', NA, min = 20, max = 43),
          
          numericInput('birthLength', 'Länge (cm)', NULL, min = 0, max = 70),
          numericInput('birthWeight', 'Gewicht (kg)', NULL, min = 0, max = 7000)
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
    tags$small('Quellcode dieser Shiny App ist verfügbar unter: ',
          a('GitHub', href = 'https://github.com/CrescNet/hgh-treatment-evaluation')
    ), align = 'center'
  )
))

