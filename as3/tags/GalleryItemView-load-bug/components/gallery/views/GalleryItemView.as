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
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.components.gallery.models.GalleryImageModel;
	import inky.framework.components.gallery.models.GalleryItemModel;
	import inky.framework.components.gallery.views.IGalleryItemView;
	import inky.framework.components.progressBar.views.IProgressBar;
	import inky.framework.display.ITransitioningObject;
	import inky.framework.events.AssetLoaderEvent;
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
		private var _loadingSize:String;
public static var whatever:Object;
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
			var loader:IAssetLoader = this.getLoader();
			loader.addEventListener(AssetLoaderEvent.READY, this._readyHandler);
//			loader.removeEventListener(AssetLoaderEvent.READY, this._readyHandler);
try{
	loader['unload']();
	loader['getTheLoader']().close();
}
catch (e:Error){}

			if (this.progressBar)
				this.progressBar.source = null;

			var oldModel:GalleryItemModel = this._model;
			if (!EqualityUtil.objectsAreEqual(oldModel, value))
			{
				if (value)
				{
					var feature:GalleryImageModel = GalleryImageModel(value.images.findFirst({size: this.featureSize}));
					var preview:GalleryImageModel = GalleryImageModel(value.images.findFirst({size: this.previewSize}));

					if (preview)
						this._startLoad(preview, "preview");
					else
						this._startLoad(feature, "feature");
				}

				this._model = value;
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
			this.removePreview();
			this.removeProgressBar();
			this.addFeature();
		}
		 
		
		/**
		 *	
		 */
		protected function getFeature():DisplayObject
		{ 
			return this._feature; 
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
		protected function getPreview():DisplayObject
		{ 
			return this._preview; 
		}
		

		/**
		 *	
		 */
		protected function modelUpdated():void
		{
			this.clearContainer();
		}
		
		
		/**
		 *	
		 */
		protected function previewLoaded():void
		{
			this.addPreview();
		}
		
		
		/**
		 *	
		 */
		protected function removePreview():void
		{
			if (this._preview && this.container.contains(this._preview))
				this.container.removeChild(this._preview);
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
import flash.utils.*;

		/**
		 *	
		 */
		private function _drawBitmap(object:DisplayObject):Sprite
		{
var s = new Sprite();
setTimeout(_j, 10, s, object);
return s;
}

	private function _j(s:Sprite, object:DisplayObject):void
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
			var b = new Bitmap(bitmapData);
			s.addChild(b);
new GridLayout(5).layoutContainer(this.whatever);
this.whatever.scaleX = this.whatever.scaleY = 0.2
		}

public var whatever:Sprite;
		/**
		 *	
		 */
		private function _init():void
		{
			this.previewSize = 'thumbnail';
			this.featureSize = 'regular';
this.whatever = new Sprite();
GalleryItemView.whatever = this.whatever;
if (this.stage)
	this.stage.addChild(this.whatever);
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
import flash.text.*;
		
		/**
		 *	
		 */
		private function _readyHandler(e:AssetLoaderEvent):void
		{
trace("READY:\t" + e.currentTarget.source + "\tpos:\t" + this.whatever.numChildren)
/*try {
	if (!this.getLoader()['getTheLoader']().contentLoaderInfo.url.match(this.getLoader()['source']))
	{
		trace('\n\t' + this.getLoader()['bytesLoaded'] + ' out of ' + this.getLoader()['bytesTotal']);

		if (this.featureSize == 'regular')
		trace('loading: ' + this._loadingSize, '\t' + this.getLoader()['source'] + ' vs ' + this.getLoader()['getTheLoader']().contentLoaderInfo.url.split('/').splice(-4).join('/'))

		return;
	} 
} 
catch(e:Error){};*/

			if (this._loadingSize == "feature")
			{
				this._feature = this.createFeature(DisplayObject(e.target));
if (this.featureSize == 'regular')
{
	var f:DisplayObject = this.createFeature(DisplayObject(e.target));
	/*f.width =
	f.height = 250;*/
	this.whatever.addChild(f);
}
				this.featureLoaded();
			}
			else if (this._loadingSize == "preview")
			{
				this._preview = this.createPreview(DisplayObject(e.target));
if (this.featureSize == 'regular')
{
	var preview:DisplayObject = this.createPreview(DisplayObject(e.target));
	/*preview.width =
	preview.height = 200;*/
	this.whatever.addChild(preview);
}
				this.previewLoaded();

				var feature:GalleryImageModel = GalleryImageModel(this.model.images.findFirst({size: this.featureSize}));
				if (feature)
				{
					this._startLoad(feature, "feature");
				}
			}
			else
			{
				throw new Error(this._loadingSize)
			}
if (this.featureSize == "regular")
{
	new GridLayout(5).layoutContainer(Sprite(this.whatever));
}
		}
private var _t;
import com.exanimo.layout.GridLayout;
import flash.display.Sprite;

		/**
		 *	
		 */
		private function _startLoad(model:GalleryImageModel, loadingSize:String):void
		{
			var loader:IAssetLoader = this.getLoader();
			this._loadingSize = loadingSize;

			/*if (loader.bytesLoaded)
				loader['unload']();*/
/*try 
{
	loader['getTheLoader']().unload();
	trace('\t\t\tclose was successful!!')
}
catch (e:Error) {}*/
				
			loader.source = model.source;
//			loader.addEventListener(AssetLoaderEvent.READY, this._readyHandler);
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
