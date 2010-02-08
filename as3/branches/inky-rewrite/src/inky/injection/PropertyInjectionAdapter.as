package inky.injection 
{
	import inky.injection.IInjectionAdapter;
	import inky.binding.utils.BindingUtil;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 * 
	 *	@author Matthew Tretter
	 *	@since  2009.11.23
	 *
	 */
	public class PropertyInjectionAdapter implements IInjectionAdapter
	{
		public var source:Object;
		public var propertyMap:Object;

		
		/**
		 * @param	source	 The object that the value will be retrieved from.
		 * @param	propertyMap	 A map consisting of key -> value pairs in which the keys are properties of the injection target and the values are binding chains to be evaluated relative to the source argument.
		 */
		public function PropertyInjectionAdapter(source:Object, propertyMap:Object)
		{
			this.propertyMap = propertyMap;
			this.source = source;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function inject(target:Object):void
		{
			for (var prop:String in propertyMap)
				target[prop] = BindingUtil.evaluateBindingChain(this.source, this.propertyMap[prop]);
		}

		

		
	}
	
}