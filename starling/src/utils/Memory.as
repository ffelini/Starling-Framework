package utils
{
import flash.system.System;

public class Memory
	{
		public static var MAX_RAM_MEMORY:Number = 1000;
		
		public function Memory()
		{
		}
		public static function getMemory(megabytes:Number=50):Boolean
		{
			if(privateMemory+megabytes<MAX_RAM_MEMORY) return true;
			return false;
		}
		public static function get freeMemory():Number
		{
			return Number( System.freeMemory / 1024 / 1024 );
		}
		public static function get totalMemory():Number
		{
			return Number( System.totalMemory / 1024 / 1024 );
		}
		public static function get privateMemory():Number
		{
			return Number( System.privateMemory / 1024 / 1024 );
		}
		public static function clearMemory():void
		{
			System.gc();
		}
	}
}