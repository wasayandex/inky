package inky.components.map.view.helpers 
{
	import inky.components.map.view.IMap;
	import inky.components.tooltip.ITooltip;
	import inky.binding.utils.BindingUtil;
	import inky.utils.IDestroyable;
	import inky.components.map.view.events.MapEvent;
	import flash.display.InteractiveObject;
	import inky.layout.validation.LayoutValidator;
	import inky.components.map.view.helpers.BaseMapViewHelper;
	
	/**
	 *
	 *  An IMap view helper that provides basic tooltip functionality.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.16
	 *
	 */
	public class TooltipHelper extends BaseMapViewHelper implements IDestroyable
	{
		private var target:InteractiveObject;
		private var _tooltip:ITooltip;
		private var watchers:Array;
		private var placemarkRendererCallback:Function;

		/**
		 * @copy inky.components.map.view.helpers.MaskedMapViewHelper
		 * 
		 * @param placemarkRendererCallback
		 * 		A method that is used to get the renderer (display object) that 
		 * 		corresponds to a placemark. The renderer is passed to the tooltip 
		 * 		as its target.
		 * 
		 * @see inky.components.tooltip.ITooltip#target
		 */
		public function TooltipHelper(map:IMap, layoutValidator:LayoutValidator, placemarkRendererCallback:Function)
		{
			super(map, layoutValidator);
			this.watchers = [];
			this.placemarkRendererCallback = placemarkRendererCallback;
			this.tooltip = this.mapContent.getChildByName("_tooltip") as ITooltip;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Gets and sets the tooltip for the map.
		 */
		public function get tooltip():ITooltip
		{ 
			return this._tooltip; 
		}
		/**
		 * @private
		 */
		public function set tooltip(value:ITooltip):void
		{
			if (this._tooltip)
				this.hideTooltip();

			this._tooltip = value;
			this.initializeForTooltip();
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			if (this.tooltip)
				this.tooltip.hide();
			
			while (this.watchers.length)
				this.watchers.pop().unwatch();
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function content_scaledHandler(event:MapEvent):void
		{
			this.tooltip.updatePosition();
		}

		/**
		 * 
		 */
		private function content_movedHandler(event:MapEvent):void
		{
			this.tooltip.updatePosition();
		}

		/**
		 * 
		 */
		private function placemarkSelectedHandler(placemarks:Array):void
		{
			if (placemarks && placemarks.length)
			{
				this.map.addEventListener(MapEvent.MOVED, this.content_movedHandler);
				this.map.addEventListener(MapEvent.SCALED, this.content_scaledHandler);
				this.target = 
				this.tooltip.target = this.placemarkRendererCallback.apply(null, [placemarks.pop()]);
				this.tooltip.show();
			}
			else
			{
				this.hideTooltip();
			}
		}
		
		/**
		 * 
		 */
		private function hideTooltip():void
		{
			this._tooltip.hide();
			this.map.removeEventListener(MapEvent.MOVED, this.content_movedHandler);
			this.map.removeEventListener(MapEvent.SCALED, this.content_scaledHandler);
		}
		
		/**
		 * 
		 */
		private function initializeForTooltip():void
		{
			while (this.watchers.length)
				this.watchers.pop().unwatch();

			if (this.tooltip)
			{
				this.watchers.push(BindingUtil.bindSetter(this.placemarkSelectedHandler, map, ["model", "selectedPlacemarks"]));
				this.hideTooltip();
			}
		}
		
	}
	
}