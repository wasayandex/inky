package inky.data 
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.events.IEventDispatcher;
	import inky.utils.IEquatable;
	import inky.binding.events.PropertyChangeEvent;
	import inky.binding.events.PropertyChangeEventKind;
	import inky.utils.EventDispatcherProxy;
	import inky.utils.EqualityUtil;
	import inky.collections.E4XHashMap;
	import inky.data.XMLProxy;

	use namespace flash_proxy;


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
	dynamic public class XMLListProxy extends EventDispatcherProxy implements IEquatable
	{
		private static var _constructorProperty:QName = new QName("constructor");
		private var _document:XMLProxy;
	    private var _source:XMLList;




		/**
		 *
		 * 
		 *
		 */	
	    public function XMLListProxy(source:XMLList, document:XMLProxy = null)
	    {
			this._document = document || new XMLProxy(<root />);
			this._source = source;
	    }




		//
		// accessors
		//


		/**
		 *
		 */
		public function get source():XMLList
		{ 
			return this._source; 
		}
		/**
		 * @private
		 */
		public function set source(value:XMLList):void
		{
			this._source = value;
		}




		//
		// flash_proxy methods
		//


		/**
		 * @private
		 */
	    override flash_proxy function callProperty(methodName:*, ...args):*
	    {
			return this[methodName].apply(this, args);
	    }


		/**
		 * @private
		 */
	    override flash_proxy function deleteProperty(name:*):Boolean
		{
			var oldValue:* = this.flash_proxy::getProperty(name);
			var result:Boolean = delete this._source[name];
			if (result)
			{
				var event:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, PropertyChangeEventKind.DELETE, name, oldValue, undefined, this)
				this.dispatchEvent(event);	
			}
			return result;
		} 


		/**
		 * @private
		 */
	    override flash_proxy function getDescendants(name:*):*
	    {
			return this._document.getProxy(this._source.descendants(name));
	    }


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
// FIXME: Values aren't returned in correct type (they're always returned as XML). Need some kind of ISerializable, and to store the types?
			var value:*;

			if (Object.prototype.hasOwnProperty(name))
			{
				value = Object.prototype[name];
			}
			else if (EqualityUtil.objectsAreEqual(name, XMLListProxy._constructorProperty))
			{
				value = XMLListProxy;
			}
			else
			{
				value = this._source[name];
				
				if (value is XML || value is XMLList)
					value = this._document.getProxy(value);
			}

			return value;
	    }


		/**
		 * @private
		 */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
	        return name in this._source;
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
				this._source[name] = value;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, name, oldValue, value));	
			}
	    }


		/**
		 * @copy Object#toString()
		 */
		public function toString():String 
		{
			return this._source.toString();
		}


		/**
		 * @copy XML#toXMLString()
		 */
		public function toXMLString():String 
		{
			return this._source.toXMLString();
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc	
		 */
		public function equals(obj:Object):Boolean
		{
			return this == obj;
		}







	}
}
