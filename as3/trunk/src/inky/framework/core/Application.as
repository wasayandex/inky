package inky.framework.core
{
	import flash.display.*;
	import flash.net.URLRequest;
	import flash.text.*;
	import inky.framework.core.inky;
	import inky.framework.core.Section;
	import inky.framework.data.SectionInfo;
	import inky.framework.events.SectionEvent;
	import inky.framework.utils.SPath;


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
		private var _data:XML;
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
			var dataSource:String = this.root.loaderInfo.parameters.dataSource;
			if (dataSource)
			{
				this.dataSource = dataSource;
			}
			else
			{
				// If the dataSource property isn't set on the SWF, try to use
				// the default value.
				this.dataSource = new URLRequest(new Loader().contentLoaderInfo.loaderURL.split('.').slice(0, -1).join('.') + '.inky.xml');
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
				this._init(dataSource as XML);
			}
			else if ((dataSource is String) || (dataSource is URLRequest))
			{
				var request:URLRequest = (dataSource as URLRequest) || new URLRequest(dataSource as String);
				this.loadManager.loadData(request, this._init);
			}
			else
			{
				throw new Error('Application.dataSource may only be set to XML, a URL String, or a URLRequest.');
			}
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
			info.parseData(this._data);
			this.setInfo(info);
			this.markupObjectManager.setData(this, this._data);
		}



	}
}
