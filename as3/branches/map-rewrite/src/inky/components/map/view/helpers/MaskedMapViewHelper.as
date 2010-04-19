package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.BaseMapViewHelper;
	import flash.display.DisplayObject;
	import inky.components.map.view.IMap;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
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
		protected var mask:DisplayObject;	

		/**
		 * @copy inky.components.map.view.helpers.BaseMapViewHelper
		 */
		public function MaskedMapViewHelper(map:IMap)
		{
			super(map);

			// Find the content container mask.
			var mask:DisplayObject = this.contentContainer.mask || this.content.getChildByName('_mask');
			if (!mask)
			{ 
				var child:DisplayObject;
				for (var i:int = this.content.numChildren - 1; i >= 0; i--)
				{
					child = this.content.getChildAt(i);
					if (child is Shape)
					{
						mask = child;
						break;
					}
				}
			}

			if (!mask)
				throw new Error('ViewHelper target is missing a mask.');

			if (this.contentContainer.mask != mask)
				this.contentContainer.mask = mask;

			this.mask = mask;
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		protected function getDragBounds():Rectangle
		{
			var contentBounds:Rectangle = this.contentContainer.getRect(this.content);
			var maskBounds:Rectangle = this.mask.getRect(this.content);
			var bounds:Rectangle = new Rectangle(maskBounds.width - contentBounds.width, maskBounds.height - contentBounds.height, contentBounds.width - maskBounds.width, contentBounds.height - maskBounds.height);
			return bounds;
		}

	}
	
}