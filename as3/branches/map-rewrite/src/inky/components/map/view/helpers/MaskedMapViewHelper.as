package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.BaseMapViewHelper;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import inky.layout.validation.LayoutValidator;
	import flash.display.DisplayObjectContainer;
	import inky.components.map.view.IInteractiveMap;
	
	/**
	 *
	 *  Abstract IMap view helper. Extend this class to create view helpers that can be mixed in with 
	 *  other helpers to create complex interactive maps.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.12
	 *
	 */
	public class MaskedMapViewHelper extends BaseMapViewHelper
	{
		private static var contentContainerProxies:Dictionary;
		protected var mask:DisplayObject;	
		protected var contentContainer:DisplayObjectContainer;

		/**
		 * @copy inky.components.map.view.helpers.BaseMapViewHelper
		 * 
		 * @param mask
		 * 		The map's content mask.
		 * 
		 * @param contentContainer
		 * 		The map's content container.
		 */
		public function MaskedMapViewHelper(map:IInteractiveMap, layoutValidator:LayoutValidator, mask:DisplayObject, contentContainer:DisplayObjectContainer)
		{
			super(map, layoutValidator);
			
			this.mask = mask;
			this.contentContainer = contentContainer;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function reset():void
		{
			super.reset();

			if (contentContainerProxies && contentContainerProxies[this.contentContainer])
				delete contentContainerProxies[this.contentContainer];
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected function getContentContainerProxy():Object
		{
			if (!contentContainerProxies)
				contentContainerProxies = new Dictionary(true);
			
			if (!contentContainerProxies[this.contentContainer])
				contentContainerProxies[this.contentContainer] = {};

			return contentContainerProxies[this.contentContainer];
		}

	}
	
}