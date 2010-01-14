package inky.app.model 
{
	import inky.app.SPath;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.12.19
	 *
	 */
	public interface IApplicationModel
	{
		/**
		 * 
		 */
		function get routes():Array;

		
		/**
		 * 
		 */
		function getSectionClassName(sPath:SPath):String;
	}
	
}