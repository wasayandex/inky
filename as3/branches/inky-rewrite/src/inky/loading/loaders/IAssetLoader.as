package inky.loading.loaders
{
	import flash.events.IEventDispatcher;
	
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
	public interface IAssetLoader extends IEventDispatcher
	{
		/**
		 * 
		 */
		function load():void;


		function get asset():Object;
		
		function get bytesLoaded():uint;
		function get bytesTotal():uint;
		
		function get source():Object;
		function set source(value:Object):void;
		
	}
	
}