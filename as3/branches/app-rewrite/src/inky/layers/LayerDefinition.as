package inky.layers 
{
	import inky.utils.getClass;
	import flash.display.DisplayObject;
	import inky.layers.strategies.IAdditionStrategy;
	import inky.layers.strategies.IRemovalStrategy;
	import inky.layers.ILayerDefinition;
	import inky.layers.strategies.AddToRoot;
	import inky.layers.LayerStack;
	import inky.layers.strategies.RemoveFromStage;
	import flash.events.EventDispatcher;
	import inky.utils.EqualityUtil;
	
	/**
	 *
	 *  Defines a display list layer.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.04.12
	 *
	 */
	public class LayerDefinition extends EventDispatcher implements ILayerDefinition
	{
		private var additionStrategy:IAdditionStrategy;
		private var additionStrategyOrClass:Object;
		private var _forceRefresh:Boolean;
		private var removalStrategy:IRemovalStrategy;
		private var removalStrategyOrClass:Object;
		private var view:DisplayObject;
		private var viewClass:Object;
		private var _onBeforeAdd:Function;
		private var _onAddComplete:Function;
		private var _onBeforeRemove:Function;
		private var _onRemoveComplete:Function;
		
		/**
		 *
		 */
		public function LayerDefinition(viewClass:Object, additionStrategyOrClass:Object = null, removalStrategyOrClass:Object = null)
		{
			this.additionStrategyOrClass = additionStrategyOrClass || AddToRoot;
			this.removalStrategyOrClass = removalStrategyOrClass || RemoveFromStage;
			this.viewClass = viewClass;
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get addIsInstantaneous():Boolean
		{
			return this.getAdditionStrategy().isInstantaneous;
		}

		/**
		 *
		 */
		public function get forceRefresh():Boolean
		{ 
			return this._forceRefresh; 
		}
		/**
		 * @private
		 */
		public function set forceRefresh(value:Boolean):void
		{
			this._forceRefresh = value;
		}
		
		/**
		 *
		 */
		public function get onAddComplete():Function
		{ 
			return this._onAddComplete; 
		}
		/**
		 * @private
		 */
		public function set onAddComplete(value:Function):void
		{
			this._onAddComplete = value;
		}

		/**
		 *
		 */
		public function get onBeforeAdd():Function
		{
			return this._onBeforeAdd;
		}
		/**
		 * @private
		 */
		public function set onBeforeAdd(value:Function):void
		{
			this._onBeforeAdd = value;
		}
		
		/**
		 *
		 */
		public function get onBeforeRemove():Function
		{ 
			return this._onBeforeRemove; 
		}
		/**
		 * @private
		 */
		public function set onBeforeRemove(value:Function):void
		{
			this._onBeforeRemove = value;
		}

		/**
		 *
		 */
		public function get onRemoveComplete():Function
		{ 
			return this._onRemoveComplete; 
		}
		/**
		 * @private
		 */
		public function set onRemoveComplete(value:Function):void
		{
			this._onRemoveComplete = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get removeIsInstantaneous():Boolean
		{
			return this.getRemovalStrategy().isInstantaneous;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function addTo(stack:LayerStack):void
		{
			var additionStrategy:IAdditionStrategy = this.getAdditionStrategy();
			additionStrategy.add(this.getView(), stack, this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone():ILayerDefinition
		{
			var def:LayerDefinition = new LayerDefinition(this.viewClass, this.additionStrategyOrClass, this.removalStrategyOrClass);
			
// FIXME: add the props defined in the interface.
			/*for (var prop:String in this)
			{
				def[prop] = this[prop];
			}*/
			
			return def;
		}
		
		/**
		 * @inheritDoc
		 */
		public function replaces(layer:Object):Boolean
		{
			var replaces:Boolean = layer != this;

			if (replaces && layer is LayerDefinition)
				replaces = getClass(LayerDefinition(layer).viewClass) != getClass(this.viewClass);

			return replaces;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeFrom(stack:LayerStack):void
		{
			var removalStrategy:IRemovalStrategy = this.getRemovalStrategy();
			removalStrategy.remove(this.getView(), stack, this);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function getAdditionStrategy():IAdditionStrategy
		{
			return IAdditionStrategy(this.getStrategy("additionStrategy", IAdditionStrategy, "IAdditionStrategy"));
		}
		
		/**
		 * 
		 */
		private function getRemovalStrategy():IRemovalStrategy
		{
			return IRemovalStrategy(this.getStrategy("removalStrategy", IRemovalStrategy, "IRemovalStrategy"));
		}
		
		/**
		 * 
		 */
		private function getStrategy(propertyName:String, interfaceType:Class, interfaceName:String):Object
		{
			var strategy:Object;
			
			if (this[propertyName])
			{
				strategy = this[propertyName];
			}
			else
			{
				var strategyOrClass:Object = this[propertyName + "OrClass"];

				if (strategyOrClass is interfaceType)
				{
					strategy = strategyOrClass;
				}
				else
				{
					var cls:Class = getClass(strategyOrClass as Class || strategyOrClass.toString());
					if (!cls)
						throw new Error("Couldn't find " + interfaceName + ": " + strategyOrClass);
					strategy = new cls();
					if (!(strategy is interfaceType))
						throw new Error(strategyOrClass + " does not implement " + interfaceName);
				}
				
				this[propertyName] = strategy;
			}
			return strategy;
		}

		/**
		 * 
		 */
		private function getView():DisplayObject
		{
			if (!this.view)
			{
				var cls:Class = getClass(this.viewClass);
				if (!cls)
					throw new Error("Could not find view class " + this.viewClass);
				this.view = new cls();
			}
			return this.view;
		}

	}
	
}