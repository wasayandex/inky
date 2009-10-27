package views 
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.26
	 *
	 */
	public class TierView extends Sprite
	{
		/**
		 *
		 */
		public function TierView()
		{
			this.showUnitButton.addEventListener("click", function(event){dispatchEvent(new Event("showUnit", true))});
		}
	}
	
}