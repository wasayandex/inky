package  
{
	import flash.display.Sprite;
	import Ball;
	import inky.sequencing.XMLSequence;
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
				<call function="#createBall" />
				<set property="ball" on="#sequence.variables" to="#sequence.previousCommand.result" />
				<set property="text" on="#owner.textField" to="waiting for click" />
				<wait for={MouseEvent.CLICK} on="#ball" />
				<set property="text" on="#owner.textField" to="gonna tween some" />
				<tween x.to="50" y.to="200" alpha.to="0" for="1s" on="#ball" />
				<set property="text" on="#owner.textField" to="gonna wait some" />
				<wait for="30 frames" />
				<set property="text" on="#owner.textField" to="gonna tween some more" />
				<tween tint.to="0x000000ff" x.to="100" alpha.to="1" for="60 frames" on="#ball" />
				<tween x.to="200" for="1500ms" on="#ball" />
				<dispatchEvent withType="introComplete" on="#owner" />
				<set property="text" on="#owner.textField" to="DONE" />
			</sequence>

		private var sequenceA:XMLSequence;

		// TODO: How should we set arguments? For example, on trace?

		/**
		 *
		 */
		public function SequencingExample()
		{
			ColorTransformPlugin.install();

			this.sequenceA = new XMLSequence(this.sequenceASource, {owner: this, createBall: this.createBall, trace: trace});
			this.sequenceA.play();
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