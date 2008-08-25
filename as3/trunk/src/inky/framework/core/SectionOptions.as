package inky.framework.core
{
	import flash.events.Event;
	import inky.framework.utils.ObjectProxy;


	/**
	 *
	 * 
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2008.08.25
	 *
	 */
	dynamic public class SectionOptions extends ObjectProxy
	{

		/**
		 *
		 *	
		 */
		public function update(options:Object):void
		{
			var prop:String;
			var isUpdated:Boolean = false;
			for (prop in this)
			{
				if (!options.hasOwnProperty(prop))
				{
					delete this[prop];
					isUpdated = true;
				}
			}
			for (prop in options)
			{
				isUpdated = isUpdated || (this[prop] != options[prop]);
				this[prop] = options[prop];
			}
			
			if (isUpdated)
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}




	}
}
