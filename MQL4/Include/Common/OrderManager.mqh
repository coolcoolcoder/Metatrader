//+------------------------------------------------------------------+
//|                                                 OrderManager.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <stdlib.mqh>
#include <Generic\ArrayList.mqh>
#include <Common\ValidationResult.mqh>
#include <Common\SimpleParsers.mqh>
#include <Common\BaseLogger.mqh>
#include <Common\Comparators.mqh>
#include <Signals\SignalResult.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderManager
  {
private:
   SimpleParsers     simpleParsers;
public:
   int               Slippage;
   BaseLogger        Logger;
   void              OrderManager();
   bool              OrderManager::Validate();
   bool              OrderManager::Validate(ValidationResult *validationResult);
   bool              CanTrade();
   bool              CanTrade(string symbol,datetime time);
   bool              ValidateStopLevels(string symbol,ENUM_ORDER_TYPE orderType,double orderPrice,double stopLoss,double takeProfit);
   int               SendOrder(SignalResult *s,double lotSize);
   bool              ModifyOrder(int ticket,double orderPrice,double stopLoss,double takeProfit,datetime expiration);
   void              CloseOrders(string symbol,datetime minimumAge);
   double            PairOpenPositionCount(string symbol,datetime minimumAge);
   double            PairProfit(string symbol);
   double            CalculateEffectiveLeverage(string symbol,ENUM_ORDER_TYPE orderType);
   void              NormalizeExits(string symbol,ENUM_ORDER_TYPE orderType,double stopLoss,double takeProfit);
   double            PairHighestStopLoss(string symbol,ENUM_ORDER_TYPE orderType);
   double            PairLowestStopLoss(string symbol,ENUM_ORDER_TYPE orderType);
   double            PairAveragePriceWithAdditonalOrder(string symbol,ENUM_ORDER_TYPE orderType,double size);
   double            PairAveragePrice(string symbol,ENUM_ORDER_TYPE orderType);
   double            PairLowestPricePaid(string symbol,ENUM_ORDER_TYPE orderType);
   double            PairHighestPricePaid(string symbol,ENUM_ORDER_TYPE orderType);
   double            PairLowestTakeProfit(string symbol,ENUM_ORDER_TYPE orderType);
   double            PairHighestTakeProfit(string symbol,ENUM_ORDER_TYPE orderType);
   double            PairLotsTotal(string symbol,ENUM_ORDER_TYPE orderType);
   double            CalculateLotValue(string symbol);
   double            CalculatePositionValue(string symbol,double lots);
   double            CalculateEffectiveLeverage(string symbol,double lots);
  };
//+------------------------------------------------------------------+
//|Gets the total size on the given currency pair.                   |
//+------------------------------------------------------------------+
double OrderManager::PairLotsTotal(string symbol,ENUM_ORDER_TYPE orderType)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && OrderType()==orderType)
        {
         num=num+OrderLots();
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the highest take profit for any order on the given pair.     |
//+------------------------------------------------------------------+
double OrderManager::PairHighestTakeProfit(string symbol,ENUM_ORDER_TYPE orderType)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && OrderType()==orderType)
        {
         if(num==0 || OrderTakeProfit()>num)
           {
            num=OrderTakeProfit();
           }
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the lowest take profit for any order on the given pair.      |
//+------------------------------------------------------------------+
double OrderManager::PairLowestTakeProfit(string symbol,ENUM_ORDER_TYPE orderType)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && OrderType()==orderType)
        {
         if(num==0 || OrderTakeProfit()<num)
           {
            num=OrderTakeProfit();
           }
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the highest price paid for any order on the given pair.      |
//+------------------------------------------------------------------+
double OrderManager::PairHighestPricePaid(string symbol,ENUM_ORDER_TYPE orderType)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && OrderType()==orderType)
        {
         if(num==0 || OrderOpenPrice()>num)
           {
            num=OrderOpenPrice();
           }
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the lowest price paid for any order on the given pair.       |
//+------------------------------------------------------------------+
double OrderManager::PairLowestPricePaid(string symbol,ENUM_ORDER_TYPE orderType)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && OrderType()==orderType)
        {
         if(num==0 || OrderOpenPrice()<num)
           {
            num=OrderOpenPrice();
           }
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the current average price paid for the given currency pair.  |
//+------------------------------------------------------------------+
double OrderManager::PairAveragePrice(string symbol,ENUM_ORDER_TYPE orderType)
  {
   double num=0;
   double sum=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && OrderType()==orderType)
        {
         sum=sum+OrderOpenPrice() * OrderLots();
         num=num+OrderLots();
        }
     }
   if(num>0 && sum>0)
     {
      return (sum / num);
     }
   else
     {
      return 0;
     }
  }
