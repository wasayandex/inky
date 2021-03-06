﻿package inky.framework.components 
{
	import inky.framework.display.IDisplayObject;
	import flash.events.IEventDispatcher;


	/**
	 *	Describes the methods that a Button must implement.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Eric Eldredge
	 *	@author Matthew Tretter (matthew@exanimo.com)
	 *	@since  2009.01.30
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
