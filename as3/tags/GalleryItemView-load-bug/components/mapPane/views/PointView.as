package inky.framework.components.mapPane.views 
{
	import inky.framework.components.mapPane.models.PointModel;
	import inky.framework.controls.TransitioningButtonClip;
	import inky.framework.components.mapPane.views.IPointView;

	public class PointView extends TransitioningButtonClip implements IPointView
	{
		private var _model:PointModel;
		
		//
		// accessors
		//
		
		public function set model(model:PointModel):void
		{
			this._model = model;
			this.x = model.x;
			this.y = model.y;
	
			this.setContent();
		}
		
		public function get model():PointModel
		{
			return this._model;
		}
		
		//
		// protected functions
		//
		
		/**
		*	
		*/
		protected function setContent():void
		{
		}
	}
}