package  
{
	import flash.display.Sprite;
	import Ball;
	import inky.sequencing.SequencePlayer;
	import inky.sequencing.XMLSequence;
	import inky.sequencing.ISequence;
	import flash.events.MouseEvent;
	import com.gskinner.motion.plugins.ColorTransformPlugin;

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
				<set property="ball" on="#player.variables" to="#player.previousCommand.result" />
				<wait for={MouseEvent.CLICK} on="#ball" />
				<tween x.to="50" y.to="200" alpha.to="0" for="1s" on="#ball" />
				<wait for="30 frames" />
				<tween tint.to="0x000000ff" x.to="100" alpha.to="1" for="60 frames" on="#ball" />
				<dispatchEvent withType="introComplete" on="#owner" />
			</sequence>

		private var sequencePlayer:SequencePlayer;

		// TODO: How should we set arguments? For example, on trace?

		/**
		 *
		 */
		public function SequencingExample()
		{
			ColorTransformPlugin.install();

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
			var color:uint = 0x000000;
			var radius:Number = Math.random() * 30 + 10;
			var x:Number = Math.random() * this.stage.stageWidth;
			var y:Number = Math.random() * this.stage.stageHeight;
			var ball:Ball = new Ball(color, radius);
			ball.x = x;
			ball.y = y;
			this.addChild(ball);
			return ball;
		}
		
	}
	
}