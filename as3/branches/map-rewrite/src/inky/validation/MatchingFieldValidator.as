package inky.validation 
{
	import flash.events.EventDispatcher;
	import inky.binding.utils.BindingUtil;
	import inky.validation.IValidator;
	import inky.validation.events.ValidationResultEvent;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.11.22
	 *
	 */
	public class MatchingFieldValidator extends EventDispatcher implements IValidator
	{
		private var _emptyValues:Array;
		private var _otherSource:Object;
		private var _otherProperty:Object;
		private var _property:Object;
		private var _required:Boolean;
		private var _source:Object;
		private var _unmatchingFieldsErrorMessage:String;

		/**
		 *
		 *	
		 */
		public function MatchingFieldValidator(source:Object = null, property:Object = null, otherSource:Object = null, otherProperty:Object = null, unmatchingFieldsErrorMessage:String = null, required:Boolean = true)
		{
			this._init(source, property, otherSource, otherProperty, unmatchingFieldsErrorMessage, required);
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 *
		 */
		public function get otherProperty():Object
		{ 
			return this._otherProperty; 
		}
		/**
		 * @private
		 */
		public function set otherProperty(value:Object):void
		{
			this._otherProperty = value;
		}

		/**
		 *
		 */
		public function get otherSource():Object
		{ 
			return this._otherSource; 
		}
		/**
		 * @private
		 */
		public function set otherSource(value:Object):void
		{
			this._otherSource = value;
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
		 */
		public function get unmatchingFieldsErrorMessage():String
		{ 
			return this._unmatchingFieldsErrorMessage; 
		}
		/**
		 * @private
		 */
		public function set unmatchingFieldsErrorMessage(value:String):void
		{
			this._unmatchingFieldsErrorMessage = value;
		}
		

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function validate():ValidationResult
		{
			var errors:Array = [];
			var value:Object = BindingUtil.evaluateBindingChain(this.source, this.property);

			if (this.required && ([null, ""].indexOf(value) != -1))
			{
				errors.push(new ValidationError('Field is required.'));
			}
			else
			{
				var otherValue:Object = BindingUtil.evaluateBindingChain(this.otherSource, this.otherProperty);
				if (value != otherValue)
					errors.push(new ValidationError(this.unmatchingFieldsErrorMessage));
			}

			var result:ValidationResult = new ValidationResult(errors.length > 0, '', errors);
			
			// Create the ValidationResultEvent
			var type:String = result.isError ? ValidationResultEvent.INVALID : ValidationResultEvent.VALID;
			var e:ValidationResultEvent = new ValidationResultEvent(type, false, false, result);
			this.dispatchEvent(e);
			return result;
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 *
		 *	
		 */
		private function _init(source:Object = null, property:Object = null, otherSource:Object = null, otherProperty:Object = null, unmatchingFieldsErrorMessage:String = null, required:Boolean = true):void
		{
			this.source = source;
			this.property = property;
			this.otherSource = otherSource;
			this.otherProperty = otherProperty;
			this.required = required;
			if (this.unmatchingFieldsErrorMessage == null)
				this.unmatchingFieldsErrorMessage = "Field doesn't match.";
		}




	}
	
}