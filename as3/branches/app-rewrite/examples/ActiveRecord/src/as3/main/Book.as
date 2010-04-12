package
{
	import BookDataMapper;
	import inky.framework.db.*;


	public class Book extends ActiveRecord
	{
		private static var _dataMapper:IDataMapper;

		override public function getDataMapper():IDataMapper
		{
			return Book._dataMapper || (Book._dataMapper = new BookDataMapper()); 
		}

	}
}