package inky.components.map.view.helpers 
{
	import inky.components.map.view.IMap;
	import inky.binding.utils.BindingUtil;
	import inky.components.map.model.IMapModel;
	import inky.components.map.view.helpers.BaseMapViewHelper;
	import inky.utils.IDestroyable;
	import flash.display.Sprite;
	import inky.binding.utils.IChangeWatcher;
	import flash.utils.getDefinitionByName;
	import flash.display.DisplayObject;
	
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
		private var modelWatcher:IChangeWatcher;
		private var overlayContainer:Sprite;

		/**
		 *
		 */
		public function OverlayLoader(map:IMap)
		{
			super(map);

			var overlayContainer:Sprite = this.contentContainer.getChildByName("_overlayContainer") as Sprite;
			if (!overlayContainer)
			{
				overlayContainer = new Sprite();
				this.contentContainer.addChild(overlayContainer);
			}
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
		private function findAndLoadOverlay(model:IMapModel):void
		{
// TODO: Finish implementing this overlay loader.
			while (this.overlayContainer.numChildren)
				this.overlayContainer.removeChildAt(0);

			if (model && model.overlay && model.overlay.icon && model.overlay.icon.href)
			{
				var url:String = model.overlay.icon.href;
				if (url.match(/^lib:\/\//))
				{
					var overlayClass:Class = getDefinitionByName(url.replace(/^lib:\/\//, "")) as Class;
					var overlay:DisplayObject = new overlayClass() as DisplayObject;
					this.overlayContainer.addChild(overlay);
				}
			}
		}

	}
	
}