package inky.layout.layouts.boxModel
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.07.27
	 *
	 */
	public class BoxModelLayoutPosition
	{
		/**
		 * Generates an absolutely positioned element, positioned relative to its containing block. The element's position is specified with the "left", "top", "right", and "bottom" properties
		 */
		public static const ABSOLUTE:String = "absolute";

		/**
		 * Generates an absolutely positioned element, positioned relative to the browser window. The element's position is specified with the "left", "top", "right", and "bottom" properties
		 */
		public static const FIXED:String = "fixed";
		
		/**
		 * Generates a relatively positioned element, positioned relative to its normal position, so "left:20" adds 20 pixels to the element's LEFT position
		 */
		public static const RELATIVE:String = "relative";

		/**
		 * No position, the element occurs in the normal flow (ignores any top, bottom, left, right, or z-indez declarations)
		 */
		public static const STATIC:String = "static";
		
		/**
		 * Specifies that the value of the position property should be inherited from the parent element
		 */
		public static const INHERIT:String = "inherit";


	}
}
