package inky.sequencing.parsers.xml 
{
	import inky.sequencing.parsers.xml.IXMLCommandParser;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.04.08
	 *
	 */
	public class AbstractXMLCommandParser implements IXMLCommandParser
	{
		protected var propertyMap:Object;
		protected var requiredProperties:Array;
		protected var formatters:Object;
		
		/**
		 * @inheritDoc
		 */
		public function createCommand(xml:XML):Object
		{
			throw new Error("You must override createCommand()");
		}
		
		/**
		 * @inheritDoc
		 */
		public function setCommandProperties(command:Object, properties:Object):void
		{
			for (var propertyName:String in properties)
			{
				var formattedPropertyName:String = this.propertyMap ? this.propertyMap[propertyName] || propertyName : propertyName;
				var formatter:Function = this.formatters ? this.formatters[formattedPropertyName] : null;
				var value:* =  properties[propertyName];
				var formattedValue:* = formatter != null ? formatter(value) : value;
				command[formattedPropertyName] = formattedValue;
			}
		}
		
	}
	
}