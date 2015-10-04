package utils
{
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.geom.Rectangle;

public function globalToContenRect(globalRect:Rectangle,localCoordinateSystem:DisplayObjectContainer):Rectangle
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0);
		shape.graphics.drawRect(0,0,globalRect.width,globalRect.height);
		shape.graphics.endFill();
		
		return shape.getBounds(localCoordinateSystem);
	}
}