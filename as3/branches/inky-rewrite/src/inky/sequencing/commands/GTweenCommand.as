package inky.sequencing.commands 
{
	import com.gskinner.motion.GTween;
	import inky.utils.describeObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import inky.sequencing.commands.IAsyncCommand;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.31
	 *
	 */
	public class GTweenCommand extends EventDispatcher implements IAsyncCommand
	{
		private var _isComplete:Boolean;
		public var tween:GTween;
		public var tweenProperties:Object = {};
		public var targetValues:Object = {};
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get isComplete():Boolean
		{
			return this._isComplete;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			this._isComplete = false;
			this.tween = new GTween();
			var prop:String;
			for (prop in this.tweenProperties)
			{
				this.tween[prop] = this.tweenProperties[prop];
			}
			this.tween.dispatchEvents = true;
			this.tween.addEventListener(Event.COMPLETE, this.tween_completeHandler);
			this.tween.setValues(this.targetValues);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function tween_completeHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this._isComplete = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
	
}