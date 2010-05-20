package inky.orm.databases
{
	import inky.orm.databases.IDatabase;
	import inky.collections.IIterable;
	import inky.collections.ArrayList;

	
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
	public class XMLDatabase implements IDatabase
	{
		private var _data:XML;
		
		/**
		 *
		 */
		public function XMLDatabase(data:XML = null)
		{
			this._data = data || <db />;
		}




		//
		// accessors
		//


		/**
		 *	
		 */
		public function getItems(tableName:String):IIterable
		{
// FIXME: WE DON'T ACTUALLY WANT TO MAKE ALL THESE!!! THE ITERABLE THAT IS RETURNED SHOULD ONLY CREATE THE OBJECT WHEN REQUESTED!
// Pass lookup function (defined in this class) to IIterable implementation. It calls lookup on every iteration, passing index.
var items:Array = [];
for each (var xml:XML in this._data.child(tableName))
{
	var dto:Object = {};
	for each (var prop:XML in xml.children() + xml.attributes())
		dto[prop.localName().toString()] = prop.toString();
	items.push(dto);
}

return new ArrayList(items);
		}




		//
		// public methods
		//


		/**
		 *	@inheritDoc
		 */
		public function findFirst(conditions:Object):Object
		{
throw new Error("Not yet implemented");
		}


		/**
		 *	@inheritDoc
		 */
		public function insert(tableName:String, dto:Object, updateOnDuplicateKey:Boolean = false):void
		{
			var primaryKey:String = this._getPrimaryKey(tableName);
			var primaryKeyValue:String = dto[primaryKey];
// TODO: Could implement some kind of auto-increment feature here.
// TODO: Add more errors for non-nullable fields.
			if (primaryKeyValue == null)
				throw new Error("DTO has no value for its primary key (" + primaryKey + ")");
			
			var queryResult:XMLList = this._data[tableName].(attribute(primaryKey) == dto[primaryKey]);
			var numResults:int = queryResult.length();
			var row:XML;

			if (numResults == 0)
			{
				// Insert the row.
				row = <{tableName} />;
				this._updateRow(row, dto);
				this._data.appendChild(row);
			}
			else if (!updateOnDuplicateKey)
			{
				throw new Error("A row already exists with primary key " + primaryKey);
			}
			else
			{
				// Update the row.
				row = queryResult[0];
				this._updateRow(row, dto);
			}
		}




		//
		// private methods
		//


		/**
		 *	Gets the name of the primary key for the specified table.
		 */
		private function _getPrimaryKey(tableName:String):String
		{
			return "id";
		}




		/**
		 *	
		 */
		private function _updateRow(row:XML, dto:Object):void
		{
			for (var property:String in dto)
			{
				if (row[property].length())
					row[property] = dto[property];
				else
					row["@" + property] = dto[property];
			}
		}
		
		

/**
 *	
 */		
public function dump():void
{
trace(this._data);
}

		
	}
	
}