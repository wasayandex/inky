package inky.framework.binding.utils
{
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.binding.utils.BindingUtil;
	import inky.framework.binding.utils.IChangeWatcher;


	/**
	 *
	 * @private
	 *	
	 * Based on Flex's mx.binding.utils.ChangeWatcher
	 * @see http://opensource.adobe.com/svn/opensource/flex/sdk/trunk/frameworks/projects/framework/src/mx/
	 * This should be considered an implementation detail.
	 *	
	 */
	public class ChangeWatcher implements IChangeWatcher
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
			this._getter = access is String ? null : access.getter;
			this._handler = handler;
			this._host = null;
			this._name = access is String ? access as String : access.name;
			this._next = next;
			
			if (access is String)
			{
				this._getter = null;
				this._name = access as String;
			}
			else
			{
				this._getter = access.getter;
				this._name = access.name;
				this._events = access.eventType != null ? access.eventType is Array ? access.eventType : [access.eventType] : null;
			}
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
			if (newHost != this._host)
			{
				var eventType:String;
				var eventTypes:Array;

				// Remove the event listeners from the current host.
				if (this._host != null)
				{
					eventTypes = this._events || BindingUtil.getPropertyBindingEvents(this._host.constructor, this._name);
					for each (eventType in eventTypes)
					{
						this._host.removeEventListener(eventType, this._wrappedHandler);
					}
				}

				this._host = newHost;

				// Add listeners to the new host.
				if (this._host != null)
				{
					eventTypes = this._events || BindingUtil.getPropertyBindingEvents(this._host.constructor, this._name);
					for each (eventType in eventTypes)
					{
						this._host.addEventListener(eventType, this._wrappedHandler, false, 0, false);
					}
				}

				// Reset the next item in the chain.
				if (this._next)
				{
					this._next.reset(this._getHostPropertyValue());
				}
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
		private function _wrappedHandler(e:Event):void
		{
			if (this._next)
			{
				this._next.reset(this._getHostPropertyValue());
			}

			if (e is PropertyChangeEvent)
			{
				if ((e as PropertyChangeEvent).property == this._name)
				{
					this._handler(e as PropertyChangeEvent);
				}
			}
			else
			{
				this._handler(e);
			}
		}




	}
}
