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
		private var _className:String;
		private static var _properties2Relationships:Object;
		private static var _dynamicProperties:Object;


		/**
		 *
		 */
		public function DomainModel()
		{
			this._className = getQualifiedClassName(this).replace(/::/, ".");
		}


		/**
		 *	
		 */
		protected static function addProperty(theClass:Class, property:String, options:Object = null):void
		{
			if (!property)
				throw new ArgumentError("Property name must be a non-empty, non-null String.");

			var className:String = _getClassName(theClass);

			// Add the property to the list of properties.
			_dynamicProperties = _dynamicProperties || {};
			_dynamicProperties[className] = _dynamicProperties[className] || [];
			if (_dynamicProperties[className].indexOf(property) == -1)
				_dynamicProperties[className].push(property);
			else
				throw new ArgumentError('Property "' + property + '" already defined on ' + theClass);

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
// TODO: Defer creation of relationship until when you access it.
			// Create the relationship and add it to the map.
			var relationship:IRelationship = new relationshipClass();
			_properties2Relationships = _properties2Relationships || {};
			var relationshipMap:Object = _properties2Relationships[className] || (_properties2Relationships[className] = {});
			relationshipMap[property] = relationship;
		}


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
			// Look up the relationship.
			var relationship:IRelationship = (_properties2Relationships && _properties2Relationships[this._className] && _properties2Relationships[this._className][name]) as IRelationship;
			if (relationship)
			{
				trace(name + ":\t" + relationship);
return relationship;
			}
			
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
			DATA_MAPPER_CONFIG.getDataMapper(this._className).load(this, conditions);
		}


		/**
		 *	@inheritDoc
		 */
		public function save():void
		{
			DATA_MAPPER_CONFIG.getDataMapper(this._className).save(this, true);
		}



		private static function _getClassName(classOrClassName:Object):String
		{
			if (classOrClassName is Class)
				return getQualifiedClassName(classOrClassName as Class).replace(/::/, ".");
			else if (classOrClassName is String)
				return classOrClassName as String;
			
			throw new ArgumentError();
		}






		//
		// flash_proxy methods
		//


		/**
		 * @private
		 */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
	        return super.flash_proxy::hasProperty(name) || (_dynamicProperties && _dynamicProperties[this._className] && (_dynamicProperties[this._className].indexOf(name) != -1));
	    }


		override protected function _getPropertyList():Array
		{
			// Add the dynamic properties that were added using instance.propName = value.
			var propertyList:Array = super._getPropertyList();

			// Add the dynamic properties that were added using addProperty.
			if (_dynamicProperties && _dynamicProperties[this._className])
// TODO: Would splice be faster?
				propertyList = propertyList.concat.apply(null, _dynamicProperties[this._className]);

			return propertyList;
		}






	}
}