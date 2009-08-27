package inky.async.actions
{
	import inky.async.actions.events.ActionEvent;
	import inky.app.IInkyDataParser;
	import inky.app.Section;
	import inky.async.actions.IAction;
	import inky.collections.IIterator;
	import inky.collections.ArrayList;
	import inky.async.*;


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
	public class ActionSequence extends ArrayList implements IAction, IInkyDataParser
	{

		/**
		 *
		 *	
		 *	
		 */
		public function ActionSequence(...rest:Array)
		{
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
// TODO: Should sequence be cancelable if just current action is cancelable?
/*			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				var action:IAction = i.next() as IAction;
				if (!action.cancelable) return false;
			}
*/
			return true;
		}




		//
		// public methods
		//


		/**
		 *
		 * @inheritDoc
		 * 
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
		 *	@inheritDoc
		 */
		public function start():IAsyncToken
		{
			return this.startAction();
		}


		/**
		 *
		 * @inheritDoc
		 * 
		 */
		public function startAction():IAsyncToken
		{
			var token:AsyncToken = new AsyncToken(false);
			this._startAction(0, token);
			return token;
		}




		//
		// private methods
		//

		private function _startAction(index:uint, sequenceToken:IAsyncToken):void
		{
			if (index == this.length)
			{
				// The sequence is done!
				sequenceToken.async_internal::callResponders();
			}
			else
			{
				// Start the next action in the sequence.
				var action:IAction = this.getItemAt(index) as IAction;
				var token:IAsyncToken = action.startAction();
				var responder:Function = function()
				{
					_startAction(index + 1, sequenceToken);
				}
				token.addResponder(responder);
			}
		}




	}
}
