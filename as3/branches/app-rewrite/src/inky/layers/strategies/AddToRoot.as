package inky.layers.strategies 
{
	import inky.layers.LayerStack;
	import inky.layers.strategies.IAdditionStrategy;
	import flash.display.DisplayObject;
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
	public class AddToRoot implements IAdditionStrategy
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
		public function add(layer:DisplayObject, stack:LayerStack, dispatcher:IEventDispatcher = null):void
		{
			stack.root.addChild(layer);
			if (dispatcher)
				dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}

	}
	
}