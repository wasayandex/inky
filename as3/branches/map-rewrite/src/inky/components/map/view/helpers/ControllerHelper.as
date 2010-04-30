package inky.components.map.view.helpers 
{
	import inky.components.map.controller.mediators.PlacemarkSelectionMediator;
	import inky.components.map.controller.mediators.FolderSelectionMediator;
	import inky.binding.utils.BindingUtil;
	import inky.components.map.model.IMapModel;
	import inky.components.map.controller.IMapController;
	import inky.components.map.controller.mediators.IMapControllerMediator;
	import flash.utils.Dictionary;
	import inky.components.map.controller.mediators.FolderSelectionMediator;
	import inky.components.map.controller.mediators.FolderDeselectionMediator;
	import inky.components.map.controller.mediators.PlacemarkSelectionMediator;
	import inky.components.map.controller.mediators.PlacemarkDeselectionMediator;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import inky.components.map.view.helpers.HelperInfo;
	import inky.components.map.view.helpers.BaseMapHelper;
	
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
	public class ControllerHelper extends BaseMapHelper
	{
		private var _controller:IMapController;
		private var _folderDeselectionMediator:FolderDeselectionMediator;
		private var _placemarkDeselectionMediator:PlacemarkDeselectionMediator;
		private var mediators:Dictionary;
		private var mediatorsToRegister:Array;
		private var model:IMapModel;
		private var watchers:Array;
		private var _folderSelectionMediator:FolderSelectionMediator;
		private var _placemarkSelectionMediator:PlacemarkSelectionMediator;
		
		/**
		 * Creates a new controller helper.
		 */
		public function ControllerHelper()
		{
			this.mediators = new Dictionary(true);
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
		override public function destroy():void
		{
			super.destroy();
			
			if (this.watchers)
			{
				while (this.watchers.length)
					this.watchers.pop().unwatch();
			}

			for (var mediatorClass:Object in this.mediators)
				this.unregisterMediatorClass(mediatorClass as Class);

			this._placemarkDeselectionMediator.destroy();
			this._folderDeselectionMediator.destroy();
			this._placemarkSelectionMediator.destroy();
			this._folderSelectionMediator.destroy();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize(info:HelperInfo):void
		{
			super.initialize(info);

			this.watchers = 
			[
				BindingUtil.bindSetter(this.setControllerClass, info.map, "controllerClass"),
				BindingUtil.bindSetter(this.initializeForModel, info.map, "model")
			];
		}
		
		/**
		 * Adds a mediator.
		 * 
		 * @param mediator
		 * 		The IMapControllerMediator to register.
		 * 
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see #registerMediator
		 */
		public function registerMediator(mediator:IMapControllerMediator):void
		{
			if (this.info)
			{
				var mediatorClass:Class = getDefinitionByName(getQualifiedClassName(mediator)) as Class;
				this.mediators[mediatorClass] = mediator;
				mediator.controller = this.controller;
				mediator.view = mediator.view || this.info.map;
			}
			else
			{
				if (!this.mediatorsToRegister)
					this.mediatorsToRegister = [];
				
				this.mediatorsToRegister.push(mediator);
			}
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
			if (this.info)
			{
				this.mediators[mediatorClass] = this.createMediator(mediatorClass);
			}
			else
			{
				if (!this.mediatorsToRegister)
					this.mediatorsToRegister = [];

				this.mediatorsToRegister.push(mediatorClass);
			}
		}
		
		/**
		 * Removes a mediator from the controller helper. The mediator instance is destroyed.
		 * 
		 * @param mediator
		 * 		The IMapControllerMediator to unregister.
		 * 
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see #registerMediator
		 */
		public function unregisterMediator(mediator:IMapControllerMediator):void
		{
			var mediatorClass:Class = getDefinitionByName(getQualifiedClassName(mediator)) as Class;
			
			if (this.mediators[mediatorClass] != null)
				this.mediators[mediatorClass].destroy();
			
			delete this.mediators[mediatorClass];
		}
		
		/**
		 * Removes a mediator class from the controller helper. Any instances of the 
		 * mediator class that were created by the controller helper are destroyed.
		 * 
		 * @param mediatorClass
		 * 		The IMapControllerMediator class to unregister.
		 * 
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see #registerMediatorClass
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
			mediator.view = this.info.map;

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
		
		/**
		 * 
		 */
		private function setControllerClass(controllerClass:Class):void
		{
			this._controller = new controllerClass();
			this._folderSelectionMediator = new FolderSelectionMediator(this.controller, this.info.map);
			this._folderDeselectionMediator = new FolderDeselectionMediator(this.controller, this.info.map);
			this._placemarkSelectionMediator = new PlacemarkSelectionMediator(this.controller, this.info.map);
			this._placemarkDeselectionMediator = new PlacemarkDeselectionMediator(this.controller, this.info.map);
			
			if (this.mediatorsToRegister)
			{
				while (this.mediatorsToRegister.length)
				{
					var mediator:Object = this.mediatorsToRegister.shift();
					if (mediator is Class)
						this.registerMediatorClass(mediator as Class);
					else
						this.registerMediator(mediator as IMapControllerMediator);
				}
				
				this.mediatorsToRegister = null;
			}
		}

	}
	
}