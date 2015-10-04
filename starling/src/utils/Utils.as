package utils
{
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.display.DisplayObject;

public class Utils
	{
		public function Utils() 
		{
		}
		public static function angle(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			var angle:Number = Math.atan2((y1 - y2), (x1 - x2));
			return angle * 180 / Math.PI + 90;
		}
		public static function getAngle (x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.atan2(dy,dx);
		}
		public static function getAngleBetween(objA:DisplayObject, objB:DisplayObject):Number
		{
			return getAngle(objA.x, objA.y, objB.x, objB.y);
		}
		public static function nextObjectPoint(obj:DisplayObject,distance:Number,resultPoint:Point=null):Point
		{
			return nextPoint(obj.x,obj.y,distance,directionAngle(obj.rotation),resultPoint);
		}
		public static function nextPoint(startX:Number,startY:Number,distance:Number,directionAngle:Number,resultPoint:Point=null):Point
		{
			resultPoint = resultPoint ? resultPoint : new Point();
			resultPoint.x = startX + (distance * Math.cos(directionAngle));
			resultPoint.y = startY + (distance * Math.sin(directionAngle));
			
			return resultPoint;
		}
		public static function nextPointBetween(objA:DisplayObject,objB:DisplayObject,percentDistance:Number,resultPoint:Point):Point
		{
			var dist:Number = getDistance(objA.x,objA.y,objB.x,objB.y);
			var angle:Number = getAngleBetween(objA,objB);
			
			return nextPoint(objA.x,objA.y,dist*percentDistance,angle,resultPoint);
		}
		public static function directionAngle(objRotation:Number):Number
		{
			return (objRotation + 90)* Math.PI/180;
		}
		public static function randomArray(source:*):*{
			return source[randRange(0,source.length-1)];
		}
		public static function randRange(minNum:int, maxNum:int,offset:Number=1):int 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + offset)) + minNum);
		}
		public static function randomPositionInRect(rect:Rectangle, resultP:Point = null, offsetX:Number=0, offsetY:Number=0):Point{
			if(resultP==null){
				resultP = new Point();
			}
			resultP.x = randomXInRect(rect,offsetX);
			resultP.y = randomYInRect(rect,offsetY);
			
			return resultP;
		}
		public static function randomXInRect(rect:Rectangle, offsetX:Number=0):Number{
			return randRange(rect.x + rect.width*offsetX,rect.width - rect.width*offsetX);
		}
		public static function randomYInRect(rect:Rectangle, offsetY:Number=0):Number{
			return randRange(rect.y + rect.height*offsetY,rect.height - rect.height*offsetY);
		}
		public static function getDistance(x0:Number, y0:Number, x1:Number, y1:Number):Number
		{
			var dx:Number = x0-x1;
			var dy:Number = y0-y1;
			var distance:Number = Math.sqrt(dx*dx+dy*dy);
			return distance;
		}
		public static function getDistanceBetween(objA:DisplayObject, objB:DisplayObject):Number
		{
			return getDistance(objA.x, objA.y, objB.x, objB.y);
		}
		public static function addToVectorAt(obj:Object,vector:*,index:int):void
		{
			try{
				
				var numObjects:int = vector.length;			
				if(index>=numObjects)
				{
					for(var i:int = 0;i<index-numObjects;i++)
					{
						vector.push(null);
					}
				}
				vector[index] = obj;
				
			}catch(e:Error){}
		}
	}
}