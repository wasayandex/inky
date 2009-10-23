package inky.go.request 
{
	import flash.events.Event;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.10.22
	 *
	 */
	public interface IRequestFormatter
	{
		
		/**
		 *	@inheritDoc
		 */
		function format(event:Event, defaults:Object = null):IRequest;


	}
}