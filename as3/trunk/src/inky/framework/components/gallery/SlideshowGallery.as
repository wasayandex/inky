﻿package com.exanimo.gallery{	import com.exanimo.gallery.*;	import com.exanimo.gallery.data.*;	import com.exanimo.gallery.loading.*;	import com.exanimo.gallery.events.*;	import flash.display.*;	import flash.events.MouseEvent;	import flash.events.Event;	import flash.filters.BlurFilter;	import flash.filters.BitmapFilterQuality;	import flash.geom.*;	import flash.net.URLRequest;	/**	 *	 *  ..	 *		 * 	@langversion ActionScript 3	 *	@playerversion Flash 9.0.0	 *	 *	@author Eric Eldredge	 *	@author Rich Perez	 *	@author Matthew Tretter	 *	@since  2009.01.12	 *	 */	public class SlideshowGallery extends Sprite implements IGallery	{		private var _loadManager:IGalleryLoadManager;		private var _model:GalleryModel;public function SlideshowGallery(){	this.addEventListener(MouseEvent.CLICK, this._clickHandler);}private function _clickHandler(e:MouseEvent):void{	this.model.selectItemAt((this.model.selectedItemIndex + 1) % this.model.selectedGroupData.items.length);}/** * @inheritDoc */public function get loadManager():IGalleryLoadManager{	if (!this._loadManager)	{		this._loadManager = new GalleryLoadManager();	}	return this._loadManager;}/** * @private */public function set loadManager(value:IGalleryLoadManager):void{	this._loadManager = loadManager;	}		/**		 * @inheritDoc		 */		public function get model():GalleryModel		{			return this._model;		}		/**		 * @private		 */		public function set model(model:GalleryModel):void		{			if (this._model)			{				this._model.removeEventListener(GalleryEvent.SELECTED_ITEM_CHANGE, this._itemChangeHandler);			}			if (model)			{				model.addEventListener(GalleryEvent.SELECTED_ITEM_CHANGE, this._itemChangeHandler, false, 0, true);			}			this._model = model;		}		//		// private methods		//						/**		 *		 */		private function _itemChangeHandler(e:GalleryEvent):void		{var data:GalleryItemData = this.model.selectedItemData;if (data){	var loader:DisplayObject = this.loadManager.getItemLoader(data);	this.addChild(loader);	this.loadManager.loadItem(data);}else{	// Clear it.}		}	}}