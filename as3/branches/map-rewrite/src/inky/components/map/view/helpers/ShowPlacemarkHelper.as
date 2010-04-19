package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.MaskedMapViewHelper;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import inky.utils.toCoordinateSpace;
	import inky.components.map.view.IInteractiveMap;
	import inky.utils.IDestroyable;
	
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
	public class ShowPlacemarkHelper extends MaskedMapViewHelper implements IDestroyable
	{
		private var placemarkRendererCallback:Function;
		
		/**
		 *
		 */
		public function ShowPlacemarkHelper(map:IInteractiveMap, placemarkRendererCallback:Function)
		{
			super(map);
			this.placemarkRendererCallback = placemarkRendererCallback;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function showPlacemark(placemark:Object):void
		{
			var placemarkRenderer:Object = this.placemarkRendererCallback(placemark);
			var point:Point = toCoordinateSpace(new Point(placemarkRenderer.x, placemarkRenderer.y), this.contentContainer, this.content);

			var maskBounds:Rectangle = this.mask.getRect(this.content);
			var x:Number = this.contentContainer.x - (point.x - maskBounds.width / 2);
			var y:Number = this.contentContainer.y - (point.y - maskBounds.height / 2);

			var dragBounds:Rectangle = this.getDragBounds();
			x = Math.max(Math.min(x, dragBounds.x + dragBounds.width), dragBounds.x);
			y = Math.max(Math.min(y, dragBounds.y + dragBounds.height), dragBounds.y);

			IInteractiveMap(this.map).moveContent(x, y);
		}

		
	}
	
}