package inky.orm
{
	import inky.orm.DataMapperResource;
	import inky.async.AsyncToken;
	import inky.collections.IList;


	public interface IDataMapper
	{
		function load(obj:DataMapperResource, conditions:Object):AsyncToken;
		function save(obj:DataMapperResource, cascade:Boolean = false):AsyncToken;
		function remove(obj:DataMapperResource, cascade:Boolean = true):AsyncToken;
		function find(conditions:Object):IList;
		function findFirst(conditions:Object):AsyncToken;
	}
}