package inky.components.map.views 
{
	import flash.display.DisplayObject;
	import inky.collections.IList;
	import inky.components.map.views.IMapView;
	import inky.components.scrollPane.views.IScrollPane;
	import inky.utils.IDisplayObject;
	import inky.components.map.views.IMapView;

	/**
	 *
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	
	 */
	public interface IScrollableMapView extends IMapView
	{
				
		/**
		*	Gets and Sets the maximum amount the MapView will be zoomed into. This correlates
		*	with the scale of the MapView. By default this is set to 3.
		*	
		*	@param maximumZoom
		*		The maximum amount that the MapView can be zoomed into.
		*/
		function set maximumZoom(value:Number):void;
		function get maximumZoom():Number;
		
		/**
		*	Gets and Sets the minimum amount the MapView will be zoomed out. This correlates
		*	with the scale of the MapView. By default this is set to 1.
		*	
		*	@param minimumZoom
		*		The minimum amount that the MapView can be zoomed out.
		*/
		function set minimumZoom(value:Number):void;
		function get minimumZoom():Number;
								
		/**
		*	Gets and Sets the zoomInButton that can be any type of DisplayObject. 
		*	This can also be an IButton. If it is then it's enabled property is automatically
		*	set once clicked. Once pressed the MapView will scale up to the maximumZoom set. 
		*	
		*	@param button
		*		A DisplayObject to be used as the ZoomInButton.
		*/
		function set zoomInButton(value:DisplayObject):void;
		function get zoomInButton():DisplayObject;
		
		/**
		*	Gets and Sets the zoomOutButton that can be any type of DisplayObject.
		*	This can also be an IButton. If it is then it's enabled property is automatically
		*	set once clicked. Once pressed the MapView will scale down to the minimumZoom set.
		*	
		*	@param button
		*		A DisplayObject to be used as the ZoomOutButton.
		*/
		function set zoomOutButton(value:DisplayObject):void;
		function get zoomOutButton():DisplayObject;		
	}
}