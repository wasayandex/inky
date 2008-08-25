package inky.addons.transitions
{
	import com.exanimo.collections.ISet;
	import com.exanimo.collections.IListIterator;
	import com.exanimo.collections.ArrayList;
	import inky.framework.core.IInkyDataParser;
	import inky.framework.core.Section;
	import inky.framework.events.ActionEvent;
	import inky.framework.utils.IAction;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import fl.motion.Animator;
	import fl.motion.MotionEvent;


	/**
	 *
	 *	Class description.
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
	public class AnimatorAction extends EventDispatcher implements IAction, IInkyDataParser
	{
		private var _target:Object;
		private var _animator:Animator;
		private var _xml:XML;

		
		/**
		 *	
		 */
		public function AnimatorAction()
		{
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
			this._xml = data.*[0];
		}


		/**
		 *
		 * @inheritDoc
		 * 
		 */
		public function start():void
		{
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));
			this._animator = new Animator(this._xml, this.target as DisplayObject);
			this._animator.addEventListener(MotionEvent.MOTION_END, this._motionEndHandler)
			this._animator.play();
		}




		//
		// private methods
		//


		/**
		 *	
		 *	Dispatches an MotionEvent once the entire AnimatorAction is finished.
		 *	
		 */
		private function _motionEndHandler(e:MotionEvent):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, false, false));
		}




	}
}
