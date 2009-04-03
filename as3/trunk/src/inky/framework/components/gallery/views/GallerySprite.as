﻿package inky.framework.components.gallery.views
{
	import inky.framework.components.gallery.*;
	import inky.framework.components.gallery.models.*;
	import inky.framework.components.gallery.loading.*;
	import inky.framework.components.gallery.events.*;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.*;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;


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
		private var _keyboardNavigationEnabled:Boolean;


		public function GallerySprite()
		{
			this._init();
		}


		private function _init():void
		{
			var nextItemButton:Sprite = this.getChildByName("_nextItemButton") as Sprite;
			if (nextItemButton)
				nextItemButton.addEventListener(MouseEvent.CLICK, this._next);
			var previousItemButton:Sprite = this.getChildByName("_previousItemButton") as Sprite;
			if (previousItemButton)
				previousItemButton.addEventListener(MouseEvent.CLICK, this._previous);
		}



		private function _next(e:MouseEvent):void
		{
			this.next();
		}
		
		private function _previous(e:MouseEvent):void
		{
			this.previous();
		}



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





		/**
		 *
		 */
		public function get keyboardNavigationEnabled():Boolean
		{
			return this._keyboardNavigationEnabled;
		}
		/**
		 * @private
		 */
		public function set keyboardNavigationEnabled(value:Boolean):void
		{
			this._keyboardNavigationEnabled = value;
			if (this.stage)
				this._setKeyboardNavigationEnabled();
			else
				this.addEventListener(Event.ADDED_TO_STAGE, this._setKeyboardNavigationEnabled);
		}
		
		
		
		private function _setKeyboardNavigationEnabled(e:Event = null):void
		{
			if (this._keyboardNavigationEnabled)
			{
				this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this._keyDownHandler);
			}
			else
			{
				this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this._keyDownHandler);
			}
		}



		private function _keyDownHandler(e:KeyboardEvent):void
		{
			switch (e.keyCode)
			{
				case Keyboard.RIGHT:
				{
					this.next();
					break;
				}
				case Keyboard.LEFT:
				{
					this.previous();
					break;
				}
			}
		}


		public function next():void
		{
			this.model.selectItemAt((this.model.selectedItemIndex + 1) % this.model.selectedGroupModel.items.length);
		}


		public function previous():void
		{
			this.model.selectItemAt((this.model.selectedItemIndex - 1 + this.model.selectedGroupModel.items.length) % this.model.selectedGroupModel.items.length);
		}



		//
		// private methods
		//


private function _groupChangeHandler(e:GalleryEvent):void
{
	this.selectedGroupChanged();
}
		
protected function selectedGroupChanged():void
{
}
protected function selectedItemChanged():void
{
}
		
		/**
		 *
		 */
		private function _itemChangeHandler(e:GalleryEvent):void
		{
			this.selectedItemChanged();
		}



	}
}