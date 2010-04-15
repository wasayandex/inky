package inky.layout.validation 
{
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import inky.utils.IDestroyable;
	
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
	public class ValidationScheduler extends EventDispatcher implements IDestroyable
	{
		protected var callback:Function;
		protected var target:DisplayObject;
		protected var isInvalid:Boolean;
		private var _validateWhenNotVisible:Boolean;
		private static var _scheduledValidations:Dictionary = new Dictionary();

		/**
		 * Creates a new ValidationScheduler.
		 * 
		 * @param target
		 * 		The display object to be validated.
		 * 
		 * @param callback
		 * 		The method to be called upon validation.
		 * 
		 * @param validateWhenNotVisible
		 * 		@copy #validateWhenNotVisible
		 */
		public function ValidationScheduler(target:DisplayObject, callback:Function, validateWhenNotVisible:Boolean = false)
		{
			this.target = target;
			this.callback = callback;
			this.validateWhenNotVisible = validateWhenNotVisible;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Determines whether or not the target object will be validated if it is 
		 * removed from stage or visibility is made false after invalidation.
		 * <p><em>Note:</em> This property does not change invalidation behavior 
		 * if the target is not on stage at the time of invalidation. In that case, 
		 * the target validation is always deferred until after it is added to stage.</p>
		 * <p>If <code>true</code>, the <code>callback</code> will be called if the target 
		 * is removed from stage or made invisible after invalidation.</p>
		 * <p>If <code>false</code>, the <code>callback</code> will not be called if the 
		 * object is removed from stage or made invisible after invalidation. The 
		 * <code>callback</code> will not be validated if it is subsequently made 
		 * visible or added to stage.</p>
		 * 
		 * @default false
		 */
		public function get validateWhenNotVisible():Boolean
		{ 
			return this._validateWhenNotVisible; 
		}
		/**
		 * @private
		 */
		public function set validateWhenNotVisible(value:Boolean):void
		{
			this._validateWhenNotVisible = value;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			if (this.target)
			{
				this.target.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
				this.target.removeEventListener(Event.RENDER, this._validate);
				this.target.removeEventListener(Event.ENTER_FRAME, this._validate);
				this.isInvalid = false;
				this.target = null;
				this.callback = null;
			}
			
			delete _scheduledValidations[this];
		}
		
		/**
		 * Marks the layout as invalid, and schedules validation.
		 * If the target is not on stage at the time of invalidation, the validation
		 * isn't scheduled until after the target is added to stage.
		 */
		public function invalidate():void
		{
			if (!this.isInvalid)
			{
				this.isInvalid = true;
				_scheduledValidations[this] = null;

				if (this.target.stage)
					this.addListenersAndInvalidateStage();
				else
					this.target.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler, false, 0, true);
			}
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function addListenersAndInvalidateStage():void
		{
			this.target.addEventListener(Event.RENDER, this._validate, false, 0, true);
			this.target.addEventListener(Event.ENTER_FRAME, this._validate, false, 0, true);
			this.target.stage.invalidate();
		}

		/**
		 * 
		 */
		private function addedToStageHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.addListenersAndInvalidateStage();
		}
		
		/**
		 * 
		 */
		private function _validate(event:Event):void
		{
			event.currentTarget.removeEventListener(Event.RENDER, this._validate);
			event.currentTarget.removeEventListener(Event.ENTER_FRAME, this._validate);

			if (this.target && (this.validateWhenNotVisible || (this.target.stage && this.target.visible)))
				this.validate();

			this.isInvalid = false;
			delete _scheduledValidations[this];
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * This method may be overriden to perform custom validation routines in ValdiationScheduler subclasses.
		 */
		protected function validate():void
		{
			if (this.callback != null)
				this.callback();
		}


		

	}
	
}