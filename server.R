library(dplyr)
library(childsds)

shinyServer(function(input, output) {
  heightCentile <- reactive({
    req(input$sex, input$age, input$height)
    sds  <- sds(input$height, input$age, input$sex, 'height', kro.ref)
    
    if (sds == Inf | sds == -Inf) sds  <- NA
    
    sds
  })
  
  targetHeights <- reactive({
    req(input$sex, input$motherHeight, input$fatherHeight, input$reference)
    do.call(
      rbind,
      list(
        Tanner      = data.frame(targetHeight(input$sex, input$motherHeight, input$fatherHeight, 'Tanner', input$reference)),
        Molinari    = data.frame(targetHeight(input$sex, input$motherHeight, input$fatherHeight, 'Molinari', input$reference)),
        Hermanussen = data.frame(targetHeight(input$sex, input$motherHeight, input$fatherHeight, 'Hermanussen', input$reference))
      )
    )
  })
  
  output$heightCentile <- renderUI({
    tags$b(sprintf('%.2f SDS (p%.1f)', heightCentile(), pnorm(heightCentile()) * 100))
  })
  
  output$targetHeightTable <- renderTable(targetHeights(), rownames = TRUE)
  
  output$hghTreatmentEvaluation <- renderUI({
    req(heightCentile(), targetHeights())
    difference <- heightCentile() - targetHeights()['Hermanussen',]$sds[1]
    tagList(
      'Difference to target height SDS (Hermanussen et al.) is: ', sprintf('%.2f', difference)
    )
  })
})
