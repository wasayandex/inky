package inky.core
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.exanimo.controls.IProgressBar;
	import com.exanimo.controls.ProgressBarMode;
	import com.exanimo.net.LoadQueue;
	import com.exanimo.utils.URLUtil;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.*;
	import flash.utils.Dictionary;
	import inky.core.inky;
	import inky.core.Section;
	import inky.data.SectionInfo;
	import inky.events.SectionEvent;
	import inky.utils.SPath;


	/**
	 *
	 *  The Section that contains all other sections. Application instances
	 * correspond to the root node of an inky XML.
	 * 
	 * 	@langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2007.11.28
	 *
	 */
	public class Application extends Section
	{
		private var _currentURL:String;
		private var _data:XML;
		private var _dataSourceIsSet:Boolean;
		private var _loadQueue:LoadQueue;
		private var _loaders2xml:Dictionary;
		private var _numIncludes:uint;


		/**
		 * 
		 * Creates a new Application instance. The Section constructor should
		 * never be called directly, however. Instead, it should be used as the
		 * document class of your project's FLA.
		 * 
		 */
		public function Application()
		{
			this._loadQueue = new LoadQueue();
			this._loaders2xml = new Dictionary();
			this._numIncludes = 0;

			var dataSource:String = this.root.loaderInfo.parameters.dataSource;
			if (dataSource)
			{
				this.dataSource = dataSource;
			}
			else
			{
				// If the dataSource property isn't set on the SWF, try to use
				// the default value.
				this._loadData(new URLRequest(new Loader().contentLoaderInfo.loaderURL.split('.').slice(0, -1).join('.') + '.inky.xml'));
			}
		}




		//
		// accessors
		//


		/**
		 *
		 * The data that defines the structure of the application. The
		 * <code>dataSource</code> property may be set to one of several
		 * values: 1) a native (e4x) XML object containing the inky xml data,
		 * 2) a url that points to an inky xml file, or 3) a URLRequest that
		 * points to an inky xml file. In addition, to setting this value
		 * directly (<code>myApplication.dataSource = someValue</code>), you
		 * can also set a "dataSource" URL on the embedded SWF object in your
		 * html. If no value is supplied, the application will automatically
		 * attempt to load an XML file named filename.inky.xml (where
		 * "filename" is the name of the application's SWF) located in the same
		 * directory as the application's SWF.
		 * 
		 */
		public function set dataSource(dataSource:Object):void
		{
// TODO: Add a dataSource getter?
			if (dataSource is XML)
			{
				this._parseData(dataSource as XML);
			}
			else if ((dataSource is String) || (dataSource is URLRequest))
			{
				var request:URLRequest = (dataSource as URLRequest) || new URLRequest(dataSource as String);
				this._loadData(request);
			}
			else
			{
				throw new Error('Application.dataSource may only be set to XML, a URL String, or a URLRequest.');
			}
		}		


		/**
		 * @inheritDoc
		 */
		override public function get cumulativeProgressBar():IProgressBar
		{
			return super.cumulativeProgressBar;
		}
		/**
		 * @private
		 */
		override public function set itemProgressBar(progressBar:IProgressBar):void
		{
			if (progressBar)
			{
				super.itemProgressBar = progressBar;
				if (this._loadQueue && this._loadQueue.numItems) this.itemProgressBar.source = this._loadQueue.getItemAt(0);
			}
		}


		/**
		 * @inheritDoc
		 */
		override public function get itemProgressBar():IProgressBar
		{
			return super.itemProgressBar;
		}
		/**
		 * @private
		 */
		override public function set cumulativeProgressBar(progressBar:IProgressBar):void
		{
			if (progressBar)
			{
				super.cumulativeProgressBar = progressBar;
				if (this._loadQueue && this._loadQueue.numItems) this.cumulativeProgressBar.source = this._loadQueue;
			}
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		override public function gotoSection(target:Object, options:Object = null):void
		{
// TODO: Move this into Section so that testing without an application doesn't cause you to lose routing defaults.
			var sPath:SPath = target is String ? SPath.parse(target as String) : target as SPath;

			if (sPath)
			{
				// Make the SPath absolute.
				sPath = sPath.absolute ? sPath : sPath.resolve(this.sPath);
				sPath = sPath.normalize();

				// Resolve the SPath.
				sPath = this.getInfo().resolveSPath(sPath);
				var info:SectionInfo = this.getInfo().getSectionInfoBySPath(sPath);

				if (!info)
				{
					throw new ArgumentError('Section ' + sPath + ' does not exist');
				}

				if (info.href)
				{
					this.gotoLink(info.href);
					return;
				}

				// If inadequate routing information is provided, just goto the section normally.
				var useSPath:Boolean = false;
				try
				{
					var url:String = info.routeMapper.getURL(info.sPath, options);

					if ((url != null) && (url != this._currentURL))
					{
						// SWFAddress will throw security errors sometimes. If it does,
						// call the handler directly. (This way we still use url.)
						try
						{
							SWFAddress.setValue(url.replace(/^#(.*)$/, '$1'));
						}
						catch(error:Error)
						{
							this._addressChangeHandler(url);
						}
					}
					else
					{
						useSPath = true;
					}
				}
				catch (error:Error)
				{
					trace('Warning: ' + error.message);
					useSPath = true;
				}
				
				if (useSPath)
				{
					super.gotoSection(sPath, options);
				}
			}
		}




		//
		// private methods
		//


		/**
		 *
		 * 
		 * 
		 *
		 */
		private function _addressChangeHandler(o:Object):void
		{
			var url:String = o is SWFAddressEvent ? o.value == '/' ? '#/' : '#' + o.value : o as String;
			this._currentURL = url;

			var sPath:SPath = this.getInfo().routeMapper.getSPath(url);
			var options:Object = this.getInfo().routeMapper.getOptions(url, sPath);

			if (!sPath)
			{
				throw new Error('Application couldn\'t resolve the following url hash: ' + url);
			}

			super.gotoSection(sPath, options);
		}


		/**
		 *
		 * 	
		 * 
		 */
		private function _dataCompleteHandler(e:Event):void
		{
			this._parseData(new XML(e.currentTarget.data));			
		}


		/**
		 *
		 * Called when the data is successfully opened.
		 *
		 */		 		 		 		
		private function _dataOpenHandler(e:Event):void
		{
			// Load the data provider.
			e.currentTarget.addEventListener(Event.COMPLETE, this._dataCompleteHandler);
		
			if (this.itemProgressBar)
			{
				this.addItemProgressBar(this.itemProgressBar);
				this.itemProgressBar.source = this._loadQueue.getItemAt(0);
			}
			if (this.cumulativeProgressBar)
			{
				this.addCumulativeProgressBar(this.cumulativeProgressBar);
				this.cumulativeProgressBar.source = this._loadQueue;
			}
		}


		/**
		 *
		 * Suppresses unhandled error event warnings.
		 * 
		 */
		private function _doNothing(e:Event):void
		{
		}


		/**
		 *
		 * 	
		 * 
		 */
		private function _includeCompleteHandler(e:Event):void
		{
			// Replace the include node with the loaded data.
			var incl:XML = this._loaders2xml[e.currentTarget];
			incl.parent().replace(incl.childIndex(), new XML(e.currentTarget.data));
	
			// Remove the loader from the list of loading loaders. If the list
			// is empty (i.e. all the data is loaded), kick of the initialization
			// process.
			delete this._loaders2xml[e.currentTarget];
			this._numIncludes--;

			if (this._numIncludes == 0) this._init();
		}


		/**
		 *
		 * 	
		 * 
		 */
		private function _init():void
		{
			var info:SectionInfo = new SectionInfo();
			info.parseData(this._data);
			this.setInfo(info);
			this.setData(this, this._data);

			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this._addressChangeHandler);
		}


		/**
		 *
		 *
		 *
		 */		 		 		 		
		private function _loadData(request:URLRequest):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.OPEN, this._dataOpenHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this._doNothing);

			// Add the loader to the LoadQueue.
			this._loadQueue.addItem(loader);
			this._loadQueue.setLoadArguments(loader, request);
			this._loadQueue.load();
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _parseData(data:XML):void
		{
			// Only allow the data to be set once.
			if (this._dataSourceIsSet)
			{
				return;
			}
			this._dataSourceIsSet = true;

			this._data = data;
			var numIncludes:int = 0;
			for each (var incl:XML in this._data.descendants(new QName(inky, 'include')))
			{
				var loader:URLLoader = new URLLoader();
				var source:String = incl.@source;

				// Get the base.
				var tmp:XML = incl;
				while (tmp)
				{
					if (tmp.@inky::base.length())
					{
						source = URLUtil.getFullURL(tmp.@inky::base, source);
					}
					tmp = tmp.parent();
				}

				var request:URLRequest = new URLRequest(source);
				this._loaders2xml[loader] = incl;
				this._numIncludes++;
				loader.addEventListener(Event.COMPLETE, this._includeCompleteHandler);
				this._loadQueue.addItem(loader);
				this._loadQueue.setLoadArguments(loader, request);
				this._loadQueue.load();

				numIncludes++;
			}

			if (!this._numIncludes) this._init();
		}




	}
}
