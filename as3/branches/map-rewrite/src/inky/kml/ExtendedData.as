package inky.kml 
{
	import inky.kml.Data;
	import inky.collections.IList;
	import inky.collections.ICollection;
	import inky.collections.IListIterator;
	import inky.collections.IIterator;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.26
	 *
	 */
	public class ExtendedData implements IList
	{
		private var eventDispatcher:IEventDispatcher;
		private var _map:PropertyMap;
		private var _xml:XML;
		
		/**
		 *
		 */
		public function ExtendedData(xml:XML)
		{
			this.eventDispatcher = new EventDispatcher(this);
			this._xml = xml;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function get map():Object
		{
			if (!this._map)
				this._map = new PropertyMap(this, this._xml);
			return this._map;
		}
		
		//---------------------------------------
		// IKMLObject Implementation
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get xml():XML
		{
			return this._xml;
		}
		
		//---------------------------------------
		// IList Implementation
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function addItemAt(item:Object, index:int):void
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function addItemsAt(collection:ICollection, index:int):void
		{
throw new Error("Not implemented");	
		}

		/**
		 * @inheritDoc
		 */
		public function getItemAt(index:int):Object
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function getItemIndex(item:Object):int
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function getSubList(fromIndex:int, toIndex:int):IList
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function listIterator(index:int = 0):IListIterator
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function removeItemAt(index:int):Object
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function replaceItemAt(newItem:Object, index:int):Object
		{
throw new Error("Not implemented");
		}

		//---------------------------------------
		// ICollection Implementation
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function get isEmpty():Boolean
		{
			return this.xml.Data.length() == 0;
		}

		/**
		 * @inheritDoc
		 */
		public function get length():int
		{
			return this.xml.Data.length();
		}

		/**
		 * @inheritDoc
		 */
		public function addItem(item:Object):void
		{
throw new Error("Not implemented");	
		}

		/**
		 * @inheritDoc
		 */
		public function addItems(collection:ICollection):void
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function containsItem(item:Object):Boolean
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function containsItems(collection:ICollection):Boolean
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function removeAll():void
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function removeItem(item:Object):Object
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function removeItems(collection:ICollection):void
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function retainItems(collection:ICollection):void
		{
throw new Error("Not implemented");
		}

		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
throw new Error("Not implemented");
		}

		//---------------------------------------
		// IIterable Implementation
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function iterator():IIterator
		{
throw new Error("Not implemented");
		}

		//---------------------------------------
		// IEquatable Implementation
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function equals(obj:Object):Boolean
		{
throw new Error("Not implemented");
		}

		//---------------------------------------
		// IEventDispatcher Implementation
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			this.eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}


		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return this.eventDispatcher.dispatchEvent(event);
		}


		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean 
		{
			return this.eventDispatcher.hasEventListener(type);
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			return this.eventDispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return this.eventDispatcher.willTrigger(type);
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @copy Object#toString()
		 */
		public function toString():String 
		{
			return Object.prototype.toString.call(this);
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
/*		override protected function getProperty(propName:*):*
		{
			var dataList:XMLList = this.xml.children().(attribute('name').toString() == propName);
			if (dataList.length())
				return new Data(dataList[0]);
			return null;
		}
*/
		
	}
	
}


import flash.utils.Proxy;
import flash.utils.flash_proxy;
import inky.kml.ExtendedData;
import inky.kml.Data;
import inky.kml.kml;

class PropertyMap extends Proxy
{
	private var extendedData:ExtendedData;
	private var uniqueDataNodes:XMLList;
	private var xml:XML;
	
	/**
	 *
	 */
	public function PropertyMap(extendedData:ExtendedData, xml:XML)
	{
		this.extendedData = extendedData;
		this.xml = xml;
	}
	
	//---------------------------------------
	// Proxy methods
	//---------------------------------------

	/**
	 * @private
	 */
    override flash_proxy function callProperty(methodName:*, ... args):*
    {
		throw new Error("You can't call a method on the property map.");
    }


	/**
	 * @private
	 */
    override flash_proxy function deleteProperty(name:*):Boolean
	{
		throw new Error("You can't delete properties from the property map");
	} 

	/**
	 * @private
	 */
    override flash_proxy function getDescendants(name:*):*
    {
    	throw new TypeError("Error #1016: Descendants operator (..) not supported on this type.");
    }

	/**
	 * @private
	 */
    override flash_proxy function getProperty(propertyName:*):*
    {
		var list:XMLList = this.xml.kml::Data.(@name.toString() == propertyName);
		return list.length() == 0 ? null : new Data(list[0]);
    }

	/**
	 * @private
	 */
    override flash_proxy function hasProperty(propertyName:*):Boolean
    {
		return this.xml.kml::Data.(@name.toString() == propertyName).length() > 0;
	}

	/**
	 * @private
	 */
	override flash_proxy function nextName(index:int):String
	{
		return this.uniqueDataNodes[index - 1].@name;
	}

	/**
	 * @private
	 */
    override flash_proxy function nextNameIndex(index:int):int
	{
		// initial call
		if (index == 0)
			this.setupPropertyList();
     
		return index < this.uniqueDataNodes.length() ? index + 1 : 0;
	}

	/**
	 * @private
	 */
    override flash_proxy function nextValue(index:int):*
    {
		// initial call
		if (index == 0)
			this.setupPropertyList();

		return new Data(this.uniqueDataNodes[index]);
    }

	/**
	 * @private
	 */
    override flash_proxy function setProperty(name:*, value:*):void
    {
		throw new Error("You can't set data on a property map.");
    }

	/**
	 * 
	 */
	private function setupPropertyList():void
	{
		this.uniqueDataNodes = new XMLList();
		for each (var data:XML in this.xml.kml::Data)
		{
			if (this.isFirstNodeWithName(data))
				this.uniqueDataNodes += data;
		}
	}
	
	/**
	 * 
	 */
	private function isFirstNodeWithName(data:XML):Boolean
	{
		var key:String = data.@name;
		var nodesWithTheSameName:XMLList = this.xml.kml::Data.(@name == key);
		return (nodesWithTheSameName.length() == 1) || (data.childIndex() == nodesWithTheSameName[0].childIndex());
	}

	//---------------------------------------
	// PUBLIC METHODS
	//---------------------------------------

	/**
	 * @copy Object#toString()
	 */
	public function toString():String 
	{
		return Object.prototype.toString.call(this);
	}
		
}