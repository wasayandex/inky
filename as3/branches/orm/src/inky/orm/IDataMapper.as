package inky.orm
{
	import inky.orm.DomainModel;
	import inky.collections.IList;


	public interface IDataMapper
	{
		function load(obj:DomainModel, conditions:Object):Object;
		function save(obj:DomainModel, cascade:Boolean = false):void;
		function remove(obj:DomainModel, cascade:Boolean = true):void;
		function find(conditions:Object):IList;
		function findFirst(conditions:Object):Object;
	}
}