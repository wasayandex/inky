package inky.injection 
{
	import inky.injection.IInjectionAdapter;

	
	/**
	 *
	 *  The IInjector interface defines methods for mapping injection adapters to events.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.11.19
	 *
	 */
	public interface IInjector
	{
		
		/**
		 *
		 * Maps an adapter to an event type.
		 * 
		 * @param eventType
		 * 		The type of event the injection adapter will handle.
		 * @param adapter
		 * 		The IInjectionAdapter instance.
		 * @param filter
		 * 		A method that is consulted before initializing the adapter. This method is useful for making sure injection isn't triggered unintentionally.
		 * 
		 * @see inky.injection.IInjectionAdapter
		 * 
		 */
		function map(eventType:String, adapter:IInjectionAdapter, filter:Function):void;
		

		
	}
	
}
