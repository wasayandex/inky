package inky.framework.utils
{
	import inky.framework.core.Application;
	import inky.framework.core.SPath;


	/**
	 *	
	 *	A utility function for navigating to a new section without requiring a reference to a section.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2008.12.09
	 *	
	 */
	public function gotoSection(target:Object, options:Object = null):void
	{
		var sPath:SPath;
		if (target is String)
		{
			sPath = SPath.parse(target as String);
		}
		else if (target is SPath)
		{
			sPath = target as SPath;
		}
		
		if (!sPath.absolute)
		{
			throw new ArgumentError('inky.framework.utils.gotoSection cannot be used with relative SPaths.');
		}
		else
		{
			Application.currentApplication.gotoSection(sPath, options);
		}
	}




}
