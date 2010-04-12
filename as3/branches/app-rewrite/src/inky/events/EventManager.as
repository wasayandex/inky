package inky.events 
{
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import inky.events.IRelayableEvent;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.23
	 *
	 */
	public class EventManager
	{
		// Stores a map of class names to getter functions. We can't use a dictionary with class keys because instances of classes that extend Proxy report the wrong constructor.
		private static var _getters:Object = {};




		//
		// public methods
		//


		/**
		 *	
		 */
		public static function dispatchEvent(event:Event, target:IEventDispatcher):void
		{
			if (event is IRelayableEvent)
			{
				var currentTarget:IEventDispatcher = target;

				do
				{
					IRelayableEvent(event).prepare(currentTarget, target);
					currentTarget.dispatchEvent(event);

					// Get the next target.
					currentTarget = EventManager._getNextTarget(currentTarget) as IEventDispatcher;
				}
// TODO: Add support for stopPropagation, etc.
				while (currentTarget);
			}
			else
			{
				target.dispatchEvent(event);
			}
		}


		/**
		 *	
		 */
		public static function registerNextTargetGetter(cls:Object, getter:Function):void
		{
			if (!(cls is Class))
				throw new ArgumentError("You can only register next target getters for classes (now)");
				
			var className:String = String(describeType(cls).@name);
			EventManager._getters[className] = getter;
		}
		
		
		private static function _getNextTarget(obj:Object):IEventDispatcher
		{
			var className:String = getQualifiedClassName(obj);
			var fn:Function = EventManager._getters[className] || EventManager._defaultNextTargetGetter;
			return fn(obj);
		}


		/**
		 *	
		 */
		private static function _defaultNextTargetGetter(currentTarget:IEventDispatcher):IEventDispatcher
		{
			var nextTarget:IEventDispatcher;
			if (Object(currentTarget).hasOwnProperty("parent"))
				nextTarget = Object(currentTarget).parent as IEventDispatcher;
			return nextTarget;
		}




	}
}