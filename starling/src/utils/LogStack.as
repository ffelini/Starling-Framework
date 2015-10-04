package utils
{
import flash.utils.Dictionary;

public class LogStack
	{
		public static var DEBUG:Boolean = true;
		
		public function LogStack()
		{
		}
		public static var stack:String = "";
		private static var index:int = 0;
		private static var line:String;
		public static var lines:Array = [];
		public static function addLog(instance:Object,message:String,...params):*
		{
			index++;

			line = "\n" + index + ". " + instance + ": " + message + " - " + params;
			lines.push(line);
			
			if(DEBUG) trace(line);
			
			if(instance)
			{
				if(stackByInstance[instance]) stackByInstance[instance] = stackByInstance[instance] + line + "\n";
				else stackByInstance[instance] = line;
			}
			stack += line + "\n";
			
			return line;
		}
		private static var stackByInstance:Dictionary = new Dictionary();
		public static function getLogsByInstance(inst:Object):String
		{
			return stackByInstance[inst];
		}
		public static function getLogs():String
		{
			return stack;
		}
		public static function clearLog():void
		{
			index = 0;
			lines.length = 0;
			stack = "";
		}
//		public static function saveLogFile(fileName:String=""):void
//		{
//			fileName = fileName=="" ? AppManager.appID.replace(".","_")+".txt" : fileName;
//			var fr:File = File.desktopDirectory.resolvePath(fileName);
//
//			var outputStream:FileStream = new FileStream();
//			outputStream.open(fr,FileMode.WRITE);
//			var ba:ByteArray = new ByteArray();
//			ba.writeUTFBytes(getLogs());
//			outputStream.writeBytes(ba);
//			outputStream.close();
//		}
	}
}