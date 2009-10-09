package inky.orm
{
	import inky.orm.DomainModel;
	import inky.async.AsyncToken;
	import inky.collections.IList;


	public interface IDataMapper
	{
		function load(obj:DomainModel, conditions:Object):AsyncToken;
		function save(obj:DomainModel, cascade:Boolean = false):AsyncToken;
		function remove(obj:DomainModel, cascade:Boolean = true):AsyncToken;
		function find(conditions:Object):IList;
		function findFirst(conditions:Object):AsyncToken;
	}
}