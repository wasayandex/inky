package inky.app.controller 
{
	import inky.app.controller.IApplicationController;
	import flash.display.Sprite;
	import inky.utils.describeObject;
	import inky.app.requestHandlers.IRequestHandler;
	import inky.app.requestHandlers.RequestHandlerList;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.01.18
	 *
	 */
	public class StandardApplicationController extends Sprite implements IApplicationController
	{
		protected var requestHandlers:RequestHandlerList;


		/**
		 *
		 */
		public function StandardApplicationController()
		{
			this.requestHandlers = new RequestHandlerList();
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function handleRequest(request:Object):void
		{
			this.requestHandlers.handleRequest(request);
		}




	}
	
}