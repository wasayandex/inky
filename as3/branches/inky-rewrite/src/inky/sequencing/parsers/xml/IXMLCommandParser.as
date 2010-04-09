package inky.sequencing.parsers.xml
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.03.29
	 *
	 */
	public interface IXMLCommandParser
	{
		
		/**
		 * 
		 */
		function createCommand(xml:XML):Object;
		
		/**
		 * 
		 */
		function setCommandProperties(command:Object, properties:Object):void;
	}
	
}