package inky.validation
{
	import flash.events.EventDispatcher;
	import inky.binding.utils.BindingUtil;
	import inky.validation.IValidator;


	/**
	 *	
	 *	..
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Eric Eldredge
	 *	@author Matthew Tretter
	 *	@since  2008.11.17
	 *	
	 */
	public class DateValidator extends EventDispatcher implements IValidator
	{
		private var _dayProperty:Object;
		private var _daySource:Object;
		private var _monthProperty:Object;
		private var _monthSource:Object;
		private var _yearProperty:Object;
		private var _yearSource:Object;
		private var _property:Object;
		private var _required:Boolean;
		private var _source:Object;

		public var wrongDayError:String;
		public var wrongLengthError:String;
		public var wrongMonthError:String;
		public var wrongYearError:String;




		/**
		 *
		 *	
		 */
		public function DateValidator(yearSource:Object = null, yearProperty:Object = null, monthSource:Object = null, monthProperty:Object = null, daySource:Object = null, dayProperty:Object = null, required:Boolean = true)
		{
// TODO: Update constructor to also accept (dateSource:Object, dateProperty:Object, required:Boolean)
			this._init(yearSource, yearProperty, monthSource, monthProperty, daySource, dayProperty, required);
		}




		//
		// accessors
		//


		/**
		 *
		 *
		 *
		 */
		public function get dayProperty():Object
		{
			return this._dayProperty;
		}
		/**
		 * @private
		 */
		public function set dayProperty(dayProperty:Object):void
		{
			this._dayProperty = dayProperty;
		}


		/**
		 *
		 *
		 *
		 */
		public function get daySource():Object
		{
			return this._daySource;
		}
		/**
		 * @private
		 */
		public function set daySource(daySource:Object):void
		{
			this._daySource = daySource;
		}


		/**
		 *
		 *
		 *
		 */
		public function get monthProperty():Object
		{
			return this._monthProperty;
		}
		/**
		 * @private
		 */
		public function set monthProperty(monthProperty:Object):void
		{
			this._monthProperty = monthProperty;
		}


		/**
		 *
		 *
		 *
		 */
		public function get monthSource():Object
		{
			return this._monthSource;
		}
		/**
		 * @private
		 */
		public function set monthSource(monthSource:Object):void
		{
			this._monthSource = monthSource;
		}


		/**
		 * @inheritDoc
		 */
		public function get property():Object
		{
			return this._property;
		}
		/**
		 * @private
		 */
		public function set property(property:Object):void
		{
			this._property = property;
		}


		/**
		 * @inheritDoc
		 */
		public function get required():Boolean
		{
			return this._required;
		}
		/**
		 * @private
		 */
		public function set required(required:Boolean):void
		{
			this._required = required;
		}


		/**
		 * @inheritDoc
		 */
		public function get source():Object
		{
			return this._source;
		}
		/**
		 * @private
		 */
		public function set source(source:Object):void
		{
			this._source = source;
		}


		/**
		 *
		 *
		 *
		 */
		public function get yearProperty():Object
		{
			return this._yearProperty;
		}
		/**
		 * @private
		 */
		public function set yearProperty(yearProperty:Object):void
		{
			this._yearProperty = yearProperty;
		}


		/**
		 *
		 *
		 *
		 */
		public function get yearSource():Object
		{
			return this._yearSource;
		}
		/**
		 * @private
		 */
		public function set yearSource(yearSource:Object):void
		{
			this._yearSource = yearSource;
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function validate():ValidationResult
		{
			var dayErrors:Array = [];
			var monthErrors:Array = [];
			var yearErrors:Array = [];
			var day:Number = this._getDay();
			var month:Number = this._getMonth();
			var year:Number = this._getYear();

			// Validate the year.
			if (!isNaN(year))
			{
				if ((year < 0) || (year > 9999))
				{
					yearErrors.push(new ValidationError(this.wrongYearError));
				}
			}
			else if (this.required)
			{
				yearErrors.push(new ValidationError('Field is required.'));
			}

			// Validate the month.
			if (!isNaN(month))
			{
				if ((month < 1) || (month > 12))
				{
					monthErrors.push(this.wrongMonthError);
				}
			}
			else if (this.required)
			{
				monthErrors.push(new ValidationError('Field is required.'));
			}

			// Validate the day.
			if (!isNaN(day))
			{
				var d:Date = new Date(year, (month + 11) % 12, day);
				if (d.date != day)
				{
					dayErrors.push(new ValidationError(this.wrongDayError));
				}
			}
			else if (this.required)
			{
				dayErrors.push(new ValidationError('Field is required.'));
			}

			var dayResult:ValidationResult = new ValidationResult(dayErrors.length > 0, 'day', dayErrors);
			var monthResult:ValidationResult = new ValidationResult(monthErrors.length > 0, 'month', monthErrors);
			var yearResult:ValidationResult = new ValidationResult(yearErrors.length > 0, 'year', yearErrors);
			var result:ValidationResult = new ValidationResult(
				dayResult.isError || monthResult.isError || yearResult.isError,
				'date',
				[],
				{
					day: dayResult,
					month: monthResult,
					year: yearResult
				}
			);

			// Create the ValidationResultEvent
			var type:String = result.isError ? ValidationResultEvent.INVALID : ValidationResultEvent.VALID;
			var e:ValidationResultEvent = new ValidationResultEvent(type, false, false, result);
			this.dispatchEvent(e);
			return result;
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 */
		private function _getDay():Number
		{
			return this._getProp('day', 'date');
		}
		
		
		/**
		 *
		 *	
		 */
		private function _getMonth():Number
		{
			return this._getProp('month');
		}


		/**
		 *
		 *	
		 */
		private function _getProp(name:String, prop:String = null):Number
		{
			var value:Number;
			var property:Object = this[name + 'Property'];
			var source:Object = this[name + 'Source'];

			if (source && property)
			{
				value = parseInt(String(BindingUtil.evaluateBindingChain(source, property)));
			}
			else if (this.source && property)
			{
				value = parseInt(String(BindingUtil.evaluateBindingChain(this.source, property)));
			}
			else if (this.source && this.property)
			{
				value = parseInt(new Date(BindingUtil.evaluateBindingChain(this.source, this.property))[prop || name]);
			}

			return value;
		}


		/**
		 *
		 *	
		 */
		private function _getYear():Number
		{
			return this._getProp('year', 'fullYear');
		}


		/**
		 *
		 *	
		 */
		private function _init(yearSource:Object = null, yearProperty:Object = null, monthSource:Object = null, monthProperty:Object = null, daySource:Object = null, dayProperty:Object = null, required:Boolean = true):void
		{
			this.yearSource = yearSource;
			this.yearProperty = yearProperty;
			this.monthSource = monthSource;
			this.monthProperty = monthProperty;
			this.daySource = daySource;
			this.dayProperty = dayProperty;
			this.required = required;

			this.wrongDayError = 'Enter a valid day for the month.';
			this.wrongLengthError = 'Type the date in the format inputFormat.';
			this.wrongMonthError = 'Enter a month between 1 and 12.';
			this.wrongYearError = 'Enter a year between 0 and 9999.';
		}




	}
}
