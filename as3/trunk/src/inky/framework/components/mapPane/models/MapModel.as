package inky.framework.components.mapPane.models 
{
	import flash.events.EventDispatcher;
	import inky.framework.collections.ArrayList;
	import inky.framework.collections.IList;
	
	public class MapModel extends EventDispatcher
	{
		private var _points:IList;
				
		public function get pointModels():IList
		{
			return this._points ? this._points : this._points = new ArrayList();
		}
		
		public function set pointModels(models:IList):void
		{
			this._points = models;
		}
		
		public function addPointModel(pointModel:PointModel):void
		{
			this.pointModels.addItem(pointModel);
		}
	}
}