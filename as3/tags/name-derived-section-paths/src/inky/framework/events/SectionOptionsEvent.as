package inky.framework.events
{
	import flash.events.Event;

	
	/**
	 *
	 *  ..
	 *
	 *  @langversion ActionScript 3.0
	 *  @playerversion Flash 9.0
	 *
	 *  @author Eric Eldredge
	 *  @since  26.08.2008
	 *
	 */
	public class SectionOptionsEvent extends Event
	{
		public static const CHANGE:String = 'change';
		public static const UPDATE:String = 'update';




		/**
		 *
		 *	
		 *	
		 */
		public function SectionOptionsEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);		
		}




		//
		// public methods
		//
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new SectionOptionsEvent(this.type, this.bubbles, this.cancelable);
		}


		/**
		 * @inheritDoc
		 */
		public override function toString():String
		{
			return this.formatToString('SectionOptionsEvent', 'type', 'bubbles', 'cancelable');
		}




	}
}

