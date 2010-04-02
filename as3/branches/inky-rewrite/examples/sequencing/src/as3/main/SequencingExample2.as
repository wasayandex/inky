package  
{
	import flash.display.Sprite;
	import ImagePopup;
	import inky.sequencing.events.SequenceEvent;
	import inky.sequencing.ISequence;
	import inky.sequencing.XMLSequence;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.02
	 *
	 */
	public class SequencingExample2 extends Sprite
	{
		private static const LOAD_IMAGE:XML =
			<sequence>
				<load url="unicorn.jpg" />
				<set property="image" on="#imagePopup" to="#sequence.previousCommand.content" />
			</sequence>
		
		private var imagePopup:ImagePopup;
		private var loadImageSequence:ISequence;
		
		/**
		 *
		 */
		public function SequencingExample2()
		{
			this.imagePopup = new ImagePopup();
			this.imagePopup.addEventListener("beforeImageIntro", this.imagePopup_beforeImageIntroHandler);
			this.imagePopup.x = this.stage.stageWidth / 2;
			this.imagePopup.y = this.stage.stageHeight / 2;
			this.addChild(this.imagePopup);
			
			this.loadImageSequence = new XMLSequence(LOAD_IMAGE, {imagePopup: this.imagePopup});
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function imagePopup_beforeImageIntroHandler(event:SequenceEvent):void
		{
			event.sequence.interject(this.loadImageSequence);
		}
		
	}
	
}