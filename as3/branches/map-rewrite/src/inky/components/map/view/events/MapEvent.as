package inky.components.map.view.events
{
	import flash.events.Event;

	/**
	 *
	 *  MapEvent defines common events dispatched by typical implementations of IMap.
	 *  
	 *  @see inky.components.map.view.IMap
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.14
	 */
	public class MapEvent extends Event
	{
		private var _feature:Object;
		
		/**
		 *  The <code>MapEvent.DESELECT_FOLDER_CLICKED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>deselectFolderClicked</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>feature</code></td><td>The object that the event pertains to.</td></tr>
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
		 *  @eventType deselectFolderClicked
		 */
		public static const DESELECT_FOLDER_CLICKED:String = "deselectFolderClicked";
		
		/**
		 *  The <code>MapEvent.DESELECT_PLACEMARK_CLICKED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>deselectPlacemarkClicked</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>feature</code></td><td>The object that the event pertains to.</td></tr>
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
		 *  @eventType deselectPlacemarkClicked
		 */
		public static const DESELECT_PLACEMARK_CLICKED:String = "deselectPlacemarkClicked";

		/**
		 *  The <code>MapEvent.SELECT_FOLDER_CLICKED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>selectFolderClicked</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>feature</code></td><td>The object that the event pertains to.</td></tr>
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
		 *  @eventType selectFolderClicked
		 */
		public static const SELECT_FOLDER_CLICKED:String = "selectFolderClicked";
		
		/**
		 *  The <code>MapEvent.SELECT_PLACEMARK_CLICKED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>selectPlacemarkClicked</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>feature</code></td><td>The object that the event pertains to.</td></tr>
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
		 *  @eventType selectPlacemarkClicked
		 */
		public static const SELECT_PLACEMARK_CLICKED:String = "selectPlacemarkClicked";
		
		/**
		 *  Constructor.
		 *
		 *  @param type
		 *      The event type; indicates the action that caused the event.
		 *  @param feature
		 * 		The object that the event pertains to.
		 */
		public function MapEvent(type:String, feature:Object = null)
		{
			super(type, true, false);
			this._feature = feature;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * Gets the object that the event pertains to.
		 */
		public function get feature():Object
		{
			return this._feature;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new MapEvent(this.type, this.feature);
		}

		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("MapEvent", "feature");
		}

	}
}

