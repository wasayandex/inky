package inky.framework.utils
{
	import inky.framework.utils.SPath;


	/**
	 *
	 * <p>An object that pairs a path with a section. Routes give you control over
	 * the application's deep-linking. Routes are generally not created by the
	 * user in ActionScript. Instead, you can add a Route to a Section in your
	 * inky XML with an inky:Route node:</p>
	 *	
	 * <listing>&lt;inky:Application xmlns:inky="http://exanimo.com/2008/inky">
	 * 	&lt;inky:Section inky:class="AnimalsSection" name="animals">
	 * 		&lt;inky:Route path="#/animals" />
	 * 	&lt;/inky:Section>
	 * &lt;/inky:Application>
	 * </listing>
	 *	
	 * <p>This class should be considered an implementation detail and is subject to change.</p>
	 *	
	 * @see http://code.google.com/p/inky/wiki/Routing
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @author Matthew Tretter
	 * @since  2007.11.02
	 *
	 */
	public class Route
	{
		private var _defaultOptions:Object;
		private var _dynamicSegmentNames:Array;
		private var _requirements:Object;
		private var _sPath:SPath;
		private var _tokenizedPath:Array;
		private var _path:String;
		private var _pattern:RegExp;


		/**
		 *
		 * Creates a new Route
		 *
		 * @param path
		 * @param sPath
		 * @param defaultOptions
		 * @param requirements
		 * 
		 */
		public function Route(path:String, sPath:SPath, defaultOptions:Object = null, requirements:Object = null)
		{
			this._defaultOptions = defaultOptions || {};
			this._requirements = requirements || {};

			this.path = path;
			this.sPath = sPath;
			
			if (defaultOptions)
			{
				for (var optionName:String in defaultOptions)
				{
					this.setDefaultOption(optionName, defaultOptions[optionName]);
				}
			}
			
			if (requirements)
			{
				for (var requirementName:String in requirements)
				{
					this.setRequirement(requirementName, requirements[requirementName]);
				}
			}
		}




		//
		// accessors
		//


		/**
		 *
		 * Gets the path of a route.
		 * 
		 */
		public function get path():String
		{
			return this._path;
		}
		public function set path(path:String):void
		{
			this._path = path;
			this._tokenizedPath = this._tokenize(path);
			this._pattern = new RegExp('\\A' + this._getPatternSource(this._tokenizedPath) + '\\Z');
		}


		/**
		 *
		 * Gets the SPath that this route directs to.
		 * 
		 */
		public function get sPath():SPath
		{
			return this._sPath;
		}
		public function set sPath(sPath:SPath):void
		{
			// If the SPath isn't absolute, throw an error.
			if (!sPath.absolute)
			{
				throw new ArgumentError('A Route\'s SPath must be absolute.');
			}

			this._sPath = sPath.normalize();
		}




		//
		// public methods
		//


		/**
		 *
		 * 
		 */
		public function getDefaultOption(name:String):String
		{
			return this._defaultOptions[name];
		}


		/**
		 *
		 * 
		 */
		public function getRequirement(name:String):RegExp
		{
			return this._requirements[name];
		}

		/**
		 *
		 * 
		 * 
		 */
		public function setDefaultOption(name:String, value:String):void
		{
			this._defaultOptions[name] = value;
		}

		/**
		 *
		 * 
		 * 
		 */
		public function setRequirement(name:String, value:RegExp):void
		{
			this._requirements[name] = value;
		}


		/**
		 *
		 * Generates a url for this route using the provided options Object.
		 * Returns the url associated with this Route, with the dynamic parts
		 * replaced with the values in the options object.	
		 * 
		 */
		public function generateURL(options:Object = null):String
		{
			options = options || {};
			var defaultOption:String;
			var optionName:String;			
			var urlArray:Array = [];
			var usedOptions:Array = [];
			for each (var token:Object in this._tokenizedPath)
			{
				if (token.type == 'dynamic')
				{
					optionName = token.value;
					usedOptions.push(optionName);

					if (options && (options[optionName] != null) && (options[optionName] != this.getDefaultOption(optionName)))
					{
						urlArray.push(options[optionName].toString());
					}
					else
					{
						// Insert a placeholder for the default value.
						urlArray.push({optionName: optionName});
					}
				}
				else
				{
					urlArray.push(token.value);
				}
			}

			// If an option is not included in the route url, throw an error.
			for (var k:String in options)
			{
				if (usedOptions.indexOf(k) == -1)
				{
					throw new ArgumentError('Could not generate url: the routed path ' + this.path + ' does not specify where to include the dynamic part "' + k + '". Create a route that includes the dynamic part "' + k + '".');	
				}
			}

			// Remove the default value placeholders (and forward slashes) from the end. (Minimize urls.)
			var j:int = urlArray.length - 1;
			while ((j > 0) && (j < urlArray.length))
			{
				if (!(urlArray[j] is String))
				{
					optionName = urlArray[j].optionName;
					defaultOption = this.getDefaultOption(optionName);

					if ((options[optionName] == defaultOption) || (options[optionName] === undefined))
					{
						// Remove extraneous information from the end.
						urlArray.splice(j, urlArray.length - j);
					}
					else
					{
						// If you get to an option that doesn't match the default,
						// it is required (so stop removing things).
						break;
					}
				}
				j--;
			}

			// Replace any default value tokens that aren't at the end with the default value.
			for (var i:uint = 0; i < urlArray.length; i++)
			{
				if (!(urlArray[i] is String))
				{
					optionName = urlArray[i].optionName;
					defaultOption = this.getDefaultOption(optionName);

					if (defaultOption == null)
					{
						throw new ArgumentError('URL could not be generated: no value was provided for ' + optionName + ', and there is no default value.');
					}
					else
					{
						urlArray.splice(i, 1, defaultOption);
					}
				}
			}

			return urlArray.join('');
		}


		/**
		 *
		 * Match the route against a url. If the url matches the route, this
		 * function returns a hashmap of the dynamic parts (an "options"
		 * object). Otherwise, it returns null.
		 * 
		 */
		public function match(url:String):Object
		{
			var result:Object; 
			var o:Array = url.match(this._pattern);

			if (o)
			{
				result = {};
				for (var i:uint = 0; i < o.length - 1; i++)
				{
					var optionName:String = this._dynamicSegmentNames[i];
					result[optionName] = o[i + 1] != null ? o[i + 1] : this.getDefaultOption(optionName);
				}
			}

			return result;
		}




		//
		// private methods
		//


		/**
		 *
		 * Escapes a String for use in a RegExp	
		 * 
		 */
		private function _escapeForRegExp(input:String):String
		{
// TODO: This needs to escape more characters.
			return input.replace('\\', '\\\\').replace('/', '\\/');
		}


		/**
		 *
		 * Creates a regular expression source string for matching urls against
		 * this route.
		 *
		 */		 		 		 		
		private function _getPatternSource(segments:Array, wrap:Boolean = true):String
		{
			// Create the regexp from the tokenized path.
			var segment:Object;
			var pattern:String = '';
			var segmentPattern:String = '';
			var optional:Boolean;
			var i:int, j:int;
			for (i = 0; i < segments.length; i++)
			{
				segment = segments[i];
				
				switch (segment.type)
				{
					case 'text':
						pattern += this._escapeForRegExp(segment.value);
						break;
					case 'separator':
						// Determine whether the separator is optional based on whether subsequent parts are optional.
						optional = true;
						
						for (j = i + 1; j < segments.length; j++)
						{
							switch (segments[j].type)
							{
								case 'text':
									optional = false;
									break;
								case 'dynamic':
									optional = this.getDefaultOption(segments[j].value) != null;
									break;
							}
							if (!optional) break;
						}
						
						if (!optional)
						{
							pattern += this._escapeForRegExp(segment.value);
						}
						else
						{
							var remainingSegments:Array = segments.slice(i + 1);
							
							if (!remainingSegments.length || ((remainingSegments.length == 1) && (remainingSegments[0].type == 'separator')))
							{
								pattern += '\\/?';
							}
							else
							{
								return pattern + '(?:\\/?\\Z|\\/' + this._getPatternSource(remainingSegments) + ')';
							}
						}
						break;
					case 'dynamic':
						var requirement:RegExp = this.getRequirement(segment.value);
						segmentPattern = requirement ? '(' + requirement.source + ')' : '([^\\/;.,?]+)';
						pattern += segmentPattern;
						break;
				}
			}
		
			return pattern;
		}


		/**
		 *
		 * Tokenizes a string.
		 * 
		 */
		private function _tokenize(path:String):Array
		{
			// Get the dynamic segments.
			var dynamicSegments:Array = path.match(/:([\w]+)/g);

			// Create a list of dynamic segment names.
			this._dynamicSegmentNames = dynamicSegments.slice();
			for (var j:uint = 0; j < this._dynamicSegmentNames.length; j++)
			{
				this._dynamicSegmentNames[j] = this._dynamicSegmentNames[j].substr(1);
			}

			// Remove redundancies.
			for (var i:uint = 0; i < dynamicSegments.length; i++)
			{
				var lastIndex:int = dynamicSegments.lastIndexOf(dynamicSegments[i]);
				if (lastIndex != i)
				{
					dynamicSegments.splice(i--, 1);
				}
			}
		
			//
			// Tokenize the path.
			//
			
			// Add the trailing slash.
			path = path.replace(/\/?$/, '/');
			var a:Array = [path];
			
			// Make dynamic parts into tokens
			for each (var dynamicSegment:String in dynamicSegments)
			{
				this._replaceWithToken(a, dynamicSegment, 'dynamic');
			}
		
			// Make separators into tokens.
			var separators:Array = ['/'];
			for each (var separator:String in separators)
			{
				this._replaceWithToken(a, separator, 'separator');
			}
		
			// Make remaining strings into tokens.
			for (i = 0; i < a.length; i++)
			{
				if (a[i] is String)
				{
					a.splice(i, 1, {value: a[i], type: 'text'});
				}
			}
			return a;
		}


		/**
		 *
		 * Helper method for _tokenize. Replaces all occurences of str with a
		 * placeholder object.		 
		 *
		 */		 		 		 		
		private function _replaceWithToken(a:Array, str:String, type:String):Array
		{
			// Tokenize the Array.
			var j:int;
			for (var i:int = a.length - 1; i >= 0; i--)
			{
				var k:* = a[i];
				if (k is String)
				{
					var tmp:Array = k.split(str);
					for (var p:int = tmp.length - 1; p > 0; p -= 1)
					{
						// Remove the preceding color from dynamic segments.
						str = type == 'dynamic' ? str.substr(1) : str;
						tmp.splice(p, 0, {value: str, type: type});
					}

					// Remove the empty items.
					for (j = 0; j < tmp.length; j++)
					{
						if (tmp[j] == '')
						{
							tmp.splice(j--, 1);
						}
					}

					tmp.unshift(1);
					tmp.unshift(i);
					a.splice.apply(null, tmp);
				}
			}

			return a;
		}




	}
}
