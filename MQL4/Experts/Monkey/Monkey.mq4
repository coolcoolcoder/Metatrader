//+------------------------------------------------------------------+
//|                                                       Monkey.mq4 |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property description "Current Experiment."
#property strict

#include <EA\Monkey\Monkey.mqh>
#include <EA\Monkey\MonkeySettings.mqh>
#include <EA\Monkey\MonkeyConfig.mqh>

Monkey *bot;
#include <EA\PortfolioManagerBasedBot\BasicEATemplate.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   MonkeyConfig config;

   GetBasicConfigs(config);
   
   config.monkeySignal.Period=BotPeriod;
   config.monkeySignal.Timeframe=PortfolioTimeframe;
   config.monkeySignal.MinimumTpSlDistance=BotMinimumTpSlDistance;
   config.monkeySignal.IndicatorColor=BotIndicatorColor;
   config.monkeySignal.TriggerLevel=BotTriggerLevel;
   config.monkeySignal.AtrExitsMultiplier=BotAtrExitsMultiplier;
   config.monkeySignal.RsiPeriod=BotRsiPeriod;
   config.monkeySignal.RsiBands.Wideband.High=BotRsiWidebandHigh;
   config.monkeySignal.RsiBands.Wideband.Low=BotRsiWidebandLow;
   config.monkeySignal.RsiBands.Midband.High=BotRsiMidbandHigh;
   config.monkeySignal.RsiBands.Midband.Low=BotRsiMidbandLow;
   config.monkeySignal.RsiBands.Nullband.High=BotRsiNullbandHigh;
   config.monkeySignal.RsiBands.Nullband.Low=BotRsiNullbandLow;
   
   bot=new Monkey(config);
  }
//+------------------------------------------------------------------+
