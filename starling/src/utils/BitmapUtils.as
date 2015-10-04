package utils
{
	/**
	 * Inspired by ActiveDen Forum
	 * @link http://activeden.net/
	 */

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.IBitmapDrawable;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.filters.BitmapFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.ConvolutionFilter;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class BitmapUtils
	{
		public static var SMOOTH_NONE:String = 'none';
		public static var SMOOTH_INNER:String = 'inner';
		public static var SMOOTH_OUTER:String = 'outer';
		/**
		 * Remove target color from a bitmapData, return a new transparent bitmapData
		 * 
		 * @param	source			BitmapData	source bitmapdata
		 * @param	testColor		uint		test color, RGB color value
		 * @param	colorRange		uint		color range for testing, this value should be max at 0xFF
		 * @param	smoothType		String		smooth type : "none", "inner", "outer"
		 * @param	smoothRange		Number		out/inner size for smoothing
		 * @param	smoothStrength	Number		smooth strength
		 * @return	BitmapData	
		 */
		private static var _stage:Stage;
		
		public function BitmapUtils(stage:Stage)
		{
			_stage = stage;
		}
		public static function removeColor(source:BitmapData, testColor:uint, colorRange:uint = 0, smoothType:String = 'inner', smoothRange:Number = 2, smoothStrength:Number = 10):BitmapData
		{
			var rect:Rectangle = new Rectangle(0, 0, source.width, source.height);
			var pt:Point = new Point();
			
			var r:uint = testColor >> 16 & 0xFF;
			var g:uint = testColor >> 8 & 0xFF;
			var b:uint = testColor & 0xFF;
			
			var thRed_A:uint = ((r + colorRange) > 0xff) ? 0xff0000 : (r + colorRange) << 16 ;
			var thRed_B:uint = ((r - colorRange) < 0) ? 0 : (r - colorRange) << 16;
			var thGreen_A:uint = ((g + colorRange) > 0xff) ? 0xff00 : (g + colorRange) << 8;
			var thGreen_B:uint = ((g - colorRange) < 0) ? 0 : (g - colorRange) << 8;
			var thBlue_A:uint = ((b + colorRange) > 0xff) ? 0xff : (b + colorRange);
			var thBlue_B:uint = ((b - colorRange) < 0) ? 0 : (b - colorRange);
			
			var bitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
					
			bitmapData.threshold(source, rect, pt, ">", thRed_A, 0xffff0000, 0xff0000, false);
			bitmapData.threshold(source, rect, pt, "<", thRed_B, 0xffff0000, 0xff0000, false);
			bitmapData.threshold(source, rect, pt, ">", thGreen_A, 0xffff0000, 0x00ff00, false);		
			bitmapData.threshold(source, rect, pt, "<", thGreen_B, 0xffff0000, 0x00ff00, false);
			bitmapData.threshold(source, rect, pt, ">", thBlue_A, 0xffff0000, 0x0000ff, false);
			bitmapData.threshold(source, rect, pt, "<", thBlue_B, 0xffff0000, 0x0000ff, false);
			
			switch(smoothType)
			{
				case SMOOTH_NONE:					
					bitmapData.copyPixels(source, rect, pt, bitmapData, pt, false);
				break;
				
				case SMOOTH_OUTER:
					bitmapData.applyFilter(bitmapData, rect, pt, new GlowFilter(0x00ff00, 1, smoothRange, smoothRange, smoothStrength, smoothStrength, false, false));
					bitmapData.copyPixels(source, rect, pt, bitmapData, pt, false);
				break;
				
				case SMOOTH_INNER:
					bitmapData.applyFilter(bitmapData, rect, pt, new GlowFilter(0x00ff00, 1, smoothRange, smoothRange, smoothStrength, smoothStrength, true, false));
					
					var tempBitmapData:BitmapData = new BitmapData(rect.width, rect.height, false, 0x000000);
					tempBitmapData.copyPixels(bitmapData, rect, pt);
					
					bitmapData.copyPixels(source, rect, pt);
					bitmapData.copyChannel(tempBitmapData, rect, pt, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
				break;
				
				default:
					throw new Error('smooth type [' + smoothType + '] not defined');
			}
			
			return bitmapData;
		}
		private static var eraseContainer:MovieClip = new MovieClip();
		public static function erase(target:DisplayObject,eraseShape:DisplayObject):BitmapData
		{
			if(!target || !eraseShape || target.width==0 || target.height==0 || eraseShape.width==0 || eraseShape.height==0) return null;
			
			var targetParent:DisplayObjectContainer = target.parent;
			var eraseShapeParent:DisplayObjectContainer = eraseShape.parent;
			
			eraseContainer.blendMode = BlendMode.LAYER;
			eraseShape.blendMode = BlendMode.ERASE;
			eraseContainer.addChild(target);
			eraseContainer.addChild(eraseShape);
			
			var drawRect:Rectangle = new Rectangle(0,0,target.width,target.height);
			var bmd:BitmapData = draw(eraseContainer,null,null,null,drawRect);
			
			eraseShape.blendMode = BlendMode.NORMAL;
			
			if(targetParent) targetParent.addChild(target);
			if(eraseShapeParent) eraseShapeParent.addChild(eraseShape);
			
			return bmd;
		}
		public static function drawIntoGraphics(bmd:BitmapData,graphics:Graphics,drawVisibleRectOnly:Boolean=false):void
		{
			if(graphics && bmd)
			{
				graphics.clear();
				var fillRect:Rectangle = bmd.rect;//drawBmd.getColorBoundsRect(0xFF000000, 0x00000000, false);
				graphics.beginBitmapFill(bmd,null,false,true);
				graphics.drawRect(fillRect.x,fillRect.y,fillRect.width,fillRect.height);
				graphics.endFill();
			}
		}
		private static var removeWhiteContainer:MovieClip = new MovieClip();
		private static var removeWhiteBmp:Bitmap = new Bitmap();
		public static function removeWhite(source:BitmapData,useBitmapDataThresholdMethod:Boolean=true,stage:Stage=null):BitmapData
		{
			if(!source || source.width==0 || source.height==0) return source;
			
			if(useBitmapDataThresholdMethod)
			{
				source.threshold(source, source.rect, new Point(), "==",0xFFFFFFFF, 0x00000000, 0xFFFFFFFF, true);
				return source;
			}
			
			/*var s:Sprite = new Sprite();
			s.graphics.beginBitmapFill(source);
			s.graphics.drawRect(0,0,source.rect.width,source.rect.height);
			s.graphics.endFill();*/
			
			removeWhiteBmp.bitmapData = source;
			removeWhiteBmp.cacheAsBitmap = true;
			
			removeWhiteBmp.blendMode = BlendMode.MULTIPLY;
			
			removeWhiteContainer.addChild(removeWhiteBmp);

			/*removeWhiteContainer.graphics.beginFill(0xFFFFFF,1);
			removeWhiteContainer.graphics.drawRect(0,0,source.width,source.height);
			removeWhiteContainer.graphics.endFill();*/
			
			//if(stage) stage.addChild(removeWhiteContainer);
			
			
			//var bmd:BitmapData = replaceColor(source,0xFFFFFFFF,0x00000000,100);
			var ct:ColorTransform = removeWhiteBmp.transform.colorTransform;
			ct.alphaOffset = 1;
			
			//removeWhiteBmp.filters = [ColorMatrixUtils.setBrightness(-100)]
			var bmd:BitmapData = draw(removeWhiteContainer,null,null,BlendMode.LAYER);
			
			//if(stage) stage.removeChild(removeWhiteContainer);
			return bmd;
		}
		public static function draw(source:IBitmapDrawable, matrix:Matrix=null, colorTransform:ColorTransform=null, blendMode:String=null, clipRect:Rectangle=null, transparent:Boolean=true,backgroundColor:uint=0x00000000,smoothing:Boolean=true):BitmapData
		{
			clipRect = clipRect ? clipRect : new Rectangle(0, 0, (source as Object).width, (source as Object).height);
			if (clipRect.isEmpty()) return null;
			
			var bmd:BitmapData = new BitmapData(clipRect.width,clipRect.height,transparent,backgroundColor);
			
			bmd.draw(source,matrix,colorTransform,blendMode,clipRect,smoothing);
			
			return bmd;
		}
		public static function drawRect(src:BitmapData, dest:BitmapData, sourceX:int, sourceY:int, sourceW:int, sourceH:int, destinationX:int, destinationY:int, destinationW:int, destinationH:int):void
		{
			var scaleX:Number = destinationW / sourceW, scaleY:Number = destinationH / sourceH;
			var m:Matrix = new Matrix();
			m.scale(scaleX, scaleY);
			m.translate(destinationX, destinationY);
			
			var temp:BitmapData = new BitmapData(sourceW, sourceH, src.transparent, 0);
			temp.copyPixels(src, new Rectangle(sourceX, sourceY, sourceW, sourceH), new Point());
			dest.draw(temp, m);
		}
		private static const COLOR:uint = 0xFF;                // default color of BitmapData instance.
		private static const TRANSPARENT:Boolean = true;        // default transparency of BitmapData instance.
		private static const ORIGIN:Point = new Point(0, 0);        // default Point origin of BitmapData instance.
		private static const FLAT:BitmapData = new BitmapData(1, 1, TRANSPARENT, COLOR);    // default BitmapData instance.
		
		private static var EVAL_ALPHA:String = "alpha";
		private static var EVAL_THRESHOLD:String = "threshold";
		
		/**
		 * Returns stripped BitmapData instance. 
		 * @param    bmp : BitmapData            BitmapData instance to strip.
		 * @param    eval : String                Stip event string.
		 * @param    col : uint                    Color to set threshold if eval set to EVAL_THRESHOLD.
		 * @return     Rectangle
		 */
		private static function getStrip(bmp:BitmapData, eval:String, col:uint = 0):Rectangle
		{
			var o:Object = new Object();
			var bool:Boolean;
			
			var w:int;
			var h:int;
			var x2:int = bmp.width;
			var y2:int = bmp.height;
			
			var px1:int = 0;
			var py1:int = 0;
			var px2:int = x2;
			var py2:int = y2;
			
			var x:int;
			var y:int = y2;
			while(--y > -1)
			{
				x = x2;
				while(--x > -1)
				{
					//default alpha pixel.
					bool = ( ( bmp.getPixel32(x, y) >> 24 ) & 0xFF ) != 0;
					if(eval == EVAL_THRESHOLD) // ..else threshold
						bool = ( bmp.getPixel32(x, y) != col );
					
					if(bool) // if comparison found.
					{
						px1 = Math.max(x, px1);
						px2 = Math.min(x, px2);
						py1 = Math.max(y, py1);
						py2 = Math.min(y, py2);
					}            
				}
			}
			//add one for pixel size.
			px1 += 1;
			py1 += 1;
			
			w = px1 - px2;
			h = py1 - py2;
			return new Rectangle(px2, py2, w, h);
		}
		
		/**
		 * Strips BitmapData instance of Alpha pixels.
		 * Returns BitmapData instance within alpha pixel boundary.
		 * @param    bmp : BitmapData            BitmapData instance to strip.
		 * @return     BitmapData                    Instance of stripped BitmapData.
		 * @see #getStrip method.
		 */
		public static function stripAlpha(bmp:BitmapData):BitmapData
		{
			//send to stripper.
			var rect:Rectangle = getStrip(bmp, EVAL_ALPHA);
			//create new instance from returned rectangle object.
			var stripped:BitmapData = new BitmapData(rect.width, rect.height, TRANSPARENT, COLOR);
			stripped.copyPixels(bmp, rect, ORIGIN);
			
			//dispose of original instance.
			bmp.dispose();
			//return.
			return stripped;
		}
		
		/**
		 * Strips BitmapData instance of threshold pixels.
		 * Returns BitmapData instance within threshold pixel boundary.
		 * @param    bmp : BitmapData            BitmapData instance to strip.
		 * @return     BitmapData                    Instance of stripped BitmapData.
		 * @see #getStrip method.
		 */
		public static function stripThreshold(bmp:BitmapData, threshold:uint):BitmapData
		{
			//send to stripper.
			var rect:Rectangle = getStrip(bmp, EVAL_THRESHOLD, threshold);
			//create new instance from returned rectangle object.
			var stripped:BitmapData = new BitmapData(rect.width, rect.height, TRANSPARENT, COLOR);
			stripped.copyPixels(bmp, rect, ORIGIN)
			stripped.threshold(bmp, rect, ORIGIN, "==", threshold);
			
			//dispose of original instance.
			bmp.dispose();
			//return.
			return stripped;
		}
		public static function applyColorFilter(bmp:BitmapData, matrix:Array):BitmapData
		{
			var filter:BitmapFilter = new ColorMatrixFilter(matrix);
			bmp.applyFilter(bmp, bmp.rect, ORIGIN, filter);
			return bmp;
		}
		public static function applyConvolFilter(bmp:BitmapData, matrix:Array):BitmapData
		{
			var filter:BitmapFilter = new ConvolutionFilter(3, 3, matrix);
			bmp.applyFilter(bmp, bmp.rect, ORIGIN,filter);
			return bmp;
		}
		/**
		 * Flood fills on an image starting at an (x, y) cordinate and filling with a specific color.
		 * The floodFill() method is similar to the paint bucket tool in various paint programs.
		 *
		 * @param bd The BitmapData to modify.
		 * @param x The x cordinate of the image. 
		 * @param y The y cordinate of the image.
		 * @param color The color with which flood fills the image.
		 * @param tolerance The similarity of colors. Ranges from 0 to 255. [OPTIONAL]
		 * @param contiguous The continueity of the area to be filled. [OPTIONAL]
		 *
		 * @return A modified BitmapData.
		 */
		public static function floodFill(bd:BitmapData, x:uint, y:uint, color:uint, tolerance:uint=0, contiguous:Boolean=false):BitmapData{
			// Varlidates the (x, y) cordinates.
			x = Math.min(bd.width-1, x);
			y = Math.min(bd.height-1, y);
			// Validates the tolerance.
			tolerance = Math.max(0, Math.min(255, tolerance));
			
			// Gets the color of the selected point.
			var targetColor:uint = bd.getPixel32(x, y);
			
			if(contiguous){
				// Fills only the connected area.
				var w:uint = bd.width;
				var h:uint = bd.height;
				
				// Temporary BitmapData
				var temp_bd:BitmapData = new BitmapData(w, h, false, 0x000000);
				
				// Fills similar pixels with gray.
				temp_bd.lock();
				for(var i:uint=0; i<w; i++){
					for(var k:uint=0; k<h; k++){
						var d:int = getColorDifference32(targetColor, bd.getPixel32(i, k));
						if(d <= tolerance){
							temp_bd.setPixel(i, k, 0x333333);
						}
					}
				}
				temp_bd.unlock();
				
				// Fills the connected area with white.
				temp_bd.floodFill(x, y, 0xFFFFFF);
				
				// Uese threshold() to get the white pixels only.
				var rect:Rectangle = new Rectangle(0, 0, w, h);
				var pnt:Point = new Point(0, 0);
				temp_bd.threshold(temp_bd, rect, pnt, "<", 0xFF666666, 0xFF000000);
				
				// Gets the colorBoundsRect to minimizes a for loop.
				rect = temp_bd.getColorBoundsRect(0xFFFFFFFF, 0xFFFFFFFF);
				x = rect.x;
				y = rect.y;
				w = x + rect.width;
				h = y + rect.height;
				
				// Modifies the original image.
				bd.lock();
				for(i=x; i<w; i++){
					for(k=y; k<h; k++){
						if(temp_bd.getPixel(i, k) == 0xFFFFFF){
							bd.setPixel32(i, k, color);
						}
					}
				}
				bd.unlock();
			}else{
				// Fills all pixels similar to the targetColor.
				replaceColor(bd, targetColor, color, tolerance);
			}// end if else
			
			return bd;
		}// end floodFill
		
		
		
		/**
		 * Replaces colors similar to color c1 with color c2.
		 *
		 * @param bd The BitmapData to modify.
		 * @param c1 The color to be replaced.
		 * @param c2 The color with which replaces c1.
		 * @param tolerance The similarity of colors. Ranges from 0 to 255. [OPTIONAL]
		 *
		 * @return A modified BitmapData.
		 */
		public static function replaceColor(bd:BitmapData, c1:uint, c2:uint, tolerance:uint=0):BitmapData{
			// Validates the tolerance.
			tolerance = Math.max(0, Math.min(255, tolerance));
			
			bd.lock();
			var w:uint = bd.width;
			var h:uint = bd.height;
			for(var i:uint=0; i<w; i++){
				for(var k:uint=0; k<h; k++){
					var d:int = getColorDifference32(c1, bd.getPixel32(i, k));
					if(d <= tolerance){
						bd.setPixel32(i, k, c2);
					}
				}
			}
			bd.unlock();
			
			return bd;
		}// end replaceColor
		
		/**
		 * Calculates of the difference of two colors on an RGB basis.
		 *
		 * @param c1 The first color to compare.
		 * @param c2 The second color to compare.
		 *
		 * @return A difference of the two colors.
		 */
		public static function getColorDifference(c1:uint, c2:uint):int{
			var r1:int = (c1 & 0x00FF0000) >>> 16;
			var g1:int = (c1 & 0x0000FF00) >>> 8;
			var b1:int = (c1 & 0x0000FF);
			
			var r2:int = (c2 & 0x00FF0000) >>> 16;
			var g2:int = (c2 & 0x0000FF00) >>> 8;
			var b2:int = (c2 & 0x0000FF);
			
			var r:int = Math.pow((r1-r2), 2);
			var g:int = Math.pow((g1-g2), 2);
			var b:int = Math.pow((b1-b2), 2);
			
			var d:int = Math.sqrt(r + g + b);
			
			// Adjusts the range to 0-255.
			d = Math.floor(d / 441 * 255);
			
			return d;
		}// end getColorDifference
		
		/**
		 * Calculates of the difference of two colors on an RGBA basis.
		 *
		 * @param c1 The first color to compare.
		 * @param c2 The second color to compare.
		 *
		 * @return A difference of the two colors.
		 */
		public static function getColorDifference32(c1:uint, c2:uint):int{
			var a1:int = (c1 & 0xFF000000) >>> 24;
			var r1:int = (c1 & 0x00FF0000) >>> 16;
			var g1:int = (c1 & 0x0000FF00) >>> 8;
			var b1:int = (c1 & 0x0000FF);
			
			var a2:int = (c2 & 0xFF000000) >>> 24;
			var r2:int = (c2 & 0x00FF0000) >>> 16;
			var g2:int = (c2 & 0x0000FF00) >>> 8;
			var b2:int = (c2 & 0x0000FF);
			
			var a:int = Math.pow((a1-a2), 2);
			var r:int = Math.pow((r1-r2), 2);
			var g:int = Math.pow((g1-g2), 2);
			var b:int = Math.pow((b1-b2), 2);
			
			var d:int = Math.sqrt(a + r + g + b);
			
			// Adjusts the range to 0-255.
			d = Math.floor(d / 510 * 255);
			
			return d;
		}
		public static function generateSpriteSheets(bitmapData:BitmapData,frameW:Number,frameH:Number):Vector.<BitmapData>
		{
			var spriteSheets:Vector.<BitmapData> = new Vector.<BitmapData>();
			
			if (!bitmapData) return spriteSheets;
			
			var xSteps:int = bitmapData.width/frameW;
			var ySteps:int = bitmapData.height/frameH;
			
			//trace("BitmapUtils.generateSpriteSheets(bitmapData, frameW, frameH)",bitmapData,bitmapData.rect,frameW,frameH);
			
			var drawRect:Rectangle = new Rectangle(0,0,frameW,frameH);
			
			for (var y:int = 0; y < ySteps; y++) 
			{
				for (var x:int = 0; x < xSteps; x++) 
				{
					drawRect.x = x * drawRect.width;
					drawRect.y = y * drawRect.height;
					
					var spriteBmd:BitmapData = new BitmapData(drawRect.width,drawRect.height,true,0x00000000);						
					spriteBmd.copyPixels(bitmapData,drawRect,new Point(0,0));
					
					spriteSheets.push(spriteBmd);
				}
			}
			return spriteSheets;
		}
	}
}