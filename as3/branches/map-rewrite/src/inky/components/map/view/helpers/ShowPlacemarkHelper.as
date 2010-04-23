package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.MaskedMapViewHelper;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import inky.utils.toCoordinateSpace;
	import inky.components.map.view.IInteractiveMap;
	import inky.utils.IDestroyable;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import inky.layout.validation.LayoutValidator;
	
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
		 * @copy inky.components.map.view.helpers.MaskedMapViewHelper
		 * 
		 * @param placemarkRendererCallback
		 * 		A method used to retreive the renderer for a placemark.
		 */
		public function ShowPlacemarkHelper(map:IInteractiveMap, layoutValidator:LayoutValidator, mask:DisplayObject, contentContainer:DisplayObjectContainer, placemarkRendererCallback:Function)
		{
			super(map, layoutValidator, mask, contentContainer);
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
		 * Updates the view to reveal the associated placemark renderer for a 
		 * given placemark.
		 * 
		 * @param placemark
		 * 		The placemark to show.
		 */
		public function showPlacemark(placemark:Object):void
		{
			var placemarkRenderer:Object = this.placemarkRendererCallback(placemark);
			var point:Point = toCoordinateSpace(new Point(placemarkRenderer.x, placemarkRenderer.y), this.contentContainer, this.mapContent);

			var maskBounds:Rectangle = this.mask.getRect(this.mapContent);
			var x:Number = this.contentContainer.x - (point.x - maskBounds.width / 2);
			var y:Number = this.contentContainer.y - (point.y - maskBounds.height / 2);

			IInteractiveMap(this.map).moveContent(x, y);
		}

		
	}
	
}