package inky.orm 
{
	import inky.utils.ObjectProxy;
	import flash.utils.getQualifiedClassName;
	import inky.orm.relationships.RelationshipType;
	import inky.orm.relationships.OneToOne;
	import inky.orm.relationships.OneToMany;
	import inky.orm.relationships.IRelationship;
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	import inky.orm.IDataMapper;
	import inky.orm.DATA_MAPPER_CONFIG;

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
		private var _className:String;
		private static var _properties2Relationships:Dictionary = new Dictionary(true);


		/**
		 *
		 */
		public function DomainModel()
		{
			this._className = getQualifiedClassName(this).replace(/::/, ".");
//			this._class = Class(getDefinitionByName(this._className));
		}


		/**
		 *	
		 */
		protected static function addProperty(theClass:Class, property:String, options:Object = null):void
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
		}


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
/*var o:Object = _properties2Relationships[this._class];
var r:Object = o ? o[name] : null;
trace("getting\t" + name + "\t" + r);*/
			return super.flash_proxy::getProperty(name);
	    }


		/**
		 *	@inheritDoc
		 */
		public function load(conditions:Object):void
		{
			this._getDataMapper().load(this, conditions);
		}


		/**
		 *	@inheritDoc
		 */
		public function save():void
		{
			this._getDataMapper().save(this, true);
		}
		
		
		
		/**
		 *	
		 */
		private function _getDataMapper():IDataMapper
		{
			var config:Object = DATA_MAPPER_CONFIG[this._className];
			if (!config)
				throw new Error(this._className + " has not been configured.");
			var dataMapper:IDataMapper = config.dataMapper;
			if (!dataMapper)
				throw new Error("No data mapper set for " + this._className);
			return dataMapper;
		}


	}
}