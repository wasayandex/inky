package inky.orm.reflection 
{
	import inky.orm.reflection.IReflector;
	import inky.orm.reflection.fieldData.PropertyData;
	import inky.orm.reflection.fieldData.RelationshipData;
	import inky.orm.relationships.RelationshipType;
	import flash.utils.describeType;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.06.03
	 *
	 */
	public class MetadataReflector implements IReflector
	{
		private static const PROPERTY_TAG:String = "Property";
		private static const BELONGS_TO_TAG:String = "BelongsTo";
		private static const HAS_ONE_TAG:String = "HasOne";
		private static const HAS_MANY_TAG:String = "HasMany";
		
		private static const tagsToTypes:Object = {};
		tagsToTypes[BELONGS_TO_TAG] = RelationshipType.BELONGS_TO;
		tagsToTypes[HAS_ONE_TAG] = RelationshipType.HAS_ONE;
		tagsToTypes[HAS_MANY_TAG] = RelationshipType.HAS_MANY;
		
		private var subject:Object;
		private var typeDataIsParsed:Boolean;
		private var _propertyList:Array = [];
		private var propertyData:Object = {};
		private var relationshipData:Object = {};

		/**
		 *
		 */
		public function MetadataReflector(subject:Object)
		{
			this.subject = subject;
		}

		/**
		 * @inheritDoc
		 */
		public function get propertyList():Array
		{
			if (!this.typeDataIsParsed)
				this.parseTypeData();
			
			return this._propertyList;
		}

		/**
		 * @inheritDoc
		 */
		public function getPropertyData(property:String):PropertyData
		{
			if (!this.typeDataIsParsed)
				this.parseTypeData();
			return this.propertyData[property];
		}

		/**
		 * @inheritDoc
		 */
		public function getRelationshipData(property:String):RelationshipData
		{
			if (!this.typeDataIsParsed)
				this.parseTypeData();
			return this.relationshipData[property];
		}

		/**
		 * @inheritDoc
		 */
		public function hasProperty(name:*):Boolean
		{
			if (!this.typeDataIsParsed)
				this.parseTypeData();
			return this.propertyData[name] || this.relationshipData[name];
		}


		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function parseTypeData():void
		{
			if (this.typeDataIsParsed)
				return;
			this.typeDataIsParsed = true;

			// Get the type description and then null the subject reference so we don't keep it in memory.
			var typeDescription:XML = describeType(this.subject);
			this.subject = null;
			
			for each (var metadata:XML in typeDescription.metadata)
			{
				var tagName:String = metadata.@name;
				switch (tagName)
				{
					case PROPERTY_TAG:
					case BELONGS_TO_TAG:
					case HAS_MANY_TAG:
					case HAS_ONE_TAG:
					{
						var propertyNameArguments:XMLList = (metadata.arg.(@key == "name") + metadata.arg.(@key == ""));
						
						if (propertyNameArguments.length() == 0)
							throw new Error(tagName + " tag is missing a property name:\n" + metadata.toXMLString());
						else if (propertyNameArguments.length() > 1)
							throw new Error(tagName + " tag may only have one name argument (an argument with the key \"name\" or an empty key)\n" + metadata.toXMLString());

						var propertyName:String = propertyNameArguments[0].@value;

						if (tagName == PROPERTY_TAG)
						{
							this._propertyList.push(propertyName);
							this.propertyData[propertyName] = new PropertyData(propertyName);
						}
						else
						{
							var relationshipType:String = MetadataReflector.tagsToTypes[tagName];
							var className:String = typeDescription.@name;
							this.relationshipData[propertyName] = new RelationshipData(className, propertyName, relationshipType);
						}
						break;
					}
				}
			}
		}
		
	}
	
}