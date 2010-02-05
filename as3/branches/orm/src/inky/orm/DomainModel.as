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
	import inky.orm.relationships.RelationshipFactory;

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
		private static var _dynamicProperties:Object;
		private static var _relationships:Object;
		private static var _relationshipOptions:Object;
		private static var _relationshipFactory:RelationshipFactory = RelationshipFactory.getInstance();


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
		protected static function defineRelationship(theClass:Class, property:String, options:Object = null):void
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

			// Save the relationship options.
			_relationshipOptions = _relationshipOptions || {};
			_relationshipOptions[className] = _relationshipOptions[className] || {};
			_relationshipOptions[className][property] = options || {};

// FIXME: How can we avoid creating the relationship here?			
if (_getRelationship(className, property) is OneToOne)
	_dynamicProperties[className].push(property + "Id");
		}


		/**
		 *	
		 */
		private static function _getRelationship(className:String, property:String):IRelationship
		{
			var relationship:IRelationship = (_relationships && _relationships[className] && _relationships[className][property]) as IRelationship;
			if (!relationship)
			{
				var options:Object = _relationshipOptions && _relationshipOptions[className] && _relationshipOptions[className][property];
				if (options)
				{
					_relationships = _relationships || {};
					_relationships[className] = _relationships[className] || {};
					_relationships[className][property] =
					relationship = _relationshipFactory.createRelationship(className, property, options);
				}
			}

			return relationship;
		}
			
	


		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
			var value:*;
		
			// Look up the relationship.
			var relationship:IRelationship = _getRelationship(this._className, name);
			if (relationship)
				value = relationship.evaluate(this);
			else
				value = super.flash_proxy::getProperty(name);
			return value;
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

			// Add the dynamic properties that were added using defineRelationship.
			if (_dynamicProperties && _dynamicProperties[this._className])
// TODO: Would splice be faster?
				propertyList = propertyList.concat.apply(null, _dynamicProperties[this._className]);

			return propertyList;
		}





	}
}