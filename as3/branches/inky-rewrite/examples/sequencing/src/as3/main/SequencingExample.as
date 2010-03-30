package  
{
	import flash.display.Sprite;
	import Ball;
	import inky.sequencing.SequencePlayer;
	import flash.events.Event;
	import inky.sequencing.XMLSequence;
	import inky.sequencing.ISequence;
	import flash.events.MouseEvent;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.29
	 *
	 */
	public class SequencingExample extends Sprite
	{
		private var sequenceASource:XML =
			<sequence>
				<call closure="#createBall" />
				<wait for={MouseEvent.CLICK} on="#ball" />
				<wait for="30 frames" />
				<dispatchEvent withType="introComplete" on="#owner" />
				<call closure="#trace" />
				<call closure="#player.previousCommand.execute" />
			</sequence>

// TODO: How should we set arguments? For example, on trace?

		private var sequencePlayer:SequencePlayer;
		
		/**
		 *
		 */
		public function SequencingExample()
		{
			var sequenceA:ISequence = new XMLSequence(this.sequenceASource);
this.addEventListener("introComplete", trace);
			this.sequencePlayer = new SequencePlayer({owner: this, createBall: this.createBall, trace: trace});
			this.sequencePlayer.playSequence(sequenceA);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function createBall():Ball
		{
			var color:uint = Math.random() * 0xffffff;
			var radius:Number = Math.random() * 30 + 10;
			var x:Number = Math.random() * this.stage.stageWidth;
			var y:Number = Math.random() * this.stage.stageHeight;
			var redBall:Ball = new Ball(color, radius);
			redBall.x = x;
			redBall.y = y;
			this.addChild(redBall);
this.sequencePlayer.variables.ball = redBall;
			return redBall;
		}
		
	}
	
}