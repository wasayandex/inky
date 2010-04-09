package inky.sequencing 
{
	import inky.sequencing.CommandData;
	import flash.events.IEventDispatcher;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.29
	 *
	 */
	public interface ISequence extends IEventDispatcher
	{
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------

		/**
		 * 
		 */
		function get currentCommand():Object;

		/**
		 * 
		 */
		function get currentIndex():int;
		
		/**
		 * 
		 */
		function get length():int;
		
		/**
		 * 
		 */
		function get previousCommand():Object;
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
	
		/**
		 * 
		 */
		function getCommandAt(index:int):Object;

		/**
		 * 
		 */
		function interject(obj:Object):void;

		/**
		 * 
		 */
		function play():void;
		
		/**
		 * 
		 */
		function playFrom(index:int):void;
	}
	
}