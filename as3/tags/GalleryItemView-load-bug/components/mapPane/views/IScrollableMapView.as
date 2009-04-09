package inky.framework.components.mapPane.views 
{
	import flash.display.DisplayObject;
	import inky.framework.components.mapPane.models.MapModel;
	import inky.framework.components.mapPane.views.IMapView;
	import inky.framework.components.scrollPane.views.IScrollPane;

	public interface IScrollableMapView 
	{
		/**
		*	Gets and Sets the scrollpane.
		*	
		*	@param scrolPane
		*/
		function set scrollPane(scrollPane:IScrollPane):void;
		function get scrollPane():IScrollPane;

		/**
		*	Gets and Sets the mapview for the ScrollMapView.
		*	
		*	@param mapview
		*/
		function set mapView(mapView:IMapView):void;
		function get mapView():IMapView;
		
		/**
		*	Gets and Sets the zoomInButton that can be any type of DisplayObject. 
		*	This can also be an IButton. If it is then it's enabled property is automatically
		*	set once clicked. Once pressed the MapView will scale up to the maximumZoom set. 
		*	
		*	@param button
		*		A DisplayObject to be used as the ZoomInButton.
		*/
		function set zoomInButton(button:DisplayObject):void;
		function get zoomInButton():DisplayObject;
		
		/**
		*	Gets and Sets the zoomOutButton that can be any type of DisplayObject.
		*	This can also be an IButton. If it is then it's enabled property is automatically
		*	set once clicked. Once pressed the MapView will scale down to the minimumZoom set.
		*	
		*	@param button
		*		A DisplayObject to be used as the ZoomOutButton.
		*/
		function set zoomOutButton(button:DisplayObject):void;
		function get zoomOutButton():DisplayObject;
		
		/**
		*	Gets and Sets the maximum amount the MapView will be zoomed into. This correlates
		*	with the scale of the MapView. By default this is set to 3.
		*	
		*	@param maximumZoom
		*		The maximum amount that the MapView can be zoomed into.
		*/
		function set maximumZoom(maximumZoom:Number):void;
		function get maximumZoom():Number;
		
		/**
		*	Gets and Sets the minimum amount the MapView will be zoomed out. This correlates
		*	with the scale of the MapView. By default this is set to 1.
		*	
		*	@param minimumZoom
		*		The minimum amount that the MapView can be zoomed out.
		*/
		function set minimumZoom(minimumZoom:Number):void;
		function get minimumZoom():Number;
		
		/**
		*	Gets and Sets the base tween to be used by the Tweener library. This allows a user to 
		*	customize the type of easing and other properties related to the animation.
		*	
		*	@param baseTween
		*/
		function set baseTween(baseTween:Object):void;
		function get baseTween():Object;
		
		/**	
		*	Gets and Sets the model for the MapView. This model must be a MapModel.
		*	
		*	@param model
		*/
		function set model(model:MapModel):void;
		function get model():MapModel;
		
		/**
		*	Gets and Sets the PointViewClass for each point on the map.
		*	
		*	@param pointViewClass
		*/
		function get pointViewClass():Class;
		function set pointViewClass(pointViewClass:Class):void;
	}
}

