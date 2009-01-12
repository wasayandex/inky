package inky.framework.controls 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import inky.framework.core.Section;
	import inky.framework.core.SPath;
	import inky.framework.utils.gotoSection;

	
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
	 *	@since  2009.01.12
	 *
	 */
	public class NavigationButton extends Sprite
	{
		private var _address:String;
		private var _options:Object;
		private var _sPath:String;

		
		/**
		 *
		 */
		public function NavigationButton()
		{
			this.addEventListener(MouseEvent.CLICK, this._clickHandler);
		}
		
		
		
		
		//
		// accessors
		//
		
		
		/**
		 *
		 */
		public function get address():String
		{
			return this._address;
		}
		/**
		 * @private
		 */
		public function set address(address:String):void
		{
			this._address = address;
		}


		/**
		 *
		 */
		public function get options():Object
		{
			return this._options;
		}
		/**
		 * @private
		 */
		public function set options(options:Object):void
		{
			this._options = options;
		}

		
		/**
		 *
		 */
		public function get sPath():String
		{
			return this._sPath;
		}
		/**
		 * @private
		 */
		public function set sPath(sPath:String):void
		{
			this._sPath = sPath;
		}
		
		
		
		
		
		//
		// private methods
		//


		/**
		 *	@private
		 */
		private function _clickHandler(e:MouseEvent):void
		{
			gotoSection(this.sPath, this.options);
		}
		
	}
	
}
