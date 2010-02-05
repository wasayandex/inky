package inky.orm 
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	import inky.orm.IDatabase;
	import inky.orm.IDataMapper;
	import inky.collections.IList;
	import inky.collections.IIterator;
	import inky.utils.Conditions;
	import inky.orm.DATA_MAPPER_CONFIG;
	import inky.orm.DomainModel;
	import inky.utils.describeObject;

	
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
	public class DataMapper implements IDataMapper
	{
		private var _db:IDatabase;


		/**
		 *
		 */
		public function DataMapper(db:IDatabase)
		{
			this._db = db;
		}




		//
		// public methods
		//


		/**
		 *	
		 */
		public function find(conditions:Object):IList
		{
			return null;
		}


		/**
		 *	
		 */
		public function findFirst(conditions:Object):Object
		{
			return null;
		}


		/**
		 *	@inheritDoc
		 */
		public function load(model:DomainModel, c:Object):Object
		{
// TODO: Optimize for case when c only contains primary key. Should be a simple lookup. Actually, should be like that for any unique key.

			var foundMatch:Boolean = false;
			var conditions:Conditions = c is Conditions ? c as Conditions : new Conditions(c);
			for (var i:IIterator = this._db.getItems(this.getTableName(model)).iterator(); i.hasNext(); )
			{
				var dto:Object = i.next();
				var obj:Object = {};
				var prop:String;

				// Deserialize only the properties needed to test the conditions.
				for (prop in conditions)
				{
					var value:* = this.deserializeProperty(dto, prop);
					obj[prop] = value;
				}
// TODO: Clear model properties first?
				if (conditions.test(obj))
				{
					foundMatch = true;
					
					// Put the already deserialized properties on the domain model
					for (prop in obj)
						model[prop] = obj[prop];
//!
/*
					// Deserialize the remaining properties.
					for each (prop in _getConfigFor(model))
						if (!obj.hasOwnProperty(prop))
							model[prop] = this.deserializeProperty(dto, prop);
*/
				}
			}
			
			if (!foundMatch)
				throw new Error("Could not find object in database!");

			return model;
		}


		/**
		 *	@inheritDoc
		 */
		private static function _getConfigFor(model:DomainModel):void
		{
			var className:String = getQualifiedClassName(model).replace(/::/, ".");
			var config:Object = DATA_MAPPER_CONFIG[className];
			if (!config || !config.properties)
				throw new Error(className + " is not configured.");
		}


		/**
		 *	@inheritDoc
		 */
		public function remove(obj:DomainModel, cascade:Boolean = true):void
		{
		}


		/**
		 *	
		 */
		public function save(obj:DomainModel, cascade:Boolean = false):void
		{
			if (!obj)
				throw new ArgumentError();
// TODO: Add support for cascading save.
			var tableName:String = this.getTableName(obj);
			var dto:Object = this.getDTO(obj);
			return this._db.insert(tableName, dto, true);
		}




		//
		// protected methods
		//


		/**
		 *	@inheritDoc
		 */
		protected function deserializeProperty(dto:Object, name:String):*
		{
return dto[name];
		}


		/**
		 *	Converts the business object into a form that is suitable for
		 *  injection into the database. The result (while still an object)
		 *  will only contain values that the database is capable of storing.
		 *  This method may be overwritten so that you can change how the data
		 *  transfer object is formatted without having to write a data mapper
		 *  from scratch. The default implementation is to put all of the
		 *  business object's properties of primitive type onto the DTO.
		 */
		protected function getDTO(obj:DomainModel):Object
		{
			var dto:Object = {};

			//
			// Analyze the object to know what to put in the database.
			//

			var value:String;

			// Add dynamic properties to dto.
			for (var property:String in obj)
			{
				value = this.serializeProperty(property, obj[property]);
				if (value != null)
					dto[property] = value;
			}

			// Add class properties to dto.
			var typeDescription:XML = describeType(obj);
			for each (var prop:XML in typeDescription.accessor.((@access == "readonly") || (@access == "readwrite")) + typeDescription.variable)
			{
				var name:String = prop.@name;
				value = this.serializeProperty(name, obj[name]);
				if (value != null)
					dto[prop.@name] = value;
			}

			return dto;
		}


		/**
		 *	Given a business object, this function returns the name of the table
		 *  in which this object's data should be stored.
		 */
		protected function getTableName(obj:DomainModel):String
		{
			var className:String = getQualifiedClassName(obj).split("::").pop();
			return className.substr(0, 1).toLowerCase() + className.substr(1);
		}


		/**
		 *	Serializes values to add to the DTO.
		 */
		protected function serializeProperty(name:String, value:Object):String
		{
			var result:String;
			if (value is String)
				result = value as String;
			else if (value is Number || value is Boolean)
				result = value.toString();
// TODO: Add a way to handle relationships.
			return result;
		}



		
	}
}