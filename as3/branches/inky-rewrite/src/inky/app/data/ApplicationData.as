package inky.app.data
{
	import inky.app.inky;
	import inky.app.SPath;
	import inky.app.data.IApplicationData;
	import inky.app.data.SectionData;
	import inky.app.data.IViewDataMap;
	import inky.app.data.ViewDataMap;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.28
	 *
	 */
	dynamic public class ApplicationData extends SectionData implements IApplicationData
	{
		private var _data:Object;
		private var _viewData:IViewDataMap;


		/**
		 *
		 */
		public function ApplicationData(data:Object = null)
		{
			super(null);
			this._data = data;
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get viewData():IViewDataMap
		{
			return this._viewData || (this._viewData = new ViewDataMap(this));
		}


		//
		// public methods
		//
		
		
/*
		public function getSectionClassName(sPath:SPath):String
		{
trace(">>>>>>>>>>>>>>>>>>>" + sPath);
return "Crap";
			
			
// TODO: This parsing needs to be done by a deserializer.
			var segments:Array = sPath.toArray();
			var segment:String;
			var node:XML = XML(this._data);
			while (segments.length)
			{
				segment = segments.shift();
				node = node.inky::Section.(@name == segment)[0];

				if (!node)
// TODO: Throw more informative error.
					throw new Error(sPath.toString() + " cannot be found.");
			}

			node = node.attribute(new QName(inky, "class"))[0];
			if (!node)
// TODO: Throw more informative error.
				throw new Error("Class cannot be determined for " + sPath.toString());
			
			return node.toString();
		}
*/


	}
	
}
