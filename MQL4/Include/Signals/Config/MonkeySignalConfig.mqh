//+------------------------------------------------------------------+
//|                                           MonkeySignalConfig.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Signals\Config\RsiBandsConfig.mqh>
#include <Signals\Config\AbstractSignalConfig.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct MonkeySignalConfig : public AbstractSignalConfig
  {
public:
   double            TriggerLevel;
   double            AtrExitsMultiplier;
   int               RsiPeriod;
   RsiBandsConfig    RsiBands;

   void MonkeySignalConfig()
     {
      this.TriggerLevel=2;
      this.AtrExitsMultiplier=0.5;
      this.RsiPeriod=14;
     };
  };
//+------------------------------------------------------------------+
