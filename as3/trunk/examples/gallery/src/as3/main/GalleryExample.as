package
{
	import inky.framework.binding.utils.BindingUtil;
	import inky.framework.components.gallery.*;
	import inky.framework.components.gallery.parsers.*;
	import inky.framework.components.gallery.models.GalleryModel;
	import flash.display.*;
	import flash.events.Event;
	import flash.net.*;
	import Thumbnail;


	public class GalleryExample extends Sprite
	{
		private var _loader:URLLoader;


		public function GalleryExample()
		{
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, this._loaderCompleteHandler);
			this._loader.load(new URLRequest("galleryData.xml"));
		}
		
		private function _loaderCompleteHandler(e:Event):void
		{
			var model:GalleryModel = new GalleryDataParser().parse(new XML(e.currentTarget.data));
			this.gallery.model =
			this.thumbnailGallery.model = model;
			this.thumbnailGallery.galleryItemViewClass = Thumbnail;

			this.gallery.model.selectGroupByName("amenities");
			this.gallery.model.selectItemAt(0);

			/*BindingUtil.bindSetter(this.thumbnailGallery.model.selectGroupByName, this.gallery.model, "selectedGroupName");
			BindingUtil.bindSetter(this.gallery.model.selectGroupByName, this.thumbnailGallery.model, "selectedGroupName");
			BindingUtil.bindSetter(this.thumbnailGallery.model.selectItemAt, this.gallery.model, "selectedItemIndex");
			BindingUtil.bindSetter(this.gallery.model.selectItemAt, this.thumbnailGallery.model, "selectedItemIndex");*/
		}

	
	}
}