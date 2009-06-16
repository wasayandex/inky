package inky.framework.styles.selectors 
{
	import inky.framework.styles.selectors.ICombinator;


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
	public interface ICombinator extends ISelector
	{
		
		/**
		 *
		 */
		function get relatedSelector():ISelector;
		/**
		 * @private
		 */
		function set relatedSelector(value:ISelector):void;

	}
}
