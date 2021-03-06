package inky.components.map.controller 
{
	import inky.components.map.view.IMap;
	import inky.binding.utils.BindingUtil;
	import inky.utils.IDestroyable;
	import inky.components.map.model.MapModel;
	import inky.binding.utils.IChangeWatcher;
	
	/**
	 *
	 *  A controller that provides typical map functionality to an IMap.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.07
	 *
	 */
	public class MapController implements IDestroyable
	{
		private var modelWatcher:IChangeWatcher;
		private var changeWatchers:Array;
		private var map:IMap;
		
		/**
		 * Creates a new map behavior.
		 * 
		 * @param map
		 * 		The IMap target to apply map behavior to.
		 */
		public function MapController(map:IMap)
		{
			this.map = map;
			this.modelWatcher = BindingUtil.bindSetter(this.initializeForModel, map, "model");
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function destroy():void
		{
			this.modelWatcher.unwatch();
			this.clearChangeWatchers();
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function clearChangeWatchers():void
		{
			if (this.changeWatchers)
			{
				while (this.changeWatchers.length)
					this.changeWatchers.pop().unwatch();
			}
		}
		
		/**
		 * 
		 */
		private function initializeForModel(model:MapModel):void
		{
			this.clearChangeWatchers();

			if (model)
			{
				this.changeWatchers = [];
				this.changeWatchers.push(BindingUtil.bindSetter(this.setSelectedDocument, model, "selectedDocument"));
				this.changeWatchers.push(BindingUtil.bindSetter(this.setSelectedFolder, model, "selectedFolder"));
				this.changeWatchers.push(BindingUtil.bindSetter(this.setSelectedPlacemark, model, "selectedPlacemark"));
			}
			else
			{
				this.map.removeAllPlacemarks();
			}

		}
		
		/**
		 * 
		 */
		private function setSelectedDocument(document:Object):void
		{
			if (!document)
			{
				// show all placemarks.
				this.map.addPlacemarks(this.map.model.placemarks.toArray());
			}
			else
			{
				
			}
		}
		
		/**
		 * 
		 */
		private function setSelectedFolder(folder:Object):void
		{
			if (!folder)
			{
			}
			else
			{
			}
		}
		
		
		/**
		 * 
		 */
		private function setSelectedPlacemark(placemark:Object):void
		{
			if (!placemark)
			{
			}
			else
			{
			}
		}

		
	}
	
}