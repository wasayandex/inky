package inky.framework.components.gallery.views 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import inky.framework.components.gallery.models.GalleryImageModel;
	import inky.framework.components.gallery.models.GalleryItemModel;
	import inky.framework.components.gallery.views.IGalleryItemView;
	import inky.framework.components.progressBar.views.IProgressBar;
	import inky.framework.display.ITransitioningObject;
	import inky.framework.events.AssetLoaderEvent;

	
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
	public class GalleryItemView extends Sprite implements IGalleryItemView
	{
		private var __container:DisplayObjectContainer;
		private var _containerBounds:Rectangle;
		private var _featureSize:String;
		private var _model:GalleryItemModel;
		private var _orientation:String;
		private var _previewSize:String;
		private var __progressBar:IProgressBar;

		
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
				for (var i:int = 0; i < this._model.images.length; i++)
				{
					var model:GalleryImageModel = GalleryImageModel(value.images.getItemAt(i));
					if (model.loader)
					{
						model.loader.removeEventListener(AssetLoaderEvent.READY, this._featureReadyHandler);
						model.loader.removeEventListener(AssetLoaderEvent.READY, this._previewReadyHandler);
					}
				}
				this.clearContainer();
			}

			this._model = value;
			
			if (this._model)
			{
				var feature:GalleryImageModel = GalleryImageModel(value.images.findFirst({size: this.featureSize}));
				var preview:GalleryImageModel = GalleryImageModel(value.images.findFirst({size: this.previewSize}));

				if (preview)
				{
					preview.loader.addEventListener(AssetLoaderEvent.READY, this._previewReadyHandler);
					preview.loader.load();
				}
				else
				{
					feature.loader.addEventListener(AssetLoaderEvent.READY, this._featureReadyHandler);
					feature.load();
				}
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
		



		//
		// protected methods
		//
		
		
		/**
		 *	
		 */
		protected function addFeature(feature:DisplayObject):void
		{
			this.container.addChild(feature);
		}
		

		/**
		 *	
		 */
		protected function addPreview(preview:DisplayObject):void
		{
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
		protected function clearContainer():void
		{
			while (this.container.numChildren > 1)
			{
				this.container.removeChildAt(this.numChildren - 1);
			}
		}
		
		
		/**
		 *	
		 */
		protected function initializeFeature(feature:Object):void
		{
			var bmp:Bitmap = this._drawBitmap(DisplayObject(feature));
			this.clearContainer();
			this.removeProgressBar();
			this.addFeature(bmp);
		}
		
		
		/**
		 *	
		 */
		protected function initializePreview(preview:Object):void
		{
			var bmp:Bitmap = this._drawBitmap(DisplayObject(preview));
			this.clearContainer();
			this.addPreview(bmp);
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
			this.initializeFeature(e.target);
		}
		
		
		/**
		 *	
		 */
		private function _init():void
		{
			this.__progressBar = IProgressBar(this.getChildByName('_progressBar'));
			this.__container = DisplayObjectContainer(this.getChildByName('_container'));
			
			if (!this.__container)
			{
				this.__container = new Sprite();

				var shape:Shape;
				for (var i:int = 0; i < this.numChildren; i++)
				{
					shape = Shape(this.getChildAt(i));
					if (shape)
						break;
				}
				if (shape)
				{
					this.__container.x = shape.x;
					this.__container.y = shape.y;
					this.addChildAt(this.__container, this.getChildIndex(shape));
					this.__container.addChild(shape);
					shape.x = 0;
					shape.y = 0;
				}
			}
			
			this._containerBounds = this.__container.getBounds(this.__container);
			if (!this._containerBounds.width || !this._containerBounds.height)
				throw new Error('GalleryItemView must have a shape to define the dimensions of the item container.')
		}
		

		/**
		 *	
		 */
		private function _previewReadyHandler(e:AssetLoaderEvent):void
		{
			e.target.removeEventListener(e.type, arguments.callee);
			this.initializePreview(e.target);
			
			var feature:GalleryImageModel = GalleryImageModel(this.model.images.findFirst({size: this.featureSize}));
			feature.loader.addEventListener(AssetLoaderEvent.READY, this._featureReadyHandler);
			feature.loader.load();
		}




	}
	
}
