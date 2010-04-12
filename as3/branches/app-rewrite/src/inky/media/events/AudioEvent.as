package inky.media.events
{
	import flash.events.Event;
	import flash.media.SoundTransform;


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
	public class AudioEvent extends Event
	{
		public static const SOUND_UPDATE:String = "soundUpdate";
		private var _soundTransform:SoundTransform;
		
		
		/**
		 *
		 *	
		 */
		public function AudioEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, soundTransform:SoundTransform = null)
		{
			super(type, bubbles, cancelable);
			this._soundTransform = soundTransform;
		}




		//
		// accessors
		//


		/**
		 *
		 *
		 *
		 */
		public function get soundTransform():SoundTransform
		{
			return this._soundTransform;
		}




		//
		// public methods
		//


		/**
		 *
		 *	
		 */
		public override function clone():Event
		{
			return new AudioEvent(this.type, this.bubbles, this.cancelable, this.soundTransform);
		}




	}
}