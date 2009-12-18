package inky.app.model 
{
	import inky.app.model.IApplicationModelFactory;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.12.18
	 *
	 */
	public class DefaultApplicationModelFactory implements IApplicationModelFactory
	{
		
		/**
		 * @inheritDoc
		 */
		public function createModel(data:Object = null):Object
		{
			if (data is XML)
				return new ApplicationModel(data as XML);
			else if (data is String)
				return new ApplicationModel(new XML(data as String));
			else
				throw new ArgumentError("DefaultApplicationModelFactory needs XML to create a model.");
		}

		
	}
	
}