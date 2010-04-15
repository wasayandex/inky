package inky.components.map.view 
{
	import inky.components.map.view.BaseMap;
	import inky.components.map.view.helpers.ControllerHelper;
	import flash.events.MouseEvent;
	import inky.components.map.view.events.MapEvent;
	
	/**
	 *
	 *  A basic implementation of IMap. This implementation is based on 
	 * 	BaseMap, but creates its own map controller for convenience. 
	 *  For more explicit control over the map controller, including 
	 *  when it is created and how it is implemented, use BaseMap instead.
	 * 
	 *  @see inky.components.map.view.IMap
	 * 	@see inky.components.map.view.BaseMap
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.14
	 *
	 */
	public class Map extends BaseMap
	{
		private var _controllerHelper:ControllerHelper;
		private var _controllerClass:Class;

		/**
		 * Creates a new Map.
		 */
		public function Map()
		{
			this.addEventListener(MouseEvent.CLICK, this.clickHandler);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Sets the controller class that is created by the controller helper.
		 * Set this to a custom controller class to easily modify the behavior of the 
		 * map interaction.
		 */
		public function set controllerClass(value:Class):void
		{
			if (this._controllerHelper)
				this._controllerHelper.destroy();

			this._controllerClass = value;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Adds a trigger (event type) that the folder selection mediator should listen 
		 * for. The trigger is typically an event that is the result of user interaction 
		 * with the view, such as a click event, and the mediator typically responds to the 
		 * trigger by executing methods on the controller.
		 * 
		 * @param trigger
		 * 		The trigger (event type) to handle.
		 * 
		 * @param siteFilter
		 * 		A method used to determine the intended site for the action invoked by the trigger. 
		 */
		public function addFolderSelectionTrigger(trigger:String, siteFilter:Function = null):void
		{
			this.getControllerHelper().folderSelectionMediator.addTrigger(trigger, siteFilter);
		}
		
		/**
		 * Adds a trigger (event type) that the placemark selection mediator should listen 
		 * for. The trigger is typically an event that is the result of user interaction 
		 * with the view, such as a click event, and the mediator typically responds to the 
		 * trigger by executing methods on the controller.
		 * 
		 * @param trigger
		 * 		The trigger (event type) to handle.
		 * 
		 * @param siteFilter
		 * 		A method used to determine the intended site for the action invoked by the trigger. 
		 */
		public function addPlacemarkSelectionTrigger(trigger:String, siteFilter:Function = null):void
		{
			this.getControllerHelper().placemarkSelectionMediator.addTrigger(trigger, siteFilter);
		}
		
		/**
		 * Adds a mediator class to the controller helper. The mediator is instantiated by 
		 * the controller helper.
		 * 
		 * @param mediatorClass
		 * 		The IMapControllerMediator class to register.
		 * 
		 * @see inky.components.map.controller.mediators.IMapControllerMediator
		 * @see inky.components.map.view.helpers.ControllerHelper#registerMediatorClass
		 */
		public function registerMediatorClass(mediatorClass:Class):void
		{
			this.getControllerHelper().registerMediatorClass(mediatorClass);
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
			this.getControllerHelper().unregisterMediatorClass(mediatorClass);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function clickHandler(event:MouseEvent):void
		{
			if (!this.placemarkRendererClass)
				return;

			if (event.target is this.placemarkRendererClass)
				this.dispatchEvent(new MapEvent(MapEvent.SELECT_PLACEMARK_CLICKED, event.target.model));
		}
		
		/**
		 * 
		 */
		private function getControllerHelper():ControllerHelper
		{
			return this._controllerHelper || (this._controllerHelper = new ControllerHelper(this, this._controllerClass));
		}

	}
	
}