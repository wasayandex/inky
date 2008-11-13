﻿package inky.framework.utils{	import com.exanimo.collections.IIterator;	import inky.framework.core.IInkyDataParser;	import inky.framework.core.Section;	import inky.framework.events.ActionEvent;	import inky.framework.utils.IAction;	import inky.framework.collections.Set;	/**	 *		 *	Defines a set of actions to be executed concurrently.	 *	 *	@langversion ActionScript 3.0	 *	@playerversion Flash 9.0	 *	 * 	@author Zack Dolin	 *	@author Eric Eldredge	 *	@author Rich Perez	 *	@author Matthew Tretter	 *	@since  2008.07.22	 *		 */	public class ActionGroup extends Set implements IAction, IInkyDataParser	{		private var _currentIndex:Number;		private var _target:Object;				/**		 *		 */		public function ActionGroup(...rest:Array)		{			for each (var action:IAction in rest)			{				if (!action) return;				else this.addItem(action);			}		}		//		// accessors		//		/**		 * @inheritDoc		 */		public function get cancelable():Boolean		{// TODO: Should be cancelable if all elements are cancelable.			return false;		}		/**		 *		 *	The target upon which the action acts.		 *		 * 	@default null			 * 		 */		public function get target():Object		{			return this._target;		}		/**		 * 	@private			 */		public function set target(target:Object):void		{			this._target = target;		}			//		// public methods		//		/**		 * @inheritDoc		 */		public function cancel():void		{// TODO: Should be cancelable if all elements are cancelable.			throw new Error('ActionGroup is not cancelable.');		}		/**		 * 	@inheritDoc		 */		public function parseData(data:XML):void		{			// TODO: Type mom?			var mom:Object = Section.getSection(this).markupObjectManager;			for each (var xml:XML in data.*)			{				var obj:Object = mom.createMarkupObject(xml);				this.addItem(obj);			}		}		/**		 * 	@inheritDoc		 */		public function start():void		{			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));			this._currentIndex = 0;			this._startActionGroup();		}		//		// private methods		//		/**		 *		 *	Iterates through the Group starting every action.			 *			 */		private function _startActionGroup():void		{			for (var i:IIterator = this.iterator(); i.hasNext(); )			{				var action:IAction = i.next() as IAction;				action.target = action.target || this.target;				action.addEventListener(ActionEvent.ACTION_FINISH, this._transitionFinish);				action.start();			}		}		/**		 *			 *	Dispatches an ActionEvent once the final Action in the group is finished.		 *			 */		private function _transitionFinish(e:ActionEvent):void		{			e.currentTarget.removeEventListener(e.type, arguments.callee);						this._currentIndex++;			if (this._currentIndex >= this.length)			{				this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, false, false));			}		}	}}