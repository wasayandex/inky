﻿package inky.data {	import flash.utils.Proxy;	import flash.utils.flash_proxy;	import flash.events.IEventDispatcher;	import inky.utils.IEquatable;	import inky.binding.events.PropertyChangeEvent;	import inky.binding.events.PropertyChangeEventKind;	import inky.utils.EventDispatcherProxy;	import inky.utils.EqualityUtil;	import inky.collections.E4XHashMap;	import inky.data.XMLProxy;	import inky.collections.IList;	import inky.collections.IListIterator;	import inky.collections.ICollection;	import inky.collections.IIterator;	import inky.collections.events.CollectionEvent;	import inky.collections.events.CollectionEventKind;	import inky.collections.ListIterator;	use namespace flash_proxy;	/**	 *	 *  ..	 *		 * 	@langversion ActionScript 3	 *	@playerversion Flash 9.0.0	 *	 *	@author Matthew Tretter	 *	@since  2009.08.17	 *	 */	dynamic public class XMLListProxy extends EventDispatcherProxy implements IList	{		private static var _constructorProperty:QName = new QName("constructor");		private var _document:XMLProxy;		private var _parent:XML;	    private var _source:XMLList;		/**		 *		 * 		 *		 */		    public function XMLListProxy(source:XMLList, document:XMLProxy = null, parent:XML = null)	    {			this._document = document || new XMLProxy(<root />);			this._source = source;			this._parent = parent;	    }		//		// accessors		//		/**		 *		 */		public function get source():XMLList		{ 			return this._source; 		}		/**		 * @private		 */		public function set source(value:XMLList):void		{			this._source = value;		}		//		// list methods		//		/**		 *	@inheritDoc		 */		public function addItemAt(item:Object, index:uint):void		{			this._addItemAt(item, index);		}						private function _addItemAt(item:Object, index:uint, dispatchEvent:Boolean = true):Boolean		{			if (!(item is XMLProxy))				throw new ArgumentError("Argument must be of type XMLProxy");							var parent:XML = this._getParent();			if (parent == null)			{				throw new Error("List does not have a common parent!");			}			var collectionChanged:Boolean = false;						var oldLocation:int = this.getItemIndex(item);			if (oldLocation != index)			{				collectionChanged = true;								// If the object is already in the list, remove it.				if (oldLocation != -1)					this.removeItemAt(oldLocation);								if (index == 0)					parent.prependChild(item.source);				else if (index == this.length)					parent.appendChild(item.source);				else				{					var previousChild:XMLProxy = this.getItemAt(index - 1) as XMLProxy;					if (previousChild)						parent.insertChildAfter(previousChild.source, item.source);					else						throw new RangeError("The supplied index (" + index + ") is out of bounds.");				}							if (dispatchEvent)				{					var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, oldLocation, [item]);					this.dispatchEvent(event);				}			}			return collectionChanged;		}		private function _addItemsAt(collection:ICollection, index:uint):void		{			var collectionChanged:Boolean = false;			for (var i:IIterator = collection.iterator(); i.hasNext(); )			{				var item:Object = i.next();				collectionChanged = collectionChanged || this._addItemAt(item, index + i, false);			}			if (collectionChanged)			{				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, collection.toArray());				this.dispatchEvent(event);			}		}		/**		 *	@inheritDoc		 */		public function addItemsAt(collection:ICollection, index:uint):void		{			this._addItemsAt(collection, index);		}		/**		 *	@inheritDoc		 */		public function getItemAt(index:uint):Object		{			return this._document.getProxy(this._source[index]);		}		/**		 *	@inheritDoc		 */		public function getItemIndex(item:Object):int		{			return this._source.contains(item) ? item.childIndex() : -1;		}		/**		 *	@inheritDoc		 */		public function getSubList(fromIndex:uint, toIndex:uint):IList		{			if (toIndex > this.length || fromIndex > toIndex || fromIndex < 0)				throw new RangeError();			var xml:XMLList = this._source.(childIndex() >= fromIndex && childIndex() < toIndex);			return this._document.getListProxy(xml, this._parent);		}		/**		 *	@inheritDoc		 */		public function iterator():IIterator		{			return new ListIterator(this);		}		/**		 *	@inheritDoc		 */		public function listIterator(index:uint = 0):IListIterator		{			return new ListIterator(this, index);		}		/**		 *	@inheritDoc		 */		public function removeItemAt(index:uint):Object		{			if (!(item is XMLProxy))				throw new ArgumentError("Argument must be of type XMLProxy");			if (index < 0 || index > this.length)				throw new RangeError("The supplied index (" + index + ") is out of bounds.");			var item:XMLProxy = this._document.getProxy(this._source[index]) as XMLProxy;			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, index, [item]);			this.dispatchEvent(event);			return item;		}		/**		 *	@inheritDoc		 */		public function replaceItemAt(newItem:Object, index:uint):Object		{throw new Error("not yet implemented");		}		/**		 *	@inheritDoc		 */		public function get length():uint		{			return this._source.length();		}		/**		 *	@inheritDoc		 */		public function addItem(item:Object):void		{			this._addItemAt(item, this.length);		}						/**		 *	@inheritDoc		 */		public function addItems(collection:ICollection):void		{			this._addItemsAt(collection, 0);		}				/**		 *	@inheritDoc		 */				public function containsItem(item:Object):Boolean		{			if (!(item is XMLProxy))				throw new ArgumentError("Argument must be of type XMLProxy");						return this._source.contains(item.source);		}				/**		 *	@inheritDoc		 */		public function containsItems(collection:ICollection):Boolean		{throw new Error("not yet implemented");		}						/**		 *	@inheritDoc		 */		public function isEmpty():Boolean		{			return this._source.length() == 0;		}				/**		 *	@inheritDoc		 */				public function removeAll():void		{			if (this.length > 0)			{				var removedItems:Array = this.toArray();								var len:int = this._source.length();				while (len)				{					delete this._source[0];					len--;				}									var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, 0, removedItems);				this.dispatchEvent(event);			}		}				/**		 *	@inheritDoc		 */				public function removeItem(item:Object):Object		{			if (!(item is XMLProxy))				throw new ArgumentError("Argument must be of type XMLProxy");			var index:int = this.getItemIndex(item);			if (index != -1)			{				delete this._source[index];				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, index, [item]);				this.dispatchEvent(event);			}						return item;		}						/**		 *	@inheritDoc		 */		public function removeItems(collection:ICollection):void		{throw new Error("not yet implemented");		}				/**		 *	@inheritDoc		 */				public function retainItems(collection:ICollection):void		{throw new Error("not yet implemented");		}				/**		 *	@inheritDoc		 */				public function toArray():Array		{// TODO: Don't create a new array every time, if possible.			var result:Array = [];			var len:int = this.length;			for (var i:int = 0; i < len; i++)			{				result[i] = this.getItemAt(i);			}			return result;		}		//		// flash_proxy methods		//		/**		 * @private		 */	    override flash_proxy function callProperty(methodName:*, ...args):*	    {			var fn:Function = this[methodName];			if (fn != null)				return fn.apply(this, args);			else				throw new ArgumentError();	    }		/**		 * @private		 */	    override flash_proxy function deleteProperty(name:*):Boolean		{			var oldValue:* = this.flash_proxy::getProperty(name);			var result:Boolean = delete this._source[name];			if (result)			{				var event:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false, PropertyChangeEventKind.DELETE, name, oldValue, undefined, this)				this.dispatchEvent(event);				}			return result;		} 		/**		 * @private		 */	    override flash_proxy function getDescendants(name:*):*	    {			return this._document.getProxy(this._source.descendants(name));	    }		/**		 * @private		 */	    override flash_proxy function getProperty(name:*):*	    {trace("\t" + name);// FIXME: Values aren't returned in correct type (they're always returned as XML). Need some kind of ISerializable, and to store the types?			var value:*;			if (Object.prototype.hasOwnProperty(name))			{				value = Object.prototype[name];			}			else if (EqualityUtil.objectsAreEqual(name, XMLListProxy._constructorProperty))			{				value = XMLListProxy;			}			else			{				value = this._source[name];								if (value is XML)					value = this._document.getProxy(value);				else if (value is XMLList)					value = this._document.getListProxy(value, null);			}			return value;	    }		/**		 * @private		 */	    override flash_proxy function hasProperty(name:*):Boolean	    {	        return name in this._source;	    }		/**		 * @private		 */		override flash_proxy function nextName(index:int):String		{throw new Error("not yet implemented");		}		/**		 * @private		 */	    override flash_proxy function nextNameIndex(index:int):int		{throw new Error("not yet implemented");		}		/**		 * @private		 */	    override flash_proxy function nextValue(index:int):*	    {throw new Error("not yet implemented");	    }		/**		 * @private		 */	    override flash_proxy function setProperty(name:*, value:*):void	    {// FIXME: setting a property with an XML value is a little weird. i.e. proxy.a = <b />			var oldValue:Object = this.flash_proxy::getProperty(name);			if (value != oldValue)			{				this._source[name] = value;				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, name, oldValue, value));				}	    }		/**		 * @copy Object#toString()		 */		public function toString():String 		{			return this._source.toString();		}		/**		 * @copy XML#toXMLString()		 */		public function toXMLString():String 		{			return this._source.toXMLString();		}		// public methods		//		/**		 * @inheritDoc			 */		public function equals(obj:Object):Boolean		{			return this == obj;		}		private function _getParent():XML		{			return this._parent || this._source.parent();		}	}}