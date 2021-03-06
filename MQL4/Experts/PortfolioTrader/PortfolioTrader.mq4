//+------------------------------------------------------------------+
//|                                              PortfolioTrader.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property description "Does Magic."
#property strict

#include <EA\PortfolioTrader\PortfolioTrader.mqh>
#include <EA\PortfolioTrader\PortfolioTraderSettings.mqh>
#include <EA\PortfolioTrader\PortfolioTraderConfig.mqh>

PortfolioTrader *bot;
#include <EA\PortfolioManagerBasedBot\BasicEATemplate.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   PortfolioTraderConfig config;
   
   GetBasicConfigs(config);
   
   config.extremeBreakTimeframe=PortfolioTimeframe;
   config.extremeBreakPeriod=ExtremeBreakPeriod;
   config.extremeBreakShift=ExtremeBreakShift;
   config.extremeBreakColor=ExtremeBreakColor;
   config.atrMinimumTpSlDistance=AtrMinimumTpSlDistance;
   
   config.atrPeriod=AtrPeriod;
   config.atrSkew=AtrSkew;
   config.atrMultiplier=AtrMultiplier;
   config.atrColor=AtrColor;
   config.parallelSignals=ParallelSignals;

   bot=new PortfolioTrader(config);
  }
//+------------------------------------------------------------------+
