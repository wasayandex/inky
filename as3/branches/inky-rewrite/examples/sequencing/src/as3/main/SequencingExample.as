package  
{
	import flash.display.Sprite;
	import Ball;
	import inky.sequencing.XMLSequence;
	import flash.events.MouseEvent;
	import com.gskinner.motion.plugins.ColorTransformPlugin;
	import flash.events.Event;
	import inky.sequencing.parsers.xml.StandardParsers;
	import inky.sequencing.parsers.xml.GTweenParser;

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
		// Install sequencing plugins.
		StandardParsers.install();
		GTweenParser.install();

		// Install GTween plugins.
		ColorTransformPlugin.install();

		private static const SEQUENCE_SOURCE:XML =
			<sequence>
				<call function="#createBall" />
				<set ball.to="#sequence.previousCommand.result" on="#sequence.variables" />
				<set text.to="gonna tween some" on="#owner.textField" />
				<tween x.to="50" y.to="200" alpha.to="0" for="1s" on="#ball" />
				<wait for={Event.COMPLETE} on="#sequence.previousCommand" />
				<set text.to="gonna wait some" on="#owner.textField" />
				<wait for="30 frames" />
				<set text.to="gonna tween some more" on="#owner.textField" />
				<tween tint.to="0x000000ff" x.to="100" alpha.to="1" for="60 frames" on="#ball" />
				<wait for={Event.COMPLETE} on="#sequence.previousCommand" />
				<tween x.to="200" for="1500ms" on="#ball" />
				<wait for={Event.COMPLETE} on="#sequence.previousCommand" />
				<dispatchEvent with.type="introComplete" on="#owner" />
				<set text.to="DONE" on="#owner.textField" />
			</sequence>

		private var sequence:XMLSequence;

		/**
		 *
		 */
		public function SequencingExample()
		{
			this.sequence = new XMLSequence(SEQUENCE_SOURCE, {owner: this, createBall: this.createBall});
			this.playSequenceButton.addEventListener(MouseEvent.CLICK, this.playSequenceButton_clickHandler);
			this.abortSequenceButton.addEventListener(MouseEvent.CLICK, this.abortSequenceButton_clickHandler);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function abortSequenceButton_clickHandler(event:MouseEvent):void
		{
			this.sequence.abort();
		}

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
		
		/**
		 * 
		 */
		private function playSequenceButton_clickHandler(event:MouseEvent):void
		{
			this.sequence.play();
		}
		
	}
	
}