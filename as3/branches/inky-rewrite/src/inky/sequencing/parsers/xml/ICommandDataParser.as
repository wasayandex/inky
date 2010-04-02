package inky.sequencing.parsers.xml
{
	import inky.sequencing.CommandData;
	
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
	public interface ICommandDataParser
	{
		
		/**
		 * @inheritDoc
		 */
		function parse(xml:XML, cls:Object):CommandData;
		
	}
	
}