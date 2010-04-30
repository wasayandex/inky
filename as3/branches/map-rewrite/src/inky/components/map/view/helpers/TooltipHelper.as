package inky.components.map.view.helpers 
{
	import inky.components.tooltip.ITooltip;
	import inky.binding.utils.BindingUtil;
	import inky.components.map.view.events.MapEvent;
	import inky.components.map.view.helpers.BaseMapHelper;
	import inky.components.map.view.helpers.HelperInfo;
	import flash.display.DisplayObjectContainer;
	import inky.components.map.view.events.MapFeatureEvent;
	
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
	public class TooltipHelper extends BaseMapHelper
	{
		private var _tooltip:ITooltip;
		private var watchers:Array;
		private var target:Object;

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
			
			if (this.info)
				this.initializeForTooltip();
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();

			if (this.watchers)
			{
				while (this.watchers.length)
					this.watchers.pop().unwatch();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize(info:HelperInfo):void
		{
			this.tooltip = DisplayObjectContainer(info.map).getChildByName("_tooltip") as ITooltip;

			super.initialize(info);

			if (this.tooltip)
				this.initializeForTooltip();
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
			if (this.tooltip)
			{
				if (placemarks && placemarks.length)
				{
					this.info.map.addEventListener(MapEvent.MOVED, this.content_movedHandler);
					this.info.map.addEventListener(MapEvent.SCALED, this.content_scaledHandler);
// TODO: How to get a ref to the placemark renderer??

//					this.target = 
//					this.tooltip.target = this.placemarkRendererCallback.apply(null, [placemarks.pop()]);
					this.tooltip.show();
trace('show tooltip!')
				}
				else
				{
					this.hideTooltip();
				}
			}
		}
		
		/**
		 * 
		 */
		private function hideTooltip():void
		{
			this._tooltip.hide();
			
			if (this.target)
				this.info.map.dispatchEvent(new MapFeatureEvent(MapFeatureEvent.DESELECT_PLACEMARK_TRIGGERED, this.target.model));

			if (this.info)
			{
				this.info.map.removeEventListener(MapEvent.MOVED, this.content_movedHandler);
				this.info.map.removeEventListener(MapEvent.SCALED, this.content_scaledHandler);
			}
		}
		
		/**
		 * 
		 */
		private function initializeForTooltip():void
		{
			if (this.watchers)
			{
				while (this.watchers.length)
					this.watchers.pop().unwatch();
			}
			
			if (this.tooltip)
			{
				this.hideTooltip();

				this.watchers =
				[
					BindingUtil.bindSetter(this.placemarkSelectedHandler, info.map, ["model", "selectedPlacemarks"])
				];
			}
		}
		
	}
	
}