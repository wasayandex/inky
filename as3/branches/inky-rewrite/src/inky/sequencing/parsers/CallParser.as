package inky.sequencing.parsers 
{
	import inky.sequencing.parsers.CommandParserUtil;
	import inky.sequencing.CommandData;
	import inky.sequencing.commands.CallCommand;
	
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
	public class CallParser implements ICommandDataParser
	{
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function parse(xml:XML, cls:Object):CommandData
		{
			xml = xml.copy();
			xml["@function"].setLocalName("callee");
			
			return new CommandData(
				new CallCommand(),
				CommandParserUtil.createInjectors(xml)
			);
		}
		
	}
	
}