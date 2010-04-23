package inky.components.map.view.helpers 
{
	import inky.components.map.view.IMap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import inky.layout.validation.LayoutValidator;
	import inky.layout.utils.ValidationState;
	import flash.events.EventDispatcher;
	
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
	public class BaseMapViewHelper extends EventDispatcher
	{
		protected var map:IMap;
		protected var mapContent:DisplayObjectContainer;
		protected var layoutValidator:LayoutValidator;
		protected var validationState:ValidationState;
		
		/**
		 * Creates a new IMap view helper.
		 * 
		 * @param map
		 * 		The IMap target to apply the view helper behavior to.
		 */
		public function BaseMapViewHelper(map:IMap, layoutValidator:LayoutValidator)
		{
			if ((!map is DisplayObjectContainer))
				throw new ArgumentError("Target map must be a DisplayObjectContainer.");

			this.map = map;
			this.mapContent = DisplayObjectContainer(map);
			
			this.layoutValidator = layoutValidator;
			this.validationState = layoutValidator.validationState;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function validate():void
		{
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected function invalidateProperty(property:String):void
		{
			//this.layoutValidator.properties[property] = this[property];
			this.layoutValidator.validationState.markPropertyAsInvalid(property);
			this.invalidate();
		}

		/**
		 * @inheritDoc
		 */
		protected function invalidate():void
		{
			this.layoutValidator.invalidate();
		}

	}
	
}