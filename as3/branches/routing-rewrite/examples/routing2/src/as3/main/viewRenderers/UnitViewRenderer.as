package viewRenderers 
{
import viewRenderers.IViewRenderer;
import views.TierView;
import flash.display.Sprite;
import ViewStack;
import views.UnitView;
	
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
	public class UnitViewRenderer implements IViewRenderer
	{
		/**
		 *	@inheritDoc
		 */
		public function render():void
		{
			var tierView:Sprite = new TierView();
			var viewStack:ViewStack = ViewStack.getInstance();
			viewStack.removeAll();
			viewStack.add(tierView);
			viewStack.add(new UnitView());
		}




	}
	
}