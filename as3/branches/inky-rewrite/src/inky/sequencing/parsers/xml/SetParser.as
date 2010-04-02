package inky.sequencing.parsers.xml
{
	import inky.sequencing.parsers.CommandParserUtil;
	import inky.sequencing.CommandData;
	import inky.sequencing.commands.SetCommand;
	import inky.sequencing.parsers.xml.ICommandDataParser;
	
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
	public class SetParser implements ICommandDataParser
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
			
			xml.@on.setLocalName("target");
			xml.@to.setLocalName("value");
			
			return new CommandData(
				new SetCommand(),
				CommandParserUtil.createInjectors(xml)
			);
		}
		
	}
	
}