library(dplyr)
library(GrowthSDS)
library(lubridate)

shinyServer(function(input, output, session) {
  age <- reactive({
    req(input$birthDate, input$observationDate)
    time_length(interval(input$birthDate, input$observationDate), 'years')
  })
  
  heightCentile <- reactive({
    req(input$sex, age(), input$height, input$reference)
    sds(x = age(), y = input$height, sex = input$sex, measurement = 'height', refName = input$reference)
  })
  
  targetHeights <- reactive({
    req(input$sex, input$motherHeight, input$fatherHeight, input$reference)
    do.call(
      rbind,
      list(
        data.frame(targetHeight(input$sex, input$motherHeight, input$fatherHeight, refName = input$reference)),
        data.frame(targetHeight(input$sex, input$motherHeight, input$fatherHeight, method = 'Molinari', refName = input$reference)),
        data.frame(targetHeight(input$sex, input$motherHeight, input$fatherHeight, method = 'Hermanussen', refName = input$reference))
      )
    )
  })
  
  targetHeightDifference <- reactive({
    req(heightCentile(), targetHeights())
    heightCentile() - filter(targetHeights(), method == 'Hermanussen')$sds[1]
  })
  
  output$heightCentile <- renderUI({
    req(heightCentile())
    age <- nearestX(x = age(), sex = input$sex, measurement = 'height', refName = input$reference)
    tagList(
      tags$b(sprintf('%.2f SDS (p%.1f)', heightCentile(), pnorm(heightCentile()) * 100)),
      tags$small(sprintf('at age %.2f', age))
      )
  })
  
  output$targetHeightTable <- renderTable(targetHeights())
  
  output$targetHeightDifference <- renderText({
    req(targetHeightDifference())
    paste0('Difference to target height SDS (Hermanussen et al.) is: ', sprintf('%.2f', targetHeightDifference()))
  })
  
  output$targetHeightDifferenceResult <- renderText({
    req(targetHeightDifference())
    if (targetHeightDifference() <= -1) {
      'Current height is 1 SDS or more below target height! Please check for SGA.'
    } else {
      ''
    }
  })
  
  
  
  # SGA
  gestationalAge <- reactive({
    req(input$gestationalAge)
    floor(input$gestationalAge) + (input$gestationalAge %% 1 * 10) / 7
  })

  birthLengthCentile <- reactive({
    req(input$birthSex, gestationalAge(), input$birthLength)
    GrowthSDS:::evaluateCentiles(x = gestationalAge(), y = input$birthLength, ref = GrowthSDS::voigt@values$height[[input$birthSex]],
                                 centiles = c(.03, .1, .5, .9, .97), zscores = c(-2, 2))
  })
  
  birthWeightCentile <- reactive({
    req(input$birthSex, gestationalAge(), input$birthWeight)
    GrowthSDS:::evaluateCentiles(x = gestationalAge(), y = input$birthWeigth, ref = GrowthSDS::voigt@values$weight[[input$birthSex]],
                                 centiles = c(.03, .1, .5, .9, .97), zscores = c(-2, 2))
  })
  
  output$birthLengthPlot <- renderPlot({
    result <- birthLengthCentile()
    req(result)
    print(plotCentile(result, input$birthLength, 'Birth length [cm]'))
  })
  
  output$birthWeightPlot <- renderPlot({
    result <- birthWeightCentile()
    req(result)
    print(plotCentile(result, input$birthWeight, 'Birth weight [kg]'))
  })
  
  output$birthLengthEvaluation <- renderUI({
    req(birthLengthCentile())
    wellPanel(
      tags$h4('Birth length:', tags$b(sprintf('%.1f cm (%.2f SDS, p%.1f)', input$birthLength, birthLengthCentile()$zscore, pnorm(birthLengthCentile()$zscore) * 100))),
      uiOutput('birthLengthCentile'),
      plotOutput('birthLengthPlot', height = 70)
    )
  })
  
  output$birthWeightEvaluation <- renderUI({
    req(birthWeightCentile())
    wellPanel(
      tags$h4('Birth weight:', tags$b(sprintf('%.1f g (%.2f SDS, p%.1f)', input$birthWeight, birthWeightCentile()$zscore, pnorm(birthWeightCentile()$zscore) * 100))),
      uiOutput('birthWeightCentile'),
      plotOutput('birthWeightPlot', height = 70)
    )
  })
  
  
  # observers
  observeEvent(input$sex, {
    if (input$sex != input$birthSex) {
      updateSelectInput(
        session  = session,
        inputId  = 'birthSex',
        selected = input$sex
      )
    }
  })
  
  observeEvent(input$birthSex, {
    if (input$birthSex != input$sex) {
      updateSelectInput(
        session  = session,
        inputId  = 'sex',
        selected = input$birthSex
      )
    }
  })
})
