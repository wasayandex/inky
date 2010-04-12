package inky.utils
{
	import flash.display.DisplayObject;
	import flash.events.Event;


	/**
	 *
	 * A decorator that prevents ADDED_TO_STAGE events from firing twice.
	 * @see http://bugs.adobe.com/jira/browse/FP-1569
	 * 
	 * 	@langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2007.11.09
	 *
	 */
	public class AddedToStageEventFixer
	{
		private var _enabled:Boolean;
		private var _obj:Object;
		private var _onStage:Boolean;


		/**
		 *
		 * Creates an AddedToStageEventFixer for the specified object.
		 *	
		 * @param enable
		 *     If true, the AddedToStageEventFixer will be immediately enabled.
		 *	   If false, it will be left in its current state. To disable it,
		 *	   you must set the enabled property of the returned
		 *	   AddedToStageEventFixer to false.
		 *	
		 */
		public function AddedToStageEventFixer(obj:DisplayObject)
		{
			this._obj = obj;
		}




		//
		// accessors
		//


		/**
		 *
		 *	
		 */
		public function get enabled():Boolean
		{
			return this._enabled;
		}
		/**
		 * @private
		 */
		public function set enabled(enabled:Boolean):void
		{
			if (enabled != this._enabled)
			{
				if (enabled)
				{
					this._onStage = !!this._obj.stage;
					this._obj.addEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler, false, int.MAX_VALUE, true);
					this._obj.addEventListener(Event.REMOVED_FROM_STAGE, this._removedFromStageHandler, false, int.MAX_VALUE, true);
				}
				else
				{
					this._obj.removeEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler);
					this._obj.removeEventListener(Event.REMOVED_FROM_STAGE, this._removedFromStageHandler);
				}
				this._enabled = enabled;
			}
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 */
		private function _addedToStageHandler(e:Event):void
		{
			if (this._onStage)
			{
				e.stopImmediatePropagation();
			}
			this._onStage = true;
		}


		/**
		 *
		 *	
		 */
		private function _removedFromStageHandler(e:Event):void
		{
			this._onStage = false;
		}




	}
}
