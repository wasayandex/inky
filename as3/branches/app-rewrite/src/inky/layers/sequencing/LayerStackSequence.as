package inky.layers.sequencing 
{
	import inky.sequencing.AbstractSequence;
	
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
	public class LayerStackSequence extends AbstractSequence
	{
		private var commands:Array = [];
		
		
		/**
		 *
		 */
		public function LayerStackSequence()
		{
			
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function get length():int
		{
			return this.commands.length;
		}
		
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function addCommand(command:Object):void
		{
			this.commands.push(command);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getCommandAt(index:int):Object
		{
			return this.commands[index];
		}
		
	}
	
}