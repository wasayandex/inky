package inky.framework.utils
{
	/**
	 *
	 *  Based on <http://livedocs.adobe.com/labs/flex/3/langref/mx/utils/URLUtil.html>
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2007.11.14
	 *
	 */
	public class URLUtil
	{
		// Holds the default ports for given protocols.
		private static var _defaultPorts:Object = {
			http: 80,
			rtmp: 1935,
			rtmpt: 80,
			rtmps: 443
		}




		/**
		 *
		 *	
		 */
		public function URLUtil()
		{
			throw new Error('URLUtil contains static utility methods and cannot be instantialized.');
		}




		//
		// public static methods
		//
		

		/**
		 *
		 * Converts a potentially relative URL to a full qualified URL. If the
		 * URL is not relative, it is just returned as is. If the URL starts
		 * with a slash, the host and port from the root URL are prepended.
		 * Otherwise, the host, port, and path are prepended.
		 *
		 * @param rootURL:String
		 *     URL used to resolve url, if url is relative.		 
		 * @param url:String
		 *     URL to convert.
		 * @return String
		 *     Fully qualified URL.		 
		 *	
		 */
		public static function getFullURL(rootURL:String, url:String):String
		{
			if (!rootURL) return url;
			else if (url.indexOf('://') != -1) return url;
			else
			{
				rootURL = rootURL.lastIndexOf('/') == rootURL.length - 1 ? rootURL : rootURL + '/';
			
				if (url.charAt(0) == '/')
				{
					var tmp:int = rootURL.indexOf('://');
					
					if (tmp == -1)
					{
						return url;
					}
					
					var slashIndex:int = rootURL.indexOf('/', tmp + 3);
					slashIndex = slashIndex == -1 ? rootURL.length : slashIndex;
					return rootURL.substr(0, slashIndex) + '/' + url.substr(1);
				}
				else return rootURL + url;
			}
			
			throw new ArgumentError('Unable to resolve URL');
		}


		/**
		 *
		 * Pull the port out of a URL.
		 * 
		 * @param url:String		 		 
		 *	
		 */
		public static function getPort(url:String):uint
		{
			var tmp:int = url.indexOf('://');
			if (tmp == -1) return 0;
			
			var startIndex:int = url.indexOf(':', tmp + 3) + 1;
			return parseInt(url.substr(startIndex)) || URLUtil._getDefaultPort(URLUtil.getProtocol(url));
		}

		
		/**
		 *
		 * Returns the protocol section of the specified url.
		 * 
		 * @param url:String
		 *     String containing the url to parse.		 
		 * @return String
		 *     String containing the protocol or an empty string if no protocol
		 *     is specified.
		 *		 
		 */
		public static function getProtocol(url:String):String
		{
			var endIndex:uint = url.indexOf(':/');
			if (endIndex == -1) return '';
			return url.substr(0, endIndex);
		}
		
		
		/**
		 *
		 * Pull the server name out of a URL.
		 * 
		 * @param url:String
		 * @return String		 		 		 
		 *
		 */
		public static function getServerName(url:String):String
		{
			var tmp:int = url.indexOf('://');
			if (tmp == -1) return '';
			
			var colonIndex:int = url.indexOf(':', tmp + 3);
			var slashIndex:int = url.indexOf('/', tmp + 3);
			var endIndex:int = Math.min(colonIndex == -1 ? url.length : colonIndex, slashIndex == -1 ? url.length : slashIndex);
			return url.substring(tmp + 3, endIndex);
		}
		
		
		/**
		 *
		 * Pull the domain and port information out of a URL.
		 *
		 * @param url:String
		 * @return String		 
		 *		 		 
		 */
		public static function getServerNameWithPort(url:String):String
		{
			var tmp:int = url.indexOf('://');
			if (tmp == -1) return '';
			
			var slashIndex:int = url.indexOf('/', tmp + 3);
			return url.substring(tmp + 3, slashIndex == -1 ? url.length : slashIndex);
		}
		
		
		/**
		 *
		 *
		 *
		 */
		public static function isHttpsURL(url:String):Boolean
		{
			return url.indexOf('https://') == 0;
		}
		
		
		/**
		 *
		 *
		 *
		 */
		public static function isHttpURL(url:String):Boolean
		{
			switch (url.substr(url.indexOf('://')))
			{
				case 'http':
				case 'https':
				case 'rtmp':
					return true;
			}
			
			return false;
		}	 		




		//
		// private static methods
		//


		/**
		 *
		 *
		 *
		 */		 		 		 		
		private static function _getDefaultPort(protocol:String):uint
		{
			return URLUtil._defaultPorts[protocol.toLowerCase()] || 0;
		}




	}
}
