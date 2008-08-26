package inky.framework.core
{
	import flash.events.Event;
	import inky.framework.events.SectionOptionsEvent;
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
			var isChanged:Boolean = false;
			for (prop in this)
			{
				if (!options.hasOwnProperty(prop))
				{
					delete this[prop];
					isChanged = true;
				}
			}
			for (prop in options)
			{
				isChanged = isChanged || (this[prop] != options[prop]);
				this[prop] = options[prop];
			}

			if (isChanged)
			{
				this.dispatchEvent(new SectionOptionsEvent(SectionOptionsEvent.CHANGE));
			}

			this.dispatchEvent(new SectionOptionsEvent(SectionOptionsEvent.UPDATE));
		}




	}
}
