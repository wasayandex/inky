package inky.loading.events
{
	import flash.events.Event;
	import inky.loading.CumulativeLoaderInfo;

	/**
	 *
	 *  I wanted this to extend ProgressEvent but it looks like Adobe changed
	 *  the ProgressEvent API between player versions (bytesLoaded/bytesTotal
	 *  used to return uint; now return Number). This causes the player to
	 *  fail at runtime if the player version has the old class definition:
	 * 	    return types dont match
	 *          virt uint flash.events::ProgressEvent/get bytesLoaded()
	 *          over Number inky.loading.events::CumulativeLoaderInfoProgressEvent/get bytesLoaded()
	 * 	    return types dont match
	 * 	        virt uint flash.events::ProgressEvent/get bytesTotal()
	 * 	    	over Number inky.loading.events::CumulativeLoaderInfoProgressEvent/get bytesTotal()
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.06
	 *
	 */
	public class CumulativeLoaderInfoProgressEvent extends Event
	{
		private var loaderInfo:CumulativeLoaderInfo;
		
		/**
		 *  The <code>CumulativeLoaderInfoProgressEvent.PROGRESS</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>progress</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
		 *       event listener that handles the event. For example, if you use 
		 *       <code>myButton.addEventListener()</code> to register an event listener, 
		 *       myButton is the value of the <code>currentTarget</code>. </td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. 
		 *       Use the <code>currentTarget</code> property to always access the 
		 *       Object listening for the event.</td></tr>
		 *  </table>
		 *
		 *  @eventType progress
		 */
		public static const PROGRESS:String = "progress";

		/**
		 *  Constructor.
		 *
		 *  @param type
		 *      The event type; indicates the action that caused the event.
		 *  @param bubbles
		 *      Specifies whether the event can bubble up the display list hierarchy.
		 *  @param cancelable
		 *      Specifies whether the behavior associated with the event can be prevented.
		 *
		 */
		public function CumulativeLoaderInfoProgressEvent(loaderInfo:CumulativeLoaderInfo, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			this.loaderInfo = loaderInfo;
			super(PROGRESS, bubbles, cancelable);		
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @copy flash.events.ProgressEvent
		 */
		public function get bytesLoaded():Number
		{ 
			return this.loaderInfo.bytesLoaded; 
		}

		/**
		 * @copy flash.events.ProgressEvent
		 */
		public function get bytesTotal():Number
		{ 
			return this.loaderInfo.bytesTotal; 
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new CumulativeLoaderInfoProgressEvent(this.loaderInfo, this.bubbles, this.cancelable);
		}

		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("CumulativeLoaderInfoProgressEvent", "type", "bubbles", "cancelable");
		}




	}
}