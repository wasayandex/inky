package inky.components.map.models
{
	import flash.events.EventDispatcher;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Rich Perez
	 *	@since  2010.02.19
	 *
	 */
	dynamic public class GroundOverlayModel extends EventDispatcher
	{
		private var _latLonBox:Object;
		
		/**
		 *
		 */
		public function GroundOverlayModel()
		{
		}
		
		/**
		*		
		*/
		public function get latLonBox():Object
		{
			return this._latLonBox;
		}
		public function set latLonBox(value:Object):void
		{
			this._latLonBox = value;
		}

	}
}

