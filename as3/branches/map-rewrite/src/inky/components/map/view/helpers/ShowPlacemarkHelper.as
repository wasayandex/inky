package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.BaseMapHelper;
	import inky.components.map.view.helpers.HelperInfo;
	import inky.components.map.view.events.MapChangeEvent;
	import inky.components.map.view.events.MapFeatureEvent;
	import inky.components.map.view.helpers.HelperType;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import inky.utils.toCoordinateSpace;
	import inky.binding.utils.BindingUtil;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.19
	 *
	 */
	public class ShowPlacemarkHelper extends BaseMapHelper
	{
		private var watchers:Array;

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
			super.initialize(info);
			this.watchers =
			[
				BindingUtil.bindSetter(this.setSelectedPlacemarks, this.info.map, ["model", "selectedPlacemarks"])
			];
		}
		
		/**
		 * Updates the view to reveal the associated placemark renderer for a 
		 * given placemark.
		 * 
		 * @param placemark
		 * 		The placemark to show.
		 */
		public function showPlacemark(placemark:Object):void
		{
			if (this.info && placemark)
			{
				var placemarkHelper:Object = this.info.map.getHelper(HelperType.PLACEMARK_HELPER);
				var panningHelper:Object = this.info.map.getHelper(HelperType.PANNING_HELPER);
				var map:DisplayObject = DisplayObject(this.info.map);
				var contentContainer:DisplayObjectContainer = this.info.contentContainer;
				var placemarkRenderer:Object = placemarkHelper.getPlacemarkRendererFor(placemark);
				var dragBounds:Rectangle = panningHelper.getDragBounds();

				var point:Point = toCoordinateSpace(new Point(placemarkRenderer.x, placemarkRenderer.y), contentContainer, map);

				var maskBounds:Rectangle = this.info.mask.getRect(map);
				var x:Number = Math.max(dragBounds.x, contentContainer.x - (point.x - maskBounds.width / 2));
				var y:Number = Math.max(dragBounds.y, contentContainer.y - (point.y - maskBounds.height / 2));
				
/*
trace(x, y);
trace(panningHelper.verticalPan, panningHelper.horizontalPan)
trace(dragBounds);
				panningHelper.verticalPan = x / dragBounds.x;
				panningHelper.horizontalPan = y / dragBounds.y;
trace(panningHelper.verticalPan, panningHelper.horizontalPan)*/
			}
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function setSelectedPlacemarks(placemarks:Array):void
		{
			if (placemarks && placemarks.length)
				this.showPlacemark(placemarks[0]);
		}

	}
	
}