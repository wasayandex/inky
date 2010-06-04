package inky.orm.reflection.fieldData 
{
	
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
	public class RelationshipData
	{
		public var className:String;
		public var propertyName:String;
		public var relationshipType:String;
		public var key:String = "id";
		public var options:Object;

		/**
		 *
		 */
		public function RelationshipData(className:String, propertyName:String, relationshipType:String, options:Object = null)
		{
			this.className = className;
			this.propertyName = propertyName;
			this.relationshipType = relationshipType;
			this.options = options || {};
		}
	}
	
}
