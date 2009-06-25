package inky.framework.components.gallery.views
{
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.binding.utils.BindingUtil;
	import inky.framework.components.gallery.*;
	import inky.framework.components.gallery.models.*;
	import inky.framework.components.gallery.loading.*;
	import inky.framework.components.gallery.events.*;
	import inky.framework.utils.EqualityUtil;
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
			BindingUtil.bindSetter(this._groupChangeHandler, this, ["model", "selectedGroupModel"]);
			BindingUtil.bindSetter(this._itemChangeHandler, this, ["model", "selectedItemModel"]);
			this._init();
		}


		private function _init():void
		{
			var nextItemButton:InteractiveObject = this.getChildByName("_nextItemButton") as InteractiveObject;
			if (nextItemButton)
				nextItemButton.addEventListener(MouseEvent.CLICK, this._next);
			var previousItemButton:InteractiveObject = this.getChildByName("_previousItemButton") as InteractiveObject;
			if (previousItemButton)
				previousItemButton.addEventListener(MouseEvent.CLICK, this._previous);
		}



		private function _next(e:MouseEvent):void
		{
			this.model.next();
		}
		
		private function _previous(e:MouseEvent):void
		{
			this.model.previous();
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
			var oldModel:GalleryModel = this._model;
			if (!EqualityUtil.objectsAreEqual(oldModel, model))
			{
				this._model = model;
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, 'model', oldModel, model));
			}
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
					this.model.next();
					break;
				}
				case Keyboard.LEFT:
				{
					this.model.previous();
					break;
				}
			}
		}




		//
		// private methods
		//


private function _groupChangeHandler(e:Object):void
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
		private function _itemChangeHandler(e:Object):void
		{
			this.selectedItemChanged();
		}



	}
}