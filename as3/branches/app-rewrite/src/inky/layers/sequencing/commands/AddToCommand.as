package inky.layers.sequencing.commands 
{
	import inky.layers.ILayerDefinition;
	import inky.sequencing.commands.ICommand;
	import inky.layers.LayerStack;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.05.19
	 *
	 */
	public class AddToCommand extends EventDispatcher implements ICommand
	{
		private var layer:ILayerDefinition;
		private var stack:LayerStack;
		
		/**
		 *
		 */
		public function AddToCommand(layer:ILayerDefinition, stack:LayerStack)
		{
			this.layer = layer;
			this.stack = stack;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get isInstantaneous():Boolean
		{
			return this.layer.addIsInstantaneous;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			if (!this.isInstantaneous)
				this.layer.addEventListener(Event.COMPLETE, this.dispatchEvent, false, 0, true);
			
			this.layer.addTo(this.stack);
		}

	}
	
}