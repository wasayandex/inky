package inky.app.model
{
	import inky.app.inky;
	import flash.utils.getDefinitionByName;
	import inky.app.controllers.ApplicationController;
	
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
	dynamic public class ApplicationModel
	{
		public var data:XML;
		
		use namespace inky;
		
		/**
		 *
		 */
		public function ApplicationModel(data:XML)
		{
			this.data = data;
			
			// TODO: Must be a better way to get these attributes that are in the default namespace.
			for each (var attr:XML in data.attributes())
			{
				if (attr.name().uri == "")
					this[attr.localName()] = attr.valueOf();
			}
		}
		
		
		
		
		//
		// accessors
		//
		
		
		/**
		 *	
		 */
		public function get controllerClass():Class
		{
// TODO: This should be coming from the data.
			return ApplicationController;
		}
		
		
		

		//
		// public methods
		//

		
		/**
		 *	
		 */
		public function getSectionClassByName(sectionName:String):Class
		{
			
			var className:String = this.data..Section.(@name == sectionName)[0].attributes().((namespace() == inky) && (localName() == "class"));
			return Class(getDefinitionByName(className));
		}
		

		

	}
	
}