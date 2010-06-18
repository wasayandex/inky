package inky.components.map.view.helpers 
{
	import inky.layout.validation.LayoutValidator;
	import flash.display.DisplayObjectContainer;
	import inky.components.map.view.IMap;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import inky.components.tooltip.ITooltip;
	import inky.utils.toCoordinateSpace;
	
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
	public class HelperInfo
	{
		private var _contentContainer:DisplayObjectContainer;
		private var _layoutValidator:LayoutValidator;
		private var _map:IMap;
		private var _mask:DisplayObject;
		private var _overlayContainer:DisplayObjectContainer;
		private var _placemarkContainer:DisplayObjectContainer;
		private var _tooltip:ITooltip;

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
		public function get mask():DisplayObject
		{
			return this._mask;
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
		
		/**
		 * 
		 */
		public function get tooltip():ITooltip
		{
			return this._tooltip;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function getDragBounds():Rectangle
		{
			var b:Rectangle = this.calculateDragBounds();
			return b;
		}

		/**
		 *
		 */
		public function setContentContainer(contentContainer:DisplayObjectContainer):void
		{ 
			this._contentContainer = contentContainer; 
		}

		/**
		 *
		 */
		public function setLayoutValidator(layoutValidator:LayoutValidator):void
		{ 
			this._layoutValidator = layoutValidator; 
		}

		/**
		 *
		 */
		public function setMap(map:IMap):void
		{ 
			this._map = map;
		}

		/**
		 * 
		 */
		public function setMask(mask:DisplayObject):void
		{ 
			this._mask = mask; 
		}

		/**
		 *
		 */
		public function setOverlayContainer(overlayContainer:DisplayObjectContainer):void
		{ 
			this._overlayContainer = overlayContainer; 
		}

		/**
		 *
		 */
		public function setPlacemarkContainer(placemarkContainer:DisplayObjectContainer):void
		{ 
			this._placemarkContainer = placemarkContainer; 
		}

		/**
		 * 
		 */
		public function setTooltip(tooltip:ITooltip):void
		{ 
			this._tooltip = tooltip; 
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
	
		/**
		 * 
		 */
		private function calculateDragBounds():Rectangle
		{
			var map:DisplayObjectContainer = this.map as DisplayObjectContainer;
			var overlayBounds:Rectangle = this.overlayContainer.getRect(map);
			var maskBounds:Rectangle = this.mask.getRect(map);

			var p:Point = new Point(this.contentContainer.x, this.contentContainer.y);
			p = toCoordinateSpace(p, this.contentContainer.parent, map);
			p.x = overlayBounds.x - p.x;
			p.y = overlayBounds.y - p.y;

			var bounds:Rectangle = new Rectangle(
				maskBounds.width - overlayBounds.width - p.x,
				maskBounds.height - overlayBounds.height - p.y,
				overlayBounds.width - maskBounds.width,
				overlayBounds.height - maskBounds.height
			);

			return bounds;
		}

	}
	
}