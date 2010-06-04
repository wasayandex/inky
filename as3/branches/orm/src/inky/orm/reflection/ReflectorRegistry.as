package inky.orm.reflection 
{
	import inky.orm.reflection.IReflector;
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
	public class ReflectorRegistry
	{
		private var reflectors:Object = {};
		
		/**
		 * 
		 */
		public function get(obj:Object):IReflector
		{
			var reflector:IReflector;
			if (obj == null)
				throw new ArgumentError("Null arguments not allowed.");
			else if (obj is String)
				reflector = this.reflectors[obj];
			else if (obj is Class)
				reflector = this.reflectors[String(describeType(obj).@name)];
			else
				reflector = this.reflectors[getQualifiedClassName(obj)];
			return reflector;
		}
		
		/**
		 * 
		 */
		public function put(qualifiedClassName:String, reflector:IReflector):void
		{
			this.reflectors[qualifiedClassName] = reflector;
		}

		
	}
	
}