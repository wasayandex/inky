package com.hzdg.citypalms.gallery.controls
{
	import com.exanimo.gallery.*;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.DisplayShortcuts;
	import com.hzdg.citypalms.gallery.controls.*;
	import com.hzdg.citypalms.gallery.controls.GalleryProgressBar;
	import fl.video.FLVPlayback;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.*;
	import flash.net.URLRequest;


	/**
	 *
	 *  ..
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
	public class SlideshowGallery extends Sprite
	{
		DisplayShortcuts.init();

		private var _imageContainer:Sprite;
		public var imageWidth:Number = 855;
		public var imageHeight:Number = 490;
		private var _loader:DisplayObject;
		private var _loaderInfo:Object;
		private var _nextButton:Sprite;
		private var _previousButton:Sprite;
		private var _progressBar:Sprite;
		private var _selectedItemIndex:int;
		private var _flvPlayback:FLVPlayback;


		/**
		 *
		 *	
		 */
		public function SlideshowGallery()
		{
			this._init();
		}




		//
		// accessors
		//


		/**
		 * @private
		 */
		override public function set controller(controller:IGalleryController):void
		{
			if (this.controller)
			{
				this.controller.removeEventListener(GalleryEvent.SELECTED_ITEM_CHANGE, this._selectedItemChangeHandler);
			}
			if (controller)
			{
				controller.addEventListener(GalleryEvent.SELECTED_ITEM_CHANGE, this._selectedItemChangeHandler, false, 0, true);
			}
			super.controller = controller;
		}




		//
		// private methods
		//



		/**
		 *
		 *	
		 */
		private function _imageCompleteHandler(e:Event):void
		{
			var loader:DisplayObject = this._loader;
			var bmpData:BitmapData = new BitmapData(loader.width, loader.height);
			bmpData.draw(loader);
			this._imageContainer.addChildAt(new Bitmap(bmpData), 0);

			while (this._imageContainer.numChildren > 2)
			{
				var child:DisplayObject = this._imageContainer.getChildAt(2);
				Tweener.removeTweens(child);
				this._imageContainer.removeChildAt(2);
			}

			Tweener.addTween(this._imageContainer.getChildAt(1), {alpha: 0, time: 0.5, transition: 'easeInQuad', onComplete: this._tweenCompleteHandler});
			this._hideProgressBar();
		}


		/**
		 *
		 *	
		 */
		private function _init():void
		{
			this._selectedItemIndex = -1;
			
			// View stuff.
			this._flvPlayback = this.getChildByName('flvPlayback') as FLVPlayback;
			this._imageContainer = this.getChildByName('imageContainer') as Sprite;
			this._nextButton = this.getChildByName('nextButton') as Sprite;
			this._nextButton.addEventListener(MouseEvent.CLICK, this._next);
			this._previousButton = this.getChildByName('previousButton') as Sprite;
			this._previousButton.addEventListener(MouseEvent.CLICK, this._previous);
			
			this._progressBar = new GalleryProgressBar();
			this._progressBar.visible = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler, false, 0, true);
		}


		private function _next(e:MouseEvent):void
		{
			var index:int = (this.selectedItemIndex + 1) % this.numItems;
			this.selectItemAt(index);
		}


		private function _previous(e:MouseEvent):void
		{
			var index:int = (this.selectedItemIndex - 1 + this.numItems) % this.numItems;
			this.selectItemAt(index);
		}


		/**
		 *
		 *	
		 */
		private function _selectedItemChangeHandler(e:GalleryEvent):void
		{
			var index:int = e.currentTarget.selectedItemIndex;
			if (index == -1)
			{
			}
			else if (this._selectedItemIndex != index)
			{
				var info:Object = this.controller.dataProvider.getItemAt(index);
				
				if (info.type == 'video')
				{
					this._nextButton.visible =
					this._previousButton.visible = false;
					Tweener.addTween(this._imageContainer, {_autoAlpha: 0, time: 1});
					Tweener.addTween(this._flvPlayback, {_autoAlpha: 1, time: 1});
					
					this._flvPlayback.play(info.source);
				}
				else
				{
					this._nextButton.visible =
					this._previousButton.visible = true;
					
					this._flvPlayback.stop();
					
					Tweener.addTween(this._imageContainer, {_autoAlpha: 1, time: 1});
					Tweener.addTween(this._flvPlayback, {_autoAlpha: 0, time: 1});

					// Add the white flash.
					var s:Sprite = new Sprite();
					var g:Graphics = s.graphics;
					g.beginFill(0xffffff);
					g.drawRect(0, 0, this.imageWidth, this.imageHeight);
					g.endFill();
					this._imageContainer.addChildAt(s, 0);

					this._showProgressBar();

					/*// Add the resized thumb.
					var thumbnailSource:String = info.thumbnailSource;
					var tmpImage:DisplayObject = this.controller.getItemLoader(thumbnailSource);

					if (tmpImage)
					{
						var bitmapData:BitmapData = new BitmapData(this.imageWidth, this.imageHeight);
						bitmapData.draw(tmpImage, new Matrix(this.imageWidth / tmpImage.width, 0, 0, this.imageHeight / tmpImage.height));
//						bitmapData.applyFilter(bitmapData, new Rectangle(0, 0, bitmapData.width, bitmapData.height), new Point(0, 0), new BlurFilter(32, 32, BitmapFilterQuality.LOW));
						var bmp:Bitmap = new Bitmap(bitmapData);
						this._imageContainer.addChildAt(bmp, 0);
					}*/

					if (this._loaderInfo)
					{
						this._loaderInfo.removeEventListener(Event.COMPLETE, this._imageCompleteHandler);
					}
					var itemSource:String = info.source;
					var loaderInfo:Object = this.controller.getItemLoaderInfo(info.source);
					loaderInfo.addEventListener(Event.COMPLETE, this._imageCompleteHandler);
					this.controller.loadItem(info.source);
					this._loaderInfo = loaderInfo;
					this._loader = this.controller.getItemLoader(info.source);
				}
			}
			this._selectedItemIndex = index;
		}


		/**
		 *
		 *	
		 */
		private function _tweenCompleteHandler():void
		{
			while (this._imageContainer.numChildren > 1)
			{
				this._imageContainer.removeChildAt(1);
			}
		}



		private function _addedToStageHandler(e:Event):void
		{
			this.stage.addChild(this._progressBar);
			e.currentTarget.removeEventListener(e.type, arguments.callee);
		}

		private function _showProgressBar():void
		{
			Tweener.addTween(this._progressBar, {_autoAlpha: 1, time: 0.5, delay: 0.5})
		}


		private function _hideProgressBar():void
		{
			Tweener.addTween(this._progressBar, {_autoAlpha: 0, time: 0.5})
		}




	}
}