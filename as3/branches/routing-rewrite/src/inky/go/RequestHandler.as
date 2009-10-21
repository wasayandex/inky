package inky.go 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.10.20
	 *
	 */
	public class RequestHandler implements IRequestHandler
	{
		/**
		 *	@inheritDoc
		 */
		public function handleRequest(request:Object):void
		{
trace("handling request:");
			for (var p in request)
				trace("\t" + p + ":\t" + request[p]);
		}

		
	}
	
}