package utils
{
public function log(instance:Object,message:String,...params):*
	{
		return LogStack.addLog(instance,message,params);
	}
}