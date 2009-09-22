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
	import inky.xml.XMLProxy;
	import inky.xml.XMLListProxy;
	import inky.xml.events.XMLEvent;
	import flash.events.Event;
	import inky.xml.events.XMLPropertyChangeEvent;
	import inky.events.EventManager;
	import flash.utils.getQualifiedClassName;

	use namespace flash_proxy;




	/**
	 *  Dispatched after a node has been added.
	 *
	 *  @eventType inky.xml.events.XMLEvent.ADDED
	 */
	[Event(name="added", type="inky.xml.events.XMLEvent")]
	
	
	/**
	 *  Dispatched after a child node has been removed.
	 *
	 *  @eventType inky.xml.events.XMLEvent.CHILD_REMOVED
	 */
	[Event(name="childRemoved", type="inky.xml.events.XMLEvent")]
	
	
	/**
	 *  Dispatched immediately before an element is removed. Dispatching the
	 *  element before the removal allows it to bubble up the tree, and
	 *  allows the user to access the parent node in the event handler. If you
	 *  need to perform an action after the removal has taken place, use
	 *  CHILD_REMOVED.
	 *
	 *  @eventType inky.xml.events.XMLEvent.REMOVED
	 */
	[Event(name="removed", type="inky.xml.events.XMLEvent")]
	

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
		EventManager.registerNextTargetGetter(DirectXMLProxy, DirectXMLProxy._getNextTarget);

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
			return (obj is IXMLProxy) && (this.source === obj.source);
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


		/**
		 *	@inheritDoc
		 */
		public function appendChild(child:Object):void
		{
			var childProxy:IXMLProxy;
			
			if (child is XML)
				childProxy = new XMLProxy(child as XML);
			else if (child is IXMLProxy)
				childProxy = child as IXMLProxy;
			else
				throw new ArgumentError("You cannot append children of type " + getQualifiedClassName(child));

			// Add the child to the dom.
			this._source.appendChild(childProxy.source);

			// Dispatch an ADDED event.
			this._dispatchEvent(new XMLEvent(XMLEvent.ADDED, childProxy), childProxy);
		}


		/**
		 *	@inheritDoc
		 */
		public function child(propertyName:Object):IXMLListProxy
		{
			return new XMLListProxy(this._source.child(propertyName));
		}


		/**
		 *	@inheritDoc
		 */
		public function childIndex():int
		{
			return this._source.childIndex();
		}


		/**
		 *	@inheritDoc
		 */
		public function children():IXMLListProxy
		{
			return new XMLListProxy(this._source.*);
		}


		/**
		 *	@inheritDoc
		 */
		public function descendants(name:Object = "*"):XMLListProxy
		{
			return new XMLListProxy(this._source.descendants(name));
		}


		/**
		 *	
		 */
		public function insertChildAfter(child1:Object, child2:Object):void
		{
			var child1Proxy:IXMLProxy;
			var child2Proxy:IXMLProxy;
	
			if (child1 is XML)
				child1Proxy = new XMLProxy(child1 as XML);
			else if (child1 is IXMLProxy)
				child1Proxy = child1 as IXMLProxy;
			else
				throw new ArgumentError();

			if (child2 is XML)
				child2Proxy = new XMLProxy(child2 as XML);
			else if (child2 is IXMLProxy)
				child2Proxy = child2 as IXMLProxy;
			else
				throw new ArgumentError();

			// Add the child to the dom.
			this._source.insertChildAfter(child1Proxy.source, child2Proxy.source);

			// Dispatch an ADDED event.
			this._dispatchEvent(new XMLEvent(XMLEvent.ADDED, child2Proxy), child2Proxy);
		}		


		/**
		 *	
		 */
		public function insertChildBefore(child1:Object, child2:Object):void
		{
			var child1Proxy:IXMLProxy;
			var child2Proxy:IXMLProxy;
	
			if (child1 is XML)
				child1Proxy = new XMLProxy(child1 as XML);
			else if (child1 is IXMLProxy)
				child1Proxy = child1 as IXMLProxy;
			else
				throw new ArgumentError();

			if (child2 is XML)
				child2Proxy = new XMLProxy(child2 as XML);
			else if (child2 is IXMLProxy)
				child2Proxy = child2 as IXMLProxy;
			else
				throw new ArgumentError();

			// Add the child to the dom.
			this._source.insertChildBefore(child1Proxy.source, child2Proxy.source);

			// Dispatch an ADDED event.
			this._dispatchEvent(new XMLEvent(XMLEvent.ADDED, child2Proxy), child2Proxy);
		}		


		/**
		 *	@inheritDoc
		 */
		public function localName():Object
		{
			return this._source.localName();
		}


		/**
		 *	@inheritDoc
		 */
		public function parent():*
		{
			return this._source.parent() ? _proxyManager.getProxy(this._source.parent()) : null;
		}


		/**
		 *	@inheritDoc
		 */
		public function removeChild(child:Object):void
		{
			var childProxy:IXMLProxy;
			
			if (child is XML)
				childProxy = new XMLProxy(child as XML);
			else if (child is IXMLProxy)
				childProxy = child as IXMLProxy;
			else
				throw new ArgumentError();
			
			var parent:XML = childProxy.source.parent();
			if (parent != this.source)
				throw new ArgumentError("The supplied element is not a child of this parent.");

			this._dispatchEvent(new XMLEvent(XMLEvent.REMOVED, childProxy), childProxy);

			delete parent.children()[childProxy.source.childIndex()];
			
			this._dispatchEvent(new XMLEvent(XMLEvent.CHILD_REMOVED, childProxy), this);
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
		private function _dispatchEvent(event:Event, target:IXMLProxy):void
		{
			EventManager.dispatchEvent(event, target);
		}


		/**
		 *	
		 */
		private function _dispatchPropertyChangeEvent(name:String, oldValue:Object, newValue:Object, kind:String = "update"):void
		{
			// Dispatch PROPERTY_CHANGE.
			var event:XMLPropertyChangeEvent = new XMLPropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, kind, name, oldValue, newValue, this);
			this._dispatchEvent(event, this);
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
				throw new ArgumentError(methodName + " is not a method.");
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
				else if (value is Boolean)
					type = Boolean;
				else
					throw new ArgumentError();
					
				// Add "@" if the name is an attribute, but doesn't start with "@":
				// Accessing o.@prop instead of o["@prop"] will result in the
				// name.localName property of the first argument lacking a @ character.
				// This is fine when we use the QName (because Flash knows magically
				// how to deal with it), but will result in the QName.toString() value
				// (which we're using for the PropertyChangeEvent's "property"" property
				// being incorrect.
				var propString:String;
				if (this.isAttribute(name) && (!name.localName || (name.localName.substr(0) != "@")))
					propString = "@" + name.localName;
				else
					propString = name.localName;

				this._dispatchPropertyChangeEvent(propString, oldValue, this[name]);
			}
	    }




		//
		//
		//


		/**
		 *	
		 */
		private static function _getNextTarget(currentTarget:Object):Object
		{
			return currentTarget.source.parent() ? _proxyManager.getProxy(currentTarget.source.parent()) : null;
		}




	}
}