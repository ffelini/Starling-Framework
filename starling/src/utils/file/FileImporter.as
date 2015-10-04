package utils.file
{
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import utils.log;

public class FileImporter
	{
		public function FileImporter()
		{
		}
		public static function importObject(path:String,format:String):Object
		{
			try{
				var f:File = new File(path);
				var str:FileStream = new FileStream();
				str.open(f,FileMode.READ);
				
				switch(format)
				{
					case FileFormat.FORMAT_AMF_Bytearray:
					{
						return str.readObject();
						break;
					}
					case FileFormat.FORMAT_JSON:
					{
						return JSON.parse(str.readUTFBytes(str.bytesAvailable));
						break;
					}
					case FileFormat.FORMAT_XML:
					{
						return new XML(str.readUTFBytes(str.bytesAvailable));
						break;
					}
				}
				
				str.close();
				
				log(FileImporter,"importFile","format-"+format,path);
			}
			catch(e:Error){
				log(FileImporter,"error importing object - "+format,path,e.message);
			}
			
			return null;
		}
	}
}