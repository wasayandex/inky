package inky.orm.inspection 
{
	import inky.orm.inspection.ITypeInspector;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.05.19
	 *
	 */
	public class XMLTypeInspector implements ITypeInspector
	{
		private var xml:XML;
		private var dataCache:Object = {};
		private var _propertyList:Array;
		
		/**
		 *
		 */
		public function XMLTypeInspector(xml:XML)
		{
			this.xml = xml;
		}
		
		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function get propertyList():Array
		{
			if (!this._propertyList)
			{
				this._propertyList = [];
				for each (var property:XML in this.xml.property)
				{
					this._propertyList.push(String(property.@name));
				}
			}
			return this._propertyList;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function getRelationshipData(property:String):RelationshipData
		{
			var isDefined:Boolean = this.dataCache[property] !== undefined;
			var data:RelationshipData;
			if (!isDefined)
			{
				var propertyNode:XML = this.xml.property.(@name == property)[0];
				if (propertyNode.@relationshipType.length())
				{
					data = new RelationshipData();
					var relationshipType:String = propertyNode.@relationshipType;
					data.relationshipType = relationshipType;
				}
				else
				{
					data = null;
				}
				
				this.dataCache[property] = data;
			}
			return data;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasProperty(propertyName:*):Boolean
		{
			return this.xml.property.(@name == propertyName).length() != 0;
		}

	}
	
}