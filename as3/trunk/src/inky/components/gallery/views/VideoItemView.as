package inky.components.gallery.views
{
	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
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
				super.startLoad(model, loadingSize);
			}
			else
			{				
				this.flvPlayback.source = model.source;
				this.removeProgressBar();
				this.featureLoaded(this.flvPlayback);
			}
		}

		override protected function featureLoaded(feature:DisplayObject):void
		{
			this.addFeature(feature);
			this.removePreviousPreviews();
			this.removeProgressBar();
		}

		//
		// private functions
		//
		
		private function _init():void
		{
			this.flvPlayback = this.getChildByName('_flvPlayback') as FLVPlayback || null;
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
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, this._removedHandler);
			
			//!FIXME: Need to know how to handle progressBars with Videos. 
			// When should it show? During bufferring state and when should it go away?
			// These are the questions that everyone asks.
			this.__flvPlayback.addEventListener(VideoEvent.BUFFERING_STATE_ENTERED, this._videoReadyHandler);
		}
		
		
		private function _removedHandler(event:Event):void
		{	
			this.flvPlayback.stop();
			this.flvPlayback.getVideoPlayer(0).close();
			this.__flvPlayback.removeEventListener(VideoEvent.BUFFERING_STATE_ENTERED, this._videoReadyHandler);
			this.removeEventListener(Event.REMOVED, this._removedHandler);
		}
		
		private function _videoReadyHandler(event:VideoEvent):void
		{
			this.removeProgressBar();
		}
	}
}