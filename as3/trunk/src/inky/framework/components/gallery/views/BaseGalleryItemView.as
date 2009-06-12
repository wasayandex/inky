package inky.framework.components.gallery.views 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.collections.ArrayList;
	import inky.framework.collections.IIterator;
	import inky.framework.collections.IListIterator;
	import inky.framework.components.gallery.models.GalleryImageModel;
	import inky.framework.components.gallery.models.GalleryItemModel;
	import inky.framework.components.gallery.views.IGalleryItemView;
	import inky.framework.components.progressBar.views.IProgressBar;
	import inky.framework.display.ITransitioningObject;
	import inky.framework.loading.events.AssetLoaderEvent;
	import inky.framework.loading.loaders.IAssetLoader;
	import inky.framework.loading.loaders.ImageLoader;
	import inky.framework.utils.EqualityUtil;

	
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
	public class BaseGalleryItemView extends MovieClip implements IGalleryItemView
	{
		private var __container:DisplayObjectContainer;
		private var _containerBounds:Rectangle;
		private var _features:ArrayList;
		private var _featureSize:String;
		private var _model:GalleryItemModel;
		private var _orientation:String;
		private var _previews:ArrayList;
		private var _previewSize:String;
		private var _progressBarDelay:uint;
		private var __progressBar:IProgressBar;
		private var _loader:IAssetLoader;
		private var _loadingSize:String;
	
		public function BaseGalleryItemView()
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
			return this._featureSize;
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
			if (this.progressBar)
				this.progressBar.source = null;

			var oldModel:GalleryItemModel = this._model;
			if (!EqualityUtil.objectsAreEqual(oldModel, value))
			{
				var feature:GalleryImageModel;
				var preview:GalleryImageModel;
				if (oldModel)
				{
					feature = GalleryImageModel(oldModel.images.findFirst({size: this.featureSize}));
					preview = GalleryImageModel(oldModel.images.findFirst({size: this.previewSize}));
					
					if (feature)
						this.cancelLoad(feature);
					
					if (preview)
						this.cancelLoad(preview);
				}
				
				this._model = value;
				if (value)
				{
					feature = GalleryImageModel(value.images.findFirst({size: this.featureSize}));
					preview = GalleryImageModel(value.images.findFirst({size: this.previewSize}));

					if (preview)
						this.startLoad(preview, "preview");
					else
						this.startLoad(feature, "feature");
				}

				this.modelUpdated();
				this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, 'model', oldModel, value));
			}
		}


		/**
		 *
		 */
		public function get previewSize():String
		{
			return this._previewSize;
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
		protected function addFeature(feature:DisplayObject):void
		{
			this._features.addItem(feature);
			this.container.addChild(feature);
		}
		

		/**
		 *	
		 */
		protected function addPreview(preview:DisplayObject):void
		{
			this._previews.addItem(preview);
			this.container.addChild(preview);
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
		protected function cancelLoad(model:GalleryImageModel):void
		{
			this._cancelLoad(model);
		}
		
		/**
		 *	
		 */
		protected function clearContainer():void
		{
			var i:IIterator;

			for (i = this._features.iterator(); i.hasNext();)
			{
				this.removeFeature(DisplayObject(i.next()));
			}

			for (i = this._previews.iterator(); i.hasNext();)
			{
				this.removePreview(DisplayObject(i.next()));
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
		protected function featureLoaded(feature:DisplayObject):void
		{
			this.addFeature(feature);
			this.removePreviousFeatures();
			this.removePreviousPreviews();
			this.removeProgressBar();
		}

	
		/**
		 *	
		 */
		protected function modelUpdated():void
		{
		}
		
		
		/**
		 *	
		 */
		protected function previewLoaded(preview:DisplayObject):void
		{
			this.addPreview(preview);
			this.removePreviousFeatures();
			this.removePreviousPreviews();
			this.removeProgressBar();
		}
		
		
		/**
		 *	
		 */
		protected function removeFeature(feature:DisplayObject):void
		{
			this._removeFromContainer(feature);
			this._features.removeItem(feature);
		}


		/**
		 *	
		 */
		protected function removePreview(preview:DisplayObject):void
		{
			this._removeFromContainer(preview);
			this._previews.removeItem(preview);
		}


		/**
		 *	
		 */
		protected function removePreviousFeatures():void
		{
			var i:IListIterator = this._features.listIterator(this._features.length);
			if (i.hasPrevious())
			{
				i.previous();
				while (i.hasPrevious())
				{
					this.removeFeature(DisplayObject(i.previous()));
				}
			}
		}		


		/**
		 *	
		 */
		protected function removePreviousPreviews():void
		{
			var i:IListIterator = this._previews.listIterator(this._previews.length);
			if (i.hasPrevious())
			{
				i.previous();
				while (i.hasPrevious())
				{
					this.removePreview(DisplayObject(i.previous()));
				}
			}
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
		
		
		/**
		 *	
		 */
		protected function startLoad(model:GalleryImageModel, loadingSize:String):void
		{
			var loader:IAssetLoader = model.loader;
			this._loadingSize = loadingSize;
			loader.source = model.source;
			loader.addEventListener(AssetLoaderEvent.READY, this._readyHandler);
			loader.load();

			if (this.progressBar)
			{
				this.progressBar.source = loader;
				var timeout:Timer = new Timer(this.progressBarDelay);
				timeout.addEventListener(TimerEvent.TIMER, this._addProgressBarNow);
				timeout.start();
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
		private function _cancelLoad(model:GalleryImageModel):void
		{
			var loader:IAssetLoader = model.loader;
			if (loader)
			{
				loader.removeEventListener(AssetLoaderEvent.READY, this._readyHandler);
// TODO: how to cancel the load?? This may be LoadQueue/AssetLoaderBehavior issue...
/*if (loader.bytesLoaded && !loader.loaded)
	loader.close();*/
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

			var xOffset:Number = (w - (object.getBounds(object).width * scale)) / 2;
			var yOffset:Number = (h - (object.getBounds(object).height * scale)) / 2;

			var bitmapData:BitmapData = new BitmapData(Math.round(w), Math.round(h), true, 0x00000000);
			bitmapData.draw(object, new Matrix(scale, 0, 0, scale, xOffset, yOffset), null, null, null, true);
			var bmp:Bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
			bmp.x = this._containerBounds.x;
			bmp.y = this._containerBounds.y;
			return bmp;
		}
		
		
		/**
		 *	
		 */
		private function _featureReadyHandler(e:AssetLoaderEvent):void
		{
			e.target.removeEventListener(e.type, arguments.callee);
			this.featureLoaded(this.createFeature(DisplayObject(e.target)));
		}
		
		
		/**
		 *	
		 */
		private function _init():void
		{
			this.previewSize = 'thumbnail';
			this.featureSize = 'regular';
			this._previews = new ArrayList();
			this._features = new ArrayList();
			
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
		private function _readyHandler(e:AssetLoaderEvent):void
		{
			if (this._loadingSize == "feature")
			{
				var feature:DisplayObject = this.createFeature(DisplayObject(e.target));
				this.featureLoaded(feature);
			}
			else if (this._loadingSize == "preview")
			{
				var preview:DisplayObject = this.createPreview(DisplayObject(e.target));
				this.previewLoaded(preview);

				var featureModel:GalleryImageModel = GalleryImageModel(this.model.images.findFirst({size: this.featureSize}));
				if (featureModel)
				{
					this.startLoad(featureModel, "feature");
				}
			}
			else
			{
				throw new Error(this._loadingSize)
			}
		}
		
		
		/**
		 *	
		 */
		private function _removeFromContainer(object:DisplayObject):void
		{
			if (this.container.contains(object))
			{
				this.container.removeChild(object);
			}
		}
	
	}
}