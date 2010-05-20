package inky.orm.relationships 
{
	import inky.orm.inspection.RelationshipData;
	
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
		
		/**
		 *	
		 */
		public function createRelationship(className:String, property:String, options:RelationshipData):IRelationship
		{
			options = options || new RelationshipData();
			var relationshipClass:Class = this.getRelationshipClass(className, property, options);

			// Create the relationship.
			var relationship:IRelationship = new relationshipClass();
			relationship.setup(className, property, options);
			return relationship;
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function getRelationshipClass(className:String, property:String, options:RelationshipData):Class
		{
// TODO: More advanced lexical analysis.
			var relationshipClass:Class;
			var relationshipType:String;
			if (options && options.relationshipType)
			 	relationshipType = options.relationshipType;
			else
				// If the relationship type wasn't explicitly specified, infer it from the property name.			
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

			return relationshipClass;
		}

	}
	
}