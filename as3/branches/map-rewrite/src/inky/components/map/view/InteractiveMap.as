package inky.components.map.view 
{
	import inky.components.map.view.BaseInteractiveMap;
	import inky.components.map.view.helpers.ControllerHelper;
	import flash.events.MouseEvent;
	import inky.components.map.view.events.MapEvent;
	
	/**
	 *
	 *  A basic implementation of IMap. This implementation is based on 
	 * 	BaseInteractiveMap, but creates its own map controller for 
	 *  convenience. For more explicit control over the map controller, 
	 *  including when it is created and how it is implemented, 
	 *  use BaseInteractiveMap instead.
	 *	
	 *  @see inky.components.map.view.IMap
	 *  @see inky.components.map.view.InteractiveMap
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
		private var _controllerHelper:ControllerHelper;
		private var _controllerClass:Class;

		/**
		 * Creates an InteractiveMap.
		 */
		public function InteractiveMap()
		{
			this.addEventListener(MouseEvent.CLICK, this.clickHandler);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @copy inky.components.map.view.Map#controllerClass
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
		 * @copy inky.components.map.view.Map#addFolderSelectionTrigger
		 */
		public function addFolderSelectionTrigger(trigger:String, siteFilter:Function = null):void
		{
			this.getControllerHelper().folderSelectionMediator.addTrigger(trigger, siteFilter);
		}
		
		/**
		 * @copy inky.components.map.view.Map#addPlacemarkSelectionTrigger
		 */
		public function addPlacemarkSelectionTrigger(trigger:String, siteFilter:Function = null):void
		{
			this.getControllerHelper().placemarkSelectionMediator.addTrigger(trigger, siteFilter);
		}
		
		/**
		 * @copy inky.components.map.view.Map#registerMediatorClass
		 */
		public function registerMediatorClass(mediatorClass:Class):void
		{
			this.getControllerHelper().registerMediatorClass(mediatorClass);
		}
		
		/**
		 * @copy inky.components.map.view.Map#unregisterMediatorClass
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