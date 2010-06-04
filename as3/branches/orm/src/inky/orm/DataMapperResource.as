package inky.orm 
{
	import inky.utils.ObjectProxy;
	import flash.utils.getQualifiedClassName;
	import inky.orm.relationships.IRelationship;
	import flash.utils.flash_proxy;
	import inky.orm.DATA_MAPPER_CONFIG;
	import inky.orm.relationships.RelationshipFactory;
	import inky.orm.reflection.IReflector;
	import inky.orm.reflection.ReflectorRegistry;
	import inky.orm.relationships.RelationshipRegistry;
	import inky.orm.reflection.fieldData.RelationshipData;
	import inky.orm.IDataMapper;
	import inky.orm.reflection.MetadataReflector;

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
	public class DataMapperResource extends ObjectProxy
	{
		private var className:String;
		private static var reflectorRegistry:ReflectorRegistry;
		private static var relationshipRegistry:RelationshipRegistry;
		private static var relationshipFactory:RelationshipFactory;

		/**
		 *
		 */
		public function DataMapperResource()
		{
			this.className = getQualifiedClassName(this);
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * 
		 */
		public static function getDataMapper(clazz:Object):IDataMapper
		{
			return null;
		}

/**
 *	@inheritDoc
 */
public function load(conditions:Object):void
{
	DATA_MAPPER_CONFIG.getDataMapper(this.className).load(this, conditions);
}

/**
 *	@inheritDoc
 */
public function save():void
{
	DATA_MAPPER_CONFIG.getDataMapper(this.className).save(this, true);
}

		//---------------------------------------
		// flash_proxy methods
		//---------------------------------------

		/**
		 * @private
		 */
	    override flash_proxy function getProperty(name:*):*
	    {
			if (!this.hasOwnProperty(name))
				throw new ReferenceError("Property " + name + " not found on " + this.className + ". Add an accessor or variable to your class definition.");

			var value:* = super.flash_proxy::getProperty(name);
		
			if (!value)
			{
				// Look up the relationship.
				var relationship:IRelationship = this.getRelationship(name);
				if (relationship)
					value = relationship.evaluate(this);
			}

			return value;
	    }

		/**
		 * @private
		 */
	    override flash_proxy function hasProperty(name:*):Boolean
	    {
	        return super.flash_proxy::hasProperty(name) || this.getReflector().hasProperty(name);
	    }

		/**
		 * @inheritDoc
		 */
	    override flash_proxy function setProperty(name:*, value:*):void
		{
			if (!this.hasOwnProperty(name))
				throw new ReferenceError("Property " + name + " not found on " + this.className + ". Add an accessor or variable to your class definition.");
			super.flash_proxy::setProperty(name, value);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function getReflector():IReflector
		{
			// Create a registry for storing reflectors if it hasn't already been created.
			if (!DataMapperResource.reflectorRegistry)
				DataMapperResource.reflectorRegistry = new ReflectorRegistry();

			// Fetch the registered reflector from the registry, creating it if necessary.
			var reflector:IReflector = DataMapperResource.reflectorRegistry.get(this.className)
			if (!reflector)
			{
				reflector = this._createReflector();
				DataMapperResource.reflectorRegistry.put(this.className, reflector);
			}
			return reflector;
		}

		/**
		 *	
		 */
		private function getRelationship(property:String):IRelationship
		{
			var reflector:IReflector = this.getReflector();
			if (!DataMapperResource.relationshipRegistry)
				DataMapperResource.relationshipRegistry = new RelationshipRegistry();
			var relationship:IRelationship = DataMapperResource.relationshipRegistry.get(this.className, property);
			if (!relationship)
			{
				var options:RelationshipData = this.getReflector().getRelationshipData(property);
				if (options)
				{
					relationship = this._createRelationship(options);
					DataMapperResource.relationshipRegistry.put(this.className, property, relationship);
				}
			}

			return relationship;
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------

		/**
		 * 
		 */
		protected function _createRelationship(options:RelationshipData):IRelationship
		{
			if (!DataMapperResource.relationshipFactory)
				DataMapperResource.relationshipFactory = new RelationshipFactory();
			return DataMapperResource.relationshipFactory.createRelationship(options);
		}

		/**
		 * Creates a type reflector for this class. Although this is a class method (non-static), it is only called once per type.
		 */
		protected function _createReflector():IReflector
		{
			return new MetadataReflector(this);
		}

		/**
		 * @inheritDoc
		 */
		override protected function _getPropertyList():Array
		{
			return this.getReflector().propertyList;
		}

	}
}