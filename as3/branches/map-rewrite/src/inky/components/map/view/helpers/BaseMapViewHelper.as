package inky.components.map.view.helpers 
{
	import inky.components.map.view.IMap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import inky.layout.validation.LayoutValidator;
	import inky.utils.ValidationState;
	
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
		private var contentContainerProxy:Object;
		protected var layoutValidator:LayoutValidator;
		protected var map:IMap;
		protected var validationState:ValidationState;
		
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

			this.layoutValidator = new LayoutValidator(this.content, this.validate);
			this.validationState = this.layoutValidator.validationState;

			// Find the content container. If it can't be found, create one.
			var contentContainer = this.content.getChildByName("_contentContainer") as Sprite;
			if (!contentContainer)
			{
				contentContainer = new Sprite();
				contentContainer.name == "_contentContainer";
				this.content.addChild(contentContainer);
			}
			this.contentContainer = contentContainer;
			this.contentContainerProxy = {};
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 *
		 */
		public function get contentRotation():Number
		{ 
			var value:Number = this.contentContainerProxy.rotation;
			if (isNaN(value))
			{
				value =
				this.contentContainerProxy.rotation =
				this.contentContainer.rotation;
			}
			return value;
		}
		/**
		 * @private
		 */
		public function set contentRotation(value:Number):void
		{
			var oldValue:Number = this.contentRotation;
			if (value != oldValue)
			{
				this.contentContainerProxy.rotation = value;
				this.invalidateProperty('contentRotation');
			}
		}

		/**
		 *
		 */
		public function get contentScaleX():Number
		{ 
			var value:Number = this.contentContainerProxy.scaleX;
			if (isNaN(value))
			{
				value =
				this.contentContainerProxy.scaleX =
				this.contentContainer.scaleX;
			}
			return value;
		}
		/**
		 * @private
		 */
		public function set contentScaleX(value:Number):void
		{
			var oldValue:Number = this.contentScaleX;
			if (value != oldValue)
			{
				this.contentContainerProxy.scaleX = value;
				this.invalidateProperty('contentScaleX');
			}
		}
		
		/**
		 *
		 */
		public function get contentScaleY():Number
		{ 
			var value:Number = this.contentContainerProxy.scaleY;
			if (isNaN(value))
			{
				value =
				this.contentContainerProxy.scaleY =
				this.contentContainer.scaleY;
			}
			return value;
		}
		/**
		 * @private
		 */
		public function set contentScaleY(value:Number):void
		{
			var oldValue:Number = this.contentScaleY;
			if (value != oldValue)
			{
				this.contentContainerProxy.scaleY = value;
				this.invalidateProperty('contentScaleY');
			}
		}
		
		/**
		 *
		 */
		public function get contentX():Number
		{ 
			var value:Number = this.contentContainerProxy.x;
			if (isNaN(value))
			{
				value =
				this.contentContainerProxy.x =
				this.contentContainer.x;
			}
			return value;
		}
		/**
		 * @private
		 */
		public function set contentX(value:Number):void
		{
			var oldValue:Number = this.contentX;
			if (value != oldValue)
			{
				this.contentContainerProxy.x = value;
				this.invalidateProperty('contentX');
			}
		}
		
		/**
		 *
		 */
		public function get contentY():Number
		{ 
			var value:Number = this.contentContainerProxy.y;
			if (isNaN(value))
			{
				value =
				this.contentContainerProxy.y =
				this.contentContainer.y;
			}
			return value;
		}
		/**
		 * @private
		 */
		public function set contentY(value:Number):void
		{
			var oldValue:Number = this.contentY;
			if (value != oldValue)
			{
				this.contentContainerProxy.y = value;
				this.invalidateProperty('contentY');
			}
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected function invalidateProperty(property:String):void
		{
			this.layoutValidator.properties[property] = this[property];
			this.invalidate();
		}

		/**
		 * @inheritDoc
		 */
		protected function invalidate():void
		{
			this.layoutValidator.invalidate();
		}

		/**
		 * @inheritDoc
		 */
		protected function validate():void
		{
			this.layoutValidator.validationState.markAllPropertiesAsValid();
		}


	}
	
}