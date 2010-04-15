package inky.components.map.controller.mediators 
{
	import inky.components.map.controller.mediators.AbstractMapControllerMediator;
	import inky.components.map.controller.IMapController;
	import inky.components.map.view.events.MapEvent;
	import flash.events.Event;
	
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
	public class FolderSelectionMediator extends AbstractMapControllerMediator
	{
		/**
		 *
		 */
		public function FolderSelectionMediator(controller:IMapController, view:Object)
		{
			this.controller = controller;
			this.view = view;

			this.addTrigger(MapEvent.SELECT_FOLDER_CLICKED);
			this.addTrigger(MapEvent.DESELECT_FOLDER_CLICKED);
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function handleTrigger(trigger:String, site:Object):void
		{
			if (trigger == MapEvent.SELECT_FOLDER_CLICKED)
				this.controller.selectFolder(site);
			else if (trigger == MapEvent.DESELECT_FOLDER_CLICKED)
				this.controller.deselectFolder(site);
		}
		
	}
	
}