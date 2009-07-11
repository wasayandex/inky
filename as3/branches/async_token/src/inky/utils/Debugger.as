package inky.utils 
{


	/**
	 *
	 * Aids in the process of debugging an Inky application. The debugger
	 * throws framework-related warnings and errors. By default, debugging mode
	 * is disabled. To enable debugging in your application, set the debug
	 * property of your application to true. This can be done in the Inky XML,
	 * as shown below.
	 * 
	 * <listing>&lt;inky:Application xmlns:inky="http://inkyframework.com/2008/inky" debug="true">
	 * &lt;/inky:Application>
	 * </listing>
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2008.08.07
	 *
	 */
	public class Debugger
	{
		private static var _enabled:Boolean = false;




		//
		// accessors
		//


		/**
		 *
		 *
		 *
		 */
		public static function get enabled():Boolean
		{
			return Debugger._enabled;
		}
		/**
		 * @private
		 */
		public static function set enabled(enabled:Boolean):void
		{
			Debugger._enabled = enabled;
		}




		//
		// public methods
		//


		/**
		 *
		 *	
		 */
		public static function traceWarning(msg:*):void
		{
			if (Debugger.enabled)
			{
				trace(String('Warning: ' + msg));
			}
		}




	}
}