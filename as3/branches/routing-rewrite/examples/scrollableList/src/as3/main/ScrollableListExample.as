﻿package{	import MyListItem;	import inky.framework.collections.ArrayList;	import inky.framework.components.listViews.IListView;	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	public class ScrollableListExample extends Sprite	{		/**		 *		 *		 *		 */			public function ScrollableListExample()		{			this.listView.itemViewClass = MyListItem;						var a:Array = [];			for (var i:int = 0; i < 100; i++)			{				a.push({index: i});			}			this.listView.model = new ArrayList(a);		}	}}