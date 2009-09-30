package inky.orm
{
	import inky.orm.BusinessObject;
	import inky.orm.ActiveCollection;
	import inky.async.AsyncToken;


	public interface IDataMapper
	{
		function load(obj:BusinessObject, conditions:Object):AsyncToken;
		function save(obj:BusinessObject, cascade:Boolean = false):AsyncToken;
		function remove(obj:BusinessObject, cascade:Boolean = true):AsyncToken;
		function find(conditions:Object):ActiveCollection;
		function findFirst(conditions:Object):AsyncToken;
	}
}