package inky.sequencing.parsers.xml
{
	import inky.sequencing.commands.CallCommand;
	import inky.sequencing.parsers.xml.AbstractXMLCommandParser;
	
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
	public class CallParser extends AbstractXMLCommandParser
	{
		/**
		 *
		 */
		public function CallParser()
		{
			this.propertyMap = {
				"function": "callee"
			}
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function createCommand(xml:XML):Object
		{
			return new CallCommand();
		}
		
	}
	
}