package
{
	import flash.display.*;
	import flash.text.*;


	public class Thumbnail extends Sprite
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