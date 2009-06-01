package inky.framework.components.mapPane.views 
{
	import inky.framework.controls.TransitioningButtonClip;
	import inky.framework.components.mapPane.views.IPointView;

	public class PointView extends TransitioningButtonClip implements IPointView
	{
		private var _model:Object;
		
		//
		// accessors
		//
		
		public function set model(value:Object):void
		{
			this._model = value;
			this.x = value.x;
			this.y = value.y;
		}
		
		public function get model():Object
		{
			return this._model;
		}		
	}
}