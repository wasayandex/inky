package  
{
	import flash.display.Sprite;
	import inky.layers.LayerStack;
	import flash.events.MouseEvent;
	import inky.layers.LayerDefinition;
	import inky.layers.ILayerDefinition;
	
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
	public class LayersExample extends Sprite
	{
		private var stack:LayerStack;
		
		/**
		 *
		 */
		public function LayersExample()
		{
			this.stack = new LayerStack(this);

			this.inputField.text = "red/green/blue";
			this.buildStackButton.addEventListener(MouseEvent.CLICK, this.buildStackButton_clickHandler);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function buildStackButton_clickHandler(event:MouseEvent):void
		{
			// Parse the stack from the input field.
			var colors:Array = this.inputField.text.toLowerCase().split("/");
			var layers:Array = []
			for each (var color:String in colors)
			{
				if (color)
					layers.push(this.createLayer(color));
			}
			
			this.stack.build.apply(null, layers);
		}

		/**
		 * 
		 */
		private function createLayer(color:String):ILayerDefinition
		{
			var viewClassName:String = color.substr(0, 1).toUpperCase() + color.substr(1) + "Widget";
			return new LayerDefinition(viewClassName);
		}
		
	}
	
}