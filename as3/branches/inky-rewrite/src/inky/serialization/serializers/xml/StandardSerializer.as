package inky.serialization.serializers.xml
{
	import inky.serialization.serializers.xml.IXMLSerializer;
	import flash.utils.describeType;
	
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
	public class StandardSerializer implements IXMLSerializer
	{
		
		/**
		 *	@inheritDoc
		 */
		public function serializeToXML(object:Object, deep:Boolean = false):XML
		{
// TODO: Use better reflection techniques, or at least a describeType cache
			var typeDescription:XML = describeType(object);
			var className:String = typeDescription.@name;
			var pkg:String = "";
			var result:XML;

			if (this._isPrimitiveType(object))
			{
				result = <value>{String(object)}</value>.*[0];
			}
			else
			{
// TODO: Throw error if the constructor has required arguments?
				if (className.indexOf("::") != -1)
				{
					var parts:Array = className.split("::");
					className = parts[1];
					pkg = parts[0] + ".*";
					result = <{"ns:" + className} xmlns:ns={pkg} />;
				}
				else
				{
					result = <{className} />;
				}

				// Serialize the properties.
				for each (var prop:XML in typeDescription.accessor.(@access == "readwrite") + typeDescription.variable)
				{
					var propType:String = prop.@type;
					var isPrimitive:Boolean;
					var propName:String = prop.@name;

					switch (propType)
					{
						case "int":
						case "uint":
						case "Number":
						case "String":
						case "Boolean":
						{
							isPrimitive = true;
							break;
						}
						default:
						{
							isPrimitive = false;
							break;
						}
					}
				
					if (isPrimitive || deep)
					{
						var serializedProperty:XML = <{propName} />;
						serializedProperty.appendChild(this.serializeToXML(object[propName]));
						result.appendChild(serializedProperty);
					}
				}
			}

			return result;
		}



		private function _isPrimitiveType(object:Object):Boolean
		{
			var type:String = typeof object;
			return type == "number" || type == "string" || type == "boolean";
		}


		/**
		 *	@inheritDoc
		 */
		public function serialize(object:Object, deep:Boolean = false):Object
		{
			return this.serializeToXML(object);
		}




	}
	
}