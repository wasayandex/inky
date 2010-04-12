package inky.styles.selectors 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.06.15
	 *
	 */
	public interface ISelector
	{
		
		/**
		 *
		 */
		function matches(obj:Object):Boolean;


		/**
		 *
		 */
		function toCSSString():String;
		
		
		/**
		 *
		 */
		function get specificity():uint;

	}
}
