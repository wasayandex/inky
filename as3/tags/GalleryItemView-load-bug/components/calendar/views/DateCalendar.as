package inky.framework.components.calendar.views 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import inky.framework.components.calendar.views.IDateCalendar;
	import inky.framework.components.calendar.events.CalendarEvent;
	import inky.framework.components.calendar.models.DateModel;
	import inky.framework.formatters.DateFormatter;

	
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
	public class DateCalendar extends Sprite implements IDateCalendar
	{
		private var __labelField:TextField;
		private var __selectedIndicator:Sprite;
		private var _selected:Boolean;
		private var _model:DateModel;
		
		
		/**
		 *	
		 */
		public function DateCalendar()
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
		public function get model():DateModel
		{
			return this._model;
		}
		/**
		 * @private
		 */
		public function set model(model:DateModel):void
		{
			if (this._model)
			{
				this._model.removeEventListener(CalendarEvent.SELECTED_DATE_CHANGE, this._dateChangeHandler);
			}

			if (model)
			{
				model.addEventListener(CalendarEvent.SELECTED_DATE_CHANGE, this._dateChangeHandler, false, 0, true);
			}

			this._model = model;
this.dateUpdateHandler();
		}
		
		
		/**
		 *
		 */
		public function get selected():Boolean
		{
			return this._selected;
		}
		/**
		 * @private
		 */
		public function set selected(selected:Boolean):void
		{
			this._selected = selected;
			if (this.__selectedIndicator)
				this.__selectedIndicator.visible = selected;
		}
		



		//
		// private methods
		//
		
		
		/**
		 *	
		 */
		protected function dateUpdateHandler():void
		{
			if (this.__labelField)
				this.__labelField.text = new DateFormatter("D").format(this.model.selectedDate);
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
			this.__selectedIndicator = this.getChildByName('_selectedIndicator') as Sprite;
			
			this.selected = false;
		}
		
	}
	
}
