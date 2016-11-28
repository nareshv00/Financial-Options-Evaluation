# Financial-Options-Evaluation

Individual investors have more investment options than they often realize. Options like” stock options” allow us to make money if the stock market is going up and it also causes loss if the stock market is going down. As the name suggests, options give you the option to buy or sell a security (stocks, extra-traded funds, indices, commodities etc.) at some point in the future. Our team has decided to forecast the stock market for the investors (our users) to make a wise decision. It is said that regardless of any technique, accurately forecasting stock market performance is more a matter of luck than technique. However,  we have decided to forecast the stock price using “Random walk” forecasting model to build the web application, we selected this model as the winning forecast model out of different models we built and validated.

Call Options: It provide the holder the right to purchase an underlying asset at a specified price for a certain period of time. If the stock fails to meet the strike price before the expiration date, the option expires and becomes worthless. Investors buy calls when they think the share price of the underlying security will rise or sell a call if they think it will fall. Selling an option is also referred to as ''writing'' an option.

Put options: It give the holder the right to sell an underlying asset at a specified price (the strike price). The seller (or writer) of the put option is obligated to buy the stock at the strike price. Put options can be exercised at any time before the option expires. Investors buy puts if they think the share price of the underlying stock will fall, or sell one if they think it will rise.

Random walk is a stock market theory that states that the past movement or direction of the price of a stock or overall market cannot be used to predict its future movement. Originally examined by Maurice Kendall in 1953, the theory states that stock price fluctuations are independent of each other and have the same probability distribution, but that over a period of time, prices maintain an upward trend. In short, random walk says that stocks take a random and unpredictable path. The chance of a stock's future price going up is the same as it going down. A follower of random walk believes it is impossible to outperform the market without assuming additional risk.

##Using the Stock Option valuation Application ########################

###Put the below Rcode in r command line or R Studio to use this application ( You can also download and make changes to use your own options )

```r
runGitHub("Financial-Options-Evaluation", "nareshv00")
```

###Types of Option
Call Option :  It provides the holder the right to purchase a stock at a specific price(strike price), for a certain period.
Eg :Shares of Nike are selling for $130 on July 18, 2018 (recall the stock is at $117 today, 10/28/2016), and it will cost us $12 to buy an option today. 

If on July 18, 2018, the price is $150, we would have $20-12=$8 of profit

If on July 18, 2018, the price is $125, the option has zero value

Puts are the opposite of Calls. If you buy a Put, it gives you the right to sell at a particular price.

The ultimate goal of buying shares is to make money by buying stocks in companies you expect to do well.
Our UI Application trying to predict which stock will rise or fall 

Eg – To buy an call option for Bank of America on 19, Jan 2018:
 First we check the strike price, call option on Yahoo Finance website

![alt tag](https://cloud.githubusercontent.com/assets/19517513/20690351/1ae3d14a-b598-11e6-978d-4686bf12c7f5.PNG)

Inputting the selected option values into the application( Input the information fetched from Yahoo to UI application in the below way)

![alt tag](https://cloud.githubusercontent.com/assets/19517513/20690616/ac62f0fa-b599-11e6-8486-1d774dc38f65.PNG)

Results shows that there are chances of making six times profit on the call option we have invested in Banking sector

![alt tag](https://cloud.githubusercontent.com/assets/19517513/20690352/1aeda2f6-b598-11e6-9cd4-b15591dd61a4.PNG)



####Application and Functionality

1 Landing Page And Menu 1 In The Application
  
  1.1 Landing page has forecasts for 10 different stocks which are manually fed into the code, you can input the stocks you want by downloading and changing the code, these forecasts gives the price difference compared to current price to the forecasted price from today to the next one year.
  
  1.2 You can select the stock name in enter manually drop down and switch to selection tab and feed Option value, Option target and click on submit button.
  
  1.3 the forecasts obtained will be from today to the next one year increase or decrease in the stock price( change in stock price), by default  using 1 year date for forecast date, and when you give 0 in option price we will use current price as the option target. This will give increase stock price fro current price.
  
  1.4 The price increase graph shows the change in the stock price from the option target price, this determines if it is wise to invest in the call option or not.
  
  1.5 second density graph shows the distribution of number of times you will make profit on the forecasted date,, when you mouse iver on this plot you can also observe the ratio of profit to call option value you are investing.
  
  1.6 The other ui element is data table consisting of the forecasted increase from the option target price from today until the given forecasted date. You can search for the particular date get the mean earnings to the option target. 
  

![alt tag](https://cloud.githubusercontent.com/assets/19517513/20689286/a379a97c-b592-11e6-8032-5d8b485082f8.png)


2 Landing Page And Menu 2 In The Application, You can use the filtering options as well by selecting the selection menu tab.

![alt tag](https://cloud.githubusercontent.com/assets/19517513/20689288/a3811144-b592-11e6-907f-502e7df1b2cc.png)


3 Interpreting the Options And Using The Application

![alt tag](https://cloud.githubusercontent.com/assets/19517513/20689285/a3716564-b592-11e6-91f9-016f27e71dc1.png)





