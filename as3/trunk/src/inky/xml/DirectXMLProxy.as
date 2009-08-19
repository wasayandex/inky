package inky.xml 
{
	import inky.binding.events.PropertyChangeEvent;
	import inky.xml.XMLProxy;
	import flash.utils.flash_proxy;
	import inky.utils.EventDispatcherProxy;
	import inky.utils.EqualityUtil;
	import inky.binding.events.PropertyChangeEventKind;
	import inky.xml.XMLProxyManager;
	import inky.xml.IXMLProxy;
	import inky.xml.XMLListProxy;
	import inky.xml.events.XMLEvent;
	import inky.xml.xml_internal;
	import flash.events.Event;
	import inky.xml.events.XMLPropertyChangeEvent;

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
	dynamic internal class DirectXMLProxy extends EventDispatcherProxy implements IXMLProxy
	{
		private static var _constructorProperty:QName = new QName("constructor");
	    private var _source:XML;
		private static var _proxyManager:XMLProxyManager = XMLProxyManager.getInstance();




		/**
		 *
		 * 
		 *
		 */	
	    public function DirectXMLProxy(source:XML = null)
	    {
			this._source = source || <document />;
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
		 */
		public function appendChild(child:Object):void
		{
			if (!(child is IXMLProxy) && !(child is IXMLListProxy))
				throw new ArgumentError();

			this._source.appendChild(child.source);
			
			var event:XMLEvent = new XMLEvent(XMLEvent.ADDED);
			this._dispatchEvent(event);
// TODO: What should this return? Model it after E4X or DOM (https://developer.mozilla.org/En/DOM/Node.removeChild)
		}


		/**
		 *	
		 */
		public function child(propertyName:Object):IXMLListProxy
		{
			return new XMLListProxy(this._source.child(propertyName));
		}


		/**
		 *	
		 */
		public function children():IXMLListProxy
		{
			return new XMLListProxy(this._source.*);
		}


		/**
		 *	
		 */
		public function parent():*
		{
			return this._source.parent() ? _proxyManager.getProxy(this._source.parent()) : null;
		}


		/**
		 *	
		 */
		public function removeChild(child:Object):void
		{
			if (!(child is IXMLProxy) && !(child is IXMLListProxy))
				throw new ArgumentError();
			
			var parent:XML = child.source.parent();
			if (parent != this.source)
				throw new ArgumentError("The supplied element is not a child of this parent.");

			var event:XMLEvent = new XMLEvent(XMLEvent.REMOVED);
			this._dispatchEvent(event);

			delete parent.children()[child.source.childIndex()];
// TODO: What should this return? Model it after E4X or DOM (https://developer.mozilla.org/En/DOM/Node.removeChild)
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
		private function _dispatchEvent(event:Object):void
		{
// TODO: Add support for stopPropagation, etc. Probably a good idea to separate this functionality (the ability to bubble non-display object events) into an inky.events package.
			event.xml_internal::setCurrentTarget(this);
			event.xml_internal::setTarget(this);
			this.dispatchEvent(event as Event);

			if (event.bubbles)
			{
				var target:IXMLProxy;
				var node:XML = this._source.parent();
				while (node)
				{
					target = _proxyManager.getProxy(node, false);
					if (target)
					{
						event = event.clone();
						event.xml_internal::setCurrentTarget(target);
						event.xml_internal::setTarget(this);
						target.dispatchEvent(event as Event);
					}
					node = node.parent();
				}
			}
		}


		/**
		 *	
		 */
		private function _dispatchPropertyChangeEvent(name:String, oldValue:Object, newValue:Object, kind:String = "update"):void
		{
			// Dispatch PROPERTY_CHANGE.
			var event:XMLPropertyChangeEvent = new XMLPropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, true, false, kind, name, oldValue, newValue, this);
			this._dispatchEvent(event);
			
/*			// Dispatch CHANGE events. (Use this method instead of going up the proxy parent tree so that we don't create new proxies.)
			var xml:XML = this._source;
			var proxy:IXMLProxy = this;
			var event:XMLChangeEvent;
			while (xml)
			{
				if (proxy)
				{
					event = new XMLChangeEvent(XMLChangeEvent.CHANGE, this, changeEvent);
					proxy.dispatchEvent(event);
				}
				xml = xml.parent();
				proxy = _proxyManager.getProxy(xml, false) as IXMLProxy;
			}*/
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
			var value:*;

			if (Object.prototype.hasOwnProperty(name))
			{
				value = Object.prototype[name];
			}
			else if (EqualityUtil.objectsAreEqual(name, DirectXMLProxy._constructorProperty))
			{
// FIXME: This isn't the correct constructor.
				value = XMLProxy;
			}
			else
			{
				value = this._source[name];
// FIXME: Values aren't returned in correct type (they're always returned as XML). Need some kind of ISerializable, and to store the types?
				if (value is XML)
					value = _proxyManager.getProxy(value);
				else if (value is XMLList)
					value = new XMLListProxy(value);
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
				this._dispatchPropertyChangeEvent(name, oldValue, value);
			}
	    }




	}
}
