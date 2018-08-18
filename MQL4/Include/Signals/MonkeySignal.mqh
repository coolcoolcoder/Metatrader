//+------------------------------------------------------------------+
//|                                                 MonkeySignal.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Signals\MonkeySignalBase.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MonkeySignal : public MonkeySignalBase
  {
private:
   datetime          _lastTrigger;
   double            _triggerLevel;
   int               _rsiPeriod;
   RsiBandsConfig    _rsiBands;
public:
                     MonkeySignal(MonkeySignalConfig &config,AbstractSignal *aSubSignal=NULL);
   SignalResult     *Analyzer(string symbol,int shift);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MonkeySignal::MonkeySignal(MonkeySignalConfig &config,AbstractSignal *aSubSignal=NULL):MonkeySignalBase(config,aSubSignal)
  {
   this._lastTrigger=TimeCurrent();
   this._triggerLevel=config.TriggerLevel;
   this._rsiPeriod=config.RsiPeriod;
   this._rsiBands=config.RsiBands;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SignalResult *MonkeySignal::Analyzer(string symbol,int shift)
  {
   MqlTick tick;
   bool gotTick=SymbolInfoTick(symbol,tick);
   CandleMetrics *candle=this.GetCandleMetrics(symbol,shift);
   if(candle.IsSet && 0<OrderManager::PairOpenPositionCount(symbol))
     {
      this._lastTrigger=candle.Time;
     }

   if(gotTick && candle.IsSet && candle.Time!=this._lastTrigger)
     {
      double atr=this.GetAtr(symbol,shift)*this._triggerLevel;
      PriceRange trigger;
      trigger.high=candle.Open+atr;
      trigger.low=candle.Open-atr;

      this.DrawIndicatorRectangle(symbol,shift,trigger.high,trigger.low,NULL,1);

      double rsi=this.GetRsi(symbol,shift,this._rsiPeriod,PRICE_CLOSE);

      bool sellSignal=(candle.High>=(trigger.high)) && (this._compare.IsBetween(rsi,this._rsiBands.Wideband.Low,50.0));
      sellSignal=sellSignal || ((candle.Low<=(trigger.low)) && (this._compare.IsBetween(rsi,this._rsiBands.Wideband.High,100.0)));

      bool buySignal=(candle.Low<=(trigger.low)) && (this._compare.IsBetween(rsi,50.0,this._rsiBands.Wideband.High));
      buySignal=buySignal || ((candle.High>=(trigger.high)) && (this._compare.IsBetween(rsi,0.0,this._rsiBands.Wideband.Low)));

      bool setTp=this._compare.IsBetween(rsi,this._rsiBands.Midband.Low,this._rsiBands.Midband.High);

      if(_compare.Xor(sellSignal,buySignal) && !this._compare.IsBetween(rsi,this._rsiBands.Nullband.Low,this._rsiBands.Nullband.High))
        {
         if(sellSignal)
           {
            this.SetSellSignal(symbol,shift,tick,setTp);
           }

         if(buySignal)
           {
            this.SetBuySignal(symbol,shift,tick,setTp);
           }

         // signal confirmation
         if(!this.DoesSubsignalConfirm(symbol,shift))
           {
            this.Signal.Reset();
           }
         else
           {
            this._lastTrigger=candle.Time;
           }
        }
      else
        {
         this.Signal.Reset();
        }

     }

// if there is an order open...
   if(1<=OrderManager::PairOpenPositionCount(symbol,TimeCurrent()))
     {
      this.SetExits(symbol,shift,tick);
     }

   delete candle;
   return this.Signal;
  }
//+------------------------------------------------------------------+
