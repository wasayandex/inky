package inky.serialization.deserializers.xml 
{
	import inky.serialization.deserializers.ICollectionDeserializer;
	import flash.utils.getQualifiedClassName;
	import inky.app.inky;
	import inky.serialization.deserializers.IDeserializer;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.12.19
	 *
	 */
	public class XMLListDeserializer implements ICollectionDeserializer
	{
		private var _list:XMLList;
		private var _typesToQNames:Object;
		private var _qNameHashesToDeserializers:Object;


		/**
		 *
		 */
		public function XMLListDeserializer(list:XMLList)
		{
			if (!list)
				throw new ArgumentError("Null argument not allowed.");
			this._list = list;
			this._typesToQNames = {};
			this._qNameHashesToDeserializers = {};
		}


		/**
		 * @inheritDoc
		 */
		public function deserializeType(type:Object):Array
		{
			var qName:QName = this._getQNameFor(type);
			var deserializer:IDeserializer = this.getTypeDeserializer(type);

			if (!deserializer)
				throw new ArgumentError("No deserializer registered for " + type);

			var elementsToDeserialize:XMLList = this._list.(name() && name().uri == qName.uri && name().localName == qName.localName);
			var objects:Array = [];
			for each (var element:XML in elementsToDeserialize)
			{
				objects.push(deserializer.deserialize(element));
			}

			return objects;
		}


		/**
		 * @inheritDoc
		 */
		public function deserializeAll():Array
		{
// TODO: Implement this.
throw new Error("Not yet implemented");
		}


		/**
		 * @inheritDoc
		 */
		public function getTypeDeserializer(type:Object):IDeserializer
		{
			var qName:QName = this._getQNameFor(type);
			var hash:String = this._getQNameHash(qName);
			return this._qNameHashesToDeserializers[hash] || null;
		}


		/**
		 * @inheritDoc
		 */
		public function registerTypeDeserializer(type:Object, deserializer:IDeserializer):void
		{
			var oldValue:IDeserializer = this.getTypeDeserializer(type);
			if (oldValue != deserializer)
			{
				var typeName:String = this._getTypeName(type);
				var qName:QName = this._getQNameFor(typeName);
				var qNameHash:String = this._getQNameHash(qName);

				this._typesToQNames[typeName] = qName;
				this._qNameHashesToDeserializers[qNameHash] = deserializer;
			}			
		}








		/**
		 * Creates a hash unique to the given QName
		 */
		private function _getQNameHash(qName:QName):String
		{
			return qName.uri + "::" + qName.localName;
		}
		
		
		/**
		 * Gets a QName that represents the given type.
		 */
		private function _getQNameFor(type:Object):QName
		{
			var typeName:String = this._getTypeName(type);

			if (!typeName)
				throw new ArgumentError("Invalid type parameter");

			var qName:QName = this._typesToQNames[typeName];
			if (!qName)
			{
				// Derive a QName from the type (in order to match the elements in the list)
				var parts:Array = typeName.split(".");
				var localName:String = String(parts.pop());
				var uri:String;
				if (parts.length)
				{
					if (parts[0] == "inky")
					 	uri = inky.uri;
					else
						uri = parts.join(".") + ".*";
				}
				qName = new QName(uri || "", localName);
			}

			return qName;
		}


		/**
		 * 
		 */
		private function _getTypeName(type:Object):String
		{
			var typeName:String = null;
			if (type is String)
				typeName = String(type).replace("::", ".");
			else if (type is Class)
				typeName = getQualifiedClassName(type as Class).replace("::", ".");

			return typeName;
		}


	}
	
}