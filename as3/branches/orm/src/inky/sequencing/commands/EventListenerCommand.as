package inky.sequencing.commands 
{
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.events.Event;
	import inky.sequencing.commands.IAsyncCommand;
	import flash.utils.describeType;
	import flash.events.EventDispatcher;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.30
	 *
	 */
	public class EventListenerCommand extends EventDispatcher implements IAsyncCommand
	{
		public var eventClass:Object;
		public var eventType:String;
		public var target:IEventDispatcher;
		public var useCapture:Boolean = false;
		public var priority:int = 0;
		public var useWeakReference:Boolean = false;
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get isAsync():Boolean
		{
			return false;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			if (!this.target)
				throw new Error("There is no target specified.");
			else if (!this.eventType)
				throw new Error("There is no eventType specified.");

			this.target.addEventListener(this.eventType, this.eventHandler, this.useCapture, this.priority, this.useWeakReference);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function eventHandler(event:Event):void
		{
			// Make sure the event is of the right class.
			if (this.eventClass)
			{
				var className:String;
				if (this.eventClass is String)
					className = String(this.eventClass);
				else if (this.eventClass is Class)
					className = String(describeType(Class(this.eventClass)).@name);
				else
					throw new Error("Invalid eventClass value.");

				className = className.replace(/::/, ".");
				if (getQualifiedClassName(event).replace(/::/, ".") != className)
					return;
			}
			
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.onComplete();
		}

		/**
		 * 
		 */
		private function onComplete():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
	
}