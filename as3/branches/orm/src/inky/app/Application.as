package inky.app
{
	import flash.display.*;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.*;
	import inky.app.inky;
	import inky.app.inky_internal;
	import inky.app.Section;
	import inky.app.SPath;
	import inky.app.SectionInfo;
	import inky.app.events.SectionEvent;
	import inky.utils.Debugger;


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
		private static var _currentApplication:Application;
		private var _data:XML;
		private var _dataSource:Object;
		private var _dataSourceIsSet:Boolean;


		/**
		 * 
		 * Creates a new Application instance. The Section constructor should
		 * never be called directly, however. Instead, it should be used as the
		 * document class of your project's FLA.
		 * 
		 */
		public function Application()
		{
			if (Application._currentApplication) return;
			Application._currentApplication = this;
			
			var dataSource:String = this.root.loaderInfo.parameters.dataSource;
			if (dataSource)
			{
				this.dataSource = dataSource;
			}
			this.addEventListener(Event.ENTER_FRAME, this._loadData);
		}




		//
		// accessors
		//


		/**
		 *	@private
		 */
		public static function get activeSection():Section
		{
			var section:Section = Application.currentApplication;
			if (!section) return null;

			var leaf:Section = section.currentSubsection;
			while (leaf)
			{
				section = leaf;
				leaf = section.currentSubsection;
			}
			return section;
		}
		

		/**
		 * @private
		 */
		public static function get currentApplication():Application
		{
			return Application._currentApplication;
		}


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
			this._dataSource = dataSource;

			if (!(dataSource is XML) && !(dataSource is String) && !(dataSource is URLRequest))
			{
				throw new Error('Application.dataSource may only be set to XML, a URL String, or a URLRequest.');
			}
		}		


		/**
		 *
		 *
		 *
		 */
		public function get debug():Boolean
		{
			return Debugger.enabled;
		}
		/**
		 * @private
		 */
		public function set debug(debug:Boolean):void
		{
			Debugger.enabled = debug;
		}




		//
		// private methods
		//


		/**
		 *
		 * 	
		 * 
		 */
		private function _init(data:XML):void
		{
			if (this._dataSourceIsSet)
			{
				return;
			}
			this._dataSourceIsSet = true;
			this._data = data;

			var info:SectionInfo = new SectionInfo();
			info.parseData(this._data, this.root.loaderInfo.parameters.overrideURL);
			this.inky_internal::setInfo(info);
			this.markupObjectManager.setData(this, this._data);
		}


		/**
		 *
		 * Loads the XML file.	
		 *	
		 */
		private function _loadData(e:Event):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);

			if (this._dataSource is XML)
			{
				this._init(this._dataSource as XML);
			}
			else
			{
				if (this._dataSource == null)
				{
					this._dataSource = this.loaderInfo.loaderURL.split('.').slice(0, -1).join('.') + '.inky.xml';
				}
				var request:URLRequest = this._dataSource is URLRequest ? this._dataSource as URLRequest : new URLRequest(this._dataSource as String);
				this.inky_internal::getLoadManager().loadData(request, this._init);
			}
		}




	}
}
