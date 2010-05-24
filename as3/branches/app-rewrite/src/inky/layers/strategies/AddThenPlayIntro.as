package inky.layers.strategies 
{
	import inky.layers.strategies.IAdditionStrategy;
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import inky.transitioning.IHasIntro;
	import inky.layers.LayerStack;
	import inky.transitioning.events.TransitioningEvent;
	import inky.utils.getClass;
	import flash.events.Event;
	import inky.layers.strategies.AddToRoot;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
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
	public class AddThenPlayIntro implements IAdditionStrategy
	{
		private var additionStrategy:IAdditionStrategy;
		private var additionStrategyOrClass:Object;
		private var dispatcher:IEventDispatcher;
		private var layer:DisplayObject;
		private var stack:LayerStack;
		private var _isInstantaneous:Boolean = false;

		/**
		 *
		 */
		public function AddThenPlayIntro(additionStrategyOrClass:Object = null)
		{
			this.additionStrategyOrClass = additionStrategyOrClass || AddToRoot;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * 
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
		public function add(layer:DisplayObject, stack:LayerStack, dispatcher:IEventDispatcher = null):void
		{
			this.dispatcher = dispatcher;
			this.layer = layer;
			this.stack = stack;
			
			if (!this.additionStrategy)
			{
				var strategyOrClass:Object = this.additionStrategyOrClass;
				if (strategyOrClass is IAdditionStrategy)
				{
					this.additionStrategy = strategyOrClass as IAdditionStrategy;
				}
				else
				{
					var cls:Class = getClass(strategyOrClass);
					if (!cls)
						throw new Error("Couldn't find IAdditionStrategy: " + strategyOrClass);
					this.additionStrategy = new cls();
					if (!(this.additionStrategy is IAdditionStrategy))
						throw new Error(strategyOrClass + " does not implement IAdditionStrategy");
				}
			}

			this.additionStrategy.add(layer, stack, null);

			var completeNow:Boolean = !(layer is IHasIntro);
			if (!completeNow)
			{
				if (!(completeNow = IHasIntro(layer).playIntro()))
					layer.addEventListener(TransitioningEvent.INTRO_FINISH, this.introFinishHandler);
			}

			if (completeNow)
			{
				this._isInstantaneous = true;
				this.dispatchCompleteEvent();
			}
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
		private function introFinishHandler(event:TransitioningEvent):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.dispatchCompleteEvent();
		}

	}
	
}