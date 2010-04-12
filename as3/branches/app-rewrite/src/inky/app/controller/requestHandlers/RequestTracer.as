package inky.app.controller. requestHandlers 
{
	import inky.app.controller. requestHandlers.IRequestHandler;
	import inky.utils.describeObject;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.02.02
	 *
	 */
	public class RequestTracer implements IRequestHandler
	{
		/**
		 * @inheritDoc
		 */
		public function handleRequest(request:Object):Object
		{
			trace(describeObject(request));
			return request;
		}


	}
}