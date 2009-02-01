package inky.framework.core
{
	import inky.framework.core.inky;
	import inky.framework.core.inky_internal;
	import inky.framework.core.SPath;
	import inky.framework.utils.RouteMapper;
	import com.exanimo.utils.URLUtil;
	import flash.utils.getDefinitionByName;
	

	/**
	 *
	 * Holds information about a section. Unlike sections, SectionInfo
	 * instances are never destroyed, so that the application always has access
	 * to the information they store. This class should be considered an
	 * implementation detail and is subject to change.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2007.11.02
	 *
	 */
	public class SectionInfo
	{
		private var _className:String;
		private var _data:XML;
		private var _defaultRouteRoot:SPath;
		private var _defaultSubsection:SPath;
		private var _href:String;
		private var _index:int;
		private var _isParsed:Boolean;
		private var _name:String;
		private var _owner:SectionInfo;
		private var _routeMapper:RouteMapper;
		private var _source:String;


// TODO: Make sure that only prefixed nodes are being used.
		use namespace inky;

// TODO: Allow some way of registering a node name with a info class
		/**
		 *
		 * 
		 * 
		 */
		public function SectionInfo()
		{
			SectionInfo._sectionInfos.push(this);
		}




		//
		// accessors
		//


		/**
		 *
		 * 
		 * 
		 */
		public function get className():String
		{
			return this._className;
		}

		
		/**
		 *
		 * 
		 */
		public function get defaultRouteRoot():SPath
		{
			return this._defaultRouteRoot;
		}


		/**
		 *
		 * 
		 * 
		 */
		public function get defaultSubsection():SPath
		{
			return this._defaultSubsection;
		}


		/**
		 *
		 * 
		 * 
		 */
		public function get href():String
		{
			return this._href;
		}


		/**
		 *
		 *
		 *
		 */
		public function get index():int
		{
			return this._index;
		}


		/**
		 *
		 * 
		 * 
		 */
		public function get name():String
		{
			return this._name;
		}


		/**
		 *
		 * 
		 * 
		 */
		public function get numSubsections():int
		{
//!
throw Error('i took this out');
		}


		/**
		 *
		 * 
		 * 
		 */
		public function get owner():SectionInfo
		{
			return this._owner;
		}


		/**
		 *
		 * 
		 * 
		 */
		public function get routeMapper():RouteMapper
		{
			return this._routeMapper || this.owner.routeMapper;
		}

		
		/**
		 *
		 * 
		 * 
		 */
		public function get source():String
		{
			return this._source;
		}


		/**
		 *
		 *
		 * 
		 */
		public function get sPath():SPath
		{
// TODO: Store this instead of parsing it each time.
			// Parse the SPath.
			var sPath:SPath = new SPath(this.name);
			var tmp:SectionInfo = this.owner;

			while (tmp)
			{
				sPath.addItemAt(tmp.name, 0);
				tmp = tmp.owner;
			}

			sPath.removeItemAt(0);
			sPath.absolute = true;
			return sPath;
		}




		//
		// public methods
		//


		/**
		 *
		 * 
		 * 
		 */
		public function getSubsectionInfoList():Array
		{
//!
throw new Error('i took this out');
		}


		/**
		 *
		 * 
		 * 
		 */
		public function parseData(value:XML):void
		{
			// There's some costly parsing going on here, so don't do it twice.
			if (this._isParsed) return;
			this._isParsed = true;

			this._data = value;
	
			var tmp:XML;
			
			if (!this.owner)
			{
				this._routeMapper = new RouteMapper();
			}
			
			// Parse the section name.
			this._name = this._getAttribute(value, 'name');
			
			// Parse the href.
			this._href = this._getAttribute(value, 'href');
			
			// Parse the path.
			if (this.owner)
			{
				this._path = SPath.parse(value.@path.toString() || this._name).resolve(SPath.parse(this.owner.path)).toString();
			}
			else
			{
				this._path = '/';
			}

			// Parse subsection data.
			var index:int = 0;
			for each (var subsection:XML in value.Section)
			{
				// Subsection owners MUST be set before the the data is
				// parsed so that the subsection info can access
				// its owner.
				var info:SectionInfo = new SectionInfo();
				info._index = index++;
				info._owner = this;
				info.parseData(subsection);
			}

			// Parse class.
			this._className = this._getAttribute(value, 'class', true);
			if (!this._className && !this._href && this.owner)
			{
				throw new Error('Required attribute inky:class missing from Section ' + this.sPath);
			}

			// Parse source.
			var baseURL:String;
			tmp = value;
			while (tmp)
			{
				baseURL = URLUtil.getFullURL(baseURL, this._getAttribute(tmp, 'base', true));
				tmp = tmp.parent();
			}
			var source:String = this._getAttribute(value, 'source');
			this._source = source ? URLUtil.getFullURL(baseURL, source) : '';

			// Parse the routes.
			for each (var route:XML in value.Route)
			{
				// Parse the default options.
				var defaultOptions:Object = {};
				for each (var defaultOption:XML in route.inky::Default)
				{
					defaultOptions[defaultOption.attribute('for')] = this._getAttribute(defaultOption, 'value');
				}
				
				// Parse the requirements.
				var requirements:Object = {};
				for each (var requirement:XML in route.inky::Requirement)
				{
					requirements[requirement.attribute('for')] = new RegExp(this._getAttribute(requirement, 'value'));
				}
				this.routeMapper.connect(this._getAttribute(route, 'path'), this.sPath, defaultOptions, requirements);
			}

			// Parse default subsection.
			var defaultSubsectionStr:String = value.attribute('defaultSubsection').length() ? value.attribute('defaultSubsection') : null;
			this._defaultSubsection = defaultSubsectionStr ? this.resolveSPath(SPath.parse(defaultSubsectionStr).resolve(this.sPath)) : null;

			if (!this.owner)
			{
				// Parse the url.
				var defaultRouteRoot:SPath = SPath.parse(value.attribute('defaultRouteRoot')).resolve(this.sPath);
				this._getDefaultRoutes(defaultRouteRoot);
				this._updateDefaultSubsection();
			}
		}


		/**
		 *
		 * Takes an SPath and returns an absolute SPath that points to the Section to which the given path resolves (taking into account default subsections).	
		 * 
		 */
		public function resolveSPath(sPath:SPath):SPath
		{
			// If the sPath points to a Section with a default subsection,
			// resolve that and return the result.
			var info:SectionInfo = this.getSectionInfoBySPath(sPath);

			if (info && info.defaultSubsection)
			{
				try
				{
					return this.resolveSPath(info.defaultSubsection);
				}
				catch (error:Error)
				{
					throw new Error('Circular default subsection reference');
				}
			}

			return sPath.clone() as SPath;
		}



public function get pathPattern():RegExp
{
	// TODO: cache this?
	return new RegExp('^' + this.path + '$');
}
private var _path:String;
public function get path():String
{
	return this._path;
}

		//
		// private methods
		//
private static var _sectionInfos:Array = [];

		/**
		 *
		 * 
		 * 
		 */
		public function getSectionInfoBySPath(sPath:SPath):SectionInfo
		{
// FIXME
if (!sPath.absolute) trace('Warning: SectionInfo.getSectionInfoBySPath: Shouldn\'t the SPath be absolute?' + sPath);
var debug:Boolean = true;

			var results:Array = [];			
			for each (var info:SectionInfo in SectionInfo._sectionInfos)
			{
				if (info.pathPattern.test(sPath.toString()))
				{
					results.push(info);
					if (!debug)
						break;
				}

				if (debug && (results.length > 1))
				{
					throw new Error('The SPath ' + sPath + ' matches more than one Section:\n\t' + results.join('\n\t'));
				}
			}

			return results[0];
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _getAttribute(node:XML, attrName:String, inkyNS:Boolean = false):String
		{
			if (inkyNS)
			{
				return node.attributes().((namespace() == inky) && (localName() == attrName));
			}
			else
			{
				return node.attribute(attrName)[0];
			}
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _getDefaultRoutes(defaultRouteRoot:SPath):void
		{
			this._defaultRouteRoot = defaultRouteRoot;
			var tmp:SectionInfo = this;
			var parts:Array = [];

			while (tmp && !tmp.sPath.equals(defaultRouteRoot) && tmp.name)
			{
				parts.unshift(tmp.name);
				tmp = tmp.owner;
			}

			var path:String;
			if (parts.length)
			{
				path = '#/' + parts.join('/') + '/';
			}
			else if (this.sPath.equals(defaultRouteRoot))
			{
				path = '#/';
			}

			if (path)
			{
				this.routeMapper.connect(path, this.sPath);
			}
//!
/*			for each (var info:SectionInfo in this._subsectionInfos)
			{
				info._getDefaultRoutes(defaultRouteRoot);
			}
*/		}


		/**
		 *
		 * Because the default subsections may point to sections with
		 * default subsections,	the default subsection properties must be
		 * updated after everything is parsed.
		 * 
		 */
		private function _updateDefaultSubsection():void
		{
			if (this._defaultSubsection)
			{
				this._defaultSubsection = this.resolveSPath(this._defaultSubsection);
			}
//!
/*			for each (var info:SectionInfo in this._subsectionInfos)
			{
				info._updateDefaultSubsection();
			}*/
		}




		//
		// inky_internal methods
		//


		/**
		 *
		 * 
		 */
		inky_internal function getData():XML
		{
			return this._data;
		}




	}
}
