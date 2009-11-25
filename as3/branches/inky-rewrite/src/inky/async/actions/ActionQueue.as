package inky.async.actions
{
	import inky.app.IInkyDataParser;
	import inky.async.actions.IAction;
	import inky.collections.IIterator;
	import inky.collections.ArrayList;
	import inky.collections.IList;
	import inky.collections.IQueue;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import inky.collections.ICollection;
	import inky.async.IAsyncToken;
	import inky.async.async_internal;
	import inky.async.actions.events.ActionEvent;
	import inky.async.AsyncToken;
	import flash.utils.Dictionary;


	/**
	 *	
	 *	Defines a list of actions to be executed sequentially.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Rich Perez
	 *	@since  2008.07.21
	 *	
	 */
	public class ActionQueue implements IEventDispatcher, IQueue, IAction, IInkyDataParser
	{
		private var _list:IList;
		private var _token:AsyncToken;


		/**
		 *
		 *	
		 *	
		 */
		public function ActionQueue(...rest:Array)
		{
			this._list = new ArrayList();

			for each (var action:IAction in rest)
			{
				this.addItem(action);
			}
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get cancelable():Boolean
		{
			return false;
		}


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
		 * @inheritDoc
		 */
		public function parseData(data:XML):void
		{
			throw new Error("That IInkyDataParser is dumb. Instead we should register parsers for QNames. You know that.");
		}


		/**
		 *	@inheritDoc
		 */
		public function removeAll():void
		{
			throw new Error("Not yet implemented");
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
		 *	@inheritDoc
		 */
		public function start():IAsyncToken
		{
			return this.startAction();
		}


		/**
		 * @inheritDoc
		 */
		public function startAction():IAsyncToken
		{
			var token:AsyncToken = this._token;
			if (!token)
			{
				token =
				this._token = new AsyncToken(false);
				token.subprocesses = [];
				this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, token, false, true))
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
				token.async_internal::callResponders();
				this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, token, false, true));
			}
			else
			{
				var headItem:IAction = this.getHeadItem() as IAction;
				var subprocessToken:IAsyncToken = headItem.startAction();
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