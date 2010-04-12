package inky.app.controller 
{
	import inky.app.data.IApplicationData;
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
	public interface IApplicationController
	{
		/**
		 * 
		 */
		function handleRequest(request:Object):void;


		/**
		 * 
		 */
		function initialize(data:IApplicationData, view:DisplayObjectContainer):void;

	}
	
}