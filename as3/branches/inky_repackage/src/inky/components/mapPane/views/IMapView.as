package inky.components.mapPane.views
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
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
		*	Gets and Sets the model for the MapView. This model must be a MapModel.
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
		*	Gets and sets the reference point for the map. This returns a Point object containg
		*	the x and y values. By default it returns a Point with (0, 0) values. 
		*	
		*	@param point
		*/
		function set referencePoint(value:Point):void
		function get referencePoint():Point;
				
		/**
		*	Gets and Sets the source for the MapPane. This is the background of the map 
		*	that is dragged and zoomed in and out. This only supports DisplayObjects.
		*	
		*	@param source
		*		The source for the map pane. 
		*/
		function set source(value:Sprite):void;
		function get source():Sprite;
		
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