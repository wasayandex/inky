package inky.loading.utils 
{
	import flash.net.URLRequest;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.11.25
	 *
	 */
	public function toURLRequest(url:Object):URLRequest
	{
		var request:URLRequest;
		if (url is String)
			request = new URLRequest(url as String);
		else if (url is URLRequest)
			request = url as URLRequest;
		else
			throw new ArgumentError();
		return request;
	}
	
}
