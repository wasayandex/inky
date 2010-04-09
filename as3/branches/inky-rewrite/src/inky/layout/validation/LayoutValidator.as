package inky.layout.validation 
{
	import flash.events.Event;
	import inky.layout.validation.ValidationScheduler;
	import inky.utils.ValidationState;
	import inky.utils.EqualityUtil;
	import flash.display.DisplayObject;
	import inky.utils.CloningUtil;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.08
	 *
	 */
	public class LayoutValidator extends ValidationScheduler
	{
		public var properties:Object;
		private var validatedProperties:Object;
		private var _validationState:ValidationState;
		private var validationCount:int;

		/**
		 * Creates a new LayoutValidator.
		 * 
		 * @param target
		 * 		The display object to be validated.
		 * 
		 * @param callback
		 * 		The method to be called upon validation.
		 * 
		 * @param validateWhenNotVisible
		 * 		@copy inky.layout.validation.ValidationScheduler#validateWhenNotVisible
		 */
		public function LayoutValidator(target:DisplayObject, callback:Function, validateWhenNotVisible:Boolean = false)
		{
			super(target, callback, validateWhenNotVisible);
			
			this._validationState = new ValidationState();
			this.properties = {};
			this.copyProperties(target, (this.validatedProperties = {}));
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * The validation state. This object can be used in the <code>callback</code> 
		 * to optimize redrawing and updating as much as possible.
		 * 
		 * <p>A callback should always updated the validation state by calling
		 * <code>markAllAsValid()</code> on this object.</p>
		 * 
		 * @see inky.utils.ValidationState
		 */
		public function get validationState():ValidationState
		{
			return this._validationState;
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * TODO: Describe this method's behavior.
		 */
		override protected function validate():void
		{
			var changedProps:Object = this.copyProperties(this.properties);

			if (++this.validationCount > 100)
				throw new Error("Recursive validation. Double Check that validationState.markAllPropertiesAsValid() is called in your validation method.")

			for (var prop:String in changedProps)
			{
				if (!EqualityUtil.objectsAreEqual(changedProps[prop], this.validatedProperties[prop]))
					this.validationState.markPropertyAsInvalid(prop);
			}
			
			this.copyProperties(changedProps, this.validatedProperties);
			super.validate();

			if (this.validationState.hasInvalidProperty || !EqualityUtil.propertiesAreEqual(changedProps, this.properties))
			{
				this.validate();
			}
			else
			{
				this.copyProperties(target, (this.validatedProperties = {}));
				this.validationCount = 0;
			}
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * Copies the properties of the source object to the target object. If no 
		 * target is provided, a new object is used.
		 * 
		 * @param source
		 * 		The object to copy properties from.
		 * 
		 * @param target
		 * 		The object to copy properties to. If no target is provided,
		 * 		a new object is used.
		 * 
		 * @return the target object.
		 */
		private function copyProperties(source:Object, target:Object = null):Object
		{
			if (!target)
				target = {};

			for (var prop:String in source)
				target[prop] = source[prop];

			return target;
		}
		
	}
	
}