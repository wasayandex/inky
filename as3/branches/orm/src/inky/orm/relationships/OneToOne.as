package inky.orm.relationships 
{
	import inky.orm.relationships.IRelationship;
	import inky.orm.IDataMapper;
	import inky.orm.DATA_MAPPER_CONFIG;
	import inky.utils.getClass;
	import inky.utils.describeObject;
	import inky.orm.reflection.fieldData.RelationshipData;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.10.08
	 *
	 */
	public class OneToOne implements IRelationship
	{
		private var _className:String;
		private var _property:String;
		private var _options:Object;

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function evaluate(model:Object):*
		{
			var relatedObject:Object;
			var key:String = this.getKey();
			var relatedKeyValue:String = model[key];

			if (relatedKeyValue)
			{
				var relatedClass:String = this.getRelatedClass();
				var dataMapper:IDataMapper = DATA_MAPPER_CONFIG.getDataMapper(relatedClass);
				var relatedClassConstructor:Class = getClass(relatedClass);
				relatedObject = new relatedClassConstructor();
				var relatedKey:String = this.getRelatedKey(relatedClass);
				var query:Object = {};
				query[relatedKey] = relatedKeyValue;
				relatedObject = dataMapper.load(relatedObject, query);
			}

			return relatedObject;
		}

		/**
		 * @inheritDoc
		 */
		public function setup(relationshipData:RelationshipData):void
		{
			this._className = relationshipData.className;
			this._property = relationshipData.propertyName;
			this._options = relationshipData.options;
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function formatAsClass(str:String):String
		{
			return str.substr(0, 1).toUpperCase() + str.substr(1);
		}
		
		
		/**
		 * 
		 */
		private function getKey():String
		{
			return this._options.key || this._property + "Id";
		}


		/**
		 * 
		 */
		private function getRelatedClass():String
		{
			var relatedClass:String = this._options.relatedClass;
			if (!relatedClass)
			{
				var parts:Array = this._className.split(".");
				parts.pop();
				parts.push(this.formatAsClass(this._property));
				relatedClass = parts.join(".");
			}
			return relatedClass;
		}


		/**
		 * 
		 */
		private function getRelatedKey(relatedClass:String):String
		{
			return DATA_MAPPER_CONFIG.getPrimaryKey(relatedClass) || "id";
		}




	}
	
}