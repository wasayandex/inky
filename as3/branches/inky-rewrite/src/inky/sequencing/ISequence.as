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
		function get length():int;
		
		/**
		 * 
		 */
		function get previousCommand():Object;
		
		/**
		 * 
		 */
		function get variables():Object;
	
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
	
		/**
		 * 
		 */
		function getCommandAt(index:int):Object;
// TODO: Get rid of getCommandDataAt. CommandData object should not be exposed. In fact they probably shouldn't exist anymore. Just have injectors.
		/**
		 * 
		 */
		function getCommandDataAt(index:int):CommandData;

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