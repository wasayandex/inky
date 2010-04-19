package inky.components.map.view.helpers 
{
	import inky.components.map.controller.MapController;
	import inky.components.map.controller.mediators.PlacemarkSelectionMediator;
	import inky.components.map.controller.mediators.FolderSelectionMediator;
	import inky.components.map.view.IMap;
	import inky.binding.utils.BindingUtil;
	import inky.components.map.model.IMapModel;
	import inky.utils.IDestroyable;
	import inky.binding.utils.IChangeWatcher;
	import inky.components.map.controller.IMapController;
	import inky.components.map.controller.mediators.IMapControllerMediator;
	import flash.utils.Dictionary;
	import inky.components.map.controller.mediators.FolderSelectionMediator;
	import inky.components.map.controller.mediators.FolderDeselectionMediator;
	import inky.components.map.controller.mediators.PlacemarkSelectionMediator;
	import inky.components.map.controller.mediators.PlacemarkDeselectionMediator;
	
	/**
	 *
	 *  A helper for instantiating the default map controller and mediators for placemark and folder selection.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.14
	 *
	 */
	public class ControllerHelper implements IDestroyable
	{
		private var _controller:IMapController;
		private var controllerClass:Class;
		private var _folderDeselectionMediator:FolderDeselectionMediator;
		private var _placemarkDeselectionMediator:PlacemarkDeselectionMediator;
		private var map:IMap;
		private var mediators:Dictionary;
		private var model:IMapModel;
		private var modelWatcher:IChangeWatcher;
		private var _folderSelectionMediator:FolderSelectionMediator;
		private var _placemarkSelectionMediator:PlacemarkSelectionMediator;
		
		/**
		 * Creates a new controller helper.
		 * 
		 * <p>This helper instantiates the default MapController, and it also 
		 * creates four mediators: a FolderSelectionMediator, a FolderDeselectionMediator, 
		 * a PlacemarkSelectionMediator, and a PlacemarkDeselectionMediator, all of which 
		 * allow the controller to be ignorant of the implementation of the view by 
		 * mediating the process of interpreting user interactivity with the view into 
		 * controller actions.</p>
		 * 
		 * @param map
		 * 		The IMap target to give the IMapController.
		 * 
		 * @param controllerClass
		 * 		The controller class to use. If none is specified, the default MapController is used.
		 */
		public function ControllerHelper(map:IMap, controllerClass:Class = null)
		{
			this.mediators = new Dictionary(true);
			this.map = map;
			controllerClass = controllerClass || MapController;

			this._controller = new controllerClass();
			
			this._folderSelectionMediator = new FolderSelectionMediator(this.controller, this.map);
			this._folderDeselectionMediator = new FolderDeselectionMediator(this.controller, this.map);
			this._placemarkSelectionMediator = new PlacemarkSelectionMediator(this.controller, this.map);
			this._placemarkDeselectionMediator = new PlacemarkDeselectionMediator(this.controller, this.map);

			this.modelWatcher = BindingUtil.bindSetter(this.initializeForModel, map, "model");
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Gets the default controller.
		 */
		public function get controller():IMapController
		{
			return this._controller;
		}
		
		/**
		 * Gets the folder deselection mediator.
		 */
		public function get folderDeselectionMediator():FolderDeselectionMediator
		{
			return this._folderDeselectionMediator;
		}
		
		/**
		 * Gets the placemark deselection mediator.
		 */
		public function get placemarkDeselectionMediator():PlacemarkDeselectionMediator
		{
			return this._placemarkDeselectionMediator;
		}
		
		/**
		 * Gets the folder selection mediator.
		 */
		public function get folderSelectionMediator():FolderSelectionMediator
		{
			return this._folderSelectionMediator;
		}
		
		/**
		 * Gets the placemark selection mediator.
		 */
		public function get placemarkSelectionMediator():PlacemarkSelectionMediator
		{
			return this._placemarkSelectionMediator;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			this.modelWatcher.unwatch();

			for (var mediatorClass:Object in this.mediators)
				this.unregisterMediatorClass(mediatorClass as Class);

			this._placemarkDeselectionMediator.destroy();
			this._folderDeselectionMediator.destroy();
			this._placemarkSelectionMediator.destroy();
			this._folderSelectionMediator.destroy();
		}
		
		/**
		 * Adds a mediator class.
		 * 
		 * @param mediatorClass
		 * 		The IMapControllerMediator class to register.
		 * 
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see #unregisterMediatorClass
		 */
		public function registerMediatorClass(mediatorClass:Class):void
		{
			this.mediators[mediatorClass] = this.createMediator(mediatorClass);
		}
		
		/**
		 * Removes a mediator class from the controller helper. Any instances of the 
		 * mediator class that were created by the controller helper are destroyed.
		 * 
		 * @param mediatorClass
		 * 		The IMapControllerMediator class to unregister.
		 * 
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see inky.components.map.view.helpers.ControllerHelper#unregisterMediatorClass
		 */
		public function unregisterMediatorClass(mediatorClass:Class):void
		{
			if (this.mediators[mediatorClass] != null)
				this.mediators[mediatorClass].destroy();

			delete this.mediators[mediatorClass];
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function createMediator(mediatorClass:Class):IMapControllerMediator
		{
			var mediator:IMapControllerMediator = new mediatorClass();

			if (!(mediator is IMapControllerMediator))
				throw new ArgumentError(mediatorClass + " is not an IMapControllerMediator.");

			mediator.controller = this.controller;
			mediator.view = this.map;

			return mediator;
		}
		
		/**
		 * 
		 */
		private function initializeForModel(model:IMapModel):void
		{
			this.model = model;
			this.controller.model = model;
		}

	}
	
}