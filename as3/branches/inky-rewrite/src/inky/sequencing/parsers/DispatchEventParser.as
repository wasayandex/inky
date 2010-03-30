package inky.sequencing.parsers 
{
	import inky.sequencing.commands.DispatchEventCommand;
	import inky.sequencing.parsers.AlternateSyntaxParser;
	
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
	public class DispatchEventParser extends AlternateSyntaxParser
	{
		private static const propertyMap:Object = {
			ofClass: "eventClass",
			on: "target",
			withType: "type"
		};
		
		/**
		 *
		 */
		public function DispatchEventParser()
		{
			super(DispatchEventCommand, DispatchEventParser.propertyMap);
		}
		
	}
	
}