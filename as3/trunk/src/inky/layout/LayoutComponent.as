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
			LayoutEngine.getInstance().invalidateSize(this);
			this._height = value;
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
			LayoutEngine.getInstance().invalidateSize(this);
			this._width = value;
		}



		public function get nestLevel():int
		{
			var nestLevel:int;
			if (!this.stage)
			{
				nestLevel = -1;
			}
			else
			{
				nestLevel = 0;
				var tmp:DisplayObjectContainer = this;
				while ((tmp = tmp.parent))
					nestLevel++;
			}
			return nestLevel;
		}



		public function validateSize():void
		{
trace(this.name + "\tvalidateSize()");
		}
		
		
		public function validateDisplayList():void
		{
trace(this.name + "\validateDisplayList()");
		}
		
		public function validateProperties():void
		{
trace(this.name + "\validateProperties()");
		}



		
	}
	
}