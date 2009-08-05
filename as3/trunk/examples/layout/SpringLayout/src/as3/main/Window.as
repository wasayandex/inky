package  
{
	import flash.display.Sprite;
	import inky.layout.ILayoutManagerClient;
	import inky.layout.LayoutManager;
	import inky.layout.GridLayout;

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
		public var layout:*;
		private var _height:Number;
		private var _LayoutManager:LayoutManager;
		private var _width:Number;
		



		/**
		 *
		 */
		public function Window()
		{
			this._LayoutManager = LayoutManager.getInstance();
			
			// Set default values.
			this._width = super.width;
			this._height = super.height;
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
				this._LayoutManager.invalidateSize(this);
				this._LayoutManager.invalidateDisplayList(this);
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
				this._LayoutManager.invalidateSize(this);
				this._LayoutManager.invalidateDisplayList(this);
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
			if (this.layout)
				this.layout.layoutContainer(this);
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