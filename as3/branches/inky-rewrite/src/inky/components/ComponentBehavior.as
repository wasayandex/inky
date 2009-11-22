package inky.components 
{
	import inky.components.IComponent;
	import flash.events.EventDispatcher;
	import inky.layout.LayoutManager;
	import inky.layout.ILayoutManagerClient;
	import inky.components.events.ComponentEvent;
	import flash.events.Event;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.25
	 *
	 */
	public class ComponentBehavior extends EventDispatcher
	{
		private var _initialized:Boolean;
		private var _layoutManager:LayoutManager;
		private var _target:IComponent;
		
		/**
		 *
		 */
		public function ComponentBehavior(target:IComponent)
		{
			this._initialized = false;
			this._target = target;
			this._layoutManager = LayoutManager.getInstance();
			this.invalidateLayout();
			target.addEventListener(Event.REMOVED_FROM_STAGE, this._removedFromStageHandler, false, 0, true);
		}
		
		
		
		
		//
		// accessors
		//

		
		/**
		 *	@inheritDoc
		 */
		public function get layoutManager():LayoutManager
		{
			return this._layoutManager;
		}
		
		
		
		
		//
		// public methods
		//
		

		/**
		 *	
		 */
		public function invalidateLayout():void
		{
			this._layoutManager.invalidateLayout(this._target);
		}
		
		
		/**
		 * This will find the first ancestor that is a LayoutManagerClient and invalidate it...
		 * FIXME: Should this behave this way?
		 */
		public function invalidateParentLayout():void
		{
			var parent:Object = this._target;
			while (parent = parent.parent)
			{
				if (parent is ILayoutManagerClient)
				{
					this._layoutManager.invalidateLayout(ILayoutManagerClient(parent));
					break;
				}
			}
		}
		
		
		/**
		 *	
		 */
		public function validateLayout():void
		{
			if (!this._initialized)
			{
				this._target.dispatchEvent(new ComponentEvent(ComponentEvent.INITIALIZE));
				this._initialized = true;
			}
		}
		
		
		
		
		//
		// private methods
		//
		
		
		/**
		 *	
		 */
		private function _removedFromStageHandler(event:Event):void
		{
			this._target.destroy();
		}
		
		
		

	}
	
}