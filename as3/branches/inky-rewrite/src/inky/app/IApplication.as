package inky.app 
{
	import inky.utils.IDisplayObject;
	import inky.serialization.deserializers.IDeserializer;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.11.16
	 *
	 */
	public interface IApplication extends IDisplayObject
	{

		function get model():Object;
		function set model(value:Object):void;
		
		

		
	}
	
}