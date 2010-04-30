package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.IMapHelper;
	import inky.components.map.view.helpers.HelperInfo;
	import inky.components.map.view.events.MapChangeEvent;
	
	/**
	 *
	 *  Abstract implementation of IMapHelper. Extend this class to create view helpers that can be mixed in with 
	 *  other helpers to create complex interactive maps.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.12
	 *
	 */
	public class BaseMapHelper implements IMapHelper
	{
		protected var info:HelperInfo;

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			if (this.info)
			{
				this.info.map.removeEventListener(MapChangeEvent.DESTROY_TRIGGERED, this.map_destroyTriggeredHandler);
				this.info.map.removeEventListener(MapChangeEvent.RESET_TRIGGERED, this.map_resetTriggeredHandler);
				this.info.map.removeEventListener(MapChangeEvent.VALIDATION_TRIGGERED, this.map_validationTriggeredHandler);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function initialize(helperInfo:HelperInfo):void
		{
			this.info = helperInfo;
			this.info.map.addEventListener(MapChangeEvent.DESTROY_TRIGGERED, this.map_destroyTriggeredHandler);
			this.info.map.addEventListener(MapChangeEvent.RESET_TRIGGERED, this.map_resetTriggeredHandler);
			this.info.map.addEventListener(MapChangeEvent.VALIDATION_TRIGGERED, this.map_validationTriggeredHandler);
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected function invalidateProperty(property:String):void
		{
			if (this.info)
			{
				this.info.layoutValidator.validationState.markPropertyAsInvalid(property);
				this.invalidate();
			}
		}

		/**
		 * @inheritDoc
		 */
		protected function invalidate():void
		{
			if (this.info)
				this.info.layoutValidator.invalidate();
		}
		
		/**
		 * @inheritDoc
		 */
		protected function reset():void
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		protected function validate():void
		{
			
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function map_destroyTriggeredHandler(event:MapChangeEvent):void
		{
			this.destroy();
		}

		/**
		 * 
		 */
		private function map_resetTriggeredHandler(event:MapChangeEvent):void
		{
			this.reset();
		}

		/**
		 * 
		 */
		private function map_validationTriggeredHandler(event:MapChangeEvent):void
		{
			this.validate();
		}

	}
	
}