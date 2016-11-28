#------------------------------------------
#to run the app fro git hub I a adding the code in server file itself
#We just used four packages in financial market forecasting, our model is build from base r
#functions such as random numbers and arithematic operations 

#reading the data of symbols to reduce the loading time yahoo finance
SYMs <- TTR::stockSymbols()
#SYMs=data.frame(lapply(SYMs,function(x)ifelse(is.na(x),"others",x)),stringsAsFactors=FALSE)

#clearing the work space in every new installation
rm(list = ls())

#we also optimized the iterations in the simulated model to linear level of n, which reduced the computation 
#required to power of n
require(dplyr)
require(TTR)
require(reshape2)
require(plotly)

#This is the function where our final model is built on and the steps involved in our forecasting 
#are mentioned below, this function has three parameters stockURL,forecastDate,simulations,render,option target

#1. stockURL( stock url consists of the url to getdata from yahoo finance , this has stock option 
#symbol, from date for forecasting, to date to be considered)
#by default we are considering past one year data for predicting the future values

#2. forecastDate( this will be given by the user, this is the date for which he his aiming to 
#buy a call option, based on this we forecast the respective stock to check if the call option  
#is valuable or not)

#3.simulations (number of simulations required for computing each day's forecasts from random walk moedl
#by default we are using 1000 simulations)

#4.render is a toggle button for functions defaultStocks and callingRenderingStockForecast

#5.option target is the target price of the stock
stockForecast=function(stockURL,forecastDate,simulations=1000,render=FALSE,optionTarget)
{
  #concatenating the url string to a complete url and hitting yahoo finance to get the data
  URL <- paste("http://ichart.finance.yahoo.com/table.csv?s=",stockURL,sep ='')
  #code for debugging the code, printing the url
  print(URL)
  #reading the stock options from the yahoo 
  stock <- read.csv(URL)
  #converting stock date from yahoo finance into date format
  stock$Date <- as.Date(stock$Date, "%Y-%m-%d")
  #monte carlo simulations and modeling
  #taking one day lag values into another vector to compute the increase percentage of stock 
  laggedStockValue=stock$Close[2:nrow(stock)]
  #computing the increase percentage of stock from yesterday to today
  percentIncrease=stock$Close[1:(nrow(stock)-1)]/laggedStockValue
  #mean increase in the stock price from past one year
  meanIncrease=mean(percentIncrease)
  #standard deviation of the stock price from past one year
  stdIncrease=sd(percentIncrease)
  #number of time periods we need to do simulation, if no input is passed time periods will be 
  #for next one year, which is 265
  timePeriods=forecastDate-Sys.Date()
  #creating vector of 1000 simulations with present stock price
  currentStockValue=stock$Close[1]
  simulatedVal=rep(currentStockValue,simulations)
  #creating a data frame for the simulations
  simulatedDF=data.frame(simulatedVal)
  #iterating through random walk, with mean(meanIncrease) and standard deviation (stdIncrease)
  for(j in 1:timePeriods)
  {
    #creating new vector in every iteration based on the previous simulated values
    #using the same standard deviation and mean we computed from past one year data
    simulatedVal=simulatedVal*replicate(qnorm(runif(1),mean = meanIncrease,sd = stdIncrease),n =simulations)
    #concatenating the computed simulations to the existing data frame
    simulatedDF=cbind(simulatedDF,simulatedVal)
  }
  #creating a sequence of forecast dates for each day we are predicting
  forecastDateNames=seq(from=Sys.Date(),to=forecastDate,by = 1)
  #changing column names to the forecasting dates we computed in the above step
  colnames(simulatedDF)=forecastDateNames
  
  #getting the option target stock price
  
  
  #getting the option target , if the user gives it less than 0 we make the option target as
  #current price and we do normal forecasting for the stock
  optionTarget=as.numeric(optionTarget)
  optionTarget=ifelse(optionTarget<=0,stock$Close[1],optionTarget)
  
  #function to compute min max at every stage 
  #computing difference between the current stock price and forecasted price for every simulation
  #if the difference is negative we will return 0, saying we will not make any profit from call option
  #if the diiference is more than current value , we are returning it as the increase
  
  minmax=function(earnings)(
    ifelse((earnings-optionTarget)>0,earnings-optionTarget,0))
  #calling the above function on all the columns(number of time periods using lapply)
  simulatedDF=lapply(simulatedDF,minmax)
  #converting list output from lapply to a data frame
  simulatedDF=as.data.frame(simulatedDF)
  #returning the mean income at every point of time, these are our forecasts for the stocks at each point 
  #of time
  earnings=data.frame(colSums(simulatedDF)/nrow(simulatedDF))
  #we can do this using col means as well
  
  #changing the column name of earnings to earnings
  colnames(earnings)=c("earnings")
  #giving rownames as the date of forecasts
  rownames(earnings)=forecastDateNames
  #if the render is true we will return the comlete simulations of the forecasts which is simulatedDF,
  ##we further use this simulatedDF in a different function
  if(render==TRUE)
  {
    print("inside render plots")
    results=simulatedDF
    colnames(results)=forecastDateNames
  }
  else
  {
    #this is for the precomputed stocks , where we will only show the forecasts of the mean values
    results=earnings
  }
  #returning the results
  return(results)
}


