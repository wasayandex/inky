package inky.framework.components.calendar.parsers 
{
	
	import inky.framework.components.calendar.models.DateModel;
	import inky.framework.components.calendar.models.EventModel;
	import inky.framework.components.calendar.models.MonthModel;
	import inky.framework.components.calendar.parsers.DateDataParser;
	import inky.framework.components.calendar.parsers.EventDataParser;
	import inky.framework.components.calendar.parsers.IDateDataParser;
	import inky.framework.components.calendar.parsers.IEventDataParser;
	import inky.framework.components.calendar.parsers.IMonthDataParser;
	import inky.framework.formatters.DateFormatter;
	import inky.framework.collections.ArrayList;
	import inky.framework.collections.E4XHashMap;

	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2009.03.18
	 *
	 */
	public class MonthDataParser implements IMonthDataParser
	{
		private var _dateDataParserClass:Class;
		private var _eventDataParserClass:Class;
		
		
		//
		// accessors
		//
		

		/**
		 *
		 */
		public function get dateDataParserClass():Class
		{
			return this._dateDataParserClass || DateDataParser;
		}
		/**
		 * @private
		 */
		public function set dateDataParserClass(dateDataParserClass:Class):void
		{
			this._dateDataParserClass = dateDataParserClass;
		}
		
		

		/**
		 *
		 */
		public function get eventDataParserClass():Class
		{
			return this._eventDataParserClass || EventDataParser;
		}
		/**
		 * @private
		 */
		public function set eventDataParserClass(eventDataParserClass:Class):void
		{
			this._eventDataParserClass = eventDataParserClass;
		}




		//
		// public methods
		//
		
		
		/**
		 *	
		 */
		public function parse(data:XML):MonthModel
		{
			var monthModel:MonthModel = new MonthModel();

			// Set the model properties
			for each (var prop:XML in data.attributes())
			{
				monthModel[String(prop.localName())] = String(prop);
			}

			var dates:Array = [];			
			for each (var eventXML:XML in data.event)
			{
				this._validateEventXML(eventXML);

				var date:Date = new Date(eventXML.@year, eventXML.@month - 1, eventXML.@date);
				
				var dateObj:Object = null;
				for (var i:int = 0; i < dates.length; i++)
				{
					if (dates[i].date.toString() == date.toString())
					{
						dateObj = dates[i];
						break;
					}
				}
				if (!dateObj)
				{
					dateObj = {date: date, data: <date />};
					dates.push(dateObj);
				}
				dateObj.data.appendChild(eventXML);
			}

			for (i = 0; i < dates.length; i++)
			{
				var dateDataParser:IDateDataParser = new this.dateDataParserClass();
				dateDataParser.eventDataParserClass = this.eventDataParserClass;

				var dateModel:DateModel = dateDataParser.parse(dates[i].data);
				dateModel.monthModel = monthModel;
				dateModel.selectDate(dates[i].date);
				monthModel.addDateModel(dateModel);
			}
			return monthModel;
		}


		
		
		//
		// private methods
		//
		
		
		/**
		 *	
		 */
		private function _validateEventXML(xml:XML):void
		{
			var attrs:Array = ["year", "month", "date"];
			for each (var attr:String in attrs)
			{
				if (!xml.attribute(attr))
					throw new Error("Event elements must have a " + attr + ' attribute.');
			}
		}
	}
	
}
