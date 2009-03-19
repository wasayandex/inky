package com.exanimo.controls
{
	/**
	 *
	 * Values for the <code>horizontalScrollPolicy</code> and
	 * <code>verticalScrollPolicy</code> properties of a ScrollPane.
	 *	
	 * @see http://exanimo.com/actionscript/scrollpane/	 
	 *	 	 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author    Matthew Tretter (matthew@exanimo.com)
	 * @since     2007.11.12
	 *	
	 */
	public class ScrollPolicy
	{
		/**
		 *
         * Always show the scroll bar. The size of the scroll bar is
         * automatically added to the size of the owner's contents to determine
         * the size of the owner if explicit sizes are not specified.
         *
         */
		public static const ON:String = 'on';
		
		/**
		 *
		 * Show the scroll bar if the children exceed the owner's dimensions.
		 * The size of the owner is not adjusted to account for the scroll bars 
		 * when they appear, so this may cause the scroll bar to obscure the
		 * contents of the component or container.
         *
		 */
		public static const AUTO:String = 'auto';


		/**
		 *
         * Never show the scroll bar.
         *
		 */
		public static const OFF:String = 'off';
	}
}
