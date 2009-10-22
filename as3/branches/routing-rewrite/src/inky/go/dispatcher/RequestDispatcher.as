package inky.go.dispatcher
{
	import inky.go.request.IRequest;
	
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
	public class RequestDispatcher implements IRequestDispatcher
	{
		/**
		 *	@inheritDoc
		 */
		public function dispatchRequest(request:IRequest):void
		{
trace("handling request:");
			for (var p in request.params)
				trace("\t" + p + ":\t" + request.params[p]);
		}

		
	}
	
}