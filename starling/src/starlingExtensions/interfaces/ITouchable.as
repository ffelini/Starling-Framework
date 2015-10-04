package starlingExtensions.interfaces
{
import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;

public interface ITouchable
	{
		function clicked(e:TouchEvent,target:DisplayObject=null):Touch
	}
}