package inky.components.map.view 
{
	import inky.components.map.view.BaseInteractiveMap;
	import inky.components.map.view.helpers.ControllerHelper;
	import inky.components.map.controller.MapController;
	import inky.components.map.controller.mediators.IMapControllerMediator;
	
	/**
	 *
	 *  A basic implementation of IMap. This implementation is based on 
	 * 	BaseInteractiveMap, but creates its own map controller for 
	 *  convenience. For more explicit control over the map controller, 
	 *  including when it is created and how it is implemented, 
	 *  use BaseInteractiveMap instead.
	 *	
	 *  @see inky.components.map.view.IMap
	 *  @see inky.components.map.view.BaseInteractiveMap
	 * 
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.14
	 *
	 */
	public class InteractiveMap extends BaseInteractiveMap
	{
		private var _controllerClass:Class;
		private var controllerHelper:ControllerHelper;
		
		/**
		 *
		 */
		public function InteractiveMap()
		{
			this.controllerClass = MapController;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Sets the controller class that is created by the controller helper.
		 * Set this to a custom controller class to easily modify the behavior of the 
		 * map interaction.
		 * 
		 * @see inky.components.map.controller.IMapController
		 * @see inky.components.map.controller.MapController
		 */
		public function set controllerClass(value:Class):void
		{
			var oldValue:Class = this._controllerClass;
			if (oldValue != value)
			{
				this._controllerClass = value;

				if (this.controllerHelper)
					this.controllerHelper.destroy();

				if (value)
					this.controllerHelper = new ControllerHelper(this, value);
			}
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * Adds a trigger (event type) that the controller should respond to by making a 
		 * folder deselection. The trigger is typically an event that is the result of user 
		 * interaction with the view, such as a click event, and a mediator typically 
		 * responds to the trigger by executing methods on the controller.
		 * 
		 * @param trigger
		 * 		The trigger (event type) to handle.
		 * 
		 * @param targetValidator
		 * 		A method used to check the trigger (event) target. If the target doesn't 
		 * 		validate, the trigger action is not invoked.
		 * 
		 * @param siteFilter
		 * 		A method used to determine the intended site for the action invoked by the trigger. 
		 * 
		 * @see #addFolderSelectionTrigger
		 * @see #addPlacemarkDeselectionTrigger
		 * @see #addPlacemarkSelectionTrigger
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see inky.components.map.controller.mediators.FolderDeselectionMediator
		 */
		public function addFolderDeselectionTrigger(trigger:String, targetValidator:Function = null, siteFilter:Function = null):void
		{
			this.controllerHelper.folderDeselectionMediator.addTrigger(trigger, targetValidator, siteFilter);
		}
		
		/**
		 * Adds a trigger (event type) that the controller should respond to by making a 
		 * folder selection. The trigger is typically an event that is the result of user 
		 * interaction with the view, such as a click event, and a mediator typically 
		 * responds to the trigger by executing methods on the controller.
		 * 
		 * @param trigger
		 * 		The trigger (event type) to handle.
		 * 
		 * @param targetValidator
		 * 		A method used to check the trigger (event) target. If the target doesn't 
		 * 		validate, the trigger action is not invoked.
		 * 
		 * @param siteFilter
		 * 		A method used to determine the intended site for the action invoked by the trigger. 
		 * 
		 * @see #addFolderDeselectionTrigger
		 * @see #addPlacemarkDeselectionTrigger
		 * @see #addPlacemarkSelectionTrigger
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see inky.components.map.controller.mediators.FolderSelectionMediator
		 */
		public function addFolderSelectionTrigger(trigger:String, targetValidator:Function = null, siteFilter:Function = null):void
		{
			this.controllerHelper.folderSelectionMediator.addTrigger(trigger, targetValidator, siteFilter);
		}

		/**
		 * Adds a trigger (event type) that the controller should respond to by making a 
		 * placemark deselection. The trigger is typically an event that is the result of 
		 * user interaction with the view, such as a click event, and a mediator 
		 * typically responds to the trigger by executing methods on the controller.
		 * 
		 * @param trigger
		 * 		The trigger (event type) to handle.
		 * 
		 * @param targetValidator
		 * 		A method used to check the trigger (event) target. If the target doesn't 
		 * 		validate, the trigger action is not invoked.
		 * 
		 * @param siteFilter
		 * 		A method used to determine the intended site for the action invoked by the trigger. 
		 * 
		 * @see #addFolderSelectionTrigger
		 * @see #addFolderDeselectionTrigger
		 * @see #addPlacemarkSelectionTrigger
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see inky.components.map.controller.mediators.PlacemarkDeselectionMediator
		 */
		public function addPlacemarkDeselectionTrigger(trigger:String, targetValidator:Function = null, siteFilter:Function = null):void
		{
			this.controllerHelper.placemarkDeselectionMediator.addTrigger(trigger, targetValidator, siteFilter);
		}
		
		/**
		 * Adds a trigger (event type) that the controller should respond to by making a 
		 * placemark selection. The trigger is typically an event that is the result of 
		 * user interaction with the view, such as a click event, and a mediator 
		 * typically responds to the trigger by executing methods on the controller.
		 * 
		 * @param trigger
		 * 		The trigger (event type) to handle.
		 * 
		 * @param targetValidator
		 * 		A method used to check the trigger (event) target. If the target doesn't 
		 * 		validate, the trigger action is not invoked.
		 * 
		 * @param siteFilter
		 * 		A method used to determine the intended site for the action invoked by the trigger. 
		 * 
		 * @see #addPlacemarkDeselectionTrigger
		 * @see #addFolderSelectionTrigger
		 * @see #addFolderDeselectionTrigger
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see inky.components.map.controller.mediators.PlacemakrSelectionMediator
		 */
		public function addPlacemarkSelectionTrigger(trigger:String, targetValidator:Function = null, siteFilter:Function = null):void
		{
			this.controllerHelper.placemarkSelectionMediator.addTrigger(trigger, targetValidator, siteFilter);
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			this.controllerHelper.destroy();
		}
		
		/**
		 * Registers a mediator with the controller helper. 
		 * 
		 * <p>The mediator is already instantiated, so the controller helper will only set 
		 * the <code>controller</code> property on the mediator. It will only set the 
		 * <code>view</code> property if it is not already set. The advantage of this 
		 * approach (as opposed to registering the class via <code>registerMediatorClass</code>) 
		 * is that it allows mediators to target related views (such as list of placemark 
		 * descriptions, for example), yet still control the map model.</p>
		 * 
		 * @param mediator
		 * 		The IMapControllerMediator to register.
		 * 
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see inky.components.map.view.helpers.ControllerHelper#registerMediator
		 */
		public function registerMediator(mediator:IMapControllerMediator):void
		{
			this.controllerHelper.registerMediator(mediator);
		}
		
		/**
		 * Registers a mediator class with the controller helper. The mediator is 
		 * instantiated by the controller helper.
		 * 
		 * @param mediatorClass
		 * 		The IMapControllerMediator class to register.
		 * 
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see inky.components.map.view.helpers.ControllerHelper#registerMediatorClass
		 */
		public function registerMediatorClass(mediatorClass:Class):void
		{
			this.controllerHelper.registerMediatorClass(mediatorClass);
		}
		
		/**
		 * Unregisters a mediator with the controller helper. The mediator instance 
		 * is destroyed by the controller helper.
		 * 
		 * @param mediatorClass
		 * 		The IMapControllerMediator to unregister.
		 * 
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see inky.components.map.view.helpers.ControllerHelper#unregisterMediator
		 */
		public function unregisterMediator(mediator:IMapControllerMediator):void
		{
			this.controllerHelper.unregisterMediator(mediator);
		}
		
		/**
		 * Unregisters a mediator class with the controller helper. Any instances of the 
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
			this.controllerHelper.unregisterMediatorClass(mediatorClass);
		}

	}
	
}