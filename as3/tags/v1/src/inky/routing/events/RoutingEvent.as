package inky.routing.events
{
	import flash.events.Event;
	import inky.routing.router.IRoute;
	import inky.routing.request.IRequest;

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
	public class RoutingEvent extends Event
	{
		public var triggerEvent:Event;
		public var route:IRoute;
		public var request:IRequest;


		/**
		 *  The <code>RoutingEvent.REQUEST_ROUTED</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>requestRouted</code> event.
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
		 *  @eventType requestRouted
		 */
		public static const REQUEST_ROUTED:String = "requestRouted";


		/**
		 *  Constructor.
		 *
		 *  @param type
		 *      The event type; indicates the action that caused the event.
		 *
		 */
		public function RoutingEvent(type:String, triggerEvent:Event, route:IRoute, request:IRequest)
		{
			super(type, false, true);
			this.triggerEvent = triggerEvent;
			this.route = route;
			this.request = request;
		}




		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new RoutingEvent(this.type, this.triggerEvent, this.route, this.request);
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString("RoutingEvent", "type", "triggerEvent", "route", "request");
		}




	}
}