package utils
{
import flash.utils.Dictionary;

public class DictionaryOfLists extends Dictionary
	{
		public function DictionaryOfLists(weakKeys:Boolean=false)
		{
			super(weakKeys);
		}
		public function addToList(key:*,value:*):void
		{
			var fields:Vector.<Object> = this[key];
			if(!fields)
			{
				fields = new Vector.<Object>();
				this[key] = fields;
			}
			if(fields.indexOf(value)<0) fields.push(value);
			
			trace("DictionaryOfLists.addToList(key, value)",key,value);
			
		}
		public function removeFromList(key:*,value:*):void
		{
			var fields:Vector.<Object> = this[key];
			var i:int = fields ? fields.indexOf(value) : -1;
			if(i>=0) fields.splice(i,1);
		}
		public function getList(key:*):Vector.<Object>
		{
			var fields:Vector.<Object> = this[key];
			return fields;
		}
	}
}