package
{
	import inky.binding.utils.BindingUtil;
	import inky.binding.utils.IChangeWatcher;
	import inky.components.gallery.models.GalleryItemModel;
	import inky.components.gallery.views.GalleryItemView;
	import flash.events.MouseEvent;




	public class Thumbnail extends GalleryItemView
	{
		private var _modelChangeWatchers:Array;


		/**
		 *
		 */
		public function Thumbnail()
		{
			this._modelChangeWatchers = [];
			this.buttonMode = true;
			this.featureSize = "thumbnail";
			this.addEventListener(MouseEvent.CLICK, this._clickHandler);
		}




		//
		// accessors
		//


		/**
		 * @private
		 */
		override public function set model(value:GalleryItemModel):void
		{
			while (this._modelChangeWatchers.length)
			{
				this._modelChangeWatchers.pop().unwatch();
			}

			if (value)
			{
				this._modelChangeWatchers.push(BindingUtil.bindSetter(this._setSelected, value, "selected"));
			}

			super.model = value;
		}




		//
		// private methods
		//


		/**
		 *
		 */
		private function _clickHandler(e:MouseEvent):void
		{
			if (this.model)
			{
				this.model.selected = true;
			}
		}


		/**
		 *
		 */
		private function _setSelected(value:Boolean):void
		{
			this.getChildByName("selectedIndicator").visible = value;
		}




	}
}