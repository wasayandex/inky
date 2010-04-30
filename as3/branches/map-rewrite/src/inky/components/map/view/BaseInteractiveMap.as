package inky.components.map.view 
{
	import inky.components.map.view.BaseMap;
	import inky.components.map.view.helpers.PanningHelper;
	import inky.components.map.view.helpers.ZoomingHelper;
	import inky.components.map.view.helpers.TooltipHelper;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import inky.components.map.view.helpers.HelperType;
	
	/**
	 *
	 *  A basic implementation of IMap. This implementation extends the BaseMap 
	 *  implementation with more interactive functionality, such as panning and 
	 *  zooming.
	 * 
	 *  @see inky.components.map.view.IMap
	 * 	@see inky.components.map.view.BaseMap
	 *  @see inky.components.map.view.InteractiveMap
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.11
	 *
	 */
	public class BaseInteractiveMap extends BaseMap
	{
		private var __mask:DisplayObject;
		
		/**
		 * Creates a BaseInteractiveMap. 
		 * This class can be instantiated directly, but generally should be extended intstead.
		 */
		public function BaseInteractiveMap()
		{
			super();

			// Find the content container mask.
			var mask:DisplayObject = this.contentContainer.mask || this.getChildByName('_mask');
			if (!mask)
			{ 
				var child:DisplayObject;
				for (var i:int = this.numChildren - 1; i >= 0; i--)
				{
					child = this.getChildAt(i);
					if (child is Shape)
					{
						mask = child;
						break;
					}
				}
			}

			if (!mask)
				throw new Error('Map is missing a mask.');

			if (this.contentContainer.mask != mask)
				this.contentContainer.mask = mask;

			this.__mask = mask;
			
			this.helperInfo.mask = mask;
			
			this.registerHelper(PanningHelper, HelperType.PANNING_HELPER, {horizontalPan: "horizontalPan", verticalPan: "verticalPan", panningProxy: "panningProxy"});
			this.registerHelper(ZoomingHelper, HelperType.ZOOMING_HELPER, {zoom: "zoom", minimumZoom: "minimumZoom", maximumZoom: "maximumZoom", zoomingProxy: "zoomingProxy"});
			this.registerHelper(TooltipHelper, HelperType.TOOLTIP_HELPER);
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		override protected function reset():void
		{
			/*this.contentContainer.x = 
			this.contentContainer.y = 0;
			this.overlayContainer.scaleX =
			this.overlayContainer.scaleY = this.minimumZoom;*/

			super.reset();
		}
		
	}
	
}