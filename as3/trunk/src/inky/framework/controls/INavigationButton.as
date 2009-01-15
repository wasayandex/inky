package inky.framework.controls 
{
	import com.exanimo.display.IDisplayObject;

	
	/**
	 *
	 *	A button that automatically triggers gotoSection calls on click.
	 *	The button must be given an SPath (with or without options) to go to.
	 *	It can optionally toggle itself based on whether or not a detected 
	 *	NavigationEvent matches it's target SPath.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2009.01.14
	 *
	 */
	public interface INavigationButton extends IDisplayObject
	{
		//
		// accessors
		//
		
		
		/**
		 *  
		 *	A url hash to be parsed into an SPath.
		 *	
		 *	@see inky.framework.core.SPath;
		 *	
		 */
		function get address():String
		/**
		 *	@private
		 */
		function set address(address:String):void


		/**
		 *
		 *	The options object to be used in the gotoSection call.
		 *	
		 *	@see inky.framework.core.Section#gotoSection();
		 *	
		 */
		function get options():Object
		/**
		 *	@private
		 */
		function set options(options:Object):void

		
		/**
		 *
		 *	The SPath to be used in the gotoSection call.
		 *	
		 *	@see inky.framework.core.SPath;
		 *	@see inky.framework.core.Section@gotoSection();
		 *	
		 */
		function get sPath():Object
		/**
		 *	@private
		 */
		function set sPath(sPath:Object):void
		

		/**
		 *
		 *	Determines whether this button's selected state is managed by 
		 *	NavigationEvents. If set to true, the button will become 
		 *	selected if the event's target SPath matches its own, and it
		 *	will become deselected if the SPaths do not match.
		 *	
		 *	@see inky.framework.events.NavigationEvent;
		 *		
		 */
		function get toggle():Boolean
		/**
		 *	@private
		 */
		function set toggle(toggle:Boolean):void


		
		
	}
	
}
