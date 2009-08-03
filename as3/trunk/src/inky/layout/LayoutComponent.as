package inky.layout 
{
	import flash.display.Sprite;
	import inky.layout.LayoutEngine;
	import flash.display.DisplayObjectContainer;
	import inky.layout.ILayoutManager;
	import flash.events.Event;
	import inky.layout.GridLayout;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.07.30
	 *
	 */
	public class LayoutComponent extends Sprite implements ILayoutClient
	{
		private var _width:Number;
		private var _height:Number;
		private var _oldWidth:Number;
		private var _oldHeight:Number;


public var layoutManager:ILayoutManager;


		/**
		 *
		 */
		public function LayoutComponent()
		{
			this._width = super.width;
			this._height = super.height;
			this.addEventListener(Event.ADDED, this._addedHandler);
		}

		private function _addedHandler(event:Event):void
		{
			LayoutEngine.getInstance().invalidateDisplayList(this);
		}


		/**
		 *
		 */
		override public function get height():Number
		{ 
			return this._height; 
		}
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			if (value != this._height)
			{
				this._height = value;
				LayoutEngine.getInstance().invalidateSize(this);
			}
		}

		


		/**
		 *
		 */
		override public function get width():Number
		{ 
			return this._width; 
		}
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			if (value != this._width)
			{
				this._width = value;
				LayoutEngine.getInstance().invalidateSize(this);
			}
		}






		public function validateSize():void
		{
trace("validateSize()\t\t" + this.name);
throw new Error();
		}
		
		
		public function validateDisplayList():void
		{
trace("validateDisplayList()\t\t" + this.name);
// TODO: Obviously, this shouldn't be here:
			if (this.layoutManager)
			{
				var grid:GridLayout = this.layoutManager as GridLayout;
				if (grid)
				{
					grid.numColumns = Math.floor(this.width / 100);
					grid.layoutContainer(this);
				}
			}
		}
		
		public function validateProperties():void
		{
trace("validateProperties()\t\t" + this.name);
		}



		
	}
	
}