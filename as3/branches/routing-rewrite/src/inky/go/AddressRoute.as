package inky.go 
{
	import com.asual.swfaddress.SWFAddressEvent;
	import inky.utils.CloningUtil;

	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.09.28
	 *
	 */
	public class AddressRoute extends Route
	{
		private var _dynamicSegmentNames:Array;
		private var _pattern:String;
		private var _patternSource:String;
		private var _tokenizedPattern:Array;
		private var _regExp:RegExp;
		
		// Token types.
		private static const TEXT:String = "text";
		private static const SEPARATOR:String = "separator";
		private static const DYNAMIC:String = "dynamic";

		/**
		 *	
		 */
		public function AddressRoute(addressPattern:String, triggers:Object, defaults:Object = null, requirements:Object = null, argumentMap:Object = null)
		{
			super(triggers, defaults, requirements, argumentMap);
			this._patternSource = addressPattern;
			this._createRegExp();
		}




		//
		// accessors
		//


		/**
		 * Gets a (cleaned version) of this route's pattern.
		 */
		public function get pattern():String
		{
			if (this._pattern == null)
			{
				var pattern:String = "";
				for each (var token:Object in this._tokenizedPattern)
				{
					switch (token.type)
					{
						case TEXT:
						{
							pattern += token.value;
							break;
						}
						case SEPARATOR:
						{
							pattern += token.value;
							break;
						}
						case DYNAMIC:
						{
							pattern += ":" + token.name;
							break;
						}
					}
				}
				this._pattern = pattern;
			}
			return this._pattern;
		}




		//
		// public methods
		//


		/**
		 * Generates a url for this route using the provided options Object.
		 * Returns the url associated with this Route, with the dynamic parts
		 * replaced with the values in the options object.	
		 */
		public function generateAddress(options:Object = null):String
		{
			options = options || {};
			var defaultOption:String;
			var optionName:String;			
			var usedOptions:Array = [];
			var i:uint;
			var j:uint;
			var token:Object;
			var optionalTokens:Array = [];

			// Clone the tokenized pattern, inserting values for dynamic parts.
			var tokenizedPattern:Array = [];
			for (i = 0; i < this._tokenizedPattern.length; i++)
			{
				token = CloningUtil.clone(this._tokenizedPattern[i]);
				if (token.type == DYNAMIC)
				{
					var value:String;
					if (options)
					{
						value = options[token.name];
					}
					if (value == null)
					{
						var defaultValue:String = this.defaults[token.name];
						if (defaultValue == null)
						{
							throw new Error("No value was provided for dynamic option " + token.name + " and there is no default");
						}
						else
						{
							value = defaultValue;
						}
					}
					if (value == this.defaults[token.name])
					{
						optionalTokens.push(token);
					}
					usedOptions.push(token.name);
					token.value = value;
				}
				tokenizedPattern[i] = token;
			}

			// Break pattern into chunks at the separators.
			var chunks:Array = [];
			j = 0;
			for (i = 0; i < tokenizedPattern.length; i++)
			{
				if (!chunks[j])
				{
					chunks[j] = [];
				}

				token = tokenizedPattern[i];
				if (token.type == SEPARATOR && token.value == "/")
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

			// Make the url.
			var urlArray:Array = [];
			for (i = 0; i < chunks.length; i++)
			{
				var chunk:String = "";
				for (j = 0; j < chunks[i].length; j++)
				{
					chunk += chunks[i][j].value;
				}
				urlArray.push(chunk);
			}

			return urlArray.join("/");
		}


		/**
		 *	@inheritDoc
		 */
		override public function match(obj:Object):Object
		{
			var match:Object;
			if (obj is SWFAddressEvent && obj.type == SWFAddressEvent.CHANGE)
				match = this._matchAddress("#" + obj.value);
			else if (this.triggers.indexOf(obj.type) != -1)
				match = super.match(obj);

			return match;
		}

		/**
		 * @inheritDoc
		 */
		private function _matchAddress(url:String):Object
		{
			var result:Object; 
			var o:Array = url.match(this._regExp);

			if (o)
			{
				result = {};
				// add the default options to compensate for a
				// route that has no dynamic segments, but could have
				// implied options (as in the case of an overrideURL.)
				for (var p:String in this.defaults)
				{
					result[p] = this.defaults[p];
				}
				for (var i:uint = 0; i < o.length - 1; i++)
				{
					var optionName:String = this._dynamicSegmentNames[i];
					result[optionName] = o[i + 1] != null ? o[i + 1] : this.defaults[optionName];
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
		private function _createRegExp():void
		{
			this._tokenize(this._patternSource);
			this._regExp = new RegExp("\\A" + this._getRegExpSource(this._tokenizedPattern) + "\\Z");
		}


		/**
		 *
		 * Escapes a String for use in a RegExp	
		 * 
		 */
		private function _escapeForRegExp(input:String):String
		{
// TODO: This needs to escape more characters.
			return input.replace("\\", "\\\\").replace("/", "\\/");
		}


		/**
		 *
		 * Creates a regular expression source string for matching urls against
		 * this route.
		 *
		 */		 		 		 		
		private function _getRegExpSource(segments:Array, wrap:Boolean = true):String
		{
			// Create the regexp from the tokenized pattern.
			var segment:Object;
			var source:String = "";
			var segmentSource:String = "";
			var optional:Boolean;
			var i:int, j:int;
			for (i = 0; i < segments.length; i++)
			{
				segment = segments[i];

				switch (segment.type)
				{
					case TEXT:
						source += this._escapeForRegExp(segment.value);
						break;
					case SEPARATOR:
						// Determine whether the separator is optional based on whether subsequent parts are optional.
						optional = true;

						for (j = i + 1; j < segments.length; j++)
						{
							switch (segments[j].type)
							{
								case TEXT:
									optional = false;
									break;
								case DYNAMIC:
									optional = this.defaults[segments[j].name] != null;
									break;
							}
							if (!optional) break;
						}

						if (!optional)
						{
							source += this._escapeForRegExp(segment.type == DYNAMIC ? segment.name : segment.value);
						}
						else
						{
							var remainingSegments:Array = segments.slice(i + 1);

							if (!remainingSegments.length || ((remainingSegments.length == 1) && (remainingSegments[0].type == SEPARATOR)))
							{
								source += "\\/?";
							}
							else
							{
								return source + "(?:\\/?\\Z|\\/" + this._getRegExpSource(remainingSegments) + ")";
							}
						}
						break;
					case DYNAMIC:
						var requirement:RegExp = this.requirements[segment.name];
						segmentSource = requirement ? "(" + requirement.source + ")" : "([^\\/;.,?]+)";
						source += segmentSource;
						break;
				}
			}

			return source;
		}


		/**
		 * Tokenizes a string.
		 */
		private function _tokenize(pattern:String):Array
		{
// TODO: Need to do some cleaning up here. For example, normalize the path.
			// Get the dynamic segments.
			var dynamicSegments:Array = pattern.match(/:([\w]+)/g);

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
			// Tokenize the pattern.
			//

			// Add a trailing slash.
			pattern = pattern.replace(/\/?$/, "/");
			var a:Array = [pattern];

			// Make dynamic parts into tokens
			for each (var dynamicSegment:String in dynamicSegments)
			{
				this._replaceWithToken(a, dynamicSegment, DYNAMIC);
			}

			// Make separators into tokens.
			this._replaceWithToken(a, "/", SEPARATOR);

			// Make remaining strings into tokens.
			for (i = 0; i < a.length; i++)
			{
				if (a[i] is String)
				{
					a.splice(i, 1, {value: a[i], type: TEXT});
				}
			}
			return this._tokenizedPattern = a;
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
						if (type == DYNAMIC)
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
						if (tmp[j] == "")
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
