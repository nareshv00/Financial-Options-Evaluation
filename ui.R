#shiny application
#loading the library for this
library(shiny)
library(shinydashboard)
library(shinyjs)
library(plotly)
#reading the data of symbols to reduce the loading time yahoo finance
SYMs <- read.csv("../Financial-Options-Evaluation-master/SYMs.csv",stringsAsFactors =FALSE)
SYMs=data.frame(lapply(SYMs,function(x)ifelse(is.na(x),"others",x)),stringsAsFactors=FALSE)

#replacing all the NA's with others in the data

#reading the all ticker symbols(stock option names and valuations from the yahoo finance)
SYMs <- TTR::stockSymbols()
SYMs=data.frame(lapply(SYMs,function(x)ifelse(is.na(x),"others",x)),stringsAsFactors=FALSE)


#call option drop down values,assuming call options will be less than 100$
callOptions=seq(from=0.1,to=100,by =.01)

#Ui Design
#UI(user interface rendering off all the objects from the server)
ui=dashboardPage(
  dashboardHeader(title = "Financial Options Valuation"),
  dashboardSidebar(disable = T),
  dashboardBody(
  fluidPage(sidebarLayout(fluid = TRUE,
  #rendering the plotly output of the default and precomputed stocks
  mainPanel(plotlyOutput("defaultStocks")),
  #ui calender input
  sidebarPanel(tabsetPanel( tabPanel("Enter Manually",
                                       uiOutput("Stock1"),br(),br(),
                                       "** Please select the stock and click on selection tab to submit"),
    tabPanel("Selection",fluidRow(column(6,dateInput('date',label = 'Forecast Date', 
                                                     value = Sys.Date()+365,start=Sys.Date()+1)),
         column(6,selectInput('ExchangeValue', 'Exchange', c(unique(SYMs$Exchange))))),
         #writing the ui elements
         fluidRow(column(6,uiOutput('Sector')),
         column(6,uiOutput("Industry"))),
         uiOutput("Stock"),
         fluidRow(column(4,selectInput("predictedIncrease","Option Value",callOptions,selectize = TRUE,multiple = FALSE)),
                  column(5,  numericInput("num",label = "Option Target",min = 0,
                                          value =1)),br(),
        column(3,actionButton("button", "Submit"))))))),br(),br(),       
 
   sidebarLayout(fluid = TRUE, 
    mainPanel(plotlyOutput("densityPlot")),
    sidebarPanel(h2("Forecasts:"),dataTableOutput("table")))
)))

