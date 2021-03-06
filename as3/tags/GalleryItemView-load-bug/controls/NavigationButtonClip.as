package inky.framework.controls 
{
	import com.exanimo.controls.ButtonClip;
	import inky.framework.controls.INavigationButton;
	import inky.framework.controls.NavigationButtonBehavior;

	
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
	 *	@since  2009.01.15
	 *
	 */
	public class NavigationButtonClip extends ButtonClip implements INavigationButton 
	{
		private var _proxy:NavigationButtonBehavior;

		
		/**
		 *
		 */
		public function NavigationButtonClip()
		{
			this._proxy = new NavigationButtonBehavior(this);
		}




		//
		// accessors
		//
		
		
		/**
		 *
		 */
		public function get address():String
		{
			return this._proxy.address;
		}
		/**
		 * @private
		 */
		public function set address(address:String):void
		{
			this._proxy.address = address;
		}

		
		/**
		 *
		 */
		public function get autoSelect():Boolean
		{
			return this._proxy.autoSelect;
		}
		public function set autoSelect(autoSelect:Boolean):void
		{
			this._proxy.autoSelect = autoSelect;
		}
		
		
		/**
		 *
		 */
		public function get options():Object
		{
			return this._proxy.options;
		}
		/**
		 * @private
		 */
		public function set options(options:Object):void
		{
			this._proxy.options = options;
		}
		
		
		/**
		 *
		 */
		public function get sPath():Object
		{
			return this._proxy.sPath;
		}
		/**
		 * @private
		 */
		public function set sPath(sPath:Object):void
		{
			this._proxy.sPath = sPath;
		}


		
	}
	
}
