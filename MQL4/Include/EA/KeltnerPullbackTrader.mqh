//+------------------------------------------------------------------+
//|                                        KeltnerPullbackTrader.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <PLManager\PLManager.mqh>
#include <Schedule\ScheduleSet.mqh>
#include <Signals\SignalSet.mqh>
#include <Signals\AtrRange.mqh>
#include <Signals\MovingAverage.mqh>
#include <PortfolioManager\PortfolioManager.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class KeltnerPullbackTrader
  {
private:
   PortfolioManager *portfolioManager;
   SymbolSet        *ss;
   ScheduleSet      *sched;
   OrderManager     *om;
   PLManager        *plman;
   SignalSet        *signalSet;

public:
   void              KeltnerPullbackTrader(
                                           string watchedSymbols,
                                           int keltnerPullbackMaPeriod,int keltnerPullbackMaShift,
                                           ENUM_MA_METHOD keltnerPullbackMaMethod,
                                           ENUM_APPLIED_PRICE keltnerPullbackMaAppliedPrice,
                                           int keltnerPullbackMaColor,
                                           int keltnerPullbackAtrPeriod,int keltnerPullbackAtrMultiplier,
                                           int keltnerPullbackShift,int keltnerPullbackAtrColor,
                                           int keltnerPullbackMinimumTpSlDistance,ENUM_TIMEFRAMES keltnerPullbackTimeframe,
                                           int parallelSignals,double lots,double profitTarget,
                                           double maxLoss,int slippage,ENUM_DAY_OF_WEEK startDay,
                                           ENUM_DAY_OF_WEEK endDay,string startTime,string endTime,
                                           bool scheduleIsDaily,bool tradeAtBarOpenOnly);
   void             ~KeltnerPullbackTrader();
   void              Execute();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void KeltnerPullbackTrader::KeltnerPullbackTrader(
                                                  string watchedSymbols,
                                                  int keltnerPullbackMaPeriod,int keltnerPullbackMaShift,
                                                  ENUM_MA_METHOD keltnerPullbackMaMethod,
                                                  ENUM_APPLIED_PRICE keltnerPullbackMaAppliedPrice,
                                                  int keltnerPullbackMaColor,
                                                  int keltnerPullbackAtrPeriod,int keltnerPullbackAtrMultiplier,
                                                  int keltnerPullbackShift,int keltnerPullbackAtrColor,
                                                  int keltnerPullbackMinimumTpSlDistance,ENUM_TIMEFRAMES keltnerPullbackTimeframe,
                                                  int parallelSignals,double lots,double profitTarget,
                                                  double maxLoss,int slippage,ENUM_DAY_OF_WEEK startDay,
                                                  ENUM_DAY_OF_WEEK endDay,string startTime,string endTime,
                                                  bool scheduleIsDaily,bool tradeAtBarOpenOnly)
  {
   string symbols=watchedSymbols;
   this.ss=new SymbolSet();
   this.ss.AddSymbolsFromCsv(symbols);

   this.sched=new ScheduleSet();
   if(scheduleIsDaily==true)
     {
      this.sched.AddWeek(startTime,endTime,startDay,endDay);
     }
   else
     {
      this.sched.Add(new Schedule(startDay,startTime,endDay,endTime));
     }

   this.om=new OrderManager();
   this.om.Slippage=slippage;

   this.plman=new PLManager(ss,om);
   this.plman.ProfitTarget=profitTarget;
   this.plman.MaxLoss=maxLoss;
   this.plman.MinAge=60;

   this.signalSet=new SignalSet();
   int i;
   for(i=0;i<parallelSignals;i++)
     {
      this.signalSet.Add(
                         new AtrRange(
                         keltnerPullbackAtrPeriod,
                         keltnerPullbackAtrMultiplier,
                         keltnerPullbackTimeframe,
                         keltnerPullbackShift+(keltnerPullbackMaPeriod*i),
                         keltnerPullbackMinimumTpSlDistance,
                         keltnerPullbackAtrColor));
      this.signalSet.Add(
                         new MovingAverage(
                         keltnerPullbackMaPeriod,
                         keltnerPullbackTimeframe,
                         keltnerPullbackMaMethod,
                         keltnerPullbackMaAppliedPrice,
                         keltnerPullbackMaShift,
                         keltnerPullbackShift+(keltnerPullbackMaPeriod*i),
                         keltnerPullbackMaColor));
     }

   this.portfolioManager=new PortfolioManager(lots,this.ss,this.sched,this.om,this.plman,this.signalSet);
   this.portfolioManager.tradeEveryTick=!tradeAtBarOpenOnly;
   this.portfolioManager.Initialize();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void KeltnerPullbackTrader::~KeltnerPullbackTrader()
  {
   delete portfolioManager;
   delete ss;
   delete sched;
   delete om;
   delete plman;
   delete signalSet;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void KeltnerPullbackTrader::Execute()
  {
   this.portfolioManager.Execute();
  }
//+------------------------------------------------------------------+
