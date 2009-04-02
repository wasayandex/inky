package inky.framework.components.gallery.utils
{
	import inky.framework.components.gallery.models.GalleryModel;
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


		public function registerGallery(model:GalleryModel):void
		{
			this._galleryModels[model] = 1;
		}
		
		public function unregisterGallery(model:GalleryModel):void
		{
			delete this._galleryModels[model];
		}

		private function _init(delay:Number, repeatCount:int):void
		{
			this._galleryModels = new Dictionary(true);
			this.addEventListener(TimerEvent.TIMER, this._timerHandler);
		}

		private function _timerHandler(e:TimerEvent):void
		{
			for (var model:Object in this._galleryModels)
			{
				model.selectItemAt((model.selectedItemIndex + 1) % model.selectedGroupModel.items.length);
			}
		}




	}
}