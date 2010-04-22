package
{
	import inky.components.listViews.scrollableList.ScrollableList;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Exponential;

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
			this.itemRendererClass = MyListItem;
			this.tween = new GTween(this.getContentContainer(), 0.5, null, {ease: Exponential.easeOut, onChange: this.tweenChangeHandler});
			this.contentContainerProxy = this.tween.proxy;
		}

		/**
		 * 
		 */
		private function tweenChangeHandler(tween:GTween):void
		{
			this.invalidate();
		}

	}
}
