package inky.sequencing.parsers.xml
{
	import inky.sequencing.parsers.xml.CallParser;
	import inky.sequencing.parsers.xml.DispatchEventParser;
	import inky.sequencing.parsers.xml.WaitParser;
	import inky.sequencing.parsers.xml.SetParser;
	import inky.sequencing.parsers.xml.LoadParser;
	import inky.sequencing.parsers.xml.TraceParser;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.09
	 *
	 */
	public class StandardParsers
	{
		/**
		 * 
		 */
		public static function install():void
		{
			CallParser.install();
			DispatchEventParser.install();
			WaitParser.install();
			SetParser.install();
			LoadParser.install();
			TraceParser.install();
		}

	}
	
}