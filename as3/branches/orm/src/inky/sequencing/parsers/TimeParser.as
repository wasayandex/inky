package inky.sequencing.parsers 
{
	import inky.sequencing.parsers.ParsedTime;
	import inky.sequencing.parsers.TimeUnit;
	
	/**
	 *
	 *  Parses time from a string.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.30
	 *
	 */
	public class TimeParser
	{
// TODO: Extract this into part of a parsing library.
		private static const TIME_IN_MS:RegExp = /^(\d+)\s*ms$|^(\d+)\s*milliseconds?$/;
		private static const TIME_IN_SECS:RegExp = /^(\d+(\.\d+)?)\s*s$|^(\d+(\.\d+)?)\s*seconds?$|^(\d+(\.\d+)?)$/;
		private static const TIME_IN_FRAMES:RegExp = /^(\d+)\s*frames?$/;

		/**
		 * 
		 */
		public function parse(str:String):ParsedTime
		{
			str = str.toLowerCase();
			var units:String;
			var time:Number;
			var match:Object;
			var seconds:Number;
			
			if ((match = str.match(TIME_IN_FRAMES)))
			{
				units = TimeUnit.FRAMES;
				time = parseInt(match[1]);
			}
			else
			{
				units = TimeUnit.MILLISECONDS;
				
				if ((match = str.match(TIME_IN_MS)))
				{
					time = parseInt(match[1] || match[2]);
				}
				else if ((match = str.match(TIME_IN_SECS)))
				{
					seconds = parseFloat(match[1] || match[3] || match[5]);
					time = seconds * 1000;
				}
			}
			
			if (isNaN(time))
				throw new Error("Could not parse time " + str);
			
			return new ParsedTime(time, units);
		}
		
	}
	
}