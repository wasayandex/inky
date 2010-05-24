package inky.layers.strategies 
{
	import inky.layers.strategies.IRemovalStrategy;
	import flash.display.DisplayObject;
	import inky.layers.LayerStack;
	import flash.events.IEventDispatcher;
	import inky.transitioning.IHasOutro;
	import inky.transitioning.ISelfRemovingDisplayObject;
	import flash.events.Event;
	import inky.utils.getClass;
	import inky.layers.strategies.RemoveFromStage;
	import inky.utils.UIDUtil;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.05.20
	 *
	 */
	public class PlayOutroThenRemove implements IRemovalStrategy
	{
		private var dispatcher:IEventDispatcher;
		private var _isInstantaneous:Boolean = false;
		private var layer:DisplayObject;
		private var removalStrategyOrClass:Object;
		private var removalStrategy:IRemovalStrategy;
		private var stack:LayerStack;
		
		/**
		 *
		 */
		public function PlayOutroThenRemove(removalStrategyOrClass:Object = null)
		{
			this.removalStrategyOrClass = removalStrategyOrClass || RemoveFromStage;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get isInstantaneous():Boolean
		{
			return this._isInstantaneous;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function remove(layer:DisplayObject, stack:LayerStack, dispatcher:IEventDispatcher = null):void
		{
			this.layer = layer;
			this.dispatcher = dispatcher;
			this.stack = stack;
			
			this._isInstantaneous = !this.layer.parent;
			
			if (this.layer.parent)
			{
				if (layer is ISelfRemovingDisplayObject)
				{
					this._isInstantaneous = ISelfRemovingDisplayObject(layer).remove();
				}
				else if (layer is IHasOutro)
				{
					throw new ArgumentError("Layers that have outros but are not self-removing are not yet supported");
				}
				else
				{
					if (!this.removalStrategy)
					{
						var strategyOrClass:Object = this.removalStrategyOrClass;

						if (strategyOrClass is IRemovalStrategy)
						{
							this.removalStrategy = strategyOrClass as IRemovalStrategy;
						}
						else
						{
							var cls:Class = getClass(strategyOrClass);
							if (!cls)
								throw new Error("Couldn't find IRemovalStrategy: " + strategyOrClass);
							this.removalStrategy = new cls();
							if (!(this.removalStrategy is IRemovalStrategy))
								throw new Error(strategyOrClass + " does not implement IRemovalStrategy");
						}
					}

					this.removalStrategy.remove(this.layer, this.stack, this.dispatcher);
					this._isInstantaneous = this.removalStrategy.isInstantaneous;
				} 
					
			}

			if (!this.isInstantaneous)
				layer.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageHandler);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function dispatchCompleteEvent():void
		{
			if (this.dispatcher)
				this.dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 
		 */
		private function removedFromStageHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.dispatchCompleteEvent();
		}
		
	}
	
}