package inky.framework.components.listViews.gridList 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import inky.framework.collections.IList;
	import inky.framework.components.listViews.IListView;
	import com.exanimo.layout.GridLayout;

	
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
		private var _itemViewClass:Class;
		private var _model:IList;
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
		public function get itemViewClass():Class
		{
			return this._itemViewClass;
		}
		/**
		 * @private
		 */
		public function set itemViewClass(value:Class):void
		{
			this._itemViewClass = value;
		}


		/**
		 *
		 */
		public function get model():IList
		{
			return this._model;
		}
		/**
		 * @private
		 */
		public function set model(value:IList):void
		{
			this._model = value;
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
			this._grid.register(this.__contentContainer);
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

			if (this._model == null) return;
			if (this._itemViewClass == null)
			{
				throw new Error("itemViewClass is not set!");
			}
			
			this._updateContent();
		}


		/**
		 *	
		 */
		private function _updateContent():void
		{
			for (var i:int = 0; i < this.model.length; i++)
			{
				var item:Object = new this._itemViewClass();
				item.model = this.model.getItemAt(i);
				this.__contentContainer.addChild(DisplayObject(item));
			}
		}



		
	}
	
}
