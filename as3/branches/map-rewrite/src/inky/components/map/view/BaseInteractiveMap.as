package inky.components.map.view 
{
	import inky.components.map.view.BaseMap;
	import inky.components.map.view.helpers.PanningHelper;
	import inky.components.map.view.helpers.ZoomingHelper;
	import flash.display.InteractiveObject;
	import inky.components.map.view.helpers.TooltipHelper;
	import inky.components.tooltip.ITooltip;
	import inky.binding.utils.BindingUtil;
	import flash.display.DisplayObject;
	import inky.components.map.view.IInteractiveMap;
	import inky.components.map.view.helpers.ShowPlacemarkHelper;
	import flash.display.Shape;
	import inky.binding.events.PropertyChangeEvent;
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
	public class BaseInteractiveMap extends BaseMap implements IInteractiveMap
	{
		private var __mask:DisplayObject;
		private var _horizontalPan:Number;
		private var _panningProxy:Object;
		private var _verticalPan:Number;
		private var _zoom:Number;
		
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
			
			this.registerHelper(PanningHelper, HelperType.PANNING_HELPER);
			this.registerHelper(ZoomingHelper, HelperType.ZOOMING_HELPER);
			
			/*this.panningHelper = new PanningHelper(this, this.layoutValidator, this.__mask, this.contentContainer);
			this.zoomingHelper = new ZoomingHelper(this, this.layoutValidator, this.__mask, this.contentContainer, this.overlayContainer);
			this.showPlacemarkHelper = new ShowPlacemarkHelper(this, this.layoutValidator, this.__mask, this.contentContainer, this.getPlacemarkRendererFor);
			this.tooltipHelper = new TooltipHelper(this, this.layoutValidator, this.getPlacemarkRendererFor);*/
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function showPlacemark(placemark:Object):void
		{
//			this.showPlacemarkHelper.showPlacemark(placemark);
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