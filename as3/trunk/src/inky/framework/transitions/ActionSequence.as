package inky.framework.transitions
{
	import inky.framework.events.ActionEvent;
	import inky.framework.core.IInkyDataParser;
	import inky.framework.core.Section;
	import inky.framework.utils.IAction;
	import com.exanimo.collections.IListIterator;
	import com.exanimo.collections.ArrayList;


	/**
	 *	
	 *	Class description.
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


		/**
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
		}




		//
		// accessors
		//

		
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
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));
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
			
			action.target = action.target || this.target;
			
			action.addEventListener(ActionEvent.ACTION_FINISH, this._transitionFinish);
			action.start();
		}

		
		/**
		 *	
		 *	Dispatches an ActionEvent once the entire ActionSequence is finished. Otherwise it will call on the next action to start.
		 *	
		 */
		private function _transitionFinish(e:ActionEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			this._currentIndex++;
			
			if (this._currentIndex >= this.length) this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, false, false));
			else this._startAction(this._currentIndex);			
		}



		
	}
}
