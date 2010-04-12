package inky.async.actions
{
	import inky.collections.IIterator;
	import inky.app.IInkyDataParser;
	import inky.app.Section;
	import inky.async.actions.events.ActionEvent;
	import inky.async.actions.IAction;
	import inky.collections.Set;
	import inky.async.IAsyncToken;
	import inky.async.AsyncToken;
	import inky.async.async_internal;

	/**
	 *	
	 *	Defines a set of actions to be executed concurrently.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 * 	@author Zack Dolin
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2008.07.22
	 *	
	 */
	public class ActionGroup extends Set implements IAction, IInkyDataParser
	{
		private var _currentIndex:Number;
		

		/**
		 *
		 */
		public function ActionGroup(...rest:Array)
		{
			this._currentIndex = 0;
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
			/*for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				var action:IAction = i.next() as IAction;
				if (!action.cancelable) return false;
			}*/
			
			return true;
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function cancel():void
		{
			/*if (!this.cancelable) 
			{
				throw new Error('ActionGroup is not cancelable.');
			}
			else
			{
				for (var i:IIterator = this.iterator(); i.hasNext(); )
				{
					var action:IAction = i.next() as IAction;
					action.cancel();
					this._running = false;
				}	
			}*/
		}


		/**
		 * 	@inheritDoc
		 */
		public function parseData(data:XML):void
		{
			/*// TODO: Type mom?
			var mom:Object = Section.getSection(this).markupObjectManager;
			for each (var xml:XML in data.*)
			{
				var obj:Object = mom.createMarkupObject(xml);
				this.addItem(obj);
			}*/
		}
		
		
		/**
		 * @inheritDoc	
		 */
		public function start():IAsyncToken
		{
			return this.startAction();
		}


		/**
		 * 	@inheritDoc
		 */
		public function startAction():IAsyncToken
		{
			var token:AsyncToken = new AsyncToken(false);
			this._startGroup(token);
			return token;
		}




		//
		// private methods
		//


		/**
		 *
		 *	Iterates through the Group starting every action.	
		 *	
		 */
		private function _startGroup(groupToken:IAsyncToken):void
		{
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				// Start the actions in the group.
				var action:IAction = i.next() as IAction;
				var token:IAsyncToken = action.startAction();
				var responder:Function = function()
				{
					_finishGroup(groupToken);
				}
				token.addResponder(responder);
			}
		}


		/**
		 *	
		 */
		private function _finishGroup(groupToken:IAsyncToken):void
		{
			if (++this._currentIndex >= this.length)
				groupToken.async_internal::callResponders();
		}




	}
}