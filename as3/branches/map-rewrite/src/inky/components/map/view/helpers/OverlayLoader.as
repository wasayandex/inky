package inky.components.map.view.helpers 
{
	import inky.components.map.view.IMap;
	import inky.binding.utils.BindingUtil;
	import inky.components.map.model.IMapModel;
	import inky.components.map.view.helpers.BaseMapViewHelper;
	import inky.utils.IDestroyable;
	import inky.binding.utils.IChangeWatcher;
	import flash.utils.getDefinitionByName;
	import flash.display.DisplayObject;
	import inky.components.map.view.events.MapEvent;
	import inky.layout.validation.LayoutValidator;
	import flash.display.DisplayObjectContainer;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.15
	 *
	 */
	public class OverlayLoader extends BaseMapViewHelper implements IDestroyable
	{
		protected var modelWatcher:IChangeWatcher;
		protected var overlayContainer:DisplayObjectContainer;

		/**
		 * @copy inky.components.map.view.helpers.BaseMapViewHelper
		 * 
		 * @param overlayContainer
		 * 		The map's overlay container.
		 */
		public function OverlayLoader(map:IMap, layoutValidator:LayoutValidator, overlayContainer:DisplayObjectContainer)
		{
			super(map, layoutValidator);

			this.overlayContainer = overlayContainer;
			this.modelWatcher = BindingUtil.bindSetter(this.findAndLoadOverlay, this.map, "model");
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
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function clearOverlay():void
		{
			while (this.overlayContainer.numChildren)
				this.overlayContainer.removeChildAt(0);
		}
		
		/**
		 * 
		 */
		private function findAndLoadOverlay(model:IMapModel):void
		{
// TODO: Finish implementing this overlay loader.
			if (model && model.overlay && model.overlay.icon && model.overlay.icon.href)
			{
				var url:String = model.overlay.icon.href;
				if (url.match(/^lib:\/\//))
				{
					this.clearOverlay();
					
					var overlayClass:Class = getDefinitionByName(url.replace(/^lib:\/\//, "")) as Class;
					var overlay:DisplayObject = new overlayClass() as DisplayObject;
					this.overlayContainer.addChild(overlay);
					
					this.dispatchEvent(new MapEvent(MapEvent.OVERLAY_UPDATED));
				}
			}
		}

	}
	
}