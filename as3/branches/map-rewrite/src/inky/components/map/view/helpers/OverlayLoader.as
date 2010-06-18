package inky.components.map.view.helpers 
{
	import inky.binding.utils.BindingUtil;
	import inky.components.map.model.IMapModel;
	import inky.binding.utils.IChangeWatcher;
	import flash.utils.getDefinitionByName;
	import flash.display.DisplayObject;
	import inky.components.map.view.events.MapEvent;
	import inky.display.utils.removeFromDisplayList;
	
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
	public class OverlayLoader extends BaseMapHelper
	{
		protected var modelWatcher:IChangeWatcher;
		private var overlay:DisplayObject;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			
			if (this.modelWatcher)
				this.modelWatcher.unwatch();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize(info:HelperInfo):void
		{
			super.initialize(info);
			this.modelWatcher = BindingUtil.bindSetter(this.findAndLoadOverlay, this.info.map, "model");
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function clearOverlay():void
		{
			removeFromDisplayList(this.overlay);
			/*while (this.info.overlayContainer.numChildren)
				this.info.overlayContainer.removeChildAt(0);*/
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
					this.overlay = new overlayClass() as DisplayObject;
					this.info.overlayContainer.addChild(this.overlay);
					
					this.info.map.dispatchEvent(new MapEvent(MapEvent.OVERLAY_UPDATED));
				}
			}
		}

	}
	
}