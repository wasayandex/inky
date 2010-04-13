package inky.layers.strategies 
{
	import flash.display.DisplayObject;
	import inky.layers.LayerStack;
	import inky.layers.strategies.IAdditionStrategy;
	
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
		public function add(layer:DisplayObject, stack:LayerStack):void
		{
			stack.root.addChild(layer);
		}
		
	}
	
}