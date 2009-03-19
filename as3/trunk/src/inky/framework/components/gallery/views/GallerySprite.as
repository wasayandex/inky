package inky.framework.components.gallery.views
{
	import inky.framework.components.gallery.*;
	import inky.framework.components.gallery.models.*;
	import inky.framework.components.gallery.loading.*;
	import inky.framework.components.gallery.events.*;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.*;
	import flash.net.URLRequest;


	/**
	 *
	 *  A class to help simplify making galleries. Just extend this and override the protected methods.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2009.01.12
	 *
	 */
	public class GallerySprite extends Sprite implements IGallery
	{
		private var _loadManager:IGalleryLoadManager;
		private var _model:GalleryModel;








/**
 * @inheritDoc
 */
public function get loadManager():IGalleryLoadManager
{
	if (!this._loadManager)
	{
		this._loadManager = new GalleryLoadManager();
	}
	return this._loadManager;
}
/**
 * @private
 */
public function set loadManager(value:IGalleryLoadManager):void
{
	this._loadManager = loadManager;	
}




		/**
		 * @inheritDoc
		 */
		public function get model():GalleryModel
		{
			return this._model;
		}
		/**
		 * @private
		 */
		public function set model(model:GalleryModel):void
		{
			if (this._model)
			{
				this._model.removeEventListener(GalleryEvent.SELECTED_ITEM_CHANGE, this._itemChangeHandler);
				this._model.removeEventListener(GalleryEvent.SELECTED_GROUP_CHANGE, this._groupChangeHandler);
			}

			if (model)
			{
				model.addEventListener(GalleryEvent.SELECTED_ITEM_CHANGE, this._itemChangeHandler, false, 0, true);
				model.addEventListener(GalleryEvent.SELECTED_GROUP_CHANGE, this._groupChangeHandler, false, 0, true);
			}

			this._model = model;
		}




		//
		// private methods
		//


private function _groupChangeHandler(e:GalleryEvent):void
{
	this.selectedGroupChangeHandler();
}
		
protected function selectedGroupChangeHandler():void
{
}
protected function selectedItemChangeHandler():void
{
}
		
		/**
		 *
		 */
		private function _itemChangeHandler(e:GalleryEvent):void
		{
			this.selectedItemChangeHandler();
		}



	}
}