package inky.framework.loading.loaders
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import inky.framework.loading.loaders.GraphicLoader;


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
			var bmpData:BitmapData = new BitmapData(loader.width, loader.height, true, 0x00000000);
			bmpData.draw(loader);
			super.setContent(new Bitmap(bmpData, PixelSnapping.AUTO, true));
		}




	}
}
