package inky.components.map.view.helpers 
{
	import inky.layout.validation.LayoutValidator;
	import flash.display.DisplayObjectContainer;
	import inky.components.map.view.IMap;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.29
	 *
	 */
// FIXME: This is hacked (dynamic) to allow extra info (such as mask, tooltip, etc) to be added to the object in subclasses of BaseMap. 
	dynamic public class HelperInfo
	{
		private var _contentContainer:DisplayObjectContainer;
		private var _layoutValidator:LayoutValidator;
		private var _map:IMap;
		private var _overlayContainer:DisplayObjectContainer;
		private var _placemarkContainer:DisplayObjectContainer;
		
		/**
		 *
		 */
		public function HelperInfo(map:IMap, layoutValidator:LayoutValidator, contentContainer:DisplayObjectContainer, placemarkContainer:DisplayObjectContainer, overlayContainer:DisplayObjectContainer)
		{
			this._contentContainer = contentContainer;
			this._layoutValidator = layoutValidator;
			this._map = map;
			this._overlayContainer = overlayContainer;
			this._placemarkContainer = placemarkContainer;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 *
		 */
		public function get contentContainer():DisplayObjectContainer
		{ 
			return this._contentContainer; 
		}
		
		/**
		 *
		 */
		public function get layoutValidator():LayoutValidator
		{ 
			return this._layoutValidator; 
		}
		
		/**
		 *
		 */
		public function get map():IMap
		{ 
			return this._map; 
		}
		
		/**
		 *
		 */
		public function get overlayContainer():DisplayObjectContainer
		{ 
			return this._overlayContainer; 
		}
		
		/**
		 *
		 */
		public function get placemarkContainer():DisplayObjectContainer
		{ 
			return this._placemarkContainer; 
		}

	}
	
}