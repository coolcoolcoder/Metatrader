//+------------------------------------------------------------------+
//|                                                       Circle.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <SpatialReasoning\RightTriangle.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct Circle
  {
private:
   double            _radius;
   double            _diameter;
   double            _circumference;
public:
   CoordinatePoint   Center;

   void Circle()
     {
     }

   void Circle(CoordinatePoint &center,double radius)
     {
      this.Center.Set(center);
      this.SetRadius(radius);
     }

   double GetDiameter()
     {
      return this._diameter;
     }

   void SetDiameter(double diameter)
     {
      this._diameter=diameter;
      this._radius=this._diameter/2;
      this._circumference=2*M_PI*this._radius;
     }

   double GetRadius()
     {
      return this._radius;
     }

   void SetRadius(double radius)
     {
      this._radius=radius;
      this._diameter=2*this._radius;
      this._circumference=2*M_PI*this._radius;
     }

   double GetCircumference()
     {
      return this._circumference;
     }

   void SetCircumference(double circumference)
     {
      double f=2*M_PI;
      this._circumference=circumference;
      this._radius=this._circumference/f;
      this._diameter=this._radius*2;
     }

  };
//+------------------------------------------------------------------+
