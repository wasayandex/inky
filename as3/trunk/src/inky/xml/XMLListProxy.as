package inky.xml 
{
	import inky.collections.IList;
	import inky.collections.IListIterator;
	import inky.collections.ICollection;
	import inky.collections.IIterator;
	import flash.events.Event;
	import inky.xml.IXMLListProxy;


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
	public class XMLListProxy implements IXMLListProxy
	{
		private var _directProxy:DirectXMLListProxy;
		private static var _proxyManager:XMLProxyManager = XMLProxyManager.getInstance();


		/**
		 *
		 * 
		 *
		 */	
	    public function XMLListProxy(source:XMLList)
	    {
			this._directProxy = _proxyManager.getListProxy(source);
	    }




		//
		// accessors
		//


		/**
		 *
		 */
		public function get source():XMLList
		{ 
			return this._directProxy.source; 
		}




		//
		// list methods
		//


		/**
		 *	@inheritDoc
		 */
		public function addItem(item:Object):void
		{
			this._directProxy.addItem(item);
		}
		


		/**
		 *	@inheritDoc
		 */
		public function addItemAt(item:Object, index:uint):void
		{
			this._directProxy.addItemAt(item, index);
		}


		/**
		 *	@inheritDoc
		 */
		public function addItems(collection:ICollection):void
		{
			this._directProxy.addItems(collection);
		}


		/**
		 *	@inheritDoc
		 */
		public function addItemsAt(collection:ICollection, index:uint):void
		{
			this._directProxy.addItemsAt(collection, index);
		}


		/**
		 *	@inheritDoc
		 */		
		public function containsItem(item:Object):Boolean
		{
			return this._directProxy.containsItem(item);
		}


		/**
		 *	@inheritDoc
		 */
		public function containsItems(collection:ICollection):Boolean
		{
			return this._directProxy.containsItems(collection);
		}



		/**
		 *	@inheritDoc
		 */
		public function getItemAt(index:uint):Object
		{
			return this._directProxy.getItemAt(index);
		}


		/**
		 *	@inheritDoc
		 */
		public function getItemIndex(item:Object):int
		{
			return this._directProxy.getItemIndex(item);
		}


		/**
		 *	@inheritDoc
		 */
		public function getSubList(fromIndex:uint, toIndex:uint):IList
		{
			return this._directProxy.getSubList(fromIndex, toIndex);
		}


		/**
		 *	@inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return this._directProxy.isEmpty();
		}


		/**
		 *	@inheritDoc
		 */
		public function iterator():IIterator
		{
// FIXME: Does this need to be specific to this instance? (In case you iterator over different proxies of the same direct proxy)
			return this._directProxy.iterator();
		}


		/**
		 *	@inheritDoc
		 */
		public function get length():uint
		{
			return this._directProxy.length;
		}


		/**
		 *	@inheritDoc
		 */
		public function listIterator(index:uint = 0):IListIterator
		{
			return this._directProxy.listIterator(index);
		}


		/**
		 *	@inheritDoc
		 */		
		public function removeAll():void
		{
			this._directProxy.removeAll();
		}
		

		/**
		 *	@inheritDoc
		 */		
		public function removeItem(item:Object):Object
		{
			return this._directProxy.removeItem(item);
		}
		

		/**
		 *	@inheritDoc
		 */
		public function removeItemAt(index:uint):Object
		{
			return this._directProxy.removeItemAt(index);
		}


		/**
		 *	@inheritDoc
		 */
		public function removeItems(collection:ICollection):void
		{
			this._directProxy.removeItems(collection);
		}


		/**
		 *	@inheritDoc
		 */
		public function replaceItemAt(newItem:Object, index:uint):Object
		{
			return this.replaceItemAt(newItem, index);
		}


		/**
		 *	@inheritDoc
		 */		
		public function retainItems(collection:ICollection):void
		{
			return this._directProxy.retainItems(collection);
		}
		

		/**
		 *	@inheritDoc
		 */		
		public function toArray():Array
		{
			return this._directProxy.toArray();

		}




		//
		// public methods
		//


		/**
		 * @inheritDoc	
		 */
		public function equals(obj:Object):Boolean
		{
			return this._directProxy.equals(obj);
		}


		/**
		 * @copy Object#toString()
		 */
		public function toString():String 
		{
			return this._directProxy.toString();
		}




		//
		// xml methods
		//


		/**
		 * @copy XML#toXMLString()
		 */
		public function toXMLString():String 
		{
			return this._directProxy.toXMLString();
		}











		//
		// event dispatcher methods
		//


		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			this._directProxy.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}


		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return this._directProxy.dispatchEvent(event);
		}


		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean 
		{
			return this._directProxy.hasEventListener(type);
		}


		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			return this._directProxy.removeEventListener(type, listener, useCapture);
		}


		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return this._directProxy.willTrigger(type);
		}





















	}
}