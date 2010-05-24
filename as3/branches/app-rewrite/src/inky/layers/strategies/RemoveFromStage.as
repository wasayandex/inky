package inky.layers.strategies 
{
	import inky.layers.strategies.IRemovalStrategy;
	import flash.display.DisplayObject;
	import inky.layers.LayerStack;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.04.12
	 *
	 */
	public class RemoveFromStage implements IRemovalStrategy
	{

		/**
		 * @inheritDoc
		 */
		public function get isInstantaneous():Boolean
		{
			return true;
		}

		/**
		 * @inheritDoc
		 */
		public function remove(layer:DisplayObject, stack:LayerStack, dispatcher:IEventDispatcher = null):void
		{
			if (layer.parent)
				layer.parent.removeChild(layer);

			if (dispatcher)
				dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}

	}
	
}