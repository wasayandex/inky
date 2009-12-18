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
	public class Validator extends EventDispatcher implements IValidator
	{
		private var _property:Object;
		private var _required:Boolean;
		private var _source:Object;
		private var _evaluator:Function;




		/**
		 *
		 *	
		 */
		public function Validator(source:Object = null, property:Object = null, evaluator:Function = null, required:Boolean = true)
		{
			this._init(source, property, evaluator, required);
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
		public function get evaluator():Function
		{
			return this._evaluator;
		}
		/**
		 * @private
		 */
		public function set evaluator(value:Function):void
		{
			this._evaluator = value;
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
				if (!this.evaluator.apply(null, [value]))
					errors.push(new ValidationError('The evaluation failed.'));
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
		private function _init(source:Object = null, property:Object = null, evaluator:Function = null, required:Boolean = true):void
		{
			this.source = source;
			this.property = property;
			this.evaluator = evaluator;
			this.required = required;
		}




	}
	
}