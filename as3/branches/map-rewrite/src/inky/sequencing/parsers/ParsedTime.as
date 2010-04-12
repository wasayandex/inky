package inky.sequencing.parsers 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.30
	 *
	 */
	public class ParsedTime
	{
		public var time:Number;
		public var units:String;

		/**
		 *
		 */
		public function ParsedTime(time:Number, units:String = "milliseconds")
		{
			this.time = time;
			this.units = units;
		}
	}
	
}
