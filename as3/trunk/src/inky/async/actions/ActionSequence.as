package inky.async.actions
{
	import inky.async.actions.events.ActionEvent;
	import inky.app.IInkyDataParser;
	import inky.app.Section;
	import inky.async.actions.IAction;
	import inky.collections.IIterator;
	import inky.collections.ArrayList;
	import inky.async.*;
	import inky.async.actions.ActionQueue;
	import inky.async.AsyncToken;
	import inky.async.async_internal;


	/**
	 *	
	 *	Defines a list of actions to be executed sequentially.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
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
			var queue:ActionQueue = new ActionQueue();
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				queue.addItem(i.next());
			}
			return queue.startAction();
		}




	}
}