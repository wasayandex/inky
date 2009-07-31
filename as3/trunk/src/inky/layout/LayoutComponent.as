package inky.layout 
{
	import flash.display.Sprite;
	import inky.layout.LayoutEngine;
	import flash.display.DisplayObjectContainer;

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
	public class LayoutComponent extends Sprite
	{
		private var _width:Number;
		private var _height:Number;


		/**
		 *
		 */
		public function LayoutComponent()
		{
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
			if (this.width != super.width)
				super.width = this.width;

			if (this.height != super.height)
				super.height = this.height;
		}
		
		
		public function validateDisplayList():void
		{
trace("validateDisplayList()\t\t" + this.name);
		}
		
		public function validateProperties():void
		{
trace("validateProperties()\t\t" + this.name);
		}



		
	}
	
}