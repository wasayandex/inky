package inky.sequencing.commands 
{
	import com.gskinner.motion.GTween;
	import inky.utils.describeObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import inky.sequencing.commands.ICommand;
	
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
	public class GTweenCommand extends EventDispatcher implements ICommand
	{
		private var _isInstantaneous:Boolean = true;
		public var tween:GTween;
		public var tweenProperties:Object = {};
		public var targetValues:Object = {};
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get isInstantaneous():Boolean
		{ 
			return this._isInstantaneous; 
		}
		/**
		 * @private
		 */
		public function set isInstantaneous(value:Boolean):void
		{
			this._isInstantaneous = value;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			if (!this.tween)
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
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
	
}