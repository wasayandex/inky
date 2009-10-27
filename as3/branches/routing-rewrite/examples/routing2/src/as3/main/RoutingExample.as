package  
{
	import flash.display.Sprite;
	import inky.routing.*;
	import inky.routing.request.*;
	import inky.routing.router.*;
	import inky.routing.events.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import ViewStack;
	import controllers.*;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2008.09.22
	 *
	 */
	public class RoutingExample extends Sprite
	{
		private var _frontController:IFrontController;

// FIXME: How do these get compiled in?!
TierController;
UnitController;

		/**
		 *
		 */
		public function RoutingExample()
		{
var subsectionContainer:Sprite = new Sprite();
this.addChild(subsectionContainer);
ViewStack.initialize(subsectionContainer);
			
			// Create a router.
			var map:Router = new Router();
			map.addRoute(new Route("showUnit", {controller: "Unit", action: "view", id: "0"}, {id: /[0-9]+/}));
			map.addRoute(new Route("showTier", {controller: "Tier", action: "view", id: "0"}, {id: /[0-9]+/}, new StandardRequestFormatter({examplePropertyFromEvent: "bubbles"})));

			// Create the front controller.
			this._frontController = new FrontController(this, map, new RequestDispatcher().handleRequest);

			// Add a "show unit" button.
			this._createButton("showUnit", 0, 0);
			
			// Add a "show tier" button.
			this._createButton("showTier", 110, 0);
		}


		/**
		 *	Creates a button on the stage that will dispatch an event of the specified type when clicked.
		 */
		private function _createButton(eventType:String, x:Number = 0, y:Number = 0):void
		{
			var button:Sprite = new Sprite();
			button.graphics.beginFill(uint(Math.random() * 0xff0000), 0.5);
			button.graphics.drawRect(0, 0, 100, 100);
			this.addChild(button);
			button.x = x;
			button.y = y;
			button.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {dispatchEvent(new Event(eventType, true))});
		}



		
	}
}