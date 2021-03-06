﻿package inky.framework.loading
{
	import inky.framework.loading.BaseLoadQueue;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import inky.framework.core.inky_internal;
	import inky.framework.loading.loaders.ImageLoader;
	import inky.framework.loading.loaders.IAssetLoader;


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
	public class LoadQueue extends BaseLoadQueue
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
