package utils
{
import flash.utils.Dictionary;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

public class TimeOut
	{
		public function TimeOut()
		{
		}
		
		private static var timeOuts:Dictionary = new Dictionary();
		
		public static function setTimeOutFunc(func:Function,delay:Number,clearAllTimeOuts:Boolean=true,...parameters):void
		{
			var tuid:uint = setTimeout.apply(null,[func,delay].concat(parameters));
			
			if(clearAllTimeOuts) clearTimeOuts(func);
			
			var _timeOuts:Vector.<uint> = timeOuts[func];
			if(!_timeOuts)
			{
				_timeOuts = new Vector.<uint>();
				timeOuts[func] = _timeOuts;
			}
			_timeOuts.push(tuid);
		}
		public static function clearTimeOuts(func:Function):void
		{
			var _timeOuts:Vector.<uint> = timeOuts[func];
			if(!_timeOuts) return;
			
			for each(var tuid:uint in _timeOuts)
			{
				clearTimeout(tuid);
			}
			_timeOuts.length = 0;
		}
		public static function getTimeouts(func:Function):Vector.<uint>
		{
			var _timeOuts:Vector.<uint> = timeOuts[func];
			return _timeOuts;
		}
		public static function haveTimeouts(func:Function):Boolean
		{
			var _timeOuts:Vector.<uint> = timeOuts[func];
			return _timeOuts ? _timeOuts.length>0 : false;
		}
	}
}