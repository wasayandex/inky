package inky.orm.relationships 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.02.05
	 *
	 */
	public class RelationshipFactory
	{
		private static var _instance:RelationshipFactory;
		
		/**
		 *
		 */
		public function RelationshipFactory()
		{
			if (_instance)
				throw new ArgumentError();
		}
		
		
		/**
		 *	
		 */
		public function createRelationship(className:String, property:String, options:Object):IRelationship
		{
			options = options || {};
			var relationshipClass:Class = this._getRelationshipClass(className, property, options);

			// Create the relationship.
			var relationship:IRelationship = new relationshipClass();
			relationship.setup(className, property, options);
			return relationship;
		}
		
		
		/**
		 * 
		 */
		private function _getRelationshipClass(className:String, property:String, options:Object):Class
		{
			var relationshipClass:Class = (options && options.relationship) as Class;
			if (!relationshipClass)
			{
				// If the relationship type wasn't explicitly specified, infer it from the property name.			
// TODO: More advanced lexical analysis.
				var relationshipType:String;
				if (options && options.relationshipType)
				 	relationshipType = options.relationshipType;
				else
					relationshipType = property.substr(-1) == "s" ? RelationshipType.HAS_MANY : RelationshipType.HAS_ONE;

				switch (relationshipType)
				{
					case RelationshipType.HAS_ONE:
					{
						relationshipClass = OneToOne;
						break;
					}
					case RelationshipType.HAS_MANY:
					{
						relationshipClass = OneToMany;
						break;
					}
					default:
					{
						throw new ArgumentError("Invalid relationship type: \"" + relationshipType + "\".");
						break;
					}
				}
			}
			
			return relationshipClass;
		}



		/**
		 *	
		 */
		public static function getInstance():RelationshipFactory
		{
			return _instance || (_instance = new RelationshipFactory());
		}
		getInstance();
	}
	
}
