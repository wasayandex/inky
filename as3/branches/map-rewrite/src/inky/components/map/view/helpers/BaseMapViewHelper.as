package inky.components.map.view.helpers 
{
	import inky.components.map.view.IMap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
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
	public class BaseMapViewHelper
	{
		protected var content:DisplayObjectContainer;
		protected var contentContainer:Sprite;
		protected var map:IMap;
		
		/**
		 * Creates a new IMap view helper.
		 * 
		 * @param map
		 * 		The IMap target to apply the view helper behavior to.
		 */
		public function BaseMapViewHelper(map:IMap)
		{
			if ((!map is DisplayObjectContainer))
				throw new ArgumentError("Target map must be a DisplayObjectContainer.");

			this.map = map;
			this.content = DisplayObjectContainer(map);

			// Find the content container. If it can't be found, create one.
			var contentContainer = this.content.getChildByName("_contentContainer") as Sprite;
			if (!contentContainer)
			{
				contentContainer = new Sprite();
				contentContainer.name == "_contentContainer";
				this.content.addChild(contentContainer);
			}
			this.contentContainer = contentContainer;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 *
		 */
		public function get contentRotation():Number
		{ 
			return this.contentContainer.rotation; 
		}
		/**
		 * @private
		 */
		public function set contentRotation(value:Number):void
		{
			this.contentContainer.rotation = value;
		}

		/**
		 *
		 */
		public function get contentScaleX():Number
		{ 
			return this.contentContainer.scaleX; 
		}
		/**
		 * @private
		 */
		public function set contentScaleX(value:Number):void
		{
			this.contentContainer.scaleX = value;
		}
		
		/**
		 *
		 */
		public function get contentScaleY():Number
		{ 
			return this.contentContainer.scaleY; 
		}
		/**
		 * @private
		 */
		public function set contentScaleY(value:Number):void
		{
			this.contentContainer.scaleY = value;
		}
		
		/**
		 *
		 */
		public function get contentX():Number
		{ 
			return this.contentContainer.x; 
		}
		/**
		 * @private
		 */
		public function set contentX(value:Number):void
		{
			this.contentContainer.x = value;
		}
		
		/**
		 *
		 */
		public function get contentY():Number
		{ 
			return this.contentContainer.y; 
		}
		/**
		 * @private
		 */
		public function set contentY(value:Number):void
		{
			this.contentContainer.y = value;
		}

	}
	
}