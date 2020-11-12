library(dplyr)
library(GrowthSDS)

shinyServer(function(input, output) {
  heightCentile <- reactive({
    req(input$sex, input$age, input$height, input$reference)
    sds(x = input$age, y = input$height, sex = input$sex, measurement = 'height', refName = input$reference)
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
  
  output$ageSlider <- renderUI({
    req(input$reference)
    ref <- get(data(list = input$reference, package = 'GrowthSDS'))
    ranges <- xRanges(ref)$height
    min <- min(data.frame(ranges)[,1])
    max <- max(data.frame(ranges)[,2])
    sliderInput('age', 'Age', min = signif(min, 1), max = signif(max, 1), value = 10, step = .1)
  })
  
  output$heightCentile <- renderUI({
    req(heightCentile())
    age <- nearestX(x = input$age, sex = input$sex, measurement = 'height', refName = input$reference)
    tagList(
      tags$b(sprintf('%.2f SDS (p%.1f)', heightCentile(), pnorm(heightCentile()) * 100)),
      tags$small(sprintf('at age %.2f', age))
      )
  })
  
  output$targetHeightTable <- renderTable(targetHeights())
  
  output$hghTreatmentEvaluation <- renderUI({
    req(heightCentile(), targetHeights())
    difference <- heightCentile() - filter(targetHeights(), method == 'Hermanussen')$sds[1]
    tagList(
      'Difference to target height SDS (Hermanussen et al.) is: ', sprintf('%.2f', difference)
    )
  })
})
