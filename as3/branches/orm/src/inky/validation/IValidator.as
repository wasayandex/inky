package inky.validation
{
	import flash.events.IEventDispatcher;
	import inky.validation.ValidationResult;


	/**
	 *	
	 *	..
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2008.09.09
	 *	
	 */
	public interface IValidator extends IEventDispatcher
	{
		//
		// accessors
		//


		/**
		 *
		 *	
		 */
		function set property(property:Object):void;


		/**
		 *
		 *	
		 */
		function set source(source:Object):void;




		//
		// public methods
		//


		/**
		 *
		 *	
		 */
		function validate():ValidationResult;
	}
}
