package inky.layout
{
	import inky.collections.ArrayList;
	import inky.collections.IList;
	import inky.layout.BasicLayoutRenderer;
	import inky.layout.ILayoutRenderer;
	import inky.layout.Layout;
	import inky.layout.ILayoutManager;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import inky.layout.ILayoutConstraints;

// TODO: Should layoutItems be handled by LayoutUtil??
	/**
	 *
	 *  Defines an object responsible for the laying out of children of
	 *  DisplayObjectContainers
	 *	
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author     Matthew Tretter (matthew@exanimo.com)
	 *
	 */
	public class BaseLayoutManager extends EventDispatcher implements ILayoutManager
	{
		private var _constraints:Dictionary;
		private var _layoutItems:Dictionary;
		private var _renderer:ILayoutRenderer;




		/**
		 *
		 * Constructor. BaseLayoutManager is an abstract class so it can't be
		 * instantiated directly.
		 *
		 * @throws ArgumentError
		 *         thrown if you try to create an instance of BaseLayoutManager
		 *
		 */
		public function BaseLayoutManager()
		{
			//
			// Prevent BaseLayoutManager from being instantialized.
			//
			if (getDefinitionByName(getQualifiedClassName(this)) == BaseLayoutManager)
			{
				throw new ArgumentError('Error #2012: BaseLayoutManager$ class cannot be instantiated.');
			}

			this._constraints = new Dictionary(true);
			this._layoutItems = new Dictionary(true);
		}




		//
		// accessors
		//


		/**
		 *
		 *
		 *
		 */
		public function get renderer():ILayoutRenderer
		{
			if (!this._renderer)
				this._renderer = new BasicLayoutRenderer();
			return this._renderer;
		}
		public function set renderer(renderer:ILayoutRenderer):void
		{
			this._renderer = renderer;
		}




		//
		// public methods
		//


		/**
		 *
		 * Add a DisplayObject to the layout. You may only add DisplayObjects
		 * whose parents have been registered with the LayoutManager. By
		 * default, children are automatically added to the layout.
		 *
		 * @param item:DisplayObject
		 *     the item to add to the layout
		 * @throws ArgumentError
		 *     thrown if the item's parent is not registered with this
		 *     LayoutManager
		 *
		 */
		public function addLayoutItem(item:DisplayObject):void
		{
			if (LayoutUtil.getLayoutManager(item.parent) != this)
			{
				throw new ArgumentError('You can not add an item to a LayoutManager unless its parent is registered with the LayoutManager');
			}
			if (!this._layoutItems[item.parent].containsItem(item))
			{
				this._layoutItems[item.parent].addItem(item);
			}
			item.addEventListener(Event.REMOVED, this._layoutItemRemovedHandler, false, 0, true);
		}


		/**
		 *
		 * Gets the constraints associated with a DisplayObject.
		 *
		 */
		public function getConstraints(obj:DisplayObject):ILayoutConstraints
		{
			return this._constraints[obj];
		}


		/**
		 *
		 * Mark a container as invalid. Invalid containers will be validated
		 * (redrawn) before the next frame.
		 *
		 * @param container:DisplayObjectContainer
		 *     the container to mark as invalid
		 *
		 */
		public function invalidate(container:DisplayObjectContainer):void
		{
			LayoutUtil.invalidate(container);
		}


		/**
		 *
		 * 
		 *
		 */
		public function layoutContainer(container:DisplayObjectContainer):void
		{
			LayoutUtil.layoutContainer(container, this);
		}


		/**
		 *
		 * Remove a DisplayObject from the layout. You may only remove
		 * DisplayObjects whose parents have been registered with the
		 * LayoutManager. This method allows you to ignore children of a
		 * registered container when laying it out.
		 *
		 * @param item:DisplayObject
		 *     the item to remove from the layout
		 * @return DisplayObject
		 *     the removed item
		 * @throws ArgumentError
		 *     thrown if the item's parent is not registered with this
		 *     LayoutManager
		 *	
		 */
		public function removeLayoutItem(item:DisplayObject):DisplayObject
		{
			if (!LayoutUtil.getLayoutManager(item.parent) == this)
			{
				throw new ArgumentError('You can not remove an item from a LayoutManager unless its parent is registered with the LayoutManager');
			}

			item.removeEventListener(Event.REMOVED, this._layoutItemRemovedHandler);
			
			if (this._layoutItems[item.parent].containsItem(item))
			{
				item = this._layoutItems[item.parent].removeItem(item) as DisplayObject;
			}

			return item;
		}


		/**
		 *
		 * Register a DisplayObjectContainer with this LayoutManager
		 *
		 */
		public function register(container:DisplayObjectContainer):void
		{
// TODO: Allow multiple layout managers to be registered on a single display object container? this would eliminate the need for most of the LayoutUtil functions.
			this._layoutItems[container] = new ArrayList();
			LayoutUtil.setLayoutManager(container, this);

			// Automatically add all the children to the LayoutManager.
			for (var i:uint = 0; i < container.numChildren; i++)
			{
				this.addLayoutItem(container.getChildAt(i));
			}

			container.addEventListener(Event.ADDED, this._addChildToLayout, false, 0, true);
		}


		/**
		 *
		 * Set constraints for a DisplayObject whose parent is registered with
		 * this layout.
		 *
		 * @param obj
		 *     the DisplayObject whose constraints to set
		 * @param constraints
		 *     the constraints to apply to the given DisplayObject
		 *
		 * @throws ArgumentError
		 *     thrown if the supplied DisplayObject is not a child of a
		 *     registered container
		 *
		 */
		public function setConstraints(obj:DisplayObject, constraints:ILayoutConstraints):void
		{
			// Clone constraints so the same object can be changed and set as
			// constraints on another element.
			constraints = constraints.clone() as ILayoutConstraints;
			if (!obj.parent || (LayoutUtil.getLayoutManager(obj.parent) != this))
			{
				throw new ArgumentError('The supplied DisplayObject is not a child of a container registered with this LayoutManager');
			}
			this._constraints[obj] = constraints;
		}


		/**
		 *
		 * Unregister a DisplayObjectContainer. This LayoutManager will no
		 * longer be responsible for the specified container.
		 *
		 */
		public function unregister(container:DisplayObjectContainer):void
		{
			delete this._layoutItems[container];
			LayoutUtil.setLayoutManager(container, null);
			container.removeEventListener(Event.ADDED, this._addChildToLayout);
		}


		/**
		 *
		 * Immediately recalculate the layout of and draw the container.
		 *
		 */
		public function validateNow(container:DisplayObjectContainer):void
		{
			LayoutUtil.validateNow(container);
		}


		/**
		 *
		 * Calculate the size and positioning of a container's children. This
		 * is the most important method to override in custom layout classes as
		 * it is called to determine where elements should be placed and what
		 * size they should be.
		 *
		 * @param container
		 *     the DisplayObjectContainer to calculate the layout of
		 *
		 * @return
		 *     the calculated Layout
		 *
		 */
		public function calculateLayout(container:DisplayObjectContainer):Layout
		{
			return null;
		}




		//
		// protected methods
		//


		/**
		 *
		 * Gets a list of items that should be considered when calculating the
		 * layout of the specified container. This is a convenience method that
		 * will only work correctly if your subclass calls BaseLayoutManager's
		 * register, addLayoutItem, and removeLayoutItem functions.
		 *	
		 */
		public function getLayoutItems(container:DisplayObjectContainer):IList
		{
// FIXME: I don't like that this list is different if you add an item.
			var layoutItems:IList = this._layoutItems[container];
			if (!layoutItems)
			{
				layoutItems = new ArrayList();
				for (var i:uint = 0; i < container.numChildren; i++)
				{
					layoutItems.addItem(container.getChildAt(i));
				}
			}
			return layoutItems;
		}




		//
		// private methods
		//


		/**
		 *
		 * Automatically adds children to the layout.
		 *	
		 */
		private function _addChildToLayout(e:Event):void
		{
			var container:DisplayObjectContainer = e.target.parent as DisplayObjectContainer;
			if (LayoutUtil.getLayoutManager(container) == this)
			{
				this.addLayoutItem(e.target as DisplayObject);
			}
		}


		/**
		 *
		 *	
		 */
		private function _layoutItemRemovedHandler(e:Event):void
		{
			if (e.target == e.currentTarget)
			{
				this.removeLayoutItem(e.target as DisplayObject);
			}
		}




	}
}