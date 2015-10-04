package utils
{
import flash.utils.Dictionary;

public dynamic class DictionaryCounter extends Dictionary
	{
		public function DictionaryCounter(weakKeys:Boolean=false)
		{
			super(weakKeys);
		}
		public function getCount(key:*,defaultValue:int = 1,increment:int=0):int{			
			var screenObjects:int = 0;
			if(!this[key]) {
				screenObjects = 1;
			}
			else 
			{
				screenObjects = this[key];
				screenObjects += increment;
			}
			this[key] = screenObjects;
			
			return screenObjects;
		}
		public function incrementCount(key:*,increment:int=0):int{
			return getCount(key,1,increment);
		}
		public function setCount(key:*,count:int):int{
			var screenObjects:int = 0;
			if(!this[key]) {
				screenObjects = count;
			}
			else{
				screenObjects = this[key];
				screenObjects = count;
			}
			this[key] = screenObjects;
			
			return screenObjects;
		}
		public function resetCount(key:*):int
		{
			return setCount(key,0);
		}
	}
}