package inky.components.map.view.helpers 
{
	import inky.components.map.view.IMap;
	import inky.components.map.view.helpers.MaskedMapViewHelper;
	import inky.components.tooltip.ITooltip;
	import inky.binding.utils.BindingUtil;
	import inky.utils.IDestroyable;
	import inky.components.map.view.events.MapEvent;
	import flash.display.InteractiveObject;
	
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
	public class TooltipHelper extends MaskedMapViewHelper implements IDestroyable
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
		public function TooltipHelper(map:IMap, placemarkRendererCallback:Function)
		{
			super(map);
			this.watchers = [];
			this.placemarkRendererCallback = placemarkRendererCallback;
			this.tooltip = this.content.getChildByName("_tooltip") as ITooltip;
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
		private function content_scaleHandler(event:MapEvent):void
		{
			//FIXME: If the tooltip implementation doesn't update position if the target doesn't change, this won't work.
			this.tooltip.target = this.target;
		}

		/**
		 * 
		 */
		private function content_moveHandler(event:MapEvent):void
		{
			//FIXME: If the tooltip implementation doesn't update position if the target doesn't change, this won't work.
			this.tooltip.target = this.target;
		}

		/**
		 * 
		 */
		private function placemarkSelectedHandler(placemarks:Array):void
		{
			if (placemarks && placemarks.length)
			{
				this.content.addEventListener(MapEvent.MOVE, this.content_moveHandler);
				this.content.addEventListener(MapEvent.SCALE, this.content_scaleHandler);
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
			this.content.removeEventListener(MapEvent.MOVE, this.content_moveHandler);
			this.content.removeEventListener(MapEvent.SCALE, this.content_scaleHandler);
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