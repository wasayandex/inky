package inky.loading.events
{
	import flash.events.Event;

	
	/**
	 *
	 * The AssetLoaderEvent class defines events that are associated
	 * with the IAssetLoader interface.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 *
	 * @author Eric Eldredge
	 * @since  2008.06.04
	 *
	 */
	public class AssetLoaderEvent extends Event
	{
		/**
		 * Defines the value of the <code>type</code> property for an <code>ready</code> 
		 * event object.
		 * 
		 * <p>This event has the following properties:</p>
		 *  <table class="innertable" width="100%">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 * 	   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
		 *     <tr><td><code>cancelable</code></td><td><code>false</code></td></tr>	
		 *    <tr><td><code>currentTarget</code></td><td>The object that is actively processing the event object with an event listener.</td></tr>
	     *     <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *           not always the object listening for the event. Use the <code>currentTarget</code>
		 * 			property to access the object that is listening for the event.</td></tr>
		 *  </table>
         *
         * @eventType ready
         * 
		 */
		public static const READY:String = 'ready';




		/**
		 *
		 * Creates a new AssetLoaderEvent object that contains information about an
		 * asset loader event. An AssetLoaderEvent object is passed as a parameter to
		 * an event listener.
		 * 
		 * @param type
		 *     The type of the event. Event listeners can access this
		 *     information through the type property of the event object. An
		 *     AssetLoaderEvent can have the following types of events:
		 *     AssetLoaderEvent.READY.
		 * @param bubbles
		 *     Determines whether the AssetLoaderEvent object participates in the
		 *     bubbling phase of the event flow. Event listeners can access this
		 *     information through the bubbles property of the event object.
		 * @param cancelable
		 *     Determines whether the AssetLoaderEvent object can be canceled.
		 *     Event listeners can access this information through the
		 *     cancelable property of the event object.
		 *
		 */
		public function AssetLoaderEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);		
		}




		//
		// public methods
		//
		
		
		/**
		 *
		 * Creates a copy of the AssetLoaderEvent object and sets the value of each
		 * parameter to match the original.
		 *
		 * @return
		 *     A new AssetLoaderEvent object with property values that match those of
		 *     the original.
		 * 
		 */
		override public function clone():Event
		{
			return new AssetLoaderEvent(this.type, this.bubbles, this.cancelable);
		}


		/**
		 *
		 * Returns a string that contains all the properties of the AssetLoaderEvent
		 * object. The string is in the following format:
		 * 
		 * <code>[AssetLoaderEvent type=value bubbles=value cancelable=value]</code>
		 *
		 * @return
		 *     A string representation of the AssetLoaderEvent object.
		 * 
		 */
		public override function toString():String
		{
			return this.formatToString('AssetLoaderEvent', 'type', 'bubbles', 'cancelable');
		}




	}
}

