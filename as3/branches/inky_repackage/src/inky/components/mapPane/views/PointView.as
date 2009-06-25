package inky.components.mapPane.views 
{
	import inky.controls.TransitioningButtonClip;
	import inky.components.mapPane.views.IPointView;

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