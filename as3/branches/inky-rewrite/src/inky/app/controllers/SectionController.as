package inky.app.controllers
{
	import inky.app.controllers.ActionController;
	import inky.app.ViewStack;
	import inky.app.SPath;
	import inky.collections.IIterator;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.28
	 *
	 */
	public class SectionController extends ActionController
	{
		
		
		public function viewAction(params:Object = null):void
		{
			var sPath:SPath = SPath(params.sPath);
			
// TODO: Preload assets.
			
			// Reduce the view stack to a common ancestor between the current leaf and the new section.
			var viewStack:ViewStack = ViewStack.getInstance();
			sPath = viewStack.reduceToCommonAncestor(sPath);
			
			// Iterate through the remaining portion of the sPath and create and add the sections.
			for (var i:IIterator = sPath.iterator(); i.hasNext(); )
			{
				var sectionName:String = String(i.next());

// TODO: How to convey section options to the sections?
				
// TODO: How to get the section class and instanciate it?  Here the work is just delegated to the viewStack...
				viewStack.add(sectionName);
			}
		}
		

		
	}
	
}