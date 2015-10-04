package utils
{
	public class cookie
	{
		public static function getAirCookie():String
		{
			return "javascript:window.location=document.cookie";
		}
		public static function setAirCookie(domain:String):void
		{
			
		}
		public function getCoockieFromString(cookieName:String,cookieVariable:String):String
		{
			var r:String = "";
			var search:String = cookieName + "=";
			
			if (cookieVariable.length > 0)
			{
				var offset:int = cookieVariable.indexOf(search);
				if (offset != -1)
				{
					offset += search.length;
					var end:int = cookieVariable.indexOf(";", offset);
					if (end == -1)
						end = cookieVariable.length;
					r = unescape(cookieVariable.substring(offset, end));
				}
			}
			return r;
		}
		public static function setCookie(cookieName:String, cookieValue:String):String
		{
			var js:String = "function sc(){";
			js += "var c = escape('" + cookieName + "') + '=' + escape('" + cookieValue + "') + '; path=/';";
			js += "document.cookie = c;";
			js += "}";
			
			return js;
		}
	}
}