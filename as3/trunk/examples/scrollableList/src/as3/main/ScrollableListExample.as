package
{
	import MyListItem;
	import inky.collections.ArrayList;
	import flash.display.Sprite;

	public class ScrollableListExample extends Sprite
	{
		/**
		 *
		 */	
		public function ScrollableListExample()
		{
			var a:Array = [];
			for (var i:int = 0; i < 100; i++)
			{
				a.push({index: i});
			}

			this.listView.dataProvider = new ArrayList(a);
		}

	}
}
