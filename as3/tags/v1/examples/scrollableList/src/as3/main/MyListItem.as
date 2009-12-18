package
{
	import flash.display.Sprite;
	import flash.text.TextField;


	/**
	 *
	 *	
	 */
	public class MyListItem extends Sprite
	{
		private var _model:Object;
private static var _heights:Array = [];
private static var _k:Array = [10, 25, 50, 75, 100, 125];

		/**
		 * @inheritDoc
		 */
		public function get model():Object
		{
			return this._model;
		}
		public function set model(model:Object):void
		{
			this.numberField.text = model.index;
			
var height:Number = _heights[model.index];
if (isNaN(height))
{
	height = _k[Math.floor(Math.random() * _k.length)];
	_heights[model.index] = height;
}
this.height = height;
			this._model = model;
		}


	}
}
