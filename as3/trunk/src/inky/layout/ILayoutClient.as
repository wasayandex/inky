package inky.layout 
{
	import inky.utils.IDisplayObject;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.08.02
	 *
	 */
	public interface ILayoutClient extends IDisplayObject
	{
		
		/**
		 *	
		 */
		function validateSize():void;
		
		/**
		 *	
		 */
		function validateDisplayList():void;
		
		/**
		 *	
		 */
		function validateProperties():void;

	}
}