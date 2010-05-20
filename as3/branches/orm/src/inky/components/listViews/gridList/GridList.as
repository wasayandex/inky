package inky.components.listViews.gridList 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import inky.collections.IList;
	import inky.components.listViews.IListView;
	import inky.layout.ILayoutConstraints;
	import inky.layout.layouts.gridLayout.GridLayout;

	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2009.03.23
	 *
	 */
	public class GridList extends Sprite implements IListView
	{
		private var _itemRendererClass:Class;
		private var _dataProvider:IList;
		private var _grid:GridLayout;
		private var __contentContainer:Sprite;
		
		/**
		 *
		 */
		public function GridList(numColumns:uint = uint.MAX_VALUE, numRows:uint = uint.MAX_VALUE, horizontalSpacing:Number = 0, verticalSpacing:Number = 0)
		{
			super();
			this._init();
			this.numColumns = numColumns;
			this.numRows = numRows;
			this.horizontalSpacing = horizontalSpacing;
			this.verticalSpacing = verticalSpacing;
		}
		
		
		
		
		//
		// accessors
		//


		/**
		 *
		 */
		public function get horizontalSpacing():Number
		{
			return this._grid.horizontalSpacing;
		}
		/**
		 * @private
		 */
		public function set horizontalSpacing(value:Number):void
		{
			this._grid.horizontalSpacing = value;
		}


		/**
		 *
		 */
		public function get itemRendererClass():Class
		{
			return this._itemRendererClass;
		}
		/**
		 * @private
		 */
		public function set itemRendererClass(value:Class):void
		{
			this._itemRendererClass = value;
		}


		/**
		 *
		 */
		public function get dataProvider():IList
		{
			return this._dataProvider;
		}
		/**
		 * @private
		 */
		public function set dataProvider(value:IList):void
		{
			this._dataProvider = value;
			this._setContent();
		}


		/**
		 *
		 */
		public function get numColumns():Number
		{
			return this._grid.numColumns;
		}
		/**
		 * @private
		 */
		public function set numColumns(value:Number):void
		{
			this._grid.numColumns = value;
		}
		
		

		/**
		 *
		 */
		public function get numRows():Number
		{
			return this._grid.numRows;
		}
		/**
		 * @private
		 */
		public function set numRows(value:Number):void
		{
			this._grid.numRows = value;
		}
		
		
		/**
		 *
		 */
		public function get verticalSpacing():Number
		{
			return this._grid.verticalSpacing;
		}
		/**
		 * @private
		 */
		public function set verticalSpacing(value:Number):void
		{
			this._grid.verticalSpacing = value;
		}

		
		

		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function showItemAt(index:int):void
		{
		}

		
		public function setGridConstraints(obj:DisplayObject, constraints:ILayoutConstraints):void
		{
			this._grid.setConstraints(obj, constraints);
			this._grid.layoutContainer(this.__contentContainer);
		}


		//
		// private methods
		//

		
		/**
		 *	
		 */
		private function _clearContent():void
		{
			while (this.__contentContainer.numChildren)
			{
				this.__contentContainer.removeChildAt(0);
			}
		}
		
		
		/**
		 *	
		 */
		private function _init():void
		{
			this.__contentContainer = Sprite(this.getChildByName('_contentContainer')) || new Sprite();
			
			if (!this.contains(this.__contentContainer))
				this.addChild(this.__contentContainer);
			
			this._grid = new GridLayout();
		}
		

		/**
		 *	
		 */
		private function _setContent():void
		{
			this.addEventListener(Event.ENTER_FRAME, this._setContentNow);
		}
		
		
		/**
		 *	
		 */
		private function _setContentNow(e:Event):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			this._clearContent();

			if (this._dataProvider == null) return;
			if (this._itemRendererClass == null)
			{
				throw new Error("itemRendererClass is not set!");
			}
			
			this._updateContent();
		}


		/**
		 *	
		 */
		private function _updateContent():void
		{
			for (var i:int = 0; i < this.dataProvider.length; i++)
			{
				var item:Object = new this._itemRendererClass();
				item.model = this.dataProvider.getItemAt(i);
				this.__contentContainer.addChild(DisplayObject(item));
			}
			this._grid.layoutContainer(this.__contentContainer);
		}



		
	}
	
}
