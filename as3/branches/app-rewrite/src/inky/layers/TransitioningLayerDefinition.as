package inky.layers 
{
	import inky.layers.LayerDefinition;
	import inky.layers.strategies.AddThenPlayIntro;
	import inky.layers.strategies.PlayOutroThenRemove;
	import inky.layers.strategies.AddToRoot;
	import inky.layers.strategies.RemoveFromStage;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.05.21
	 *
	 */
	public class TransitioningLayerDefinition extends LayerDefinition
	{
		private var additionStrategyOrClass:Object;
		private var removalStrategyOrClass:Object;
		private var viewClass:Object;

		/**
		 *
		 */
		public function TransitioningLayerDefinition(viewClass:Object, additionStrategyOrClass:Object = null, removalStrategyOrClass:Object = null)
		{
			if (!additionStrategyOrClass)
				additionStrategyOrClass = new AddThenPlayIntro(AddToRoot);

			if (!removalStrategyOrClass)
				removalStrategyOrClass = new PlayOutroThenRemove(RemoveFromStage);

			super(viewClass, additionStrategyOrClass, removalStrategyOrClass);

			this.viewClass = viewClass;
			this.additionStrategyOrClass = additionStrategyOrClass;
			this.removalStrategyOrClass = removalStrategyOrClass;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function clone():ILayerDefinition
		{
			var def:TransitioningLayerDefinition = new TransitioningLayerDefinition(this.viewClass, this.additionStrategyOrClass, this.removalStrategyOrClass);

// FIXME: add the props defined in the interface.
			/*for (var prop:String in this)
			{
				def[prop] = this[prop];
			}*/
			
			return def;
		}

	}
	
}