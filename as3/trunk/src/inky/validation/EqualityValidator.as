﻿package inky.validation
{
	import flash.events.EventDispatcher;
	import inky.binding.utils.BindingUtil;
	import inky.validation.IValidator;
	import inky.validation.events.ValidationResultEvent;


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
	public class EqualityValidator extends EventDispatcher implements IValidator
	{
		private var _property:Object;
		private var _required:Boolean;
		private var _source:Object;
		private var _value:Object;




		/**
		 *
		 *	
		 */
		public function EqualityValidator(source:Object = null, property:Object = null, value:Object = null, required:Boolean = true)
		{
			this._init(source, property, value, required);
		}




		//
		// accessors
		//


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
		public function get value():Object
		{
			return this._value;
		}
		/**
		 * @private
		 */
		public function set value(value:Object):void
		{
			this._value = value;
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function validate():ValidationResult
		{
			var errors:Array = [];
			var value:Object = BindingUtil.evaluateBindingChain(this.source, this.property);

			if (value != null)
			{
				if (this.value != value)
				{
					errors.push(new ValidationError('The value does not match.'));
				}
			}
			else if (this.required)
			{
				errors.push(new ValidationError('Field is required.'));
			}

			var result:ValidationResult = new ValidationResult(errors.length > 0, '', errors);

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
		private function _init(source:Object = null, property:Object = null, value:Object = null, required:Boolean = true):void
		{
			this.source = source;
			this.property = property;
			this.value = value;
			this.required = required;
		}




	}
}