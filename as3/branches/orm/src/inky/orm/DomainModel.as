package inky.orm 
{
	import inky.utils.ObjectProxy;
	import inky.async.AsyncToken;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import inky.orm.relationships.RelationshipType;
	import inky.orm.relationships.OneToOne;
	import inky.orm.relationships.OneToMany;
	import inky.orm.relationships.IRelationship;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;

	use namespace flash_proxy;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.09.28
	 *
	 */
	public class DomainModel extends ObjectProxy
	{
		private var _class:Class;
		private static var _properties2Relationships:Dictionary = new Dictionary(true);


		/**
		 *
		 */
		public function DomainModel()
		{
			this._class = Class(getDefinitionByName(getQualifiedClassName(this)));
		}


		/**
		 *	
		 */
		public static function addProperty(theClass:Class, property:String, options:Object = null):void
		{
			if (!property)
				throw new ArgumentError("Property name must be a non-empty, non-null String.");

			var relationshipClass:Class = (options && options.relationship) as Class;
			if (!relationshipClass)
			{
				// If the relationship type wasn't explicitly specified, infer it from the property name.			
// TODO: More advanced lexical analysis.
				var relationshipType:String;
				if (options)
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

			// Create the relationship and add it to the map.
			var relationship:IRelationship = new relationshipClass();
			var relationshipMap:Object = _properties2Relationships[theClass] || (_properties2Relationships[theClass] = {});
			relationshipMap[property] = relationship;
trace("Related:\t" + theClass + "\t" + property + "\t" + relationship);
// TODO: create the relationship.
		}


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
trace("!");
			return super.flash_proxy::getProperty(name);
	    }


		/**
		 *	
		 */
		public function save():AsyncToken
		{
			return null;
		}


	}
}