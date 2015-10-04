package utils
{
import flash.net.SharedObject;
import flash.utils.Dictionary;

public class SharedObjectUtils
	{
		public function SharedObjectUtils()
		{
		}
		public static function saveSO(soName:String,fieldName:String,fieldValue:*):void
		{
			var so:SharedObject = getSO(soName);
			so.data[fieldName] = fieldValue;
			so.flush();
			so.close();
		}
		public static function getSOField(soName:String,fieldName:String):*
		{
			var so:SharedObject = getSO(soName);
			return so ? so.data[fieldName] : null;
		}
		private static var soByName:Dictionary = new Dictionary();
		public static function getSO(name:String):SharedObject
		{
			var so:SharedObject = soByName[name];
			if(so) return so;
			
			so = SharedObject.getLocal(name);
			soByName[name] = so;
			
			return so;
		}
	}
}