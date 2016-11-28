#server design

#calling defaults stocks plot
defaultStocksPlot=defaultStocks()

server=function(input, output){
  output$Sector = renderUI({
    selectInput('Sector', 'Sector',unique(SYMs$Sector[SYMs$Exchange==input$ExchangeValue]))
  })
  output$Industry = renderUI({
    selectInput('Industry', 'Industry Name',unique(SYMs$Industry[SYMs$Sector==input$Sector]))
  })
  output$Stock   <- renderUI({ selectInput( "Stock",'stock name', 
                                            unique(SYMs$Name[SYMs$Industry==input$Industry]))})
  output$Stock1   <- renderUI({times <- input$button 
  div(id=letters[(times %% length(letters)) + 1],
 selectInput( "Stock1",'stock name',unique(SYMs$Name)))})
  
  #replacing the default plots fro forecasted plots
  observe({
    if (input$button == 0) 
    {
      output$defaultStocks=renderPlotly(defaultStocksPlot)
    }})
  
  # Take an action every time button is pressed;
  # here, we just print a message to the console
  observeEvent(input$button, {
    cat("Showing", input$Stock)
    output$defaultStocks=renderPlotly(plot_ly(combined_final_rename(),x=~DateOfForecast,
                                              y=~forecastedIncrease,name=input$Stock,
                                              type="scatter",mode="lines",colors=c("green"))%>%
                                        layout(title=paste("Earnings-",ifelse(input$Stock1=="Altisource Asset Management Corp",input$Stock,input$Stock1)),
                                               xaxis=list(title=""),yaxis=list(title="price increase")))
    })
  
  # Take a reactive dependency on input$button
  forecastObjects=eventReactive(input$button,{
    callingRenderingStockForecast(stockName =ifelse(input$Stock1=="Altisource Asset Management Corp",input$Stock,input$Stock1),
                                  forecastDate =input$date,
                                  optionTarget = input$num)
  })
  
  
  
  #data set computing the mean forecasted sum of all the days
  combined_final_rename<-reactive({
    forecastData <-     data.frame(colnames(forecastObjects()),
                                   colMeans(forecastObjects()))
    colnames(forecastData) = c("DateOfForecast", "forecastedIncrease")
    forecastData
  })
  output$table <- renderDataTable({combined_final_rename()},options = list(lengthMenu = c(5,10,50), pageLength = 5))
  
  #list of data containing the forecast for the targeted date
  combined_final_DayForecast<-reactive({
    forecastData <-density(forecastObjects()[,ncol(forecastObjects())])
    
  })

  #density of predictions on final day
 output$densityPlot=renderPlotly(plot_ly(x=~combined_final_DayForecast()$x,
                                         y=~combined_final_DayForecast()$y,
                                        type="scatter",mode="lines",fill="tozeroy",
    name=input$Stock,text=~paste("ratio of profit to call option is: ",
 round(mean(forecastObjects()[,ncol(forecastObjects())])/as.numeric(input$predictedIncrease),2)))%>%
   layout(title=paste("distribution of Earnings on-",input$date),
 xaxis=list(title=input$date),yaxis=list(title="distribution of earnings")))
 
 
 # Take a reactive dependency on input$button

}

