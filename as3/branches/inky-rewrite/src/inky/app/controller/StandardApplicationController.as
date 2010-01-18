package inky.app.controller 
{
	import inky.app.controller.IApplicationController;
	import flash.display.Sprite;
	import inky.utils.describeObject;
	
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
		
		/**
		 * @inheritDoc
		 */
		public function handleRequest(request:Object):void
		{
trace(describeObject(request, true));
		}




	}
	
}