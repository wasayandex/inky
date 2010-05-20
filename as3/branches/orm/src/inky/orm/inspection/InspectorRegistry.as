package inky.orm.inspection 
{
	import inky.orm.inspection.ITypeInspector;
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.05.19
	 *
	 */
	public class InspectorRegistry
	{
		private var inspectors:Object = {};
		
		/**
		 * 
		 */
		public function get(obj:Object):ITypeInspector
		{
			var inspector:ITypeInspector;
			if (obj == null)
				throw new ArgumentError("Null arguments not allowed.");
			else if (obj is String)
				inspector = this.inspectors[obj];
			else if (obj is Class)
				inspector = this.inspectors[String(describeType(obj).@name)];
			else
				inspector = this.inspectors[getQualifiedClassName(obj)];
			return inspector;
		}
		
		/**
		 * 
		 */
		public function put(qualifiedClassName:String, inspector:ITypeInspector):void
		{
			this.inspectors[qualifiedClassName] = inspector;
		}

		
	}
	
}