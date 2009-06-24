package inky.framework.components.gallery.utils
{
	import inky.framework.components.gallery.models.GalleryModel;
	import inky.framework.loading.events.AssetLoaderEvent;
	import inky.framework.loading.loaders.IAssetLoader;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2009.01.12
	 *
	 */
	public class GalleryTimer extends Timer
	{
		private var _galleryModels:Dictionary;
		

		public function GalleryTimer(delay:Number = 5000, repeatCount:int = 0)
		{
			super(delay, repeatCount);
			this._init(delay, repeatCount);
		}
		
		//
		// public functions
		//
		
		public function registerGallery(model:GalleryModel):void
		{
			this._galleryModels[model] = 1;
		}
		
		public function unregisterGallery(model:GalleryModel):void
		{
			delete this._galleryModels[model];
		}

		//
		// private functions
		//
		
		private function _init(delay:Number, repeatCount:int):void
		{
			this._galleryModels = new Dictionary(true);
			this.addEventListener(TimerEvent.TIMER, this._timerHandler);
		}

		private function _assetLoaderComplete(event:AssetLoaderEvent):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			for (var model:Object in this._galleryModels)
			{
				var loader:IAssetLoader = model.selectedItemModel.images.findFirst({size: "regular"}).loader;
				if (loader.loaded)
					model.selectItemAt((model.selectedItemIndex + 1) % model.selectedGroupModel.items.length);
			}
			if (!this.running) this.start();
		}
		
		private function _timerHandler(event:TimerEvent):void
		{
			for (var model:Object in this._galleryModels)
			{
				//FIXME: Needs to properly support multiple galleries. 
				// Should timer start again after all images across the different galleries are loaded?
				
				var index:int = (model.selectedItemIndex + 1) % model.selectedGroupModel.items.length;
				var loader:IAssetLoader = model.selectedGroupModel.items.getItemAt(index).images.findFirst({size: "regular"}).loader;
				if (loader.loaded)
				{
					model.selectItemAt((model.selectedItemIndex + 1) % model.selectedGroupModel.items.length);
				}
				else
				{
					loader.addEventListener(AssetLoaderEvent.READY, this._assetLoaderComplete);
					loader.load();
					if (this.running) this.stop();
				}
			}
		}

	}
}