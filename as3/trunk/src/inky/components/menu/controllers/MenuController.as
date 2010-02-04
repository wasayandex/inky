package inky.components.menu.controllers

{
	/**
	 *	@author Ryan Sprake
	 *	@since 2010.02.04
	 * 
	 *  @todo Find a way to use the activeMenuItem set function since there is no way to access the menu's contentContainer.
	 *  @todo Add more ways to set activeMenuItem. setActiveMenuItemByIndex, requires Menu to know what menu buttons are available.
	 *  @todo How should I handle a static menu?
	 */	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import inky.collections.IList;
	import inky.components.listViews.IListView;
	import inky.components.listViews.gridList.GridList;
	import inky.components.menu.events.MenuEvent;
	import flash.display.DisplayObject;

	public class MenuController extends EventDispatcher
	{
		private var _view:DisplayObject;
		private var _activeMenuItem:Object;
		private var _visitedItems:Array;
		
		public function MenuController(view:DisplayObject = null)
		{
			if(view)
			{
				this._view = view;
				this.init();				
			}
		}


		//
		// Get / Set Functions
		//
		
		
		/**
		 */
		public function set view(value:DisplayObject):void
		{
			this._view = value;
		}
		
		
		/**
		 *
		 */
		public function get activeMenuItem():Object
		{ 
			return this._activeMenuItem; 
		}
		/*
		public function set activeMenuItem(value:Object):void
		{
			if(value is super.itemViewClass)
				this._activeMenuItem = value;
		}
		*/
		
		
		/**
		 */
		public function get visitedItems():Array
		{ 
			return this._visitedItems; 
		}


		//
		// Public Functions
		//
		
		
		/**
		 */
		public function init():void
		{
			this._visitedItems = [];
			this._view.addEventListener(MouseEvent.CLICK, this._clickHandler);
		}
		
		
		//
		// Private Functions
		//
		
		
		/**
		 */
		private function _setActiveItem(item:Object):void
		{
			if(this._activeMenuItem)
				this._activeMenuItem.selected = false;
			
			this._activeMenuItem = item;
			this._activeMenuItem.selected = true;
			
			if(this._visitedItems.indexOf(this._activeMenuItem) != -1)
				this._visitedItems.push(this._activeMenuItem);
			
			var changeEvent:MenuEvent = new MenuEvent(MenuEvent.CHANGE);
			this.dispatchEvent(changeEvent);
		}
		
		
		/**
		 */
		private function _clickHandler(event:MouseEvent):void
		{
			if(event.target.mouseEnabled)
				this._setActiveItem(event.target);
		}
	}
}