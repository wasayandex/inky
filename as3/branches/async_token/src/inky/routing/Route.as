package inky.routing
{
	import inky.utils.CloningUtil;
	import inky.app.SPath;


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

			this._path = path;
			
			// If the SPath isn't absolute, throw an error.
			if (!sPath.absolute)
			{
				throw new ArgumentError('A Route\'s SPath must be absolute.');
			}
			this._sPath = sPath.normalize();

			for (var optionName:String in defaultOptions)
			{
				this.setDefaultOption(optionName, defaultOptions[optionName]);
			}

			for (var requirementName:String in requirements)
			{
				var r:Object = requirements[requirementName];
				var requirement:RegExp;
				if (r is String)
				{
					requirement = new RegExp(r as String);
				}
				else if (r is RegExp)
				{
					requirement = r as RegExp;
				}
				else
				{
					throw new ArgumentError();
				}
				this.setRequirement(requirementName, requirement);
			}

			this._createPattern();
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


		/**
		 *
		 * Gets the SPath that this route directs to.
		 * 
		 */
		public function get sPath():SPath
		{
			return this._sPath;
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
		public function setRequirement(name:String, requirement:RegExp):void
		{
			this._requirements[name] = requirement;
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
			var usedOptions:Array = [];
			var i:uint;
			var j:uint;
			var token:Object;
			var optionalTokens:Array = [];

			// Clone the tokenized path, inserting values for dynamic parts.
			var tokenizedPath:Array = [];
			for (i = 0; i < this._tokenizedPath.length; i++)
			{
				token = CloningUtil.clone(this._tokenizedPath[i]);
				if (token.type == 'dynamic')
				{
					var value:String;
					if (options)
					{
						value = options[token.name];
					}
					if (value == null)
					{
						var defaultValue:String = this.getDefaultOption(token.name);
						if (defaultValue == null)
						{
							throw new Error('No value was provided for dynamic option ' + token.name + ' and there is no default');
						}
						else
						{
							value = defaultValue;
						}
					}
					if (value == this.getDefaultOption(token.name))
					{
						optionalTokens.push(token);
					}
					usedOptions.push(token.name);
					token.value = value;
				}
				tokenizedPath[i] = token;
			}

			// Break path into chunks at the separators.
			var chunks:Array = [];
			j = 0;
			for (i = 0; i < tokenizedPath.length; i++)
			{
				if (!chunks[j])
				{
					chunks[j] = [];
				}

				token = tokenizedPath[i];
				if (token.type == 'separator' && token.value == '/')
				{
					j++;
				}
				else
				{
					chunks[j].push(token);
				}
			}

			// Minimize the url
			for (i = chunks.length - 1; i > 0; i--)
			{
				// If all the tokens in a chunk are optional, remove the chunk.
				var removeChunk:Boolean = true;
				j = 0;
				while (removeChunk && (j < chunks[i].length))
				{
					token = chunks[i][j];
					removeChunk = optionalTokens.indexOf(token) != -1;
					j++
				}
				
				if (removeChunk)
				{
					chunks.splice(i, 1);
				}
				else
				{
					break;
				}
			}
/*
Removed because routes now don't need to include all of the dynamic parts. For example, 

<inky:Route path="#/my-favorite-image/">
	<defaults groupName="residences" itemIndex="6" />
	<requirements groupName="residences" itemIndex="6" />
</inky:Route>

The path contains neither dynamic part but specifies their values.

			// If an option is not included in the route url, throw an error.
			for (var k:String in options)
			{
				if (usedOptions.indexOf(k) == -1)
				{
					throw new ArgumentError('Could not generate url: the routed path ' + this.path + ' does not specify where to include the dynamic part "' + k + '". Create a route that includes the dynamic part "' + k + '".');	
				}
			}*/

			// Make the url.
			var urlArray:Array = [];
			for (i = 0; i < chunks.length; i++)
			{
				var chunk:String = ''
				for (j = 0; j < chunks[i].length; j++)
				{
					chunk += chunks[i][j].value;
				}
				urlArray.push(chunk);
			}

			return urlArray.join('/');
		}


		/**
		 *	@private
		 *	Determines whether this is a route for the given sPath and options.
		 *	TODO: rename? expose?
		 *	
		 */
		public function isRouteFor(sPath:SPath, options:Object = null):Boolean
		{
			var isRouteFor:Boolean = this.sPath.equals(sPath);
			options = options || {};
			if (isRouteFor)
			{
				var p:String;
				
				// Make sure each of the dynamic parts has a corresponding option.
				for each (p in this._dynamicSegmentNames)
				{
					if (!options.hasOwnProperty(p) && (this.getDefaultOption(p) == null))
					{
						isRouteFor = false;
						break;
					}
				}

				// Make sure there are no extra options. (Strict mode only)
				if (isRouteFor)
				{
					for (p in options)
					{
						if (this._dynamicSegmentNames.indexOf(p) == -1)
						{
							isRouteFor = false;
							break;
						}
					}
				}

				// Make sure all the requirements are satisfied.
				if (isRouteFor)
				{
					for (p in this._requirements)
					{
						var requirement:RegExp = this._requirements[p];
						var value:String = options.hasOwnProperty(p) ? options[p] : this._defaultOptions[p];
						if (!requirement.test(value))
						{
							isRouteFor = false;
							break;
						}
					}
				}
			}
			return isRouteFor;
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
				// add the default options to compensate for a
				// route that has no dynamic segments, but could have
				// implied options (as in the case of an overrideURL.)
				for (var p:String in this._defaultOptions)
				{
					result[p] = this._defaultOptions[p];
				}
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
		 */
		private function _createPattern():void
		{
			this._tokenize(this.path);
			this._pattern = new RegExp('\\A' + this._getPatternSource(this._tokenizedPath) + '\\Z');
		}


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
									optional = this.getDefaultOption(segments[j].name) != null;
									break;
							}
							if (!optional) break;
						}
						
						if (!optional)
						{
							pattern += this._escapeForRegExp(segment.type == 'dynamic' ? segment.name : segment.value);
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
						var requirement:RegExp = this.getRequirement(segment.name);
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

			// Add a trailing slash.
			path = path.replace(/\/?$/, '/');
			var a:Array = [path];
			
			// Make dynamic parts into tokens
			for each (var dynamicSegment:String in dynamicSegments)
			{
				this._replaceWithToken(a, dynamicSegment, 'dynamic');
			}

			// Make separators into tokens.
			this._replaceWithToken(a, '/', 'separator');

			// Make remaining strings into tokens.
			for (i = 0; i < a.length; i++)
			{
				if (a[i] is String)
				{
					a.splice(i, 1, {value: a[i], type: 'text'});
				}
			}
			return this._tokenizedPath = a;
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
						var o:Object = {type: type};
						if (type == 'dynamic')
						{
							o.name = str.substr(1);;
						}
						else
						{
							o.value = str;
						}
						
						tmp.splice(p, 0, o);
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
