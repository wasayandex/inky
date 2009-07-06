package inky.loading.loaders
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import inky.loading.loaders.GraphicLoader;


	/**
	 *
	 *  Loads an external image.
	 * 
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Matthew Tretter
	 *  @since  2008.05.29
	 *
	 */
	public class ImageLoader extends GraphicLoader
	{


		/**
		 *
		 * 
		 */
		override protected function setContent(content:Object):void
		{
			var loader:Loader = this.getLoader() as Loader;
			var bmp:Bitmap = loader.content as Bitmap;
			bmp.smoothing = true;
			super.setContent(bmp);
		}
	}
}
