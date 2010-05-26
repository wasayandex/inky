package inky.routing.events
{
	import flash.events.Event;
	import inky.routing.IRoute;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.10.21
	 *
	 */
	public class RouteMatchedEvent extends Event
	{
		public var params:Object;
		public var route:IRoute;
		public var url:String;

		/**
		 *  The <code>RouteMatchedEvent.ROUTE_MATCHED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>routeMatched</code> event.
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
		 *  @eventType routeMatched
		 */
		public static const ROUTE_MATCHED:String = "routeMatched";


		/**
		 *  Constructor.
		 *
		 *  @param type
		 *      The event type; indicates the action that caused the event.
		 *
		 */
		public function RouteMatchedEvent(url:String, route:IRoute, params:Object = null)
		{
			super(RouteMatchedEvent.ROUTE_MATCHED);
			this.route = route;
			this.url = url;
			this.params = params || {};
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new RouteMatchedEvent(this.url, route, params);
		}

		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
// TODO: Params should be enumerated in toString()
			return this.formatToString("RouteMatchedEvent", "type", "url", "route", "params");
		}




	}
}