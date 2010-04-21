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
	import flash.events.Event;
	
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
		private var panningHelper:PanningHelper;
		private var zoomingHelper:ZoomingHelper;
		private var showPlacemarkHelper:ShowPlacemarkHelper;
		private var tooltipHelper:TooltipHelper;
		
		/**
		 * Creates a BaseInteractiveMap. 
		 * This class can be instantiated directly, but generally should be extended intstead.
		 */
		public function BaseInteractiveMap()
		{
			super();
			this.overlayLoader.addEventListener("overlayUpdated", this.overlayLoader_overlayUpdatedHandler);
			this.panningHelper = new PanningHelper(this);
			this.zoomingHelper = new ZoomingHelper(this);
			this.tooltipHelper = new TooltipHelper(this, this.getPlacemarkRendererFor);
			this.showPlacemarkHelper = new ShowPlacemarkHelper(this, this.getPlacemarkRendererFor);
			BindingUtil.bindSetter(this.reset, this, "model");
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

// TODO: Store the exposed helper properties, in case a subclass delays super construction until after setting them?
		
		/**
		 * @inheritDoc
		 */
		override public function get contentRotation():Number
		{ 
			return this.zoomingHelper.contentRotation; 
		}
		/**
		 * @private
		 */
		override public function set contentRotation(value:Number):void
		{
			this.zoomingHelper.contentRotation = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get contentX():Number
		{ 
			return this.panningHelper.contentX; 
		}
		/**
		 * @private
		 */
		override public function set contentX(value:Number):void
		{
			this.panningHelper.contentX = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get contentY():Number
		{ 
			return this.panningHelper.contentY; 
		}
		/**
		 * @private
		 */
		override public function set contentY(value:Number):void
		{
			this.panningHelper.contentY = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get contentScaleX():Number
		{ 
			return this.zoomingHelper.contentScaleX; 
		}
		/**
		 * @private
		 */
		override public function set contentScaleX(value:Number):void
		{
			this.zoomingHelper.contentScaleX = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get contentScaleY():Number
		{ 
			return this.zoomingHelper.contentScaleY; 
		}
		/**
		 * @private
		 */
		override public function set contentScaleY(value:Number):void
		{
			this.zoomingHelper.contentScaleY = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#maximumZoom
		 */
		public function get maximumZoom():Number
		{ 
			return this.zoomingHelper.maximumZoom; 
		}
		/**
		 * @private
		 */
		public function set maximumZoom(value:Number):void
		{
			this.zoomingHelper.maximumZoom = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#minimumZoom
		 */
		public function get minimumZoom():Number
		{ 
			return this.zoomingHelper.minimumZoom; 
		}
		/**
		 * @private
		 */
		public function set minimumZoom(value:Number):void
		{
			this.zoomingHelper.minimumZoom = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.PanningHelper#panningProxy
		 */
		public function get panningProxy():Object
		{ 
			return this.panningHelper.panningProxy; 
		}
		/**
		 * @private
		 */
		public function set panningProxy(value:Object):void
		{
			this.panningHelper.panningProxy = value;
		}

		/**
		 * @copy inky.components.map.view.helpers.TooltipHelper#tooltip
		 */
		public function get tooltip():ITooltip
		{ 
			return this.tooltipHelper.tooltip;
		}
		/**
		 * @private
		 */
		public function set tooltip(value:ITooltip):void
		{
			this.tooltipHelper.tooltip = value;
		}

		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#zoomInButton
		 */
		public function get zoomInButton():InteractiveObject
		{ 
			return this.zoomingHelper.zoomInButton; 
		}
		/**
		 * @private
		 */
		public function set zoomInButton(value:InteractiveObject):void
		{
			this.zoomingHelper.zoomInButton = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#zoomingProxy
		 */
		public function get zoomingProxy():Object
		{ 
			return this.zoomingHelper.zoomingProxy; 
		}
		/**
		 * @private
		 */
		public function set zoomingProxy(value:Object):void
		{
			this.zoomingHelper.zoomingProxy = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#zoomInterval
		 */
		public function get zoomInterval():Number
		{ 
			return this.zoomingHelper.zoomInterval; 
		}
		/**
		 * @private
		 */
		public function set zoomInterval(value:Number):void
		{
			this.zoomingHelper.zoomInterval = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#zoomOutButton
		 */
		public function get zoomOutButton():InteractiveObject
		{ 
			return this.zoomingHelper.zoomOutButton; 
		}
		/**
		 * @private
		 */
		public function set zoomOutButton(value:InteractiveObject):void
		{
			this.zoomingHelper.zoomOutButton = value;
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
			this.panningHelper.destroy();
			this.zoomingHelper.destroy();
			this.tooltipHelper.destroy();
			this.showPlacemarkHelper.destroy();
		}

		/**
		 * @copy inky.components.map.view.helpers.PanningHelper#moveContent
		 */
		public function moveContent(x:Number, y:Number):void
		{
			this.panningHelper.moveContent(x, y);
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#scaleContent
		 */
		public function scaleContent(scaleX:Number, scaleY:Number):void
		{
			this.zoomingHelper.scaleContent(scaleX, scaleY);
		}
		
		/**
		 * @inheritDoc
		 */
		public function showPlacemark(placemark:Object):void
		{
			this.showPlacemarkHelper.showPlacemark(placemark);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function overlayLoader_overlayUpdatedHandler(event:Event):void
		{
			for each (var helper:Object in [
				this.panningHelper,
				this.zoomingHelper,
				this.showPlacemarkHelper,
				this.tooltipHelper
			])
			{
				helper.onOverlayUpdated();
			}
		}
		
		/**
		 * 
		 */
		private function reset(model:Object):void
		{
			var contentContainer:DisplayObject = this.getContentContainer();
			contentContainer.x = 
			contentContainer.y = 0;
			contentContainer.scaleX =
			contentContainer.scaleY = this.minimumZoom;
			
			this.panningHelper.reset();
			this.zoomingHelper.reset();
			this.tooltipHelper.reset();
			this.showPlacemarkHelper.reset();
		}
		
	}
	
}