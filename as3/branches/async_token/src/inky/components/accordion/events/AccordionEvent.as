package inky.components.accordion.events 
{
	import flash.events.Event;
	
	/**
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Rich Perez
	 *	@since  22.02.2008
	 */
	public class AccordionEvent extends Event 
	{
		public static const CHANGE:String = 'change';
		public static const OPEN:String = 'open';
		public static const CLOSE:String = 'close';
		
		/**
		 *	@constructor
		 */
		public function AccordionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);		
		}
		
		/**
		*	@inheritDoc
		*/
		override public function clone():Event 
		{
			return new AccordionEvent(type, bubbles, cancelable);
		}
		
		/**
		 *	@inheritDoc
		 */
		override public function toString():String
		{
			return this.formatToString('AccordionEvent', 'type', 'bubbles', 'cancelable');
		}		
	}
}
