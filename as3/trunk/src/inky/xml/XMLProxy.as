package inky.xml 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import inky.utils.IEquatable;
	import inky.binding.events.PropertyChangeEvent;
	import inky.xml.XMLProxy;
	import inky.utils.EqualityUtil;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.17
	 *
	 */
	dynamic public class XMLProxy extends Proxy implements IEventDispatcher, IEquatable
	{
		private static var _constructorProperty:QName = new QName("constructor");
		private var _dispatcher:EventDispatcher;
	    private var _xml:XML;




		/**
		 *
		 * 
		 *
		 */	
	    public function XMLProxy(xml:XML)
	    {
			this._xml = xml;
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
			var fn:Function = this[methodName];
			return fn.apply(this, args);
	    }


		/**
		 * @private
		 */
	    override flash_proxy function deleteProperty(name:*):Boolean
		{
			return (delete this._xml[name]);
		} 


		/**
		 * @private
		 */
	    override flash_proxy function getDescendants(name:*):*
	    {
throw new Error("not yet implemented");
	    }


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
// FIXME: Values aren't returned in correct type (they're always returned as XML). Need some kind of ISerializable, and to store the types?
// FIXME: doesn't work with E4X filters (i.e. property accessors that return an XMLList)
			var value:*;
			
			if (EqualityUtil.objectsAreEqual(name, XMLProxy._constructorProperty))
				value = XMLProxy;
			else
				value = this._xml[name];

			return value;
	    }


		/**
		 * @private
		 */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
	        return name in this._xml;
	    }


		/**
		 * @private
		 */
		override flash_proxy function nextName(index:int):String
		{
throw new Error("not yet implemented");
		}


		/**
		 * @private
		 */
	    override flash_proxy function nextNameIndex(index:int):int
		{
throw new Error("not yet implemented");
		}


		/**
		 * @private
		 */
	    override flash_proxy function nextValue(index:int):*
	    {
throw new Error("not yet implemented");
	    }


		/**
		 * @private
		 */
	    override flash_proxy function setProperty(name:*, value:*):void
	    {
// FIXME: setting a property with an XML value is a little weird. i.e. proxy.a = <b />
			var oldValue:Object = this.flash_proxy::getProperty(name);
			if (value != oldValue)
			{
				this._xml[name] = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, name, oldValue, value));	
			}
	    }




		//
		// event dispatcher methods
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
			return this._xml.toString();
		}


		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return this._dispatcher.willTrigger(type);
		}


		/**
		 * @copy XML#toXMLString()
		 */
		public function toXMLString():String 
		{
			return this._xml.toXMLString();
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc	
		 */
		public function equals(obj:Object):Boolean
		{
			return this._propertiesAreEqual(this, obj) && this._propertiesAreEqual(obj, this);
		}




		//
		// private methods
		//


		/**
		 *
		 */
		private function _propertiesAreEqual(a:Object, b:Object):Boolean
		{
			var propertiesAreEqual:Boolean = true;
			for (var prop:Object in a)
			{
				if (a[prop] != b[prop])
				{
					propertiesAreEqual = false;
					break;
				}
			}
			return propertiesAreEqual;
		}




	}
}
