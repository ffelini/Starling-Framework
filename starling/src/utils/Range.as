package utils
{
	public dynamic class Range extends Array
	{
		public var from:int;
		public var to:int;
		
		public function Range(from:int,to:int,_fillMassive:Boolean=true)
		{
			super();
			update(from,to,_fillMassive);
		}
		public static function fromString(value:String):Range
		{
			var from:int = parseInt(value.split("..")[0]);
			var to:int = parseInt(value.split("..")[1]);
			
			return new Range(from,to);
		}
		public function update(from:int,to:int,_fillMassive:Boolean=true):void
		{
			this.from = from;
			this.to = to;
			length = 0;
			
			if(_fillMassive) fillMassive(this as Array,from,to);
		}
		public static function fillMassive(massive:Array,from:int,to:int):Array
		{
			if(!massive) massive = [];
			
			for (var i:int=from;i<to;i++)
			{
				massive.push(i);
			}
			return massive;
		}
		public function getRandomValue():int
		{
			return (Math.floor(Math.random() * (to - from + 1)) + from);
		}
		public function toString():String
		{
			return from+".."+to;
		}
	}
}