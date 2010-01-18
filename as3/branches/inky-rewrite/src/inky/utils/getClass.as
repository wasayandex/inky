package inky.utils 
{
	import flash.utils.getDefinitionByName;

	/**
	 *
	 *  ..
	 *
	 */
	public function getClass(clsOrName:Object):Class
	{
		var cls:Class;
		
		if (clsOrName is Class)
		{
			cls = clsOrName as Class;
		}
		else if (clsOrName is String)
		{
			try
			{
				cls = getDefinitionByName(clsOrName as String) as Class;
			}
			catch (error:Error)
			{
			}
		}

		return cls;
	}
	
}
