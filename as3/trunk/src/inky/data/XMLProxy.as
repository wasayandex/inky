package inky.data 
{
	import flash.events.EventDispatcher;
	import inky.utils.IEquatable;
	import inky.binding.events.PropertyChangeEvent;
	import inky.data.XMLProxy;
	import inky.collections.E4XHashMap;
	import inky.data.events.XMLChangeEvent;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import inky.utils.EventDispatcherProxy;
	import inky.utils.EqualityUtil;
	import inky.binding.events.PropertyChangeEventKind;
	import inky.utils.UIDUtil;
	import inky.collections.IMap;
	import flash.events.IEventDispatcher;

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
	dynamic public class XMLProxy extends EventDispatcherProxy implements IEquatable
	{
		private var _pool:E4XHashMap; // A pool used for non-parented lists.
		private var _pool2:E4XHashMap; // A pool used for "parented" lists (lists created with the children() function)
		private static var _constructorProperty:QName = new QName("constructor");
		private var _document:XMLProxy;
	    private var _source:XML;
		private var _propertyTypes:Dictionary;




		/**
		 *
		 * 
		 *
		 */	
	    public function XMLProxy(source:XML = null, document:XMLProxy = null)
	    {
			this._pool = new E4XHashMap(true);
			this._pool2 = new E4XHashMap(true);
			this._propertyTypes = new Dictionary(true);
			this._source = source || <document />;
			this._document = document || this;
			this._pool.putItemAt(this, source);
	    }




		//
		// accessors
		//


		/**
		 *
		 */
		public function get source():XML
		{ 
			return this._source; 
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


		/**
		 * @copy Object#toString()
		 */
		public function toString():String 
		{
			return this._source.toString();
		}




		//
		// xml methods
		//

// TODO: Add other XML methods


		/**
		 *	
		 **/
		/*public function appendChild(child:Object):Object
		{
			var proxy:Object = this.getProxy(child);
			
			if (proxy is XMLProxy)
				this.children().addItem(proxy);
			else if (proxy is XMLListProxy)
				this.children().addItems(proxy);
			else
				throw new ArgumentError("not yet implemented");

			return proxy;
		}

*/
		/**
		 *	
		 */
		public function child(propertyName:Object):XMLListProxy
		{
			return this.getListProxy(this._source.child(propertyName));
		}


		/**
		 *	
		 */
		public function children():XMLListProxy
		{
			return this.getListProxy(this._source.*, true, this._source);
		}


		/**
		 *	
		 */
		public function parent():*
		{
			return this._source.parent() ? this.getProxy(this._source.parent()) : null;
		}


		/**
		 * @copy XML#toXMLString()
		 */
		public function toXMLString():String 
		{
			return this._source.toXMLString();
		}




		//
		// private methods
		//


		/**
		 *	
		 */
		private function _dispatchPropertyChangeEvent(name:String, oldValue:Object, newValue:Object, kind:String = "update"):void
		{
			// Dispatch PROPERTY_CHANGE.
			var changeEvent:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, kind, name, oldValue, newValue, this);
			this.dispatchEvent(changeEvent);
			
			// Dispatch CHANGE events. (Use this method instead of going up the proxy parent tree so that we don't create new proxies.)
			var xml:XML = this._source;
			var proxy:XMLProxy = this;
			var event:XMLChangeEvent;
			while (xml)
			{
				if (proxy)
				{
					event = new XMLChangeEvent(XMLChangeEvent.CHANGE, this, changeEvent);
					proxy.dispatchEvent(event);
				}
				xml = xml.parent();
				proxy = this.getProxy(xml, false) as XMLProxy;
			}
		}




		//
		// internal methods
		//


		/**
		 *	
		 * 
		 *  @param create    Specifies whether to create a new proxy if one doesn't already exist.
		 */
		internal function getProxy(source:XML, create:Boolean = true, parent:XML = null):XMLProxy
		{
			return this._getProxy(source, create, parent) as XMLProxy;
		}	


		/**
		 *
		 * Note: If you try to get a proxy for a list using a parent other than one you used to get the proxy the first time, weird stuff will probably happen.
		 * 
		 * @param parent    The parent xml. This should only be passed for children lists, as it will enable the add* methods for the resultant list.	
		 * 
		 */
		private function _getProxy(source:Object, create:Boolean = true, parent:XML = null):Object
		{
			var proxy:Object;

			if (this._document != this)
			{
				proxy = this._document._getProxy(source, create, parent);
			}
			else
			{
				// Select the pool to use based on whether this is a parented list.
				var pool:IMap = parent ? this._pool2 : this._pool;

				proxy = pool.getItemByKey(source);
				if (!proxy && create)
				{
					if (source is XML)
						proxy = new XMLProxy(source as XML, this._document);
					else if (source is XMLList)
						proxy = new XMLListProxy(source as XMLList, this._document, parent);
					else
						throw new Error();
					pool.putItemAt(proxy, source);
				}
			}

			return proxy;
		}


		/**
		 *	
		 */
		internal function getListProxy(source:XMLList, create:Boolean = true, parent:XML = null):XMLListProxy
		{
			return this._getProxy(source, create, parent) as XMLListProxy;
		}




		//
		// flash_proxy methods
		//


		/**
		 * @private
		 */
	    override flash_proxy function callProperty(methodName:*, ...args):*
	    {
			var fn:Function = this[methodName] as Function;
			if (fn != null)
				return fn.apply(this, args);
			else
				throw new ArgumentError();
	    }


		/**
		 * @private
		 */
	    override flash_proxy function deleteProperty(name:*):Boolean
		{
			var oldValue:* = this.flash_proxy::getProperty(name);
			delete this._propertyTypes[name];
			var result:Boolean = delete this._source[name];
			if (result)
			{
				this._dispatchPropertyChangeEvent(name, oldValue, undefined, PropertyChangeEventKind.DELETE);
			}
			return result;
		} 


		/**
		 * @private
		 */
	    override flash_proxy function getDescendants(name:*):*
	    {
			throw new Error("XMLProxy does not support the descendants operator. Please use the descendants() method instead.");
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
			else if (EqualityUtil.objectsAreEqual(name, XMLProxy._constructorProperty))
			{
				value = XMLProxy;
			}
			else
			{
				value = this._source[name];

				// Convert the value to the correct type.
/*				if (this._propertyTypes[name])
				{
					var type:Class = this._propertyTypes[name] as Class;
					value = type(value);
				}
				else*/

				if (value is XML)
					value = this.getProxy(value);
				else if (value is XMLList)
					value = this.getListProxy(value, true);
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

				// Store the type for retrieval.
// TODO: Also allow for serializable non-primitive types.
// FIXME: Should type actually be stored in the XML so that the object could be deserialized? For example <prop blah:type="Number">5</prop>
				var type:Class;
				if (value is String)
					type = String;
				else if (value is Number)
					type = Number;
				else
					throw new ArgumentError();
//!				this._propertyTypes[name] = type;
				this._dispatchPropertyChangeEvent(name, oldValue, value);
			}
	    }




	}
}
