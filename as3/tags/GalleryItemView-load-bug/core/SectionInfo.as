package inky.framework.core
{
	import inky.framework.core.inky;
	import inky.framework.core.inky_internal;
	import inky.framework.core.SPath;
	import inky.framework.utils.RouteMapper;
	import inky.framework.collections.IIterator;
	import inky.framework.utils.URLUtil;
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
		private var _hrefTarget:String;
		private var _index:int;
		private var _isParsed:Boolean;
		private var _master:SectionInfo;
		private var _name:String;
		private var _nestLevel:int;
		private var _nestedSectionInfos:Array;
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
			this._master = this;
			this._nestedSectionInfos = [];
			this._nestLevel = 0;
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
		public function get hrefTarget():String
		{
			return this._hrefTarget;
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
		public function parseData(value:XML, overrideURL:String = null):void
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
			this._hrefTarget = this._getAttribute(value, 'hrefTarget');

			// Parse subsection data.
			var index:int = 0;
			for each (var subsection:XML in value.Section)
			{
				// Subsection owners MUST be set before the the data is
				// parsed so that the subsection info can access
				// its owner.
				var info:SectionInfo = new SectionInfo();
				info._master = this._master;
				info._nestLevel = this._nestLevel + 1;
				info._index = index++;
				info._owner = this;
				info.parseData(subsection, overrideURL);
				this._nestedSectionInfos.push(info);
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
			var source:String = this._getAttribute(value, 'source', true);
			this._source = source ? URLUtil.getFullURL(baseURL, source) : '';

			// Parse the routes.
// FIXME: Only use namespaced Route nodes.
			for each (var route:XML in value.Route)
			{
				// Parse the default options.
				var defaultOptions:Object = {};
				var requirements:Object = {};
				var defaultOption:XML;
				var requirement:XML;

				for each (defaultOption in route.defaults.attributes() + route.defaults.*)
				{
					defaultOptions[defaultOption.localName().toString()] = defaultOption.toString();
				}
				
				for each (requirement in route.requirements.attributes() + route.requirements.*)
				{
					requirements[requirement.localName().toString()] = requirement.toString();
				}

// TODO: Get rid of this. Legacy routing code.
if ((route.inky::Default.length() > 0) || (route.inky::Requirement.length() > 0))
{
	trace("Warning: the way you are defining route defaults and requirements is deprecated! Use the new method!");

	for each (defaultOption in route.inky::Default)
	{
		defaultOptions[defaultOption.attribute('for')] = this._getAttribute(defaultOption, 'value');
	}
	for each (requirement in route.inky::Requirement)
	{
		requirements[requirement.attribute('for')] = new RegExp(this._getAttribute(requirement, 'value'));
	}
}
				this.routeMapper.connect(this._getAttribute(route, 'path'), this.sPath, defaultOptions, requirements);
			}

// TODO: Get rid of this too.
if (value.attribute('defaultSubsection').length() > 0)
{
	trace("Warning: the defaultSubsection attribute is deprecated! Use Routes!");
}
// Parse default subsection.
var defaultSubsectionStr:String = value.attribute('defaultSubsection').length() ? value.attribute('defaultSubsection') : null;
this._defaultSubsection = defaultSubsectionStr ? this.resolveSPath(SPath.parse(defaultSubsectionStr).resolve(this.sPath)) : null;

			if (!this.owner)
			{
				if (overrideURL)
				{
					var overrideSPath:SPath = this._routeMapper.getSPath('#' + overrideURL);
					var overrideOptions:Object = this._routeMapper.getOptions('#' + overrideURL, overrideSPath);
					this.routeMapper.connect2('#/', overrideSPath, overrideOptions, overrideOptions);
				}

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




		//
		// private methods
		//


		/**
		 *
		 * 
		 * 
		 */
		public function getSectionInfoBySPath(sPath:SPath):SectionInfo
		{
// FIXME
if (!sPath.absolute) trace('Warning: SectionInfo.getSectionInfoBySPath: Shouldn\'t the SPath be absolute?' + sPath);

			var info:SectionInfo = this._master;
			for (var i:IIterator = sPath.iterator(); i.hasNext(); )
			{
				info = info._getSectionInfoByName(i.next() as String);
				if (info == null)
					break;
			}

			return info;
		}


		/**
		 *
		 */
		private function _findDescendantInfos(name:String, matches:Array = null, findFirst:Boolean = false):Array
		{
			matches = matches || [];
			for each (var o:Object in this._nestedSectionInfos)
			{
				if (o.name == name)
				{
					matches.push(o);
					if (findFirst)
						break;
				}
				else
					o._findDescendantInfos(name, matches);
			}
			return matches;
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
		}


		/**
		 *
		 *
		 */
		private function _getSectionInfoByName(name:String):SectionInfo
		{
			var info:SectionInfo = this._nestedSectionInfos[name];
			if (info == null)
			{
				var nestedMatches:Array = this._findDescendantInfos(name);
				info = nestedMatches[0];
				for each (var o:SectionInfo in nestedMatches)
				{
					if (o._nestLevel < info._nestLevel)
						info = o;
				}
				if (info == null)
					info = this._master._findDescendantInfos(name, [], true)[0];
			}
			return info;
		}


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
