package 
{
	import inky.app.bootstrapper.Bootstrapper;
	import inky.routing.router.IRouter;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.12
	 *
	 */
	public class PetsittersBootstrapper extends Bootstrapper
	{
		/**
		 * @inheritDoc
		 */
		override protected function onStartup():void
		{
			var router:IRouter = this.frontController.router;
		}

		
	}
	
}