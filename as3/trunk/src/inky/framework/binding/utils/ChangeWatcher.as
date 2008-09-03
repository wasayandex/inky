package inky.framework.binding.utils
{
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import inky.framework.binding.events.PropertyChangeEvent;

	/**
	 *
	 * @private
	 *	
	 * Based on Flex's mx.binding.utils.ChangeWatcher
	 * @see http://opensource.adobe.com/svn/opensource/flex/sdk/trunk/frameworks/projects/framework/src/mx/
	 * This should be considered an implementation detail.
	 *	
	 */
	public class ChangeWatcher
	{
		private var _host:Object;
		private var _name:String;
		private var _getter:Function;
		private var _handler:Function;
		private var _next:ChangeWatcher;
		private var _events:Array;


		/**
		 *
		 */
		public function ChangeWatcher(access:Object, handler:Function, next:ChangeWatcher = null)
		{
			this._events = [];
			this._getter = access is String ? null : access.getter;
			this._handler = handler;
			this._host = null;
			this._name = access is String ? access as String : access.name;
			this._next = next;
		}




		//
		// public methods
		//


		/**
		 *
		 */
		public function getValue():Object
		{
			var value:Object;
			
			if (this._host == null)
			{
				value = null;
			}
			else if (this._next == null)
			{
				value = this._getHostPropertyValue();
			}
			else
			{
				value = this._next.getValue();
			}
			
			return value;
		}


		/**
		 *
		 */
		public function reset(newHost:Object):void
		{
			var eventType:String;

			// Remove the event listeners from the current host.
			if (this._host != null)
			{
				for each (eventType in this._events)
				{
					this._host.removeEventListener(eventType, this._wrappedHandler);
				}
				this._events = [];
			}

			this._host = newHost;

			// Add listeners to the new host.
			if (this._host != null)
			{
				this._events = ChangeWatcher._getEvents(this._host, this._name);
				for each (eventType in this._events)
				{
					this._host.addEventListener(eventType, this._wrappedHandler);
				}
			}

			// Reset the next item in the chain.
			if (this._next)
			{
				this._next.reset(this._getHostPropertyValue());
			}
		}


		/**
		 *
		 */
		public function setHandler(handler:Function):void
		{
			this._handler = handler;
			if (this._next)
			{
				this._next.setHandler(handler);
			}
		}


		/**
		 *
		 */
		public function unwatch():void
		{
			this.reset(null);
		}


		/**
		 *
		 */
		public static function watch(host:Object, chain:Object, handler:Function):ChangeWatcher
		{
			var watcher:ChangeWatcher;
			
			if (!(chain is Array))
			{
				chain = [chain];
			}

			if (chain.length > 0)
			{
				watcher = new ChangeWatcher(chain[0], handler, ChangeWatcher.watch(null, chain.slice(1), handler));
				watcher.reset(host);
			}

			return watcher;
		}




		//
		// private methods
		//


		/**
		 *
		 */
		private static function _getEvents(host:Object, name:String):Array
		{
// TODO: Allow some way to specify which events to use.
			return host is IEventDispatcher ? [PropertyChangeEvent.PROPERTY_CHANGE, Event.CHANGE] : [];
		}


		/**
		 *
		 */
		private function _getHostPropertyValue():Object
		{
			var value:Object;
			
			if (this._host == null)
			{
				value = null;
			}
			else if (this._getter != null)
			{
				value = this._getter(this._host);
			}
			else
			{
				value = this._host[this._name];
			}
			
			return value;
		}


		/**
		 *
		 */
		private function _wrappedHandler(event:Event):void
		{
			if (this._next)
			{
				this._next.reset(this._getHostPropertyValue());
			}

			if (event is PropertyChangeEvent)
			{
				if ((event as PropertyChangeEvent).property == this._name)
				{
					this._handler(event as PropertyChangeEvent);
				}
			}
			else
			{
				this._handler(event);
			}
		}




	}
}
