package inky.layout
{
	import inky.layout.Layout;
	import inky.layout.ILayoutManager;
	import inky.layout.events.LayoutManagerEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;


	/**
	 *
	 *  Utility methods for Layouts. Generally, you should extend
	 *  BaseLayoutManager (and not refer to LayoutUtil at all). However, if
	 *  you are unable to extend BaseLayout, you can implement the
	 *  ILayoutManager interface and call these methods.
	 *
	 *  IMPORTANT: Your LayoutManager classes' register, unregister,
	 *	validate, etc. function MUST result in calls to LayoutUtil methods
	 *  or you will get unexpected behavior.
	 *	
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author     Matthew Tretter (matthew@exanimo.com)
	 *
	 */
	public class LayoutUtil
	{
		private static var _containers2LayoutManagers:Dictionary = new Dictionary(true);
		private static var _enterFrameBeacon:Sprite = new Sprite();
		private static var _invalidContainers:Dictionary = new Dictionary(true);
		private static var _isFirstFrame:Boolean = true;
		private static var _nestLevels:Dictionary = new Dictionary(true);
		private static var _stage:Stage;
		private static var _waitingForStage:Boolean;




		//
		// static initialization
		//

		LayoutUtil._enterFrameBeacon.addEventListener(Event.ENTER_FRAME, LayoutUtil._enterFrameHandler, false, 0, true);




		//
		//
		//


		/**
		 *
		 * @throws Error
		 *     thrown if you try to create an instance of LayoutUtil
		 *
		 */
		public function LayoutUtil()
		{
			throw new Error('LayoutUtil contains static utility methods and cannot be instantialized.');
		}




		//
		// public methods
		//


		/**
		 *
		 * Gets the LayoutUtil associated with a particular container.
		 *
		 * @param container
		 *     the container whose LayoutUtil you want
		 *
		 * @return
		 *     the LayoutUtil associated with the specified container
		 *
		 */
		public static function getLayoutManager(container:DisplayObjectContainer):ILayoutManager
		{
			return LayoutUtil._containers2LayoutManagers[container] || null;
		}


		/**
		 *
		 * 
		 *
		 */
		public static function layoutContainer(container:DisplayObjectContainer, layoutManager:ILayoutManager):void
		{
			var layout:Layout = layoutManager.calculateLayout(container);
			layoutManager.renderer.drawLayout(layout, container);
// TODO: Event shouldn't be dispatched until renderer completes.
			layoutManager.dispatchEvent(new LayoutManagerEvent(LayoutManagerEvent.RENDER, false, false, container));

			// If any of the childrens' bounds have changed, invalidate them.
			var child:DisplayObjectContainer;
			for (var i:uint = 0; i < layout.length; i++)
			{
				// If the child isn't a DisplayObjectContainer, it can't have layout.
				if (!(child = container.getChildByName(layout.getItemId(i)) as DisplayObjectContainer)) continue;

				var	newBounds:Rectangle = layout.getItemAt(i);
				if (child.width != newBounds.width || child.height != newBounds.height)
				{
					LayoutUtil._markAsInvalid(child);
				}
			}
		}


		/**
		 *
		 * 
		 *
		 */
		public static function invalidate(container:DisplayObjectContainer):void
		{
			LayoutUtil._invalidate(container);
		}


		/**
		 *
		 * ..
		 *
		 * @param container
		 *     the container to register with the layout
		 *
		 */
		public static function setLayoutManager(container:DisplayObjectContainer, layoutManager:ILayoutManager):void
		{
			// If the container is already registered with a layout, unregister
			// it before registering it with this layout.
			var oldLayoutManager:ILayoutManager = LayoutUtil.getLayoutManager(container);
			if (oldLayoutManager)
			{
				delete LayoutUtil._containers2LayoutManagers[container];

				// If the container is pending redraw, just forget about it.
				if (LayoutUtil._invalidContainers[container])
				{
					delete LayoutUtil._invalidContainers[container];
				}

				// Stop monitoring the nested level.
				delete LayoutUtil._nestLevels[container];
				container.removeEventListener(Event.ADDED, LayoutUtil._updateNestLevelList);
				container.removeEventListener(Event.ADDED_TO_STAGE, LayoutUtil._updateNestLevelList);
				container.removeEventListener(Event.REMOVED, LayoutUtil._updateNestLevelList);
				container.removeEventListener(Event.ADDED, LayoutUtil._invalidateContainer);
				container.removeEventListener(Event.REMOVED, LayoutUtil._invalidateContainer);
			}

			if (layoutManager != null)
			{
				// Bind this layout to the container.
				LayoutUtil._containers2LayoutManagers[container] = layoutManager;

				// Store the container's nested level, and update it if it changes.
				LayoutUtil._nestLevels[container] = LayoutUtil._getNestLevel(container);
				container.addEventListener(Event.ADDED, LayoutUtil._updateNestLevelList, false, 0, true);
				container.addEventListener(Event.ADDED_TO_STAGE, LayoutUtil._updateNestLevelList, false, 0, true);
				container.addEventListener(Event.REMOVED, LayoutUtil._updateNestLevelList, false, 0, true);
				container.addEventListener(Event.ADDED, LayoutUtil._invalidateContainer, false, 0, true);
				container.addEventListener(Event.REMOVED, LayoutUtil._invalidateContainer, false, 0, true);

				// Invalidate the container.
				layoutManager.invalidate(container);
			}
		}



		/**
		 *
		 * Validate and update the properties and layout of this object and
		 * redraw it, if necessary.
		 *
		 * @param container
		 *     the container to validate
		 *
		 */
		public static function validateNow(container:DisplayObjectContainer):void
		{
			LayoutUtil._validateNow(container);
		}




		//
		// private static methods
		//


		/**
		 *
		 * It is possible to register a container with a LayoutUtil before
		 * the container has been placed on the stage. In this situation,
		 * validation will not occur until the container has been added to the
		 * stage. This handler is called at that time and schedules validation.
		 *
		 * @param e
		 *     the event that triggered the handler
		 *
		 */
		private static function _addedToStageHandler(e:Event):void
		{
			LayoutUtil._validateLater(e.currentTarget as DisplayObjectContainer);
		}


		/**
		 *
		 * Used by the static initializer to alert the user to the fact that
		 * they have attempted to invalidate a layout on the first frame.
		 *
		 * @param e
		 *     the event that triggered the handler
		 *
		 */
		private static function _enterFrameHandler(e:Event):void
		{
			LayoutUtil._isFirstFrame = false;
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			LayoutUtil._enterFrameBeacon = null;
		}


		/**
		 *
		 * Gets the nest level of a DisplayObject. For example, the stage has
		 * nestLevel 0, its children have nestLevel 1, their children have
		 * nestLevel 2, and so on.
		 *
		 * @param obj
		 *     the object whose nestLevel you want
		 *
		 * @return
		 *     a non-negative integer representing the nested level of the
		 *     specified DisplayObject
		 *
		 */
		private static function _getNestLevel(obj:DisplayObject):uint
		{
			var nestLevel:uint = 0;
			while ((obj = obj.parent as DisplayObject))
			{
				nestLevel++;
			}
			return nestLevel;
		}


		/**
		 *
		 * Creates Arrays of invalid containers with equal nestLevels, then
		 * returns an Array of those Arrays, using the nestLevels as indexes.
		 *
		 * @return    a list of lists of invalid containers, sorted by
		 *            nestLevel
		 *
		 */
		private static function _getSortedInvalidContainers():Array
		{
			var o:Object;
			var nestLevel:uint;

			// Sort the invalid containers by nested level.
			var invalidContainersByNestLevel:Array = [];
			for (o in LayoutUtil._invalidContainers)
			{
				nestLevel = LayoutUtil._nestLevels[o];

				if (!invalidContainersByNestLevel[nestLevel])
				{
					invalidContainersByNestLevel[nestLevel] = [];
				}
				invalidContainersByNestLevel[nestLevel].push(o);
			}
			return invalidContainersByNestLevel;
		}


		/**
		 *
		 * Invalidate the layout of the specified container, marking it for
		 * update in the next frame.
		 *
		 * @param container
		 *     the container whose layout should be invalidated
		 *
		 */
		private static function _invalidate(container:DisplayObjectContainer):void
		{
			// If the container is already marked invalid, nevermind.
			if (LayoutUtil._invalidContainers[container]) return;

			// If we wait for the RENDER event in the first frame, there will
			// be a noticable flicker and we will see our container pre-layout.
			if (LayoutUtil._isFirstFrame)
			{
// Warning: Layouts registered on the first frame of the movie will result in a flash of non-layed-out content.
// You should probably call validateNow() if you need a layout on the first frame.
			}

			LayoutUtil._validateLater(container);

			// Mark the container (and any ancestor containers with a layout)
			// as invalid so that we update them later.
			while (container)
			{
				if (LayoutUtil._containers2LayoutManagers[container])
				{
					LayoutUtil._markAsInvalid(container);
				}
				container = container.parent;
			}
		}


		/**
		 *
		 * Invalidates the container. Called when a child is added or removed.
		 *	
		 */
		private static function _invalidateContainer(e:Event):void
		{
			LayoutUtil.invalidate(e.currentTarget as DisplayObjectContainer);
		}


		/**
		 *
		 * Invalidates the stage.
		 *	
		 */
		private static function _invalidateStage():void
		{
			LayoutUtil._stage.addEventListener(Event.RENDER, LayoutUtil._validateAll);
			LayoutUtil._stage.invalidate();
		}


		/**
		 *
		 * Determines if a particular container's layout is invalid.
		 *
		 * @param container
		 *     the container whose validity you want to test
		 *
		 * @return
		 *     true if the container's layout is invalid, false if not
		 *
		 */
		private static function _isInvalid(container:DisplayObject):Boolean
		{
			return LayoutUtil._invalidContainers[container] ? true : false;
		}


		/**
		 *
		 * Marks a container's layout as invalid. This differs from invalidate
		 * in that it is only a utility function for adding containers to a
		 * a list of invalid containers, whereas invalidate will also schedule
		 * validation.
		 *
		 * @param container
		 *     the container to mark as invalid
		 *
		 */
		private static function _markAsInvalid(container:DisplayObjectContainer):void
		{
			LayoutUtil._invalidContainers[container] = true;
		}


		/**
		 *
		 * Marks a container's layout as valid.
		 *
		 * @param container
		 *     the container to mark as valid
		 *
		 */
		private static function _markAsValid(container:DisplayObjectContainer):void
		{
			delete LayoutUtil._invalidContainers[container];
		}


		/**
		 *
		 * Updates the list of nestedLevels. Called when registered containers
		 * are added to or removed from the display list. The idea is that
		 * happens much less frequently than invalidation so we can save time
		 * by caching this information.
		 *
		 * @param e
		 *     the event that triggered the handler
		 *
		 */
		private static function _updateNestLevelList(e:Event):void
		{
			if (e.currentTarget == e.target)
			{
				var nestLevel:uint = LayoutUtil._getNestLevel(e.currentTarget as DisplayObjectContainer);
				LayoutUtil._nestLevels[e.currentTarget] = nestLevel;
			}
		}


		/**
		 *
		 * Validates the stage and (as a result), all layouts.
		 *
		 * @param e
		 *     the event that triggered the handler
		 *
		 */
		private static function _validateAll(e:Event):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			LayoutUtil._markAsInvalid(LayoutUtil._stage);
			LayoutUtil._validateNow(LayoutUtil._stage);
		}


		/**
		 *
		 * Schedules validation.
		 *
		 * @param container
		 *     the method actually schedules the stage (not the container
		 *     argument) for validation. however, the container is needed in
		 *     order to get a reference to the stage.
		 *
		 */
		private static function _validateLater(container:DisplayObjectContainer):void
		{
			var justGotStage:Boolean = !LayoutUtil._stage && (LayoutUtil._stage = container.stage);

			// If we don't have a reference to the stage yet, wait until we do.
			if (!LayoutUtil._stage)
			{
				LayoutUtil._waitingForStage = true;
				container.addEventListener(Event.ADDED_TO_STAGE, LayoutUtil._addedToStageHandler, false, 0, true);
				return;
			}
			else if (justGotStage)
			{
				// If we were waiting for the stage, and have it now, stop waiting.
				if (LayoutUtil._waitingForStage)
				{
					for (var o:Object in LayoutUtil._invalidContainers)
					{
						o.removeEventListener(Event.ADDED_TO_STAGE, LayoutUtil._addedToStageHandler);
					}
					LayoutUtil._waitingForStage = false;
				}

				LayoutUtil._nestLevels[LayoutUtil._stage] = 0;
			}

			LayoutUtil._invalidateStage();
		}


		/**
		 *
		 * Validate and update the properties and layout of this object and
		 * redraw it, if necessary.
		 *
		 * @param container
		 *     the container to validate
		 *
		 */
		private static function _validateNow(container:DisplayObjectContainer, sortedInvalidContainers:Array = null):void
		{
			// If the container isn't invalid, there's nothing to validate.
			if (!inky.layout.LayoutUtil._isInvalid(container)) return;

			LayoutUtil._markAsValid(container);

			var layoutManager:ILayoutManager = LayoutUtil.getLayoutManager(container);
			if (layoutManager)
			{
				layoutManager.layoutContainer(container);
			}

			sortedInvalidContainers = sortedInvalidContainers || LayoutUtil._getSortedInvalidContainers();

			var containers:Array;
			var descendant:DisplayObjectContainer;
			var j:uint;
			for (var i:uint = LayoutUtil._nestLevels[container] + 1; i < sortedInvalidContainers.length; i++)
			{
				if (!(containers = sortedInvalidContainers[i])) continue;
				for (j = 0; j < containers.length; j++)
				{
					descendant = containers[j];
					if (container.contains(descendant))
					{
						LayoutUtil._validateNow(descendant, sortedInvalidContainers);
					}
				}
				if (!sortedInvalidContainers) break;
			}
		}




	}
}
