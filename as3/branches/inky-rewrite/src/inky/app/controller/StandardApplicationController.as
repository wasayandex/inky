package inky.app.controller 
{
	import inky.app.controller.IApplicationController;
	import flash.display.Sprite;
	import inky.app.controller. requestHandlers.RequestHandlerList;
	import inky.app.controller.requestHandlers.GotoSectionHandler;
	import inky.app.controller.requestHandlers.QueueManager;
	import inky.app.controller.requestHandlers.ViewStackManager;
	import inky.app.data.IApplicationData;
	import inky.collections.ArrayList;
	import flash.display.DisplayObjectContainer;
	
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
		protected var data:IApplicationData;
		protected var view:DisplayObjectContainer;


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


		/**
		 * @inheritDoc
		 */
		public function initialize(data:IApplicationData, view:DisplayObjectContainer):void
		{
			this.data = data;
			this.view = view;

			this.requestHandlers.addItems(new ArrayList([
				new GotoSectionHandler(this),
				new ViewStackManager(this, this.view, this.data),
				new QueueManager()
			]));
		}


	}
	
}