package inky.components 
{
	import inky.layout.ILayoutManagerClient;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.08.21
	 *
	 */
	public interface IComponent extends ILayoutManagerClient
	{

		/**
		 *	
		 */
		function destroy():void;
		
		
		/**
		 *	
		 */
		function invalidateLayout():void;
		
		
		/**
		 *	
		 */
		function invalidateParentLayout():void;

		


	}
	
}