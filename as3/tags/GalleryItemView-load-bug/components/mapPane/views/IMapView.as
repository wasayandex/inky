package inky.framework.components.mapPane.views
{
	import inky.framework.components.mapPane.models.MapModel;
	
	public interface IMapView
	{
		
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
		function set pointViewClass(pointViewClass:Class):void;
		function get pointViewClass():Class;
				
		/**
		*	Gets and Sets the source for the MapPane. Essentially, this is the background of the map 
		*	that is dragged and zoomed into. Currently, this only supports DisplayObjects.
		*	
		*	@param source
		*		The source for the map pane. 
		*/
		function set source(source:Object):void;
		function get source():Object;
	}
}