package  
{
	import flash.display.Sprite;
	import inky.go.*;
	import inky.go.events.*;
	import flash.events.MouseEvent;
	import flash.events.Event;

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
		private var _frontController:FrontController;


		/**
		 *
		 */
		public function RoutingExample()
		{
			// Create a router.
			var map:Router = new Router();
			map.addRoute(new Route("showEmployee", {controller: "employee", action: "view", id: "0"}, {id: /[0-9]+/}));
			map.addRoute(new AddressRoute("#/books/:id", "showBook", {controller: "books", action: "view", id: "0"}, {id: /[0-9]+/}));

			var frontController:AddressFrontController = new AddressFrontController(this, map);
			this._frontController = frontController;

			// Add a "show employee" button.
			this._createButton("showEmployee", 0, 0);
			
			// Add a "show book" button.
			this._createButton("showBook", 110, 0);
		}
		
		private function _createButton(eventType:String, x:Number = 0, y:Number = 0):void
		{
			var button:Sprite = new Sprite();
			button.graphics.beginFill(uint(Math.random() * 0xff0000));
			button.graphics.drawRect(0, 0, 100, 100);
			this.addChild(button);
			button.x = x;
			button.y = y;
			button.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {dispatchEvent(new Event(eventType, true))});
		}



		
	}
}