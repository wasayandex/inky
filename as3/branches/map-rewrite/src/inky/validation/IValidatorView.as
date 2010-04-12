package inky.validation
{
	import inky.validation.IValidator;


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
	public interface IValidatorView
	{
		/**
		 *
		 *	
		 */
		function reset():void;
		
		/**
		 *
		 *	
		 */
		function set validator(validator:IValidator):void;
	}
}
