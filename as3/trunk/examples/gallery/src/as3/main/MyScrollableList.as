package
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;
	import inky.components.listViews.scrollableList.ScrollableList;


	/**
	 *
	 *	
	 */
	public class MyScrollableList extends ScrollableList
	{
		private var tween:GTween;
		
		/**
		 * 
		 */
		public function MyScrollableList()
		{
			this.spacing = 10;
			this.tween = new GTween(this.getContentContainer(), 0.3, null, {onChange: this.tweenChangeHandler, ease: Sine.easeOut});
			this.contentContainerProxy = this.tween.proxy;
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 *
		 */
		private function tweenChangeHandler(tween:GTween):void
		{
			this.invalidate();
		}

	}

}
