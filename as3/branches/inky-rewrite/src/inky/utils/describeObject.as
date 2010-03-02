package inky.utils
{


	/**
	 *
	 *	
	 */
	public function describeObject(object:Object, deep:Boolean = false):String
	{
		return DescribeObjectHelper.getObjectDescription(object, deep);
	}


}




import flash.utils.describeType;
import flash.utils.getQualifiedClassName;
import inky.utils.UIDUtil;

class DescribeObjectHelper
{


	/**
	 * 
	 */
	public static function getObjectDescription(object:Object, deep:Boolean = false, nestLevel:int = 0, describedObjects:Object = null):String
	{
		if (_objIsPrimitive(object))
			return String(object);

		var uid:String = UIDUtil.getUID(object);
		var uidString:String = "(uid:" + uid + ")";
		
		if (describedObjects && describedObjects[uid])
			return "<Reference to object with uid " + uid + ">";

		if (deep)
		{
			describedObjects = describedObjects || {};
			describedObjects[uid] = true;
		}

		var propertyDescriptions:Array = [];
		
		var readProperties:Object = {};
		var typeDescription:XML = describeType(object);
		var properties:XMLList = typeDescription.variable + typeDescription.accessor;

		// Get class properties.
		for each (var prop:XML in properties)
		{
			var propName:String = prop.@name;
			if (!readProperties[propName] && !prop.@access.length() || (prop.@access.toString().indexOf("read") != -1))
				propertyDescriptions.push(_getPropertyDescription(object, prop.@name, deep, nestLevel + 1, describedObjects));
			readProperties[propName] = true;
		}

		// Get dynamic properties.
		for (var p:String in object)
		{
			if (!readProperties[p])
				propertyDescriptions.push(_getPropertyDescription(object, p, deep, nestLevel + 1, describedObjects));
			readProperties[p] = true;
		}
		
		var output:String;
		var className:String = getQualifiedClassName(object) +  " " + uidString;
		
		if (propertyDescriptions.length)
		{
			var indent:String = _getIndentation(nestLevel);
			output = className + " {\n" + propertyDescriptions.join("\n") + "\n" + indent + "}";
		}
		else
		{
			output = className + " {}";
		}

		return output;
	}


	/**
	 * 
	 */
	private static function _objIsPrimitive(object:Object):Boolean
	{
		return object is Number || object is String || object is Boolean || object is XML || object == null;
	}


	/**
	 * 
	 */
	private static function _getPropertyDescription(object:Object, propName:String, deep:Boolean, nestLevel:int, describedObjects:Object):String
	{
		var propValue:* = object[propName];
		var valueDescription:String;
		if (!deep || _objIsPrimitive(propValue))
			valueDescription = String(propValue);
		else
			valueDescription = getObjectDescription(object[propName], deep, nestLevel, describedObjects);
		return _getIndentation(nestLevel) + propName + ":\t" + valueDescription;
	}


	/**
	 * 
	 */
	public static function _getIndentation(nestLevel:uint):String
	{
		var out:String = "";
		for (var i:int = 0; i < nestLevel; i++)
			out += "\t";
		return out;
	}


}