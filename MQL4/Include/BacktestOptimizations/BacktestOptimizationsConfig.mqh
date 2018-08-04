//+------------------------------------------------------------------+
//|                                  BacktestOptimizationsConfig.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Common\Config.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct BacktestOptimizationsConfig : public Config
  {
public:
   double            InitialScore;
   double            GainsStdDevLimitMax,GainsStdDevLimitMin;
   double            LossesStdDevLimitMax,LossesStdDevLimitMin;
   double            NetProfitRangeMax,NetProfitRangeMin;
   double            ExpectancyRangeMax,ExpectancyRangeMin;
   int               TradesPlacedRangeMax,TradesPlacedRangeMin;
   double            TradesPerDayRangeMax,TradesPerDayRangeMin;
   double            LargestLossPerTotalGainLimit;
   double            MedianLossPerMedianGainPercentLimit;
   int               FactorBy_GainsSlopeUpward_Granularity;
   void BacktestOptimizationsConfig():InitialScore(100)
                                       ,GainsStdDevLimitMin(0),GainsStdDevLimitMax(0)
                                       ,LossesStdDevLimitMax(0),LossesStdDevLimitMin(0)
                                       ,NetProfitRangeMax(0),NetProfitRangeMin(0)
                                       ,ExpectancyRangeMax(0),ExpectancyRangeMin(0)
                                       ,TradesPlacedRangeMax(0),TradesPlacedRangeMin(0)
                                       ,TradesPerDayRangeMax(0),TradesPerDayRangeMin(0)
                                       ,LargestLossPerTotalGainLimit(0)
                                       ,MedianLossPerMedianGainPercentLimit(0)
                                       ,FactorBy_GainsSlopeUpward_Granularity(0)
     {
     }
  };
//+------------------------------------------------------------------+
