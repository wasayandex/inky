package inky.components.gallery.views
{
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	import fl.video.VideoState;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import inky.components.gallery.models.GalleryImageModel;

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
	 *	@since  2009.03.30
	 *
	 */
	public class VideoItemView extends BaseGalleryItemView
	{
		private var __flvPlayback:FLVPlayback;
		
		
		public function VideoItemView()
		{
			this._init();
		}
		
		//
		// accessors
		//
		
		public function set flvPlayback(value:FLVPlayback):void
		{
			this.__flvPlayback = value;
		}
		public function get flvPlayback():FLVPlayback
		{
			return this.__flvPlayback;
		}
		
		//
		// protected functions
		//
		
		override protected function startLoad(model:GalleryImageModel, loadingSize:String):void
		{
			if (loadingSize == "preview")
			{
				if (this.flvPlayback.source) this.flvPlayback.stop();
				super.startLoad(model, loadingSize);
			}
			else
			{
				this.flvPlayback.source = model.source;
				this.featureLoaded(this.flvPlayback);
			}
		}

		override protected function featureLoaded(feature:DisplayObject):void
		{
			this.removePreviousPreviews();
//this.addFeature(feature);
			this.removeProgressBar();
		}
		
		//
		// private functions
		//
		
		private function _init():void
		{
			this.flvPlayback = this.getChildByName("_flvPlayback") as FLVPlayback || null;
			if (!this.flvPlayback)
			{
				for (var i:int = 0; i < this.numChildren; i++)
				{
					var child:FLVPlayback = this.getChildAt(i) as FLVPlayback;
					if (child)
					{
						this.flvPlayback = child;
						break;
					}
				}
			}
			
			this.flvPlayback.visible = false;
			this.flvPlayback.addEventListener(VideoEvent.STATE_CHANGE, this._stateChangeHandler);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, this._removedHandler);
		}
		
		private function _removedHandler(event:Event):void
		{	
			this.flvPlayback.stop();
			this.flvPlayback.getVideoPlayer(0).close();
			this.removeEventListener(Event.REMOVED, this._removedHandler);
		}
		
		private function _stateChangeHandler(event:VideoEvent):void
		{
			switch (event.state)
			{
				case VideoState.PLAYING:
					this.clearContainer();
					this.addFeature(this.flvPlayback);
					this.flvPlayback.visible = true;
					break;
			}
		}
	}
}