package
{
	import viewRenderers.IViewRenderer;
	import viewRenderers.UnitViewRenderer;
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
	public class UnitController extends ActionController
	{
		
		/**
		 *	
		 */
		public function viewAction():void
		{
			var renderer:IViewRenderer = new UnitViewRenderer();
			renderer.render();
		}


	}
	
}