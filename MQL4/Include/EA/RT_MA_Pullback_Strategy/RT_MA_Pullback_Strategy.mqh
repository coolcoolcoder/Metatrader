//+------------------------------------------------------------------+
//|                                      RT_MA_Pullback_Strategy.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict
#include <Signals\HighLowExits.mqh>
#include <Signals\MovingAverageTrailingStop.mqh>
#include <Signals\MovingAverage.mqh>
#include <Signals\MovingAverageThreshold.mqh>
#include <Signals\MovingAveragePullback.mqh>
#include <Signals\MovingAverageTouchTest.mqh>
#include <EA\PortfolioManagerBasedBot\BasePortfolioManagerBot.mqh>
#include <EA\RT_MA_Pullback_Strategy\RT_MA_Pullback_StrategyConfig.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class RT_MA_Pullback_Strategy : public BasePortfolioManagerBot
  {
public:
   void              RT_MA_Pullback_Strategy(RT_MA_Pullback_StrategyConfig &config);
   void             ~RT_MA_Pullback_Strategy();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RT_MA_Pullback_Strategy::RT_MA_Pullback_Strategy(RT_MA_Pullback_StrategyConfig &config):BasePortfolioManagerBot(config)
  {
   if(config.followTrend)
     {
      this.signalSet.ExitSignal=new MovingAverageTrailingStop(
                                                              // Setting SL by pullback MA value.
                                                              config.followTrendTrailingStopPeriod,
                                                              config.timeframe,
                                                              MODE_SMA,
                                                              PRICE_OPEN,
                                                              0,
                                                              0,
                                                              config.minimumTpSlDistance,
                                                              config.initializeTrailingStopTo1Atr);
     }
   else
     {
      this.signalSet.ExitSignal=new HighLowExits(
                                                 // Setting SL / TP by recent High and Low
                                                 config.exitsByHighLowPeriod,
                                                 config.timeframe,
                                                 1,
                                                 config.minimumTpSlDistance,
                                                 config.exitSignalColor);
     }

   this.signalSet.Add(
                      // The main signal MA : sets the directional bias.
                      new MovingAverage(
                      config.maPeriod,
                      config.timeframe,
                      MODE_SMA,
                      PRICE_OPEN,
                      0,
                      0,
                      config.minimumTpSlDistance,
                      config.maColor
                      ));

   this.signalSet.Add(
                      // The "Area of Value" MA : triggers an order when price bounces out
                      // of the area of value and heads in the direction of the main signal.
                      new MovingAverageThreshold(
                      config.maThresholdPeriod,
                      config.timeframe,
                      MODE_SMA,
                      PRICE_OPEN,
                      0,
                      0,
                      config.minimumTpSlDistance,
                      config.maThresholdColor
                      ));

   MovingAveragePullback *touchSubsignal=new MovingAveragePullback(
                                                                   config.maPullbackPeriod,
                                                                   config.timeframe,
                                                                   MODE_SMA,
                                                                   PRICE_OPEN,
                                                                   0,
                                                                   0,
                                                                   config.minimumTpSlDistance,
                                                                   config.maPullbackColor);

   this.signalSet.Add(
                      // The "Area of Value" MA : triggers an order when price bounces out
                      // of the area of value and heads in the direction of the main signal.
                      new MovingAverageTouchTest(
                      config.maPullbackPeriod,
                      config.timeframe,
                      MODE_SMA,
                      PRICE_OPEN,
                      0,
                      touchSubsignal,
                      0,
                      config.minimumTpSlDistance,
                      config.maPullbackColor,
                      config.maPullbackTests
                      ));

   this.Initialize();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RT_MA_Pullback_Strategy::~RT_MA_Pullback_Strategy()
  {
   delete this.signalSet.ExitSignal;
  }
//+------------------------------------------------------------------+
