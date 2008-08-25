package inky.framework.net
{
	import com.exanimo.net.LoadQueue;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import inky.framework.core.inky_internal;
	import inky.framework.net.ImageLoader;


	/**
	 *
	 * Loads assets in order.
	 *
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter (matthew@exanimo.com)
	 * @author Eric Eldredge
	 * @since  2008.06.02
	 *
	 */
	public class LoadQueue extends com.exanimo.net.LoadQueue
	{


		//
		// protected methods
		//


		/**
		 * @private		
		 * 
		 * Loads an item.
		 *
		 */
		override protected function loadItemNow(item:Object, ...loadArgs:Array):void
		{
			if (item is IAssetLoader)
			{
				item.loadAsset();
			}
			else
			{
				loadArgs.unshift(item);
				super.loadItemNow.apply(null, loadArgs);
			}
		}		 		 		 		




	}
}
