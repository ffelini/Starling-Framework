package utils
{
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;
import flash.geom.ColorTransform;

public class ColorMatrixUtils
	{
		public static function setBrightness(value:Number):ColorMatrixFilter
		{
			value = value*(255/250);
			
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, value]);	// red
			matrix = matrix.concat([0, 1, 0, 0, value]);	// green
			matrix = matrix.concat([0, 0, 1, 0, value]);	// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);		// alpha
			
			return new ColorMatrixFilter(matrix);
		}
		public static function setContrast(value:Number):ColorMatrixFilter
		{
			value /= 100;
			var s: Number = value + 1;
			var o : Number = 128 * (1 - s);
			
			var matrix:Array = new Array();
			matrix = matrix.concat([s, 0, 0, 0, o]);	// red
			matrix = matrix.concat([0, s, 0, 0, o]);	// green
			matrix = matrix.concat([0, 0, s, 0, o]);	// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);	// alpha
			
			return new ColorMatrixFilter(matrix);
		}
		public static function setSaturation(value:Number):ColorMatrixFilter
		{
			const _r:Number = 0.212671;
			const _g:Number = 0.71516;
			const _b:Number = 0.072169;
			
			var v:Number = (value/100) + 1;
			var i:Number = (1 - v);
			var r:Number = (i * _r);
			var g:Number = (i * _g);
			var b:Number = (i * _b);
			
			var matrix:Array = new Array();
			matrix = matrix.concat([(r + v), g, b, 0, 0]);	// red
			matrix = matrix.concat([r, (g + v), b, 0, 0]);	// green
			matrix = matrix.concat([r, g, (b + v), 0, 0]);	// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]);			// alpha
			
			return new ColorMatrixFilter(matrix);
		}
		public static function grayScale():ColorMatrixFilter
		{
			var b:Number = 1 / 3; var c:Number = 1 - (b * 2); 
			var matrix:Array = [c, b, b, 0, 0, b, c, b, 0, 0, b, b, c, 0, 0, 0, 0, 0, 1, 0]; 

			return new ColorMatrixFilter(matrix);
		}
		public static function getColorizeContainer(obj:DisplayObject,shape:DisplayObject,color:uint,saturation:Number=-100,contrast:Number=-30,brightness:Number=-35):DisplayObject
		{
			var colorizeContainer:Sprite = new Sprite();
			
			colorizeObject(obj,shape,color,saturation,contrast,brightness);

			colorizeContainer.addChild(obj);
			colorizeContainer.addChild(shape);
			
			return colorizeContainer;
		}
		public static var DEFAULT_COLOR_TRANSFORM:ColorTransform = new ColorTransform();
		public static function colorizeObject(obj:DisplayObject,shape:DisplayObject,color:uint,saturation:Number=-100,contrast:Number=-30,brightness:Number=-35):void
		{
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = color;
			
			var grayScaleFilter:ColorMatrixFilter = setSaturation(saturation);
			var contrastFilter:ColorMatrixFilter = setContrast(contrast);
			var brightnessFilter:ColorMatrixFilter = setBrightness(brightness);
			
			obj.filters = [grayScaleFilter,brightnessFilter,contrastFilter];
			shape.transform.colorTransform = colorTransform;
			
			obj.blendMode = BlendMode.NORMAL;
			shape.blendMode = BlendMode.OVERLAY;
		}
		public static function colorize(obj:DisplayObject,shape:DisplayObject,color:uint):BitmapData
		{
			return BitmapUtils.draw(getColorizeContainer(obj,shape,color));
		}
		public static function colorizeBMD(bmd:BitmapData,color:uint):BitmapData
		{
			return bmd;
		}
	}
}

