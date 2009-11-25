package inky.loading
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.11.24
	 *
	 */
	public interface IAsset
	{
		/**
		 * 
		 */
		function load():void;
		
		
		function get source():String;
		function set source(value:String):void;
	}
	
}
