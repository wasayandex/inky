package inky.utils 
{
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.09.24
	 *
	 */
	public class PropertyChain
	{
		private var _chain:Object;
		
		/**
		 *
		 */
		public function PropertyChain(chain:Object)
		{
			this._chain = chain;
		}


		/**
		 * Evaluates a property chain.
		 * 	
		 *  @param chain A value specifying the property or chain to be watched.
     	 *  Legal values are:
     	 *  <ul>
     	 *    <li>String containing the name of a public property
     	 *    of the host object.</li>
     	 * 
	     *    <li>An function that accepts an object as its only property and
	     *    returns a value.</li>
	     * 
	     *    <li>A non-empty Array containing a combination of the first two
	     *    options that represents a chain of properties accessible
	     *    from the host. 
	     *    For example, to bind the property <code>host.a.b.c</code>, 
	     *    call the method as:
	     *    <code>bindProperty(host, ["a","b","c"], ...)</code>.</li>
	     *  </ul>
	     * 
	     * @see inky.binding.utils.BindingUtil#bindProperty()
	     * @see mx.binding.utils.BindingUtils#bindProperty()
		 */
		public function evaluate(host:Object):Object
		{
			return PropertyChain.evaluateChain(host, this._chain);
		}


		/**
		 *	
		 */
		public static function evaluateChain(host:Object, chain:Object):Object
		{
			var result:Object;
			if (host == null)
			{
				result = null;
			}
			else if (chain is String || chain is QName)
			{
				result = host[chain];
			}
			else if (chain is Function)
			{
				result = chain(host);
			}
			else if (chain is Array)
			{
				if (chain.length == 0)
					throw new ArgumentError("Chain cannot be an empty array.");
				var chainCopy:Array = chain.concat();
				var newHost:Object = PropertyChain.evaluateChain(host, chainCopy.shift());
				result = chainCopy.length ? PropertyChain.evaluateChain(newHost, chainCopy) : newHost;
			}
			return result;
		}




	}
}
