package inky.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.SharedObject;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import inky.events.PropertyChangeEvent;
	import inky.events.PropertyChangeEventKind;


	/**
	 *
	 *  ..
	 * 
	 * 	@langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2008.06.04
	 *
	 */
	dynamic public class Model extends Proxy implements IEventDispatcher
	{
		private var _dispatcher:EventDispatcher;
	    private var _item:Object;
	    private var _propertyList:Array;
		private var _sharedObject:SharedObject;
public var cache:Boolean = true;

		/**
		 *
		 *
		 *
		 */	
	    public function Model()
	    {
	        this._item = {};
	        this._dispatcher = new EventDispatcher(this);
	    }




		//
		// flash_proxy methods
		//
		

		/**
		 * @private
		 */
	    override flash_proxy function callProperty(methodName:*, ... args):*
	    {
	    	throw new TypeError('Error #1006: ' + methodName + ' is not a function.');
	    }


		/**
		 * @private
		 */
	    override flash_proxy function deleteProperty(name:*):Boolean
		{
			if (name in this._item)
			{
				var oldValue:* = this._item[name];
				delete this._item[name];
				var e:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, PropertyChangeEventKind.DELETE, name, oldValue, null, this);
				this.dispatchEvent(e);
				return true;
			}
			return false;
		} 


		/**
		 * @private
		 */
	    override flash_proxy function getDescendants(name:*):*
	    {
	    	throw new TypeError('Error #1016: Descendants operator (..) not supported on type Model.');
	    }


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
			var value:*;
		
			if (this.cache)
			{
				try
				{
					var so:SharedObject = SharedObject.getLocal('testing');
					value = so.data[name];
				}
				catch (error:Error)
				{
				}
			}

			if (value == null)
			{
				value = this._item[name];
				if (this.cache && (value != null))
				{
					try
					{
						so.data[name] = value;
					}
					catch (error:Error)
					{
					}
				}
			}
			else
			{
				this._item[name] = value;
			}

			return value;
	    }


		/**
		 * @private
		 */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
	        return name in this._item;
	    }


		/**
		 * @private
		 */
		override flash_proxy function nextName(index:int):String
		{
			return this._propertyList[index - 1];
		}


		/**
		 * @private
		 */
	    override flash_proxy function nextNameIndex(index:int):int
		{
			// initial call
			if (index == 0)
			{
				this._setupPropertyList();
			}
	     
			return index < this._propertyList.length ? index + 1 : 0;
		}


		/**
		 * @private
		 */
	    override flash_proxy function nextValue(index:int):*
	    {
			// initial call
			if (index == 0)
			{
				this._setupPropertyList();
			}
	     
			return this._item[this._propertyList[index - 1]];
	    }


		/**
		 * @private
		 */
	    override flash_proxy function setProperty(name:*, value:*):void
	    {
	    	var oldValue:* = this._item[name];
			if (value != oldValue)
			{
				this._item[name] = value;

				if (this.cache)
				{
					try
					{
						var so:SharedObject = SharedObject.getLocal('testing');
						so.data[name] = value;
					}
					catch (error:Error)
					{
					}
				}

				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, name, oldValue, value));
			}
	    }




		//
		// private methods
		//
		

		/**
		 *
		 *
		 *
		 */
		private function _setupPropertyList():void
		{
			this._propertyList = [];
			for (var x:* in this._item)
			{
				this._propertyList.push(x);
			}
		}		 		 		 		




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			this._dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}


		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return this._dispatcher.dispatchEvent(event);
		}


		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean 
		{
			return this._dispatcher.hasEventListener(type);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			return this._dispatcher.removeEventListener(type, listener, useCapture);
		}


		/**
		 * @copy Object#toString()
		 */
		public function toString():String 
		{
			return this._item.toString.call(this);
		}


		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return this._dispatcher.willTrigger(type);
		}




	}
}
