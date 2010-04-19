package inky.components.map.view.events
{
	import flash.events.Event;

	/**
	 *
	 *  MapFeatureEvent defines common events dispatched by typical implementations of features of an map component.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.19
	 *
	 */
	public class MapFeatureEvent extends Event
	{
		private var _feature:Object;
		
		/**
		 *  The <code>MapFeatureEvent.DESELECT_FOLDER_TRIGGERED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>deselectFolderTriggered</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>true</td></tr>
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
		 *  @eventType deselectFolderTriggered
		 */
		public static const DESELECT_FOLDER_TRIGGERED:String = "deselectFolderTriggered";
		
		/**
		 *  The <code>MapFeatureEvent.DESELECT_PLACEMARK_TRIGGERED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>deselectPlacemarkTriggered</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>true</td></tr>
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
		 *  @eventType deselectPlacemarkTriggered
		 */
		public static const DESELECT_PLACEMARK_TRIGGERED:String = "deselectPlacemarkTriggered";
		
		/**
		 *  The <code>MapFeatureEvent.SELECT_FOLDER_TRIGGERED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>selectFolderTriggered</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>true</td></tr>
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
		 *  @eventType selectFolderTriggered
		 */
		public static const SELECT_FOLDER_TRIGGERED:String = "selectFolderTriggered";
		
		/**
		 *  The <code>MapFeatureEvent.SELECT_PLACEMARK_TRIGGERED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>selectPlacemarkTriggered</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>true</td></tr>
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
		 *  @eventType selectPlacemarkTriggered
		 */
		public static const SELECT_PLACEMARK_TRIGGERED:String = "selectPlacemarkTriggered";

		/**
		 *  Constructor.
		 *
		 *  @param type
		 *      The event type; indicates the action that caused the event.
		 *  @param feature
		 * 		The object that the event pertains to.
		 */
		public function MapFeatureEvent(type:String, feature:Object = null)
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
			return new MapFeatureEvent(this.type, this.feature);
		}

		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("MapFeatureEvent", "feature");
		}

	}
}

