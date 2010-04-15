package inky.components.map.controller 
{
	import inky.components.map.view.IMap;
	import inky.binding.utils.BindingUtil;
	import inky.utils.IDestroyable;
	import inky.components.map.model.MapModel;
	import inky.binding.utils.IChangeWatcher;
	import inky.components.map.model.IMapModel;
	import inky.components.map.controller.IMapController;
	
	/**
	 *
	 *  A basic implementation of IMapController. This controller has the basic 
	 *  interactions between view and model defined, but requires mediation 
	 *  (via an IMapControllerMediator) to facilitate the execution of those 
	 *  interactions. 
	 * 
	 * 	<p>For example, in order to respond to a user selecting a placemark view, 
	 *  a mediator such as the PlacemarkSelectionMediator knows what aspects 
	 *  of the user interaction with the view require a response from the controller, 
	 *  and it facilitates the process by monitoring the view for user interaction, 
	 *  and then instructing the controller to make the appropriate responses 
	 *  (usually in the form of model changes).</p>
	 * 
	 *  @see inky.components.map.controller.mediators.IMapControllerMediator
	 *  @see inky.components.map.model.IMapModel
	 *  @see inky.components.map.view.IMap
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.07
	 *
	 */
	public class MapController implements IMapController
	{
		private var _model:IMapModel;
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function set model(value:IMapModel):void
		{
			this._model = value;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function deselectFolder(folder:Object):void
		{
			this.getModel().deselectFolder(folder);
		}
		
		/**
		 * @inheritDoc
		 */
		public function deselectPlacemark(placemark:Object):void
		{
			this.getModel().deselectPlacemark(placemark);
		}
		
		/**
		 * @inheritDoc
		 */
		public function selectFolder(folder:Object):void
		{
			this.getModel().selectFolder(folder);
		}
		
		/**
		 * @inheritDoc
		 */
		public function selectPlacemark(placemark:Object):void
		{
			// TODO: Provide a simple config for choosing whether or not to allow multiple placemark selections?
			var model:Object = this.getModel();
			for each (var selectedPlacemark:Object in model.selectedPlacemarks)
				model.deselectPlacemark(selectedPlacemark);

			model.selectPlacemark(placemark);
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		protected function getModel():IMapModel
		{
			if (!this._model)
				throw new Error("Model not defined for controller.");
			
			return this._model;
		}

	}
	
}