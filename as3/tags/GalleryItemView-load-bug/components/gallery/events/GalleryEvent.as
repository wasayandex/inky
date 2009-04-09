package inky.framework.components.gallery.events
{
	import flash.events.Event;


	/**
	 *
	 * 
	 *
	 */
	public class GalleryEvent extends Event
	{
		/**
		 *	
         * 
		 */
		public static const SELECTED_ITEM_CHANGE:String = 'selectedItemChange';

		public static const SELECTED_GROUP_CHANGE:String = 'selectedGroupChange';




		/**
		 *
		 * 
		 *
		 */
		public function GalleryEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}




		//
		// public methods
		//
		
		
		/**
		 *
		 * 
		 * 
		 */
		override public function clone():Event
		{
			return new GalleryEvent(this.type, this.bubbles, this.cancelable);
		}
		
		
		/**
		 *
		 * 
		 * 
		 */
		override public function toString():String
		{
			return this.formatToString('GalleryEvent', 'type', 'bubbles', 'cancelable');
		}




	}
}
