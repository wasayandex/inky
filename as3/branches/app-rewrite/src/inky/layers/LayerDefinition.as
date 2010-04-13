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
	public class LayerDefinition implements ILayerDefinition
	{
		private var additionStrategy:IAdditionStrategy;
		private var additionStrategyOrClass:Object;
		private var _forceRefresh:Boolean;
		private var removalStrategy:IRemovalStrategy;
		private var removalStrategyOrClass:Object;
		private var view:DisplayObject;
		private var viewClass:Object;
		
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

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function addTo(stack:LayerStack):void
		{
			var additionStrategy:IAdditionStrategy = IAdditionStrategy(this.getStrategy("additionStrategy", IAdditionStrategy, "IAdditionStrategy"));
			additionStrategy.add(this.getView(), stack);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeFrom(stack:LayerStack):void
		{
			var removalStrategy:IRemovalStrategy = IRemovalStrategy(this.getStrategy("removalStrategy", IRemovalStrategy, "IRemovalStrategy"));
			removalStrategy.remove(this.getView(), stack);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
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
					var cls:Class = getClass(strategyOrClass);
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