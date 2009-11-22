package inky.db
{
	import flash.utils.getQualifiedClassName;
	import inky.db.*;
	import inky.utils.ObjectProxy;


	public interface IDataMapper
	{
		function load(record:ActiveRecord, conditions:Object):Object//AsyncToken;
		function save(record:ActiveRecord, cascade:Boolean = false):Object//AsyncToken;
		function remove(record:ActiveRecord, cascade:Boolean = true):Object//AsyncToken;
		function find(conditions:Object):ActiveCollection;
		function findFirst(conditions:Object):Object//AsyncToken;
	}
}