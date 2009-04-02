package inky.framework.components.mapPane.views 
{
	import inky.framework.components.mapPane.models.PointModel;
	import inky.framework.controls.TransitioningButtonClip;

	public class PointView extends TransitioningButtonClip
	{
		private var _model:PointModel;
		
		public function PointView()
		{
		}

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