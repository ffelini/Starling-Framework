package utils.file
{

import flash.display.BitmapData;
import flash.display.PNGEncoderOptions;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

import utils.XMLUtils;
import utils.log;

public class FileExporter
	{
		public function FileExporter()
		{
		}
		public static function saveObject(obj:Object,path:String,format:String):Object
		{
			try{				
				var f:File = new File(path);
				var stream:FileStream = new FileStream();
				stream.open(f,FileMode.WRITE);
				
				var obj:Object;
				
				if(obj is BitmapData)
				{
					var rect:Rectangle = new Rectangle(0,0,(obj as BitmapData).width,(obj as BitmapData).height);
					var ba:ByteArray = (obj as BitmapData).encode(rect,new PNGEncoderOptions(true),ba);
					obj = ba;
					stream.writeBytes(ba);
				}
				else
				{
					switch(format)
					{
						case FileFormat.FORMAT_AMF_Bytearray:
						{
							stream.writeObject(obj);
							break;
						}
						case FileFormat.FORMAT_JSON:
						{
							obj = JSON.stringify(obj);
							stream.writeUTFBytes(obj+"");
							break;
						}
						case FileFormat.FORMAT_STRING:
						{
							stream.writeUTFBytes(obj+"");
							break;
						}
						case FileFormat.FORMAT_XML:
						{
							var xml:XML = obj as XML;
							if(!xml) xml = XMLUtils.convertToXml(obj);
							obj = xml;
							
							stream.writeUTFBytes(xml.toString());
							break;
						}
					} 
				}
				stream.close();
				
				log(FileExporter,"saveObject","format-"+format,obj,path);
			}
			catch(e:Error){
				log(FileExporter,"error saving object - "+format,obj,path,e.message);
			}
			
			return obj;
		}
	}
}