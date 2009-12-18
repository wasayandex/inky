package inky.app 
{
	import inky.routing.request.IRequest;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.11.24
	 *
	 */
	public interface IRequestDispatcher
	{
		/**
		 * 
		 */
		function handleRequest(request:IRequest):void;
		
	}
	
}