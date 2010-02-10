package inky.routing 
{
	import inky.routing.events.RoutingEvent;
	import inky.routing.FrontController;
	import com.asual.swfaddress.SWFAddress;
	import inky.routing.IFrontController;
	import flash.events.Event;
	import com.asual.swfaddress.SWFAddressEvent;
	import inky.routing.router.IRouter;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.09.28
	 *
	 */
	public class AddressFrontController implements IFrontController
	{
		private var _frontController:IFrontController;


		/**
		 * 
		 */
		public function AddressFrontController(frontController:IFrontController)
		{
			if (!frontController)
				throw new ArgumentError("Illegal null argument.");
			this._frontController = frontController;
		}




		//
		// front controller methods
		//


		/** @inheritDoc */
		public function handleRequest(request:Object):void { this._frontController.handleRequest(request); };


		/** @inheritDoc */
		public function get router():IRouter { return this._frontController.router; }
		public function set router(value:IRouter):void { this._frontController.router = router; }


		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this.handleRequest);
			this._frontController.initialize();
		}




		//
		// event dispatcher methods
		//


		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			this._frontController.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}


		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return this._frontController.dispatchEvent(event);
		}


		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean 
		{
			return this._frontController.hasEventListener(type);
		}


		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			return this._frontController.removeEventListener(type, listener, useCapture);
		}


		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 
		{
			return this._frontController.willTrigger(type);
		}




	}
}