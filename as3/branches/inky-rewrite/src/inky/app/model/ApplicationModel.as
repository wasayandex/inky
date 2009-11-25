package inky.app.model
{
	import inky.app.inky;
	import flash.utils.getDefinitionByName;
	import inky.app.controllers.ApplicationController;
	import inky.app.SPath;
	import inky.app.AssetRepository;
	import inky.loading.SoundLoader;
	import inky.loading.BinaryLoader;
	import inky.loading.IAssetLoader;
	
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
SoundLoader;
BinaryLoader;
		
// FIXME: This should not be exposed. In fact, the model shouldn't even have it.
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


// FIXME: ARGGG MORE PARSING IN THE MODEL!!>!!> GROSS!!LK
		public function getPreloadAssetLoadersFor(sPath:SPath):Array
		{
			if (!sPath.absolute)
				throw new ArgumentError();
			
			var loaders:Array = [];
			var xml:XML = this.data;
			for (var i:int = 0; i < sPath.length; i++)
			{
				var sectionName:String = sPath.getItemAt(i) as String;
				var list:XMLList = xml.inky::Section.(@name == sectionName);
				if (!list.length())
					throw new Error();
				xml = list[0];

				for each (var assetData:XML in xml.inky::AssetLoader + xml.inky::SoundLoader + xml.inky::BinaryLoader)
				{
					var source:String = assetData.@source;
					var id:String = assetData.@id;
					if (!source)
						throw new Error();

					var repository:AssetRepository = AssetRepository.getInstance();
					var asset:Object = repository.getAssetById(id);
					if (!asset)
					{
						var assetClass:Class = getDefinitionByName("inky.loading." + assetData.localName()) as Class;
						var assetLoader:IAssetLoader = new assetClass();
						asset = assetLoader.asset;
						assetLoader.source = source;
						if (assetData.@cache == "true")
							repository.putAsset(id, asset);
// FIXME: How do you even get the asset if it's not cached??!!
						loaders.push(assetLoader);
					}
				}
			}
			return loaders;
		}

		

	}
	
}
