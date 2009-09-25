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
			map.addRoute(new Route("showEmployee", {id: 5}, {id: 5}));

			var frontController:FrontController = new FrontController(this, map);
			this._frontController = frontController;

			// Add a dumb button.
			var button:Sprite = new Sprite();
			button.graphics.beginFill(0xff0000);
			button.graphics.drawRect(0, 0, 100, 100);
			this.addChild(button);
			button.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {dispatchEvent(new Event("showEmployee"))});
		}



		
	}
}