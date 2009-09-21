package
{
	import inky.framework.db.*;


	public class BookDataMapper implements IDataMapper
	{
		private var _data:XML;


		public function BookDataMapper()
		{
			this._data =
				<db>
					<book id="0" title="James and the Giant Peach" author="Roald Dahl" />
					<book id="1" title="On The Road" author="Jack Kerouac" />
					<book id="2" title="Nine Stories" author="J.D. Salinger" />
					<book id="3" title="The Bible" author="God" />
					<book id="4" title="The Mouse and the Motorcycle" author="Beverly Cleary" />
					<book id="5" title="Flannery" author="Brad Gooch" />
				</db>
				
		}
		
		public function save(record:ActiveRecord, cascade:Boolean = false):Object//AsyncToken
		{
			var id:String = record.id;
			var list:XMLList = this._data.book.(@id == id);
			var xml:XML;
			if (list.length() == 0)
			{
				xml = <book id={this._data.book.length()} />;
				this._data.appendChild(xml);
			}
			else
			{
				xml = list[0];
			}
			
			for each (var p:String in record.getDirtyProperties())
			{
trace("dirty: " + p);
				xml["@" + p] = String(record[p]);
			}
trace("SAVED DB:");
trace(this._data.toXMLString());
trace("\n");
			return null;
		}
		
		
		public function find(conditions:Object):ActiveCollection
		{
			return null;
		}
		
		
		public function findFirst(conditions:Object):Object//AsyncToken
		{
			return null;
		}

		public function remove(record:ActiveRecord, cascade:Boolean = true):Object//AsyncToken
		{
			return null;
		}

		public function load(record:ActiveRecord, conditions:Object):Object//AsyncToken
		{
			if (conditions.id == null)
				throw new Error("Condictions have no id!");

			var list:XMLList = this._data.book.(@id == conditions.id);
			if (list.length())
			{
				var xml:XML = list[0];
				for each (var attr:XML in xml.attributes())
				{
					record.setProperty(attr.localName(), attr.toString(), false);
				}
			}
			
			return null;
		}


	}
}