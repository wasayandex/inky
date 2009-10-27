package viewRenderers 
{
import viewRenderers.IViewRenderer;
import views.TierView;
	
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
	public class TierViewRenderer implements IViewRenderer
	{

		/**
		 *	@inheritDoc
		 */
		public function render():void
		{
			var viewStack:ViewStack = ViewStack.getInstance();
			viewStack.removeAll();
			viewStack.add(new TierView());
		}
		
	}
	
}