package inky.components.calendar.views 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import inky.components.calendar.views.IDateCalendar;
	import inky.components.calendar.views.IMonthCalendar;
	import inky.components.calendar.events.CalendarEvent;
	import inky.components.calendar.models.MonthModel;
	import inky.components.calendar.models.DateModel;
	import inky.components.calendar.parsers.DateDataParser;
	import inky.components.calendar.utils.CalendarUtil;
	import inky.formatters.DateFormatter; 
	import inky.components.calendar.views.DateCalendar;
	import inky.components.listViews.IListView;
	import inky.collections.ArrayList;			

	
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
	public class MonthCalendar extends Sprite implements IMonthCalendar
	{
		private var _dateCalendarClass:Class;
		private var _dateListView:IListView;
		private var __labelField:TextField;
		private var _model:MonthModel;
		private var _year:uint;
		private var _month:uint;
		
		
		/**
		 *	
		 */
		public function MonthCalendar()
		{
			super();
			this._init();
		}



		
		//
		// accessors
		//
		

		/**
		 *
		 */
		public function get dateCalendarClass():Class
		{
			return this._dateCalendarClass || DateCalendar;
		}
		/**
		 * @private
		 */
		public function set dateCalendarClass(dateCalendarClass:Class):void
		{
			this._dateCalendarClass = dateCalendarClass;

			if (this._dateListView)
				this._dateListView.itemViewClass = dateCalendarClass;
		}


		/**
		 *
		 */
		public function get dateCalendarListView():IListView
		{
			return this._dateListView;
		}
		/**
		 * @private
		 */
		public function set dateCalendarListView(value:IListView):void
		{
			this._dateListView = value;
			value.itemViewClass = value.itemViewClass || this.dateCalendarClass;
		}
		
		
		/**
		 *
		 */
		public function get model():MonthModel
		{
			return this._model;
		}
		/**
		 * @private
		 */
		public function set model(model:MonthModel):void
		{
			if (this._model)
				this._model.removeEventListener(CalendarEvent.SELECTED_DATE_CHANGE, this._dateChangeHandler);

			if (model)
				model.addEventListener(CalendarEvent.SELECTED_DATE_CHANGE, this._dateChangeHandler, false, 0, true);

			this._model = model;

this.dateUpdateHandler();
		}




		//
		// protected methods
		//
		
		
		/**
		 *	
		 */
		protected function dateUpdateHandler():void
		{
			var year:uint = this.model.selectedDate.getFullYear();
			var month:uint = this.model.selectedDate.getMonth();

			if (this._month == month && this._year == year)
				return;

			this._year = year;
			this._month = month;
				
			if (this.__labelField)
				this.__labelField.text = new DateFormatter("MMMM").format(this.model.selectedDate);

			var firstDayOffset:uint = new Date(year, month, 1).getDay();
			var numDays:uint = CalendarUtil.getNumDaysInMonth(this.model.selectedDate) + firstDayOffset;

			var listModel:ArrayList = new ArrayList();
			var d:Date = new Date(year, month, 1 - firstDayOffset);
			for (var i:int = 0; i < numDays; i++)
			{
				listModel.addItem(this.model.getDateModel(d));
				d = new Date(d.fullYear, d.month, d.date + 1);
			}
			
			if (!this.dateCalendarListView)
				throw new Error('dateCalendarListView not set!');

			this.dateCalendarListView.model = listModel;
		}
		
		
		

		//
		// private methods
		//
		
		
		/**
		 *	
		 */
		private function _dateChangeHandler(e:CalendarEvent):void
		{
			this.dateUpdateHandler();
		}
		
		
		/**
		 *	
		 */
		private function _init():void
		{
			this.__labelField = this.getChildByName('_labelField') as TextField;
			this.dateCalendarListView = this.getChildByName('_dateCalendarListView') as IListView;
		}



	}
	
}
