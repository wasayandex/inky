package inky.media
{
	import flash.events.IEventDispatcher;
	import flash.media.SoundTransform;



	/**
	 *
	 *  Defines a common interface for media players (i.e. video players, audio
	 *  players, etc.). Implementing classes must also dispatch the following
	 *  events:
	 *  
	 *  autoRewound
	 *  close
	 *  complete
	 *  metadataReceived
	 *  playheadUpdate
	 *  progress
	 *  ready
	 *  stateChange
	 *	
	 *  @author     matthew at exanimo dot com
	 *  @version    2008.12.18
	 *
	 */
	public interface IMediaPlayer extends IEventDispatcher
	{
// FIXME: play() and stop() conflict with MovieClip



		//
		// accessors
		//


		/**
		 *
		 *	A Boolean value that, if true, causes the media rewind to the
		 *	beginning when play stops, either because the player reached the
		 *	end of the stream or the stop() method was called.
		 *	
		 *	@default false
		 *
		 */
		function get autoRewind():Boolean;
		/**
		 *  @private
		 */
		function set autoRewind(autoRewind:Boolean):void;


		/**
		 *
		 *  A number that specifies the number of seconds to buffer in memory
		 *	before beginning to play a stream.
		 *
		 *	@default 0.1
		 *	
		 */
		function get bufferTime():Number;
		/**
		 *  @private
		 */
		function set bufferTime(bufferTime:Number):void;

	
		/**
		 *
		 *  A number that indicates the extent of downloading, in number of
		 *  bytes, for an HTTP download. Returns 0 when there is no stream,
		 *	when the stream is from Flash Media Server (FMS), or if the
		 *	information is not yet available. The returned value is useful only
		 *	for an HTTP download.
		 *	
		 *	@default 0
		 *
		 */
		function get bytesLoaded():uint;


		/**
		 *
		 *  A number that specifies the total number of bytes downloaded for an
		 *	HTTP download. Returns 0 when there is no stream, when the stream
		 *	is from Flash Media Server (FMS), or if the information is not yet
		 *	available. The returned value is useful only for an HTTP download.
		 *	
		 *	@default 0
		 *
		 */
		function get bytesTotal():uint;


		/**
		 *
		 *
		 *
		 */
		function get metadata():Object;
		
	
		/**
		 *
		 *  The left-to-right panning of the sound, ranging from -1 (full pan
		 *	left) to 1 (full pan right). A value of 0 represents no panning
		 *	(balanced center between right and left).
		 *	
		 *	@default 0
		 *
		 */
		function get pan():Number;
		/**
		 *  @private
		 */
		function set pan(pan:Number):void;


		/**
		 *
		 *  A number that is the current playhead time or position, measured in
		 *	seconds, which can be a fractional value.
		 *	
		 *	For several reasons, the playheadTime property might not have the
		 *	expected value immediately after you call one of the seek methods.
		 *
		 */
		function get playheadTime():Number;


		/**
		 *
		 *  A number that is the amount of time, in milliseconds, between each
		 *	playheadUpdate event. Setting this property while the file is
		 *	playing restarts the timer.
		 *
		 *	Because the playhead update interval is set by a call to the
		 *	setInterval() method, the update cannot fire more frequently than
		 *	the SWF file frame rate, as with any interval that is set this way.
		 *	So, as an example, for the default frame rate of 12 frames per
		 *	second, the lowest effective interval that you can create is
		 *	approximately 83 milliseconds, or one second (1000 milliseconds)
		 *	divided by 12.
		 *
		 *	@default 250
		 *	
		 */
		function get playheadUpdateInterval():Number;
		/**
		 *  @private
		 */
		function set playheadUpdateInterval(playheadUpdateInterval:Number):void;


		/**
		 *
		 *  A number that is the amount of time, in milliseconds, between each
		 *  progress event. If you set this property while the video stream is
		 *	playing, the timer restarts.
		 *	
		 *	@default 250.
		 *
		 */
		function get progressInterval():Number;
		/**
		 *  @private
		 */
		function set progressInterval(progressInterval:Number):void;


		/**
		 *
		 *  Provides direct access to the soundTransform property to expose
		 *	more sound control. You need to set this property for changes to
		 *	take effect, or you can get the value of this property to get a
		 *	copy of the current settings.
		 *
		 */
		function get soundTransform():SoundTransform;
		/**
		 *  @private
		 */
		function set soundTransform(soundTransform:SoundTransform):void;


		/**
		 *
		 *
		 *
		 */	
		function get source():String;
		
		
		/**
		 *
		 *  A string that specifies the state of the component. This property
		 *	is set by the load(), play(), stop(), pause(), and seek() methods.
		 *	
		 *	The possible values for the state property are: "buffering",
		 *	"connectionError", "disconnected", "loading", "paused", "playing",
		 *	"rewinding", "seeking", and "stopped". You can use the MediaState
		 *	class properties to test for these states.
		 *	
		 *	@see MediaState#DISCONNECTED
		 *	@see MediaState#STOPPED
		 *	@see MediaState#PLAYING
		 *	@see MediaState#PAUSED
		 *	@see MediaState#BUFFERING
		 *	@see MediaState#LOADING
		 *	@see MediaState#CONNECTION_ERROR
		 *	@see MediaState#REWINDING
		 *	@see MediaState#SEEKING
		 *
		 */
		function get state():String;


		/**
		 *
		 *  A number that is the total playing time for the video in seconds.
		 *
		 */
		function get totalTime():Number;

	
		/**
		 *
		 *  A number in the range of 0 to 1 that indicates the volume control
		 *	setting.
		 *	
		 *	@default 1
		 *
		 */
		function get volume():Number;
		/**
		 *  @private
		 */
		function set volume(volume:Number):void;
	
	
	
	
		//
		// public methods
		//


		/**
		 *
		 *  Forces the video stream and Flash Media Server connection to close.
		 *  This method triggers the close event.
		 *
		 */
		function close():void;

		
		/**
		 *
		 *  Causes the FLV file to load without playing. After initial loading,
		 *  the state is VideoState.PAUSED.
		 *  
		 *  If the player is in an unresponsive state, the load() method queues
		 *  the request.
		 *	
		 *  @param url
		 *     A URL string for the file that you want to load. If no value is
		 *     passed for URL, an error is thrown with the message null URL
		 *     sent to MediaPlayer.load.
		 *
		 */
		function load(url:String):void;
		
		
		/**
		 *
		 *  Pauses playback. If media is paused or stopped, has no effect. To
		 *  start playback again, call play(). Takes no parameters.
		 *	
		 *  If player is in an unresponsive state, the pause() method queues the
		 *  request.
		 *
		 *  If the player is in a stopped state, a call to the pause() method
		 *  has no effect and the player remains in a stopped state.
		 *
		 */
		function pause():void;
		
		
		/**
		 *
		 *  Causes the media to play. Can be called while the video is paused or
		 *  stopped, or while the media is already playing.
		 *	
		 *  If the player is in an unresponsive state, queues the request.
		 *
		 */
		function play():void;


		/**
		 *
		 *  Seeks to a given time in the file, specified in seconds, with a
		 *  precision of three decimal places (milliseconds). If media is
		 *  playing, the media continues to play from that point. If media is
		 *  paused, seeks to that point and remains paused. If media is stopped,
		 *  seeks to that point and enters the paused state. Has no effect with
		 *  live streams.
		 *	
		 *  The playheadTime property might not have the expected value
		 *  immediately after you call one of the seek methods. For a
		 *  progressive download, you can seek only to a keyframe; therefore, a
		 *  seek takes you to the time of the first keyframe after the specified
		 *  time.
		 *	
		 *  Note: When streaming, a seek always goes to the precise specified
		 *  time even if the source file doesn't have a keyframe there.
		 *	
		 *	Seeking is asynchronous, so if you call a seek method, playheadTime
		 *	does not update immediately. To obtain the time after the seek is
		 *	complete, listen for the seek event, which does not start until the
		 *	playheadTime property is updated.
		 *	
		 *	Throws an exception if called when no stream is connected. Use the
		 *	stateChange event and the connected property to determine when it
		 *	is safe to call this method.
		 *	
		 *  @param time
		 *     A number that specifies the time, in seconds, at which to place the playhead.
		 *  @throws MediaError
		 *     If time is &lt; 0 or NaN.
		 *
		 */
		function seek(time:Number):void;
		
		
		/**
		 *
		 *  Stops video playback. If autoRewind is set to true, rewinds to
		 *	first frame. If video is already stopped, has no effect. To start
		 *	playback again, call play(). Takes no parameters.
		 *	
		 *	If player is in an unresponsive state, queues the request.
		 *	
		 *	Throws an exception if called when no stream is connected. Use the
		 *	stateChange event and connected property to determine when it is
		 *	safe to call this method.
		 *
		 */
		function stop():void;




	}
}