#function to prepare url for the yahoo finance data
prepareForecast=function(forecastDate=(Sys.Date()+365),stockName="MSFT",render,optionTarget)
{
  #checking if the stock is available or not based on the user input, if the stock does not exists we will
  #return a alert message
  if(stockName%in%SYMs$Symbol)
  {
    #converting the forecast date into required format
    forecastDate=as.Date(forecastDate,"%m/%d/%Y")
    #string parsing to get forecast train data
    #financial stock options
    
    
    #reading past 1 year data, to date will be yesterday and from date will be one year before
    #computing day, month and year from the above mentioned dates
    toDay=format(Sys.Date()-1,"%d")
    toMonth=format(Sys.Date()-1,"%m")
    toYear=format(Sys.Date()-1,"%Y")
    fromDate=Sys.Date()-366
    fromDay=format(fromDate,"%d")
    fromMonth=format(fromDate,"%m")
    fromYear=format(fromDate,"%Y")
    #preparing the URL, concatenating the stock name from user, and date, month and year 
    #in the required format to hit the yahoo url
    stockURLParam=paste(stockName,"&a=",fromMonth,"&b=",fromDay,"&c=",fromYear,
                        "&d=",toMonth,"&e=",toDay,"&f=",toYear,"&g=d",sep = "")
    #debugging
    print(stockURLParam)
    #calling the model with parameters stockURLParam and forecast date
    stockPredictions=stockForecast(stockURLParam,forecastDate = forecastDate,render=render,optionTarget =optionTarget)
    #returning the predictions to the calling function
    return(stockPredictions)
  }
  else{
    #message if stock does not exist
    return( print(paste("No stock registered on the name of",stockName)))
  }
}


#function to compute the forecasts for top 10 stocks
#these 10 stocks we will show in the UI as the landing page in shiny application
defaultStocks=function()
{
  #stocks to be shown on the landing page
  stocks=list("MSFT","AAPL","GOOGL","IBM","TCS","XOM","HPQ","FB","BAC","JPM")
  #using render as false as this function needs only one mean of the stock predictions
  defaultPredictions=data.frame(
    lapply(stocks, function(stocks)prepareForecast(stockName=stocks,render =FALSE,optionTarget = 0 )))
  #converting colnames of the retrieved data frames to respective stock names
  colnames(defaultPredictions)=stocks
  #creating a new column with dates
  defaultPredictions$Date=rownames(defaultPredictions)
  #grouping the predicitons by month and year, to do that computing the month and year from the
  #forecast date
  defaultPredictions=defaultPredictions%>%
    mutate(Month=format(as.Date(Date),"%m"),
           Year=format(as.Date(Date),"%Y"))
  #summarizing with mean monthly stock predictions and sorting it accordingly
  defaultPLot=defaultPredictions%>%dplyr::group_by(Year,Month)%>%
    dplyr::summarise(MSFT=mean(MSFT),AAPL=mean(AAPL),GOOGL=mean(GOOGL),IBM=mean( IBM),
                     TCS=mean(TCS),XOM=mean(XOM),HPQ=mean(HPQ),
                     FB=mean(FB),BAC=mean(BAC),JPM=mean(JPM))%>%
    mutate(time=paste(Year,"/",Month))%>%dplyr::arrange(time)
  
  #computing and saving the plot to show in landing page of the shiny application
  firstTimeLandingPlot= plot_ly(data=defaultPredictions,x=~Date,y=~MSFT,name = 'MICROSOFT', type = 'scatter', mode = 'lines')%>%
    add_trace(y = ~AAPL, name = 'AAPLE', mode = 'lines+markers') %>%
    add_trace(y = ~GOOGL, name = 'GOOGLE', mode = 'lines+markers')%>%
    add_trace(y = ~IBM, name = 'IBM', mode = 'lines+markers')%>%
    add_trace(y = ~TCS, name = 'TCS', mode = 'lines+markers')%>%
    add_trace(y = ~XOM, name = 'Exxon Mobil Corp', mode = 'lines+markers')%>%
    add_trace(y = ~HPQ, name = 'HPQ', mode = 'lines+markers')%>%
    add_trace(y = ~FB, name = 'Facebook', mode = 'lines+markers')%>%
    add_trace(y = ~BAC, name = 'Bank of America', mode = 'lines+markers')%>%
    add_trace(y = ~JPM, name = 'CHASE', mode = 'lines+markers')%>%
    layout(xaxis =list(title=" "),
           yaxis =list(title=" "),
           title="Few Stock Performances in the Next One Year")
  #returnning the plot to the UI
  return(firstTimeLandingPlot)
}


#function to render in the UI , shiny application
#function which we call from shiny application based on the user input
#function flow will be as follows callingRenderingStockForecast--> prepareForecast--> stockForecast
#with render as true this function will provide the entire matrix of simulations to shiny
callingRenderingStockForecast=function(stockName="Microsoft Corporation",forecastDate="11/26/2017",render=TRUE,optionTarget=0)
{
  #if the stock has more than one stock , we are taking the first one alone
  symbol=SYMs$Symbol[SYMs$Name==stockName][[1]][1]
  #calling the prepare forecasts function with user values
  forecasts=prepareForecast(stockName =symbol,forecastDate = forecastDate,render = render,optionTarget =optionTarget)
  #returning the complete simulated matrix to the shiny app
  return(forecasts)
}



#----------------------------------------------------------
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

