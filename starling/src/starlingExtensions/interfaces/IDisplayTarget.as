package starlingExtensions.interfaces
{
import starling.display.DisplayObject;

public interface IDisplayTarget
	{
		function set target(value:DisplayObject):void
		function get target():DisplayObject;
	}
}