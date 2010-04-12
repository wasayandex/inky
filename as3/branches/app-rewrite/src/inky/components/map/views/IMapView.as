package inky.components.map.views
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import inky.collections.IList;
	import inky.utils.IDisplayObject;
	
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
	public interface IMapView extends IDisplayObject
	{
		
		//
		// accessors
		//
		
		/**
		*	
		*/
		function get latLonBox():Object;
		function set latLonBox(value:Object):void;
		
		/**	
		*	Gets and Sets the model for the MapView. This model must be an IList.
		*	
		*	@param model
		*/
		function set model(value:IList):void;
		function get model():IList;
		
		/**
		*	Gets and Sets the PointViewClass for each point on the map.
		*	
		*	@param pointViewClass
		*/
		function set pointViewClass(value:Class):void;
		function get pointViewClass():Class;
						
		/**
		*	Gets and Sets the source for the MapView. This is the background of the map 
		*	that is dragged and zoomed in and out. This only supports DisplayObjects.
		*	
		*	@param source
		*		The source for the map pane. 
		*/
		function set source(value:DisplayObject):void;
		function get source():DisplayObject;
		
		/**
		*	Searches for a point on the map based on the model. Once found it will return the Point object.
		*	If no object is found then null is returned.
		*	
		*	@param value	
		*/
		function getPointByModel(value:Object):DisplayObject;
		
		/**
		*	Shows the point on the map based on the model object passed as a parameter.
		*	
		*	@param value
		*		The model object of the point to show.
		*/
		function showPointByModel(value:Object):void;
		
		
	}
}