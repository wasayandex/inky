package inky.orm 
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	import inky.async.AsyncToken;
	import inky.orm.IRepository;
	import inky.orm.IDataMapper;
	import inky.collections.IList;

	
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
		private var _db:IRepository;


		/**
		 *
		 */
		public function DataMapper(db:IRepository)
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
		public function findFirst(conditions:Object):AsyncToken
		{
			return null;
		}


		/**
		 *	@inheritDoc
		 */
		public function load(obj:DataMapperResource, conditions:Object):AsyncToken
		{
			return null;
		}


		/**
		 *	@inheritDoc
		 */
		public function remove(obj:DataMapperResource, cascade:Boolean = true):AsyncToken
		{
			return null;
		}


		/**
		 *	
		 */
		public function save(obj:DataMapperResource, cascade:Boolean = false):AsyncToken
		{
			if (!obj)
				throw new ArgumentError();
			
			var tableName:String = this.getTableName(obj);
			var dto:Object = this.getDTO(obj);
			return this._db.insert(tableName, dto, true);
		}




		//
		// protected methods
		//


		/**
		 *	Converts the business object into a form that is suitable for
		 *  injection into the database. The result (while still an object)
		 *  will only contain values that the database is capable of storing.
		 *  This method may be overwritten so that you can change how the data
		 *  transfer object is formatted without having to write a data mapper
		 *  from scratch. The default implementation is to put all of the
		 *  business object's properties of primitive type onto the DTO.
		 */
		protected function getDTO(obj:DataMapperResource):Object
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
		protected function getTableName(obj:DataMapperResource):String
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
