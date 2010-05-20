package inky.orm
{
	import inky.collections.IList;


	public interface IDataMapper
	{
		function load(obj:Object, conditions:Object):Object;
		function save(obj:Object, cascade:Boolean = false):void;
		function remove(obj:Object, cascade:Boolean = true):void;
		function find(conditions:Object):IList;
		function findFirst(conditions:Object):Object;
	}
}