package inky.components.buttons 
{
	import inky.utils.IDisplayObject;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.02.01
	 *
	 */
	public interface IButton extends IDisplayObject
	{

		//
		// accessors
		//


		/**
		 *
		 * Gets or sets a Boolean value that indicates whether the button can be toggled.
		 *	
		 */
		function get toggle():Boolean
		function set toggle(toggle:Boolean):void
		

		/**
		 *
		 * Gets or sets a Boolean value that indicates whether the button is selected.
		 *
		 */
		function get selected():Boolean
		function set selected(selected:Boolean):void
		

		/**
		 *
		 * Gets or sets a Boolean value that indicates whether the button is enabled.
		 *
		 */
		function get enabled():Boolean
		function set enabled(enabled:Boolean):void
		

		
	}
	
}