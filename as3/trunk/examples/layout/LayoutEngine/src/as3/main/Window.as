package  
{
	import flash.display.Sprite;
	import inky.layout.ILayoutClient;
	import inky.layout.LayoutEngine;
	import inky.layout.GridLayout;
	import inky.utils.UIDUtil;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.08.03
	 *
	 */
	public class Window extends Sprite implements ILayoutClient
	{
		private var _grid:GridLayout;
		private var _height:Number;
		private var _layoutEngine:LayoutEngine;
		private var _width:Number;
		private var _nestedWindows:Array;
		
		private static const BORDER_SIZE:Number = 2;


		/**
		 *
		 */
		public function Window()
		{
			this._grid = new GridLayout();
			this._nestedWindows = [];
			this._layoutEngine = LayoutEngine.getInstance();
			
			// Set default values.
			this._width = super.width;
			this._height = super.height;
		}



		public function addNestedWindow(window:Window):Window
		{
			// Add the window to the display list.
			this.nestedWindowContainer.addChild(window);
			
			// Add the window to the list of windows.
			if (this._nestedWindows.indexOf(window) == -1)
				this._nestedWindows.push(window);
				
			// Invalidate the display list.
			this._layoutEngine.invalidateDisplayList(this);
			return window;
		}




		//
		// accessors
		//


		/**
		 *	@inheritDoc
		 */
		override public function get height():Number
		{
			return this._height;
		}
		/**
		 *	@private
		 */
		override public function set height(value:Number):void
		{
			if (value != this._height)
			{
				this._height = value;
				this._layoutEngine.invalidateSize(this);
				this._layoutEngine.invalidateDisplayList(this);
			}
		}


		/**
		 *	@inheritDoc
		 */
		override public function get width():Number
		{
			return this._width;
		}
		/**
		 *	@private
		 */
		override public function set width(value:Number):void
		{
			if (value != this._width)
			{
				this._width = value;
				this._layoutEngine.invalidateSize(this);
				this._layoutEngine.invalidateDisplayList(this);
			}
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function validateDisplayList():void
		{
			var availableWidth:Number = this.width - 2 * BORDER_SIZE;
			var nestedWindowSize:Number = availableWidth / this._nestedWindows.length;
			for each (var window:Window in this._nestedWindows)
			{
				window.width =
				window.height =  nestedWindowSize;
			}
			this._grid.layoutContainer(this, this._nestedWindows);
		}

		
		/**
		 * @inheritDoc
		 */
		public function validateProperties():void
		{
		}


		/**
		 * @inheritDoc	
		 */
		public function validateSize():void
		{
			this.background.width = this.width;
			this.background.height = this.height;
		}




	}
}