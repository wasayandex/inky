package inky.framework.controls 
{
	import com.exanimo.controls.IButton;
	
	/**
	 *
	 *	A button that automatically triggers gotoSection calls on click.
	 *	The button must be given an SPath (with or without options) to go to.
	 *	It can optionally toggle itself based on whether or not a detected 
	 *	NavigationEvent matches it's target SPath.
	 *	
	 *	@see com.exanimo.controls.IButton
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
	public interface INavigationButton extends IButton
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


		
		
	}
	
}
