package
{
	import viewRenderers.TierViewRenderer;
	import viewRenderers.IViewRenderer;
	import controllers.ActionController;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.26
	 *
	 */
	public class TierController extends ActionController
	{

		/**
		 *	
		 */
		public function viewAction():void
		{
			var renderer:IViewRenderer = new TierViewRenderer();
			renderer.render();
		}




	}
	
}