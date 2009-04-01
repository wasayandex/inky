package inky.framework.components.gallery.views 
{
	import inky.framework.components.gallery.models.GalleryImageModel;
	import inky.framework.components.gallery.models.GalleryItemModel;
	import inky.framework.components.gallery.views.IGalleryItemView;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import inky.framework.events.AssetLoaderEvent;
	import inky.framework.components.progressBar.views.IProgressBar;
	import inky.framework.display.ITransitioningObject;

	
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
		private var __progressBar:IProgressBar;
		private var _model:GalleryItemModel;
		private var _previewSize:String;
		private var _regularSize:String;

		
		/**
		 *
		 */
		public function GalleryItemView()
		{
			this.__container = DisplayObjectContainer(this.getChildByName('_container'));
			this.__progressBar = IProgressBar(this.getChildByName('_progressBar'));
		}
		


		
		//
		// accessors
		//
		
		
		/**
		 *	
		 */
		public function get container():DisplayObjectContainer
		{
			return this.__container || this;
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
// TODO: clear previous model and related.
			}
			
			this._model = value;
			var regular:GalleryImageModel = GalleryImageModel(value.images.findFirst({size: this.regularSize}));
			var preview:GalleryImageModel = GalleryImageModel(value.images.findFirst({size: this.previewSize}));
			
			if (preview)
			{
				preview.loader.addEventListener(AssetLoaderEvent.READY, this._previewReadyHandler);
				preview.loader.load();
			}
			
			else
			{
				regular.addEventListener(AssetLoaderEvent.READY, this._regularReadyHandler);
				regular.load();
			}

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
		public function get regularSize():String
		{
			return this._regularSize || 'regular';
		}
		/**
		 * @private
		 */
		public function set regularSize(value:String):void
		{
			this._regularSize = value;
		}
		



		//
		// protected methods
		//
		
		
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
		protected function addRegular(regular:DisplayObject):void
		{
			this.container.addChild(regular);
		}
		

		/**
		 *	
		 */
		protected function clearContainer():void
		{
			while (this.container.numChildren)
			{
				this.container.removeChildAt(0);
			}
		}
		
		
		/**
		 *	
		 */
		protected function previewReadyHandler(preview:Object):void
		{
			var bmp:Bitmap = this._drawBitmap(DisplayObject(preview));
			this.clearContainer();
			this.addPreview(bmp);
		}
		
		
		/**
		 *	
		 */
		protected function regularReadyHandler(regular:Object):void
		{
			var bmp:Bitmap = this._drawBitmap(DisplayObject(regular));
			this.clearContainer();
			this.removeProgressBar();
			this.addRegular(bmp);
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
		private function _drawBitmap(object:DisplayObject):Bitmap
		{
			var bounds:Rectangle = this.container.getBounds(this.container);
			var scale:Number = Math.max(bounds.width / object.width, bounds.height / object.height);
			var xOffset:Number = (bounds.width - (object.width * scale)) / 2;
			var yOffset:Number = (bounds.height - (object.height * scale)) / 2;

			//draw the asset according to fit the dimensions of the item container
			var bitmapData:BitmapData = new BitmapData(bounds.width, bounds.height);
			bitmapData.draw(object, new Matrix(scale, 0, 0, scale, xOffset, yOffset));
			
			return new Bitmap(bitmapData);
		}


		/**
		 *	
		 */
		private function _previewReadyHandler(e:AssetLoaderEvent):void
		{
			e.target.removeEventListener(e.type, arguments.callee);
			this.previewReadyHandler(e.target);
			
			var regular:GalleryImageModel = GalleryImageModel(this.model.images.findFirst({size: this.regularSize}));
			regular.loader.addEventListener(AssetLoaderEvent.READY, this._regularReadyHandler);
			regular.loader.load();
		}
		
		
		
		/**
		 *	
		 */
		private function _regularReadyHandler(e:AssetLoaderEvent):void
		{
			e.target.removeEventListener(e.type, arguments.callee);
			this.regularReadyHandler(e.target);
		}




	}
	
}
