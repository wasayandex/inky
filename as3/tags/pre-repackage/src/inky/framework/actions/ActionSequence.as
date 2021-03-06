﻿package inky.framework.actions
{
	import inky.framework.actions.ActionEvent;
	import inky.framework.core.IInkyDataParser;
	import inky.framework.core.Section;
	import inky.framework.actions.IAction;
	import inky.framework.collections.IIterator;
	import inky.framework.collections.ArrayList;


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
		private var _target:Object;
		private var _currentIndex:Number;
		private var _running:Boolean;


		/**
		 *
		 *	
		 *	
		 */
		public function ActionSequence(... rest)
		{
			for each (var action:IAction in rest)
			{
				if (!action) return;
				else this.addItem(action);
			}

			this._currentIndex = 0;
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
// TODO: Should sequence be cancelable if just current action is cancelable?
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				var action:IAction = i.next() as IAction;
				if (!action.cancelable) return false;
			}
			
			return true;
		}

		
		/**
		 *
		 * The target upon which the action acts.
		 *
		 * @default null	
		 * 
		 */
		public function get target():Object
		{
			return this._target;
		}
		/**
		 * @private	
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
				throw new Error('ActionSequence is not cancelable.');
			}
			else if (this._running && (this._currentIndex < this.length))
			{
				var currentAction:IAction = this.getItemAt(this._currentIndex) as IAction;
				currentAction.cancel();
				this._running = false;
			}
		}


		/**
		 *
		 * @inheritDoc
		 * 
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
		 *
		 * @inheritDoc
		 * 
		 */
		public function start():void
		{
			if (this._running) return;
			this._running = true;

			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));
			if (!this.length)
			{
				this._sequenceFinish();
				return;
			}
			
			if (this._currentIndex < 0 || this._currentIndex >= this.length)
			{
				this._currentIndex = 0;
			}

			this._startAction(this._currentIndex);
		}




		//
		// private methods
		//

		
		/**
		 *
		 *	Starts the action designated by the index in the ActionSequence.	
		 *	
		 */
		private function _startAction(index:Number):void
		{
			var action:IAction = this.getItemAt(index) as IAction;
			if (action.target == null)
			{
				action.target = this.target;
			}
			action.addEventListener(ActionEvent.ACTION_FINISH, this._actionFinishHandler);
			action.start();
		}

		
		/**
		 *	
		 *	Dispatches an ActionEvent once the entire ActionSequence is finished. Otherwise it will call on the next action to start.
		 *	
		 */
		private function _actionFinishHandler(e:ActionEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			this._currentIndex++;
			
			if (this._currentIndex >= this.length)
			{
				this._sequenceFinish();
			}
			else
			{
				this._startAction(this._currentIndex);
			}
		}


		/**
		 *
		 *	
		 */
		private function _sequenceFinish():void
		{
			this._running = false;
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, false, false));
		}




	}
}
