package inky.serialization.deserializers.xml
{
	import inky.serialization.deserializers.xml.IXMLDeserializer;
	import flash.utils.getDefinitionByName;
	import inky.serialization.deserializers.xml.AbstractXMLDeserializer;
	import inky.app.inky;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.11.16
	 *
	 */
	public class StandardDeserializer extends AbstractXMLDeserializer
	{
		

		/**
		 *	@inheritDoc
		 */
		override public function deserializeXML(data:XML):Object
		{
throw new Error("Not yet implemented");
			var qName:QName = data.name();

			var className:String = String(qName.uri).replace("*", "") + qName.localName;
			var cls:Class = getDefinitionByName(className) as Class;

			var result:Object = new cls();
			
			
			
			return result;
		}


		/**
		 * 
		 */
		public function getPropertyValue(data:XML, name:String, type:Class = null):*
		{
			var value:*;
			var matchingNodes:XMLList = data.child(name) + data.attribute(name);
			if (matchingNodes.length() > 1)
				throw new Error("Multiple values defined for \"" + name + "\" on " + data.name());

			if (type == String)
				value = matchingNodes.toString();
			
			return value;
		}




	}
	
}