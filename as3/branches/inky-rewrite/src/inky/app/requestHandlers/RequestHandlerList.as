package inky.app.requestHandlers
{
	import inky.collections.IIterator;
	import inky.collections.ArrayList;
	import inky.app.requestHandlers.IRequestHandler;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.01.06
	 *
	 */
	public class RequestHandlerList extends ArrayList implements IRequestHandler
	{
		/**
		 * @inheritDoc
		 */
		public function handleRequest(request:Object):Object
		{
			for (var i:IIterator = this.iterator(); i.hasNext(); )
			{
				var handler:IRequestHandler = i.next() as IRequestHandler;
				request = handler.handleRequest(request);
				if (!request)
					break;
			}
			return request;
		}




	}
}