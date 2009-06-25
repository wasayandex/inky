﻿package inky.components.transitioningObject
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;


	/**
	 *
	 * A decorator that provides ITransitioningObject behavior to a
	 * DisplayObject. Use this when you can't extend TransitioningMovieClip.
	 * 
	 * @see inky.components.transitioningObject.ITransitioningObject
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
		private static var _accessEnforcer:Object = {};
		private static var _fixers:Dictionary = new Dictionary(true);


		/**
		 *
		 */
		public function AddedToStageEventFixer(obj:DisplayObject, accessEnforcer:Object = null)
		{
			if (accessEnforcer != AddedToStageEventFixer._accessEnforcer)
			{
				throw new ArgumentError("AddedToStageEventFixer instances must be created through AddedToStageEventFixer.getAddedToStageEventFixer()");
			}
			this._obj = obj;
		}


		/**
		 *
		 * Gets an AddedToStageEventFixer for the specified object.
		 *	
		 * @param enable
		 *     If true, the AddedToStageEventFixer will be immediately enabled.
		 *	   If false, it will be left in its current state. To disable it,
		 *	   you must set the enabled property of the returned
		 *	   AddedToStageEventFixer to false.
		 *	
		 */
		public static function getAddedToStageEventFixer(obj:DisplayObject, enable:Boolean = false):AddedToStageEventFixer
		{
			var fixer:AddedToStageEventFixer = AddedToStageEventFixer._fixers[obj];
			if (fixer == null)
			{
				fixer =
				AddedToStageEventFixer._fixers[obj] = new AddedToStageEventFixer(obj, AddedToStageEventFixer._accessEnforcer);
			}
			if (enable)
			{
				fixer.enabled = true;
			}
			return fixer;
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
					this._onStage = false;
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
