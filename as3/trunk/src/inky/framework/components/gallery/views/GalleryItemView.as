package inky.framework.components.gallery.views 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import inky.framework.components.gallery.models.GalleryImageModel;
	import inky.framework.components.gallery.models.GalleryItemModel;
	import inky.framework.components.gallery.views.IGalleryItemView;
	import inky.framework.components.progressBar.views.IProgressBar;
	import inky.framework.display.ITransitioningObject;
	import inky.framework.events.AssetLoaderEvent;
	import inky.framework.loading.loaders.IAssetLoader;
	import inky.framework.loading.loaders.ImageLoader;

	
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
	 *	@since  2009.03.30
	 *
	 */
	public class GalleryItemView extends MovieClip implements IGalleryItemView
	{
		private var __container:DisplayObjectContainer;
		private var _containerBounds:Rectangle;
		private var _feature:DisplayObject;
		private var _featureSize:String;
		private var _model:GalleryItemModel;
		private var _orientation:String;
		private var _preview:DisplayObject;
		private var _previewSize:String;
		private var _progressBarDelay:uint;
		private var __progressBar:IProgressBar;
		private var _loader:IAssetLoader;
		
		/**
		 *
		 */
		public function GalleryItemView()
		{
			this._init();
		}
		


		
		//
		// accessors
		//
		
		
		/**
		 *	
		 */
		public function get container():DisplayObjectContainer
		{
			return this.__container;
		}
		/**
		 *	@private
		 */
		public function set container(value:DisplayObjectContainer):void
		{ 
			this.__container = value; 
		}


		/**
		 *
		 */
		public function get featureSize():String
		{
			return this._featureSize || 'regular';
		}
		/**
		 * @private
		 */
		public function set featureSize(value:String):void
		{
			this._featureSize = value;
		}


		/**
		 *
		 */
		public function get model():GalleryItemModel
		{
			return this._model;
		}
		/**
		 * @private
		 */
		public function set model(value:GalleryItemModel):void
		{
			if (this._model)
			{
				this.clearContainer();
				
				var loader:IAssetLoader = this.getLoader();
				loader.removeEventListener(AssetLoaderEvent.READY, this._featureReadyHandler);
				loader.removeEventListener(AssetLoaderEvent.READY, this._previewReadyHandler);

				if (this.progressBar)
					this.progressBar.source = null;

			}

			this._model = value;
			
			if (this._model)
			{
				var feature:GalleryImageModel = GalleryImageModel(value.images.findFirst({size: this.featureSize}));
				var preview:GalleryImageModel = GalleryImageModel(value.images.findFirst({size: this.previewSize}));
				
				if (preview)
					this._startPreviewLoad(preview);
				else
					this._startFeatureLoad(feature);
			}
		}


		/**
		 *
		 */
		public function get previewSize():String
		{
			return this._previewSize || 'thumbnail';
		}
		/**
		 * @private
		 */
		public function set previewSize(value:String):void
		{
			this._previewSize = value;
		}
		
		
		/**
		 *
		 */
		public function get progressBar():IProgressBar
		{
			return this.__progressBar;
		}
		/**
		 * @private
		 */
		public function set progressBar(value:IProgressBar):void
		{
			this.__progressBar = value;
		}
		
		
		/**
		 *
		 */
		public function get progressBarDelay():uint
		{
			return this._progressBarDelay || 500;
		}
		/**
		 * @private
		 */
		public function set progressBarDelay(value:uint):void
		{
			this._progressBarDelay = value;
		}




		//
		// protected methods
		//
		
		
		/**
		 *	
		 */
		protected function addFeature():void
		{
			this.container.addChild(this._feature);
		}
		

		/**
		 *	
		 */
		protected function addPreview():void
		{
			this.container.addChild(this._preview);
		}
		

		/**
		 *	
		 */
		protected function addProgressBar():void
		{
			if (this.progressBar)
			{
				this.addChild(DisplayObject(this.progressBar));
			}
		}

		
		/**
		 *	
		 */
		protected function clearContainer():void
		{
			while (this.container.numChildren > 1)
			{
				this.container.removeChildAt(this.container.numChildren - 1);
			}
		}
		
		
		/**
		 *	
		 */
		protected function createFeature(featureLoader:DisplayObject):DisplayObject
		{
			return this._drawBitmap(featureLoader);
		}
		
		
		/**
		 *	
		 */
		protected function createPreview(previewLoader:DisplayObject):DisplayObject
		{
			return this._drawBitmap(previewLoader);
		}

		
		/**
		 *	
		 */
		protected function featureLoaded():void
		{
			this.clearContainer();
			this.removeProgressBar();
			this.addFeature();
		}
		
		
		/**
		 *	
		 */
		protected function previewLoaded():void
		{
			this.clearContainer();
			this.addPreview();
		}
		
		
		/**
		 *	
		 */
		protected function getLoader():IAssetLoader
		{
			if (!this._loader)
				this._loader = new ImageLoader();

			return this._loader;
		}
		

		/**
		 *	
		 */
		protected function removeProgressBar():void
		{
			if (this.progressBar && this.progressBar.parent)
			{
				if (this.progressBar is ITransitioningObject)
				{
					ITransitioningObject(this.progressBar).remove();
				}
				else
				{
					this.progressBar.parent.removeChild(DisplayObject(this.progressBar));
				}
				
			}
		}
		
		
		

		//
		// private methods
		//
		
		
		/**
		 *	
		 */
		private function _addProgressBarNow(e:TimerEvent):void
		{
			e.target.removeEventListener(e.type, arguments.callee);
			var source:Object = this.progressBar.source;
			if (source && source is IAssetLoader)
			{
				if (source.bytesTotal > 0 && source.bytesTotal == source.bytesLoaded)
					return;
				else
					this.addProgressBar();
			}
		}

		
		/**
		 *	
		 */
		private function _drawBitmap(object:DisplayObject):Bitmap
		{
			var w:Number = this._containerBounds.width;
			var h:Number = this._containerBounds.height;
			var scale:Number;

			if (!this._orientation)
			{
				var scaleX:Number = w / object.width;
				var scaleY:Number = h / object.height;
				scale = Math.max(scaleX, scaleY);
				this._orientation = scale == scaleX ? 'x' : 'y';
			}
			else
			{
				scale = this._orientation == 'x' ? w / object.width : h / object.height;
			}

			var xOffset:Number = (w - (object.width * scale)) / 2;
			var yOffset:Number = (h - (object.height * scale)) / 2;
			
			var bitmapData:BitmapData = new BitmapData(Math.round(w), Math.round(h));
			bitmapData.draw(object, new Matrix(scale, 0, 0, scale, xOffset, yOffset));
			return new Bitmap(bitmapData);
		}
		
		
		/**
		 *	
		 */
		private function _featureReadyHandler(e:AssetLoaderEvent):void
		{
			e.target.removeEventListener(e.type, arguments.callee);
			this._feature = this.createFeature(DisplayObject(e.target));
			this.featureLoaded();
		}
		
		
		/**
		 *	
		 */
		private function _init():void
		{
			this.progressBar = IProgressBar(this.getChildByName('_progressBar'));
			if (this.progressBar)
				this.removeChild(DisplayObject(this.progressBar));

			this.container = DisplayObjectContainer(this.getChildByName('_container'));
			if (!this.container)
			{
				if (this.totalFrames > 1)
				{
					throw new Error("GalleryItemViews with more than one frame must contain a child named _container");
				}

				this.container = new Sprite();

				var shape:Shape;
				for (var i:int = 0; i < this.numChildren; i++)
				{
					shape = Shape(this.getChildAt(i));
					if (shape)
						break;
				}
				if (shape)
				{
					this.container.x = shape.x;
					this.container.y = shape.y;
					this.addChildAt(this.container, this.getChildIndex(shape));
					this.container.addChild(shape);
					shape.x = 0;
					shape.y = 0;
				}
			}
			
			this._containerBounds = this.container.getBounds(this.container);
			if (!this._containerBounds.width || !this._containerBounds.height)
				throw new Error('GalleryItemView must have a shape to define the dimensions of the item container.')
		}
		

		/**
		 *	
		 */
		private function _previewReadyHandler(e:AssetLoaderEvent):void
		{
			e.target.removeEventListener(e.type, arguments.callee);
			this._preview = this.createPreview(DisplayObject(e.target));
			this.previewLoaded();
			this._startFeatureLoad(GalleryImageModel(this.model.images.findFirst({size: this.featureSize})));
		}
		

		/**
		 *	
		 */
		private function _startPreviewLoad(preview:GalleryImageModel):void
		{
			var loader:IAssetLoader = this.getLoader();
			loader.source = preview.source;
			loader.addEventListener(AssetLoaderEvent.READY, this._previewReadyHandler);
			this._startLoad();
		}


		/**
		 *	
		 */
		private function _startFeatureLoad(feature:GalleryImageModel):void
		{
			var loader:IAssetLoader = this.getLoader();
			loader.source = feature.source;
			loader.addEventListener(AssetLoaderEvent.READY, this._featureReadyHandler);
			this._startLoad();
		}


		/**
		 *	
		 */
		private function _startLoad():void
		{
			var loader:IAssetLoader = this.getLoader();
			loader.load();

			if (this.progressBar)
			{
				this.progressBar.source = loader;
				var timeout:Timer = new Timer(this.progressBarDelay);
				timeout.addEventListener(TimerEvent.TIMER, this._addProgressBarNow);
				timeout.start();
			}
		}



	}
	
}
