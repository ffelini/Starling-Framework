package utils
{
import flash.utils.Dictionary;

public dynamic class JSONDictionary extends Dictionary
	{
		public function JSONDictionary(json:Object=null)
		{
			super();
			storeObject(json);
		}
		public function storeObject(obj:Object):void{
			if(obj==null){
				return;
			}
			for(var field:String in obj){
				this[field] = obj[field];
			}
		}
		public function toJSON(s:String):Object{
			var jo:Object = {};
			for(var key:String in this){
				jo[key] = this[key];
			}
			return jo;
		}
	}
}