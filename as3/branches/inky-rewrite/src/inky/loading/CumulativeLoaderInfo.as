package inky.loading 
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.utils.Dictionary;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import inky.loading.events.CumulativeLoaderInfoProgressEvent;
	import flash.events.Event;
	import flash.display.LoaderInfo;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.06
	 *
	 */
	public class CumulativeLoaderInfo extends EventDispatcher
	{
		private var _bytesLoaded:uint;
		private var bytesLoadedIsInvalid:Boolean = true;
		private var useWeakReferenceValues:Dictionary = new Dictionary(true);
		private var completeLoaders:Dictionary = new Dictionary(true);
		
		private var loaders:Object = {
			weak: new Dictionary(true),
			strong: new Dictionary(false)
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function addLoader(loader:Object, useWeakReference:Boolean = true):void
		{
			var loaderDict:Dictionary = this.loaders[useWeakReference ? "weak" : "strong"];
			this.useWeakReferenceValues[loader] = useWeakReference;
			loaderDict[loader] = null;

			var dispatcher:IEventDispatcher;
			if (loader is Loader)
				dispatcher = loader.contentLoaderInfo;
			else if (loader is URLLoader)
				dispatcher = IEventDispatcher(loader);
			else
				throw new Error("Type not supported");
			
			dispatcher.addEventListener(ProgressEvent.PROGRESS, this.progressHandler, false, 0, useWeakReference);
			dispatcher.addEventListener(Event.COMPLETE, this.dispatcher_completeHandler, false, 0, true);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 *
		 */
		public function get bytesLoaded():uint
		{ 
			if (this.bytesLoadedIsInvalid)
			{
				this.bytesLoadedIsInvalid = false;
				this._bytesLoaded = 0;
				
				for each (var dict:Dictionary in this.loaders)
				{
					for (var loader:Object in dict)
					{
						if (loader is URLLoader)
							this._bytesLoaded += loader.bytesLoaded;
						else if (loader is Loader)
							this._bytesLoaded += loader.contentLoaderInfo.bytesLoaded;
					}
				}
			}
			return this._bytesLoaded; 
		}
		
		/**
		 *
		 */
		public function get bytesTotal():uint
		{ 
			return 0;
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function dispatcher_completeHandler(event:Event):void
		{
			// Mark this loader as complete.
			var loader:Object;
			if (event.currentTarget is LoaderInfo)
				loader = LoaderInfo(event.currentTarget).loader;
			else
				loader = event.currentTarget;
			this.completeLoaders[loader] = true;
			
			// Check if all loaders are complete.
			for each (var dict:Dictionary in this.loaders)
			{
				for (loader in dict)
				{
					if (!this.completeLoaders[loader])
						return;
				}
			}
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * 
		 */
		private function progressHandler(event:ProgressEvent):void
		{
			this.bytesLoadedIsInvalid = true;
			this.dispatchEvent(new CumulativeLoaderInfoProgressEvent(this));
		}
		
	}
	
}