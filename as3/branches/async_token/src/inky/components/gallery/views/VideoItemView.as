package inky.components.gallery.views
{
	import fl.video.FLVPlayback;
	import inky.components.gallery.models.GalleryImageModel;
	import net.eightdotthree.controls.IMediaControl;
	import net.eightdotthree.controls.IMediaControls;

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
		
		public function set flvPlayback(flvPlayback:FLVPlayback):void
		{
			this.__flvPlayback = flvPlayback;
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
				this.featureLoaded(this.flvPlayback);
			}
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
			
			// look for video controls
			for (var j:int = 0; j < this.numChildren; j++)
			{
				var control:Object = this.getChildAt(j);
				if (control is IMediaControl)
				{
					IMediaControl(control).target = this.flvPlayback;
				}
				else if (control is IMediaControls)
				{
					IMediaControls(control).target = this.flvPlayback;
				}
				
			}
			
		}

	}
}