package inky.xml
{
	import inky.xml.IXMLProxy;
	import inky.xml.events.XMLEvent;
	import inky.collections.ListProxy;
	import inky.xml.XMLProxy;
	import inky.collections.IIterator;
	import inky.collections.ICollection;
	import inky.xml.IXMLListProxy;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.20
	 *
	 */
	public class XMLChildrenList extends ListProxy implements IXMLListProxy
	{
		private var _node:IXMLProxy;

		/**
		 *
		 */
		public function XMLChildrenList(xml:Object)
		{
			var proxy:IXMLProxy;
			if (xml is XML)
				proxy = new XMLProxy(xml as XML);
			else if (xml is IXMLProxy)
				proxy = xml as IXMLProxy;

			if (proxy)
			{
				super(proxy.children());
				proxy.addEventListener(XMLEvent.ADDED, this._addedHandler, false, 0, true);
				proxy.addEventListener(XMLEvent.CHILD_REMOVED, this._childRemovedHandler, false, 0, true);
				this._node = proxy;
			}
			else
			{
				throw new ArgumentError("XMLChildrenList() only accepts an XML or IXMLProxy object");
			}
		}




		//
		// accessors
		//


		/**
		 *
		 */
		public function get source():XMLList
		{ 
			return this._node.source.children();
		}




		//
		// public methods
		//


		/**
		 *	@inheritDoc
		 */
		override public function addItem(item:Object):void
		{
			this._node.appendChild(item);
		}


		/**
		 *	@inheritDoc
		 */
		override public function addItemAt(item:Object, index:int):void
		{
			var length:int = this._node.children().length;

			if (index < 0 || (length && index >= length))
				throw new RangeError("index " + index + " is out of bounds.");
				
			if (length)
				this._node.insertChildBefore(this._node.children().getItemAt(index), item);
			else
				this._node.appendChild(item);
		}


		/**
		 *	@inheritDoc
		 */
		override public function addItems(collection:ICollection):void
		{
throw new Error("not yet implemented");
		}


		/**
		 *	@inheritDoc
		 */
		override public function addItemsAt(collection:ICollection, index:int):void
		{
throw new Error("not yet implemented");
		}


		/**
		 *	@inheritDoc
		 */		
		override public function removeAll():void
		{
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				this._node.removeChild(i.next());
			}
		}


		/**
		 *	@inheritDoc
		 */		
		override public function removeItem(item:Object):Object
		{
			this._node.removeChild(item);
			return item;
		}


		/**
		 *	@inheritDoc
		 */
		override public function removeItemAt(index:int):Object
		{
			if (index < 0 || index >= this.length)
				throw new RangeError();
			
			var item:Object = this.getItemAt(index);
			this._node.removeChild(item);
			return item;
		}


		/**
		 *	@inheritDoc
		 */
		override public function removeItems(collection:ICollection):void
		{
throw new Error("not yet implemented");
		}


		/**
		 *	@inheritDoc
		 */
		override public function replaceItemAt(newItem:Object, index:int):Object
		{
throw new Error("not yet implemented");
		}


		/**
		 *	@inheritDoc
		 */		
		override public function retainItems(collection:ICollection):void
		{
throw new Error("not yet implemented");
		}


		/**
		 *	@inheritDoc
		 */
		public function toXMLString():String
		{
			return this._node.source.children().toXMLString();
		}




		//
		// private methods
		//


		/**
		 *	
		 */
		private function _addedHandler(event:XMLEvent):void
		{
			var relatedNode:IXMLProxy = event.relatedNode;
			
			// Make sure the event isn't just bubbling through this node.
			if (this._node.equals(relatedNode.parent()))
			{
				super.addItemAt(relatedNode, relatedNode.childIndex());
			}
		}


		/**
		 *	
		 */
		private function _childRemovedHandler(event:XMLEvent):void
		{
			// Make sure the event isn't just bubbling through this node.
			if (this._node.equals(event.target))
				super.removeItem(event.relatedNode);
		}




	}
}