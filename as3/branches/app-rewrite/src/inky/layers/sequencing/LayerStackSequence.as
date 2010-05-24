package inky.layers.sequencing 
{
	import inky.sequencing.AbstractSequence;
	import inky.utils.UIDUtil;
	
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
this.onAbort = function (obj) { trace(" SEQUENCE " + UIDUtil.getUID(this) + " ABORTED!")};
this.onComplete = function (obj) { trace(" SEQUENCE " + UIDUtil.getUID(this) + " COMPLETE! ")};
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
		
		override public function play():void
		{
trace(" SEQUENCE " + UIDUtil.getUID(this) + " STARTED!");
			super.play();
		}
		
		override protected function onBeforeCommandExecute():void
		{
trace("::\tEXECUTING COMMAND\t::\t" + this.currentIndex + "\t::\t" + this.currentCommand)			
		}
		
	}
	
}