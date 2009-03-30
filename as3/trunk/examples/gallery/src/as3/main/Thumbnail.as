package
{
	import flash.display.*;
	import flash.text.*;
	import inky.framework.components.listViews.IListItemView;


	public class Thumbnail extends Sprite implements IListItemView
	{
		private var _model:Object;
		

		/**
		 *
		 *
		 *
		 */
		public function get model():Object
		{
			return this._model;
		}
		/**
		 * @private
		 */
		public function set model(value:Object):void
		{
			this.labelField.text = value.group.items.getItemIndex(value);
			this._model = value;
		}
	
	}
}