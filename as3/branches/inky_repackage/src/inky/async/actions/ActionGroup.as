﻿package inky.async.actions
{
	import inky.collections.IIterator;
	import inky.app.IInkyDataParser;
	import inky.app.Section;
	import inky.async.actions.events.ActionEvent;
	import inky.async.actions.IAction;
	import inky.collections.Set;

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
		private var _target:Object;
		private var _running:Boolean;
		

		/**
		 *
		 */
		public function ActionGroup(...rest:Array)
		{
			for each (var action:IAction in rest)
			{
				if (!action) return;
				else this.addItem(action);
			}
			this._running = false;
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get cancelable():Boolean
		{			
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				var action:IAction = i.next() as IAction;
				if (!action.cancelable) return false;
			}
			
			return true;
		}


		/**
		 *
		 *	The target upon which the action acts.
		 *
		 * 	@default null	
		 * 
		 */
		public function get target():Object
		{
			return this._target;
		}
		/**
		 * 	@private	
		 */
		public function set target(target:Object):void
		{
			this._target = target;
		}	




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function cancel():void
		{
			if (!this.cancelable) 
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
			}
		}


		/**
		 * 	@inheritDoc
		 */
		public function parseData(data:XML):void
		{
			// TODO: Type mom?
			var mom:Object = Section.getSection(this).markupObjectManager;
			for each (var xml:XML in data.*)
			{
				var obj:Object = mom.createMarkupObject(xml);
				this.addItem(obj);
			}
		}


		/**
		 * 	@inheritDoc
		 */
		public function start():void
		{
			if (this._running) return;
			this._running = true;
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));
			this._currentIndex = 0;
			this._startActionGroup();
		}




		//
		// private methods
		//


		/**
		 *
		 *	Iterates through the Group starting every action.	
		 *	
		 */
		private function _startActionGroup():void
		{
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				var action:IAction = i.next() as IAction;
				if (action.target == null)
				{
					action.target = this.target;
				}
				action.addEventListener(ActionEvent.ACTION_FINISH, this._actionFinishHandler);
				action.start();
			}
		}


		/**
		 *	
		 *	Dispatches an ActionEvent once the final Action in the group is finished.
		 *	
		 */
		private function _actionFinishHandler(e:ActionEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			this._currentIndex++;

			if (this._currentIndex >= this.length)
			{
				this._groupFinish();
			}
		}


		/**
		 *
		 *	
		 */
		private function _groupFinish():void
		{
			this._running = false;
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, false, false));
		}




	}
}
