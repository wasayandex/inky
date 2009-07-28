package inky.formatters
{

	/**
	 *
	 * The DateFormatter class uses a format String to render date and time Strings from a String or a Date object. You can create many variations easily, including international formats.
	 *	
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter (matthew@exanimo.com)
	 * @since  2008.02.12
	 *
	 */
	public class DateFormatter
	{
		private static var _dayNamesLong:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		private static var _dayNamesShort:Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
		private static var _keywords:Array = ["YYYYY", "YYYY", "YY", "MMMM", "MMM", "MM", "M", "DD", "D", "EEEE", "EEE", "EE", "E", "A", "JJ", "J", "HH", "H", "KK", "K", "LL", "L", "NN", "N", "SS", "S"];
		private static var _monthNamesLong:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		private static var _monthNamesShort:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct","Nov", "Dec"];
		
		private var _formatString:String;
		private var _tokenizedFormatString:Array;


		/**
		 *
		 * Creates a new DateFormatter instance.
		 * 
		 * @param formatString
		 *     The mask pattern.
		 *	
		 */
		public function DateFormatter(formatString:String = null)
		{
			this.formatString = formatString;
		}




		//
		// accessors
		//
		
		
		/**
		 *
		 * The mask pattern. You compose a pattern String using specific
		 * uppercase letters, for example: YYYY/MM. The DateFormatter pattern
		 * String can contain other text in addition to pattern letters.
		 * Supported letters are the same as the Flex versio of this class.
		 * 
		 * @see http://livedocs.adobe.com/flex/3/langref/mx/formatters/DateFormatter.html#formatString		 		 
		 *		 
		 */		 		 		
		public function get formatString():String
		{
			return this._formatString;
		}
		/**
		 * @private
		 */		 		
		public function set formatString(formatString:String):void
		{
			this._formatString = formatString;
			this._compile();
		}




		//
		// public methods
		//


		/**
		 *
		 * Generates a date-formatted String from either a date-formatted String
		 * or a Date object. The formatString property determines the format of
		 * the output String.
		 * 
		 * @param value
		 *     Date to format. This can be a Date object, or a date-formatted
		 *     String such as "Thursday, April 22, 2004".
		 * @return
		 *     Formatted String.
		 *	
		 */
		public function format(value:Object):String
		{
			var date:Date = value as Date;
			if (!date)
			{
				throw new Error("DateFormatter.format currently only accepts Date objects");
			}
			
			var result:String = "";
			for each (var token:Object in this._tokenizedFormatString)
			{
				if (token is String)
				{
					result += token;
				}
				else
				{
					result += this._translateKeyword(token.keyword, date);
				}
			}
			return result;
		}




		//
		// private methods
		//


		/**
		 *
		 * Parses the formatString and creates an tokenized object that can be
		 * reused by the DateFormatter multiple times.
		 *	
		 */
		private function _compile():void
		{
			if (this.formatString)
			{
				var tmp:Array = [this.formatString];
				for each (var keyword:String in DateFormatter._keywords)
				{
					tmp = this._tokenize(tmp, keyword);
				}
				this._tokenizedFormatString = tmp;
			}
			else
			{
				this._tokenizedFormatString = null;
			}
		}


		/**
		 *
		 * Formats a number with a correct number of digits.
		 *	
		 */
		private function _formatNumber(number:Number, numDigits:int):String
		{
			var result:String = number.toString();
			for (var i:uint = result.length; i < numDigits; i++)
			{
				result = "0" + result;
			}
			return result;
		}


		/**
		 *
		 *	
		 *	
		 */
		private function _tokenize(a:Array, keyword:String):Array
		{
			// Tokenize the Array.
			for (var i:int = a.length - 1; i >= 0; i--)
			{
				var k:* = a[i];
				if (k is String)
				{
					var tmp:Array = k.split(keyword);
					for (var p:int = tmp.length - 1; p > 0; p -= 1)
					{
						tmp.splice(p, 0, {keyword: keyword});
					}
					tmp.unshift(1);
					tmp.unshift(i);
					a.splice.apply(null, tmp);
				}
			}
			return a;
		}


		/**
		 *
		 *	
		 *	
		 */
		private function _translateKeyword(keyword:String, date:Date):String
		{
			var hours:int;
			
			switch (DateFormatter._keywords.indexOf(keyword))
			{
				case 0:
					return this._formatNumber(date.fullYear, 5);
				case 1:
					return date.fullYear.toString();
				case 2:
					return date.fullYear.toString().substr(2);
				case 3:
				 	return DateFormatter._monthNamesLong[date.month];
				case 4:
					return DateFormatter._monthNamesShort[date.month];
				case 5:
					return this._formatNumber(date.month, 2);
				case 6:
					return date.month.toString();
				case 7:
					return this._formatNumber(date.date, 2);
				case 8:
					return date.date.toString();
				case 9:
					return DateFormatter._dayNamesLong[date.day];
				case 10:
					return DateFormatter._dayNamesShort[date.day];
				case 11:
					return this._formatNumber(date.day, 2);
				case 12:
					return date.day.toString();
				case 13:
					return date.hours < 12 ? "AM" : "PM";
				case 14:
					return this._formatNumber(date.hours, 2);
				case 15:
					return date.hours.toString();
				case 16:
					return this._formatNumber(date.hours == 0 ? 24 : date.hours, 2);
				case 17:
					return (date.hours == 0 ? 24 : date.hours).toString();
				case 18:
					return this._formatNumber(date.hours % 12, 2);
				case 19:
					return (date.hours % 12).toString();
				case 20:
					hours = date.hours % 12;
					return this._formatNumber(hours == 0 ? 12 : hours, 2);
				case 21:
					hours = date.hours % 12;
					return (hours == 0 ? 12 : hours).toString();
				case 22:
					return this._formatNumber(date.minutes, 2);
				case 23:
					return date.minutes.toString();
				case 24:
					return this._formatNumber(date.seconds, 2);
				case 25:
					return date.seconds.toString();
			}
			return keyword;
		}




	}
}
