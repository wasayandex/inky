package inky.components.map.controller.mediators 
{
	import inky.components.map.controller.mediators.AbstractMapControllerMediator;
	import inky.components.map.controller.IMapController;
	import inky.components.map.view.events.MapFeatureEvent;
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

			this.addTrigger(MapFeatureEvent.SELECT_FOLDER_TRIGGERED);
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function handleTrigger(trigger:String, site:Object):void
		{
			this.controller.selectFolder(site);
		}
		
	}
	
}