//+------------------------------------------------------------------+
//|Gets the current average price paid for the given currency pair.  |
//+------------------------------------------------------------------+
double OrderManager::PairAveragePriceWithAdditonalOrder(string symbol,ENUM_ORDER_TYPE orderType,double size)
  {
   double num=0;
   double sum=0;
   if(orderType==OP_BUY)
     {
      num=size * 100000;
      sum=Ask * size * 100000;
     }
   if(orderType==OP_SELL)
     {
      num=size * 100000;
      sum=Bid * size * 100000;
     }

   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && OrderType()==orderType)
        {
         sum=sum+OrderOpenPrice() * (OrderLots() * 100000);
         num=num+(OrderLots() * 100000);
        }
     }

   if(num>0 && sum>0)
     {
      return (sum / num);
     }
   else
     {
      return 0;
     }
  }
//+------------------------------------------------------------------+
//|Gets the lowest stop loss for any order on the given pair.        |
//+------------------------------------------------------------------+
double OrderManager::PairLowestStopLoss(string symbol,ENUM_ORDER_TYPE orderType)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && OrderType()==orderType)
        {
         if(num==0 || OrderStopLoss()<num)
           {
            num=OrderStopLoss();
           }
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the highest stop loss for any order on the given pair.       |
//+------------------------------------------------------------------+
double OrderManager::PairHighestStopLoss(string symbol,ENUM_ORDER_TYPE orderType)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && OrderType()==orderType)
        {
         if(num==0 || OrderStopLoss()>num)
           {
            num=OrderStopLoss();
           }
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderManager::CalculateLotValue(string symbol)
  {
   double symbolLotSize=MarketInfo(symbol,MODE_LOTSIZE);
   double symbolPointSize=MarketInfo(symbol,MODE_POINT);
   double symbolDigits=MarketInfo(symbol,MODE_DIGITS);
   double pointShiftFactor=MathPow(10,symbolDigits-5);
   double symbolAskPrice=MarketInfo(symbol,MODE_ASK);
   double symbolTickValue=MarketInfo(symbol,MODE_TICKVALUE);
   double symbolTickSize=MarketInfo(symbol,MODE_TICKSIZE);
   double symbolPointValue=symbolTickValue/symbolTickSize;

   return (symbolLotSize * pointShiftFactor * symbolAskPrice * symbolPointValue * symbolPointSize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderManager::CalculatePositionValue(string symbol,double lots)
  {
   return this.CalculateLotValue(symbol) * lots;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderManager::CalculateEffectiveLeverage(string symbol,double lots)
  {
   double positionValue=0;
   double num=0;
   if(lots>0 && AccountEquity()>0)
     {
      positionValue=this.CalculatePositionValue(symbol,lots);
      num=(positionValue/AccountEquity());
     }
   return num;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderManager::CalculateEffectiveLeverage(string symbol,ENUM_ORDER_TYPE orderType)
  {
   return this.CalculateEffectiveLeverage(symbol,PairLotsTotal(symbol,orderType));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderManager::OrderManager()
  {
   this.Slippage=10;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::Validate()
  {
   ValidationResult *v=new ValidationResult();
   bool out=this.Validate(v);
   delete v;
   return out;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::Validate(ValidationResult *validationResult)
  {
   Comparators compare;
   validationResult.Result=true;

   if(compare.IsLessThan(this.Slippage,(int)0))
     {
      validationResult.AddMessage("The Slippage must be greater than or equal to zero.");
      validationResult.Result=false;
     }

   return validationResult.Result;
  }
//+------------------------------------------------------------------+
//| Basic check on whether trading is allowed and enabled for the    |
//| current symbol at the current time.                              |
//+------------------------------------------------------------------+
bool OrderManager::CanTrade()
  {
   return IsTesting() || IsTradeAllowed();
  }
//+------------------------------------------------------------------+
//| Basic check on whether trading is allowed and enabled.           |
//+------------------------------------------------------------------+
bool OrderManager::CanTrade(string symbol,datetime time)
  {
   return IsTesting() || IsTradeAllowed(symbol,time);
  }
//+------------------------------------------------------------------+
//| Gets the highest price paid for any order older than the         |
//| minimum age, on the given pair.                                  |
//+------------------------------------------------------------------+
double OrderManager::PairOpenPositionCount(string symbol,datetime minimumAge)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)
         && (OrderType()==OP_BUY || OrderType()==OP_SELL)
         && OrderSymbol()==symbol
         && (OrderOpenTime()<=minimumAge))
        {
         num=num+1;
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the current net profit of open positions on the given        |
//|currency pair.                                                    |
//+------------------------------------------------------------------+
double OrderManager::PairProfit(string symbol)
  {
   double sum=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderType()==OP_BUY || OrderType()==OP_SELL) && OrderSymbol()==symbol)
        {
         sum=sum+OrderProfit();
        }
     }
   return sum;
  }
//+------------------------------------------------------------------+
//| Closes all orders for the specified symbol that are older than   |
//| the minimum age.                                                 |
//+------------------------------------------------------------------+
void OrderManager::CloseOrders(string symbol,datetime minimumAge)
  {
   int ticket,i;
//----
   while(PairOpenPositionCount(symbol,minimumAge)>0)
     {
      for(i=0;i<OrdersTotal();i++)
        {
         ticket=OrderSelect(i,SELECT_BY_POS);
         if(OrderType()==OP_BUY && OrderSymbol()==symbol && (OrderOpenTime()<=minimumAge))
           {
            if(OrderClose(OrderTicket(),OrderLots(),Bid,this.Slippage)==false)
              {
               this.Logger.Error((string)GetLastError());
              }
           }
         if(OrderType()==OP_SELL && OrderSymbol()==symbol && (OrderOpenTime()<=minimumAge))
           {
            if(OrderClose(OrderTicket(),OrderLots(),Ask,this.Slippage)==false)
              {
               this.Logger.Error((string)GetLastError());
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderManager::SendOrder(SignalResult *r,double lotSize)
  {
   int ticket=(-1);

   if(!(this.ValidateStopLevels(r.symbol,r.orderType,r.price,r.stopLoss,r.takeProfit)))
     {
      this.Logger.Warn("OrderSend not sent, stop levels are invalid.");
      return ticket;
     }

   int d=(int)SymbolInfoInteger(r.symbol,SYMBOL_DIGITS);
   ticket=OrderSend(
                    (string)r.symbol,
                    (ENUM_ORDER_TYPE)r.orderType,
                    NormalizeDouble(lotSize,2),
                    NormalizeDouble(r.price,d),
                    (int)this.Slippage,
                    NormalizeDouble(r.stopLoss,d),
                    NormalizeDouble(r.takeProfit,d));
   if(ticket<0)
     {
      this.Logger.Error("OrderSend Error : "+ ErrorDescription(GetLastError()));
      this.Logger.Error(StringConcatenate(
                        "Order Sent : symbol= ",r.symbol,
                        ", type= ",EnumToString((ENUM_ORDER_TYPE)r.orderType),
                        ", lots= ",NormalizeDouble(lotSize,2),
                        ", price= ",NormalizeDouble(r.price,d),
                        ", slippage= ",this.Slippage,
                        ", stop loss= ",NormalizeDouble(r.stopLoss,d),
                        ", take profit=  ",NormalizeDouble(r.takeProfit,d)));
      if(IsTesting())
        {
         ExpertRemove();
        }
      return ticket;
     }
   return ticket;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::ValidateStopLevels(string symbol,ENUM_ORDER_TYPE orderType,double orderPrice,double stopLoss,double takeProfit)
  {
   double minStops=(MarketInfo(symbol,MODE_STOPLEVEL)+MarketInfo(symbol,MODE_SPREAD))*MarketInfo(symbol,MODE_POINT);
   double prc=orderPrice;
   if(orderType==OP_BUY)
     {
      prc=Bid;
     }
   if(orderType==OP_SELL)
     {
      prc=Ask;
     }
   double tpd=MathAbs(prc - takeProfit);
   double sld=MathAbs(prc - stopLoss);
   if((stopLoss==0 || sld>minStops) && (takeProfit==0 || tpd>minStops))
     {
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OrderManager::ModifyOrder(int ticket,double orderPrice,double stopLoss,double takeProfit,datetime expiration)
  {
   if(!OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      this.Logger.Error(StringConcatenate("Could not select the order with ticket number : ", ticket));
      this.Logger.Error(StringConcatenate((string)GetLastError(), " : ",ErrorDescription(GetLastError())));
      return false;
     }

   string symbol=OrderSymbol();
   int d=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
   
   if(NormalizeDouble(OrderOpenPrice(),d)==NormalizeDouble(orderPrice,d)
      && NormalizeDouble(OrderStopLoss(),d)==NormalizeDouble(stopLoss,d)
      && NormalizeDouble(OrderTakeProfit(),d)==NormalizeDouble(takeProfit,d)
      && OrderExpiration()==expiration)
     {
      // when asked to change values to what they already are, we're successful without trying.
      return true;
     }

   if(!(this.ValidateStopLevels(symbol,(ENUM_ORDER_TYPE)OrderType(),orderPrice,stopLoss,takeProfit)))
     {
      this.Logger.Warn("OrderModify not sent, stop levels are invalid.");
      return false;
     }
   bool success=OrderModify(
                            ticket,
                            NormalizeDouble(orderPrice,d),
                            NormalizeDouble(stopLoss,d),
                            NormalizeDouble(takeProfit,d),
                            expiration);
   if(!success)
     {
      this.Logger.Error("OrderModify Error : "+ ErrorDescription(GetLastError()));
      this.Logger.Error(StringConcatenate(
                        "Order Sent : symbol= ",symbol,
                        ", ticket= ",ticket,
                        ", price= ",NormalizeDouble(orderPrice,d),
                        ", stop loss= ",NormalizeDouble(stopLoss,d),
                        ", take profit=  ",NormalizeDouble(takeProfit,d),
                        ", expiration= ",expiration));
      if(IsTesting())
        {
         ExpertRemove();
        }
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderManager::NormalizeExits(string symbol,ENUM_ORDER_TYPE orderType,double stopLoss,double takeProfit)
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && OrderType()==orderType)
        {
         this.ModifyOrder(OrderTicket(),OrderOpenPrice(),stopLoss,takeProfit,OrderExpiration());
        }
     }
  }
//+------------------------------------------------------------------+
