package inky.media
{
	import fl.video.*;
	import fl.video.FLVPlayback;
	import fl.video.flvplayback_internal;
	
	use namespace flvplayback_internal;


	/**
	 *
	 * 
	 *
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author     Matthew Tretter (matthew@exanimo.com)
	 *
	 */
	public class AudioPlayback extends FLVPlayback
	{
		
		public function AudioPlayback()
		{
		}
		
		
		
		
		/**
		 * Creates and configures VideoPlayer movie clip.
		 *
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		flvplayback_internal override function createVideoPlayer(index:Number):void {
			// do nothing for live preview
//!			if (isLivePreview) return;
trace('createVideoPlayer');
			// create if not already created
			var vp:Object = videoPlayers[index];
			if (vp == null) {
//				videoPlayers[index] = vp = new VideoPlayer(0, 0);
				videoPlayers[index] = vp = new AudioPlayer();
				vp.setSize(registrationWidth, registrationHeight);
			}
super.createVideoPlayer(index);
		}
		
		
		
		
		
		
		
		
	}
}