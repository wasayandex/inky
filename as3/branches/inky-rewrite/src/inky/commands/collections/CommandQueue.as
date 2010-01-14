package inky.commands.collections 
{
	import inky.commands.IAsyncCommand;
	import inky.collections.IQueue;
	import flash.events.IEventDispatcher;
	import inky.collections.ArrayList;
	import inky.commands.tokens.IAsyncToken;
	import inky.collections.ICollection;
	import inky.collections.IIterator;
	import flash.events.Event;
	import mx.rpc.AsyncToken;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 * 	@author Matthew Tretter
	 *	@since  2010.01.13
	 *
	 */
	public class CommandQueue implements IEventDispatcher, IQueue, IAsyncCommand
	{
		private var _list:ArrayList;
		private var _token:AsyncToken;
		
		/**
		 *
		 */
		public function CommandQueue(...rest:Array)
		{
			this._list = new ArrayList();
			for each (var command:Object in rest)
				this.addItem(command);
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get length():uint
		{
			return this._list.length;
		}




		//
		// public methods
		//


		/**
		 *	@inheritDoc
		 */
		public function addItem(item:Object):void
		{
			this._list.addItem(item);
		}


		/**
		 *	@inheritDoc
		 */
		public function addItems(collection:ICollection):void
		{
			this._list.addItems(collection);
		}


		/**
		 *	@inheritDoc
		 */
		public function containsItem(item:Object):Boolean
		{
			return this._list.containsItem(item);
		}


		/**
		 *	@inheritDoc
		 */
		public function containsItems(collection:ICollection):Boolean
		{
			return this._list.containsItems(collection);
		}


		/**
		 *	@inheritDoc
		 */
		public function equals(obj:Object):Boolean
		{
			return this == obj;
		}


		/**
		 *	@inheritDoc
		 */
		public function getHeadItem():Object
		{
			return this._list.getItemAt(0);
		}


		/**
		 *	@inheritDoc
		 */
		public function get isEmpty():Boolean
		{
			return this._list.isEmpty;
		}
		
		
		/**
		 *	@inheritDoc
		 */
		public function iterator():IIterator
		{
			return this._list.iterator();
		}
		
		
		/**
		 *	@inheritDoc
		 */
		public function offerItem(item:Object):Boolean
		{
			this.addItem(item);
			return true;
		}


		/**
		 *	@inheritDoc
		 */
		public function removeAll():void
		{
			if (this._token)
			{
				// Currently running. Remove all but head item.
				this._list = new ArrayList([this.getHeadItem()]);
			}
			else
			{
				this._list.removeAll();
			}
		}


		/**
		 *	@inheritDoc
		 */
		public function removeHeadItem():Object
		{
			if (this.isEmpty)
				throw new Error("Queue is empty. (There are no elements to remove.)");

			return this._list.removeItemAt(0);
		}


		/**
		 *	@inheritDoc
		 */
		public function removeItem(item:Object):Object
		{
			return this._list.removeItem(item);
		}


		/**
		 *	@inheritDoc
		 */
		public function removeItems(collection:ICollection):void
		{
			return this._list.removeItems(collection);
		}


		/**
		 *	@inheritDoc
		 */
		public function retainItems(collection:ICollection):void
		{
			this._list.retainItems(collection);
		}


		/**
		 * @inheritDoc
		 */
		public function execute(params:Object = null):IAsyncToken
		{
			var token:AsyncToken = this._token;
			if (!token)
			{
				token =
				this._token = new AsyncToken(false);
				token.subprocesses = [];
				this._executeHeadItem();
			}
			return token;
		}


		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			return this._list.toArray();
		}




		//
		// event dispatcher methods
		//


		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			this._list.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}


		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return this._list.dispatchEvent(event);
		}


		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean 
		{
			return this._list.hasEventListener(type);
		}


		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			return this._list.removeEventListener(type, listener, useCapture);
		}


		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return this._list.willTrigger(type);
		}




		//
		// private methods
		//


		/**
		 *	
		 */
		private function _executeHeadItem():void
		{
			// Get the token that corresponds to the queue.
			var token:AsyncToken = this._token;
			if (this.isEmpty)
			{
				this._token = null;
				token.callResponders();
			}
			else
			{
				var headItem:Object = this.getHeadItem();
				var subprocessToken:IAsyncToken = headItem.execute();
				// If the headItem's execute does not return a token, create one to represent it.
				if (!(subprocessToken is IAsyncToken))
				{
					subprocessToken = new AsyncToken();
					subprocessToken.callResponders();
				}
				token.subprocesses.push(subprocessToken);
				subprocessToken.addResponder(this._itemCompleteHandler);
			}
		}


		/**
		 *	
		 */
		private function _itemCompleteHandler(token:IAsyncToken):void
		{
			// Remove the item that just completed.
			this.removeHeadItem();
			
			// Execute the next item.
			this._executeHeadItem();
		}
		

		

	}
	
}