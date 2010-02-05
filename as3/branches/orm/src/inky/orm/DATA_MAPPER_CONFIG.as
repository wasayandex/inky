package inky.orm 
{
	
	/**
	 *
	 *  Stores metadata about data mapper model classes.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.02.04
	 *
	 */
	public const DATA_MAPPER_CONFIG:Object = new DataMapperConfig();
	
}


import flash.utils.getQualifiedClassName;
import inky.orm.IDataMapper;
class DataMapperConfig
{
	private var _dataMappers:Object;


	/**
	 *
	 */
	public function DataMapperConfig()
	{
		this._dataMappers = {};
	}


	/**
	 * 
	 */
	public function getDataMapper(classOrClassName:Object):IDataMapper
	{
		return this._dataMappers[_getClassName(classOrClassName)];
	}


	/**
	 * 
	 */
	public function setDataMapper(classOrClassName:Object, dataMapper:IDataMapper):void
	{
		var className:String = _getClassName(classOrClassName);
		this._dataMappers[className] = dataMapper;
	}


	/**
	 * 
	 */
	private static function _getClassName(classOrClassName:Object):String
	{
		var className:String;
		if (classOrClassName is Class)
		 	className = getQualifiedClassName(classOrClassName as Class).replace(/::/, ".");
		else if (classOrClassName is String)
		 	className = classOrClassName as String;
		else
			throw new Error();
		return className;
	}
	
}
