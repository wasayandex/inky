package  
{
	import flash.display.Sprite;
	import inky.layout.ILayoutManagerClient;
	import inky.layout.LayoutManager;
	import inky.layout.layouts.gridLayout.GridLayout;

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
	public class Window extends Sprite implements ILayoutManagerClient
	{
		private var gridLayout:GridLayout;
		private var _height:Number;
		private var layoutManager:LayoutManager;
		private var nestedWindows:Array;
		private var _width:Number;
		
		private static const BORDER_SIZE:Number = 2;


		/**
		 *
		 */
		public function Window()
		{
			this.gridLayout = new GridLayout();
			this.nestedWindows = [];
			this.layoutManager = LayoutManager.getInstance();
			
			// Set default values.
			this._width = super.width;
			this._height = super.height;
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

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
				this.layoutManager.invalidateLayout(this);
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
				this.layoutManager.invalidateLayout(this);
			}
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * 
		 */
		public function addNestedWindow(window:Window):Window
		{
			// Add the window to the display list.
			this.nestedWindowContainer.addChild(window);
			
			// Add the window to the list of windows.
			if (this.nestedWindows.indexOf(window) == -1)
				this.nestedWindows.push(window);
				
			// Invalidate the display list.
			this.layoutManager.invalidateLayout(this);
			return window;
		}

		/**
		 * @inheritDoc
		 */
		public function validateLayout():void
		{
			// Validate the size.
			this.background.width = this.width;
			this.background.height = this.height;
			
			var availableWidth:Number = this.width - 2 * BORDER_SIZE;
			var nestedWindowSize:Number = availableWidth / this.nestedWindows.length;

			for each (var window:Window in this.nestedWindows)
			{
				window.width =
				window.height = nestedWindowSize;
			}
			this.gridLayout.layoutContainer(this, this.nestedWindows);
		}

	}
}