package inky.sequencing.parsers.xml
{
	import inky.sequencing.parsers.xml.AbstractXMLCommandParser;
	import inky.sequencing.commands.TraceCommand;
	
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
	public class TraceParser extends AbstractXMLCommandParser
	{
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function createCommand(xml:XML):Object
		{
			return new TraceCommand();
		}
		
	}
	
}