package inky.panel
{
	import com.exanimo.external.JSFLInterface;
	import com.exanimo.utils.ArrayUtil;
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

			// Publish the swc.
			var swcFilename:String = JSFLInterface.call('getDocumentPath') + 'caliope.swc';
			JSFLInterface.call('publishSWC', swcFilename);

			// Load the swc catalog.
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE, this._swcCompleteHandler);
			this._loader.dataFormat = URLLoaderDataFormat.BINARY;
			this._loader.load(new URLRequest(swcFilename));
		}




private function _swcCompleteHandler(e:Event):void
{

	var className:String;

	// There's something weird going on here. If the next line isn't present,
	// the XML created from the swc contents will be messed up. It's not the
	// Inflater either, because you get the same problem using the xml
	// directly.
	namespace swc = "http://www.adobe.com/flash/swccatalog/9";

	var zip:FZip = new FZip();
	zip.loadBytes(e.currentTarget.data);
	var file:FZipFile = zip.getFileAt(0);

	// Create XML from the catalog.
	var swcContents:String = file.getContentAsString();
	this._catalog = new XML(swcContents);

	// Expand the swf map to include dependencies.
	for each (var classes:Array in this._swfMap)
	{
		for each (className in classes)
		{
			this._getDeps(className, classes);
		}
	}

	// Remove redundant classes from the map.
//	var classAttr:QName = new QName(inky, 'class');
	var sectionNode:QName = new QName(inky, 'Section');
	var applicationNode:QName = new QName(inky, 'Application');
	var extSections:Array = this._sortByNestLevel(this._inkyXML..inky::Section.(attribute('source').length()));
	var excludeClasses:Object = {};
	excludeClasses[this._publishProfile.PublishFormatProperties.flashFileName.toString()] = [];

	for each (var extSection:XML in extSections)
	{
		var source:String = extSection.@source;
		excludeClasses[source] = [];

		// Make a list of all the sections with the same source.
		var sections:XMLList = this._inkyXML..inky::Section.(attribute('source') == source);
		
		// Determine which classes are needed.
		for (var i:int = 0; i < this._swfMap[source].length; i++)
		{
			className = this._swfMap[source][i];
			var includeClass:Boolean = true;

			// Multiple sections could potentially have the same source swf, so make sure that neither swf requires this class.
			for each (var s:XML in sections)
			{
				var tmp:XML = s.parent();
				var classDefInAncestor:Boolean = false;
				var otherSource:String;
				while (tmp)
				{
					if (((tmp.name() == sectionNode)  && (otherSource = tmp.@source)) || ((tmp.name() == applicationNode) && (otherSource = this._publishProfile.PublishFormatProperties.flashFileName)))
					{
						if (this._swfMap[otherSource].indexOf(className) != -1)
						{
							classDefInAncestor = true;
							break;
						}
					}
					tmp = tmp.parent();
				}
				if (classDefInAncestor)
				{
					includeClass = false;
					break;
				}
			}

			if (!includeClass)
			{
				excludeClasses[source].push(className);
				this._swfMap[source].splice(i, 1);
				i--;
			}
		}
	}

	this._printMap(excludeClasses);

	//!
}



private function _sortByNestLevel(list:XMLList):Array
{
	var array:Array = [];
	for each (var xml:XML in list)
	{
		array.push({xml: xml, nestLevel: this._getNestLevel(xml)});
	}
	return ArrayUtil.getFieldValues(array.sortOn('nestLevel'), 'xml');
}

private function _getNestLevel(xml:XML):uint
{
	var nestLevel:uint = 0;
	var tmp:XML = xml;
	while ((tmp = tmp.parent()))
	{
		nestLevel++;
	}
	return nestLevel;
}



private function _getDeps(className:String, a:Array):void
{	
	namespace swc = "http://www.adobe.com/flash/swccatalog/9";
	var scriptName:String = className.replace(/\W/g, '/');

	// For some weird buggy reason, we have to use the ns explicitly, or else the script will only run correctly the first time.
	var script:XMLList = this._catalog..swc::script.(attribute('name') == scriptName);
	for each (var dep:XML in script.swc::dep + script.swc::def)
	{
		var depClass:String = String(dep.@id).replace(/\W/g, '.');

		// Don't add the class to the list if it's already in the list or if it's a flash.* class.
// TODO: don't add if it's a top-level flash class (i.e. Error)
		if ((a.indexOf(depClass) == -1) && !(/^flash\./.test(depClass)))
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
		map[prop].sort(Array.CASEINSENSITIVE);
		for each (var className:String in map[prop])
		{
			trace('\t' + className);
		}
	}
}


public function trace(str:*):void
{
	JSFLInterface.call('fl.trace', String(str));
}




	}
}
