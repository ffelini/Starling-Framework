package utils
{
import flash.xml.XMLDocument;
import flash.xml.XMLNode;
import flash.xml.XMLNodeType;

import mx.rpc.xml.SimpleXMLDecoder;
import mx.rpc.xml.SimpleXMLEncoder;

public class XMLUtils
	{
		public function XMLUtils()
		{
		}
		public static function convertToXml(obj:Object,qname:String="root"):XML
		{
			var qName:QName = new QName(qname);
			var xmlDocument:XMLDocument = new XMLDocument();
			var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
			var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument);
			var xml:XML = new XML(xmlDocument.toString());
			return xml;
		}
		public static function convertToObject(xml:XML):Object
		{
			var simpleXMLEncoder:SimpleXMLDecoder = new SimpleXMLDecoder(false);
			var node:XMLNode = new XMLNode(XMLNodeType.XML_DECLARATION,xml.toString());
			return simpleXMLEncoder.decodeXML(node);
		}
	}
}