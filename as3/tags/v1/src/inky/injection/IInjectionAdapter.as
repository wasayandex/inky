package inky.injection 
{
	import flash.events.Event;
	
	/**
	 *
	 *  The IInjectionAdapter interface defines methods for facilitating injection via an IInjector.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.11.19
	 *
	 */
	public interface IInjectionAdapter
	{
		
		/**
		 *
		 * Performs the injection.
		 * @param target
		 * 		The injection target.
		 * 
		 * @see inky.injection.IInjector
		 * 
		 */
		function inject(target:Object):void;
	}
	
}