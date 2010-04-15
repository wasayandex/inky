package inky.components.map.controller.mediators 
{
	import inky.components.map.controller.mediators.AbstractMapControllerMediator;
	import inky.components.map.controller.IMapController;
	import inky.components.map.view.events.MapEvent;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.14
	 *
	 */
	public class PlacemarkSelectionMediator extends AbstractMapControllerMediator
	{
		/**
		 *
		 */
		public function PlacemarkSelectionMediator(controller:IMapController, view:Object)
		{
			this.controller = controller;
			this.view = view;

			this.addTrigger(MapEvent.SELECT_PLACEMARK_CLICKED);
			this.addTrigger(MapEvent.DESELECT_PLACEMARK_CLICKED);
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function handleTrigger(trigger:String, site:Object):void
		{
			if (trigger == MapEvent.SELECT_PLACEMARK_CLICKED)
			{
				this.controller.selectPlacemark(site);
			}
			else if (trigger == MapEvent.DESELECT_PLACEMARK_CLICKED)
			{
				this.controller.deselectPlacemark(site);
			}
		}
		
	}
	
}