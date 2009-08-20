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
				proxy.addEventListener(XMLEvent.ADDED, this._childrenChangeHandler, false, 0, true);
				proxy.addEventListener(XMLEvent.CHILD_REMOVED, this._childrenChangeHandler, false, 0, true);
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
		override public function addItemAt(item:Object, index:uint):void
		{
throw new Error("not yet implemented");
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
		override public function addItemsAt(collection:ICollection, index:uint):void
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
		override public function removeItemAt(index:uint):Object
		{
throw new Error("not yet implemented");
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
		override public function replaceItemAt(newItem:Object, index:uint):Object
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





		/**
		 *	
		 */
		private function _childrenChangeHandler(event:XMLEvent):void
		{
			var relatedNode:IXMLProxy = event.relatedNode;

			// Update the list.
			switch (event.type)
			{
				case XMLEvent.ADDED:
				{
					super.addItemAt(relatedNode, relatedNode.childIndex());
					break;
				}
				case XMLEvent.CHILD_REMOVED:
				{
					super.removeItem(relatedNode);
					break;
				}
			}
		}








	}
}