package inky.panel
{
	import com.exanimo.external.JSFLInterface;
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import inky.framework.core.inky;


	/**
	 *
	 * ..
	 *	
	 *
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2008.07.29
	 *
	 */
	public class Builder
	{
		private var _catalog:XML;
		private var _publishProfile:XML;
		private var _swfMap:Object;
		private var _inkyXML:XML;
		private var _loader:URLLoader;


		/**
		 *
		 *
		 */
		public function Builder()
		{
		}		 		 		



		public function build(source:Object):void
		{
			if (source is XML)
			{
				this._inkyXML = source as XML;
				this._build();
			}
			else if ((source is String) || (source is URLRequest))
			{
				var request:URLRequest = source is String ? new URLRequest(source as String) : source as URLRequest;
				this._loader = new URLLoader();
				this._loader.addEventListener(Event.COMPLETE, this._inkyXMLCompleteHandler);
				this._loader.load(request);
			}
			else
			{
				throw new Error();
			}	
		}


		private function _inkyXMLCompleteHandler(e:Event):void
		{
			this._inkyXML = new XML(e.currentTarget.data);
			this._build();
		}


		private function _build():void
		{
			// Load the publish profile.
			this._publishProfile = new XML(JSFLInterface.call('getPublishProfile'));

			// Get the external sections.
			this._swfMap = this._mapSWFs(this._inkyXML);
var swcFilename:String = JSFLInterface.call('getDocumentPath') + 'caliope.swc';
			// Publish the swc.
			JSFLInterface.call('publishSWC', swcFilename);

			// Load the swc catalog.
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, this._swcCompleteHandler);
			this._loader.dataFormat = URLLoaderDataFormat.BINARY;
			this._loader.load(new URLRequest(swcFilename));
		}




private function _swcCompleteHandler(e:Event):void
{
	var zip:FZip = new FZip();
	zip.loadBytes(e.currentTarget.data);
	var file:FZipFile = zip.getFileAt(0);
	this._catalog = new XML(file.getContentAsString());
	
	// Expand the swf map to include dependencies.
	for each (var classes:Array in this._swfMap)
	{
		for each (var className:String in classes)
		{
			this._getDeps(className, classes);
		}
	}
	
	this._printMap(this._swfMap);
	
	//!
}


private function _getDeps(className:String, a:Array):void
{	
	namespace swc = "http://www.adobe.com/flash/swccatalog/9";
	use namespace swc;
	var scriptName:String = className.replace(/\W/g, '/');

	var script:XMLList = this._catalog..script.(attribute('name') == scriptName);
	for each (var dep:XML in script.dep + script.def)
	{
		var depClass:String = String(dep.@id).replace(/\W/g, '.');
		if (a.indexOf(depClass) == -1)
		{
			a.push(depClass);
			this._getDeps(depClass, a);
		}
	}
}



	private function _mapSWFs(section:XML, map:Object = null):Object
	{
		map = map || {};
		var classAttr:QName = new QName(inky, 'class');
		var sectionNode:QName = new QName(inky, 'Section');
		var applicationNode:QName = new QName(inky, 'Application');

		var source:String = this._publishProfile.PublishFormatProperties.flashFileName;

		if (section.name() == applicationNode)
		{
			map[source] = [JSFLInterface.call('getApplicationClass')];
		}
		else if (section.attribute(classAttr).length())
		{
			var tmp:XML = section;

			// Determine what classes the section uses.
			while (tmp)
			{
				if (tmp.name() == new QName(inky, 'Section'))
				{
					if (tmp.@source.length())
					{
						source = tmp.@source;
						break;
					}
				}
			
				tmp = tmp.parent();
			}

			map[source] = map[source] || [];
			var className:String = section.attribute(classAttr);
			if (map[source].indexOf(className) == -1)
			{
				map[source].push(className);
			}
		}

		for each (section in section.*.(name() == sectionNode))
		{
			this._mapSWFs(section, map);
		}
		
		return map;
	}







//
//
// for testing
//
//


private function _printMap(map:Object):void
{
	for (var prop:String in map)
	{
		trace(prop);
		for each (var className:String in map[prop])
		{
			trace('\t' + className);
		}
	}
}



public function trace(str:String):void
{
	JSFLInterface.call('fl.trace', str);
}




	}
}
