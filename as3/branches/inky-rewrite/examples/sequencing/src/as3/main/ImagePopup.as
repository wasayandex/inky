package  
{
	import flash.display.Sprite;
	import inky.sequencing.ISequence;
	import inky.sequencing.XMLSequence;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.display.DisplayObject;
	
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
	public class ImagePopup extends Sprite
	{
		private static const INTRO_SOURCE:XML =
			<sequence>
				<call function="#createBackground" />
				<set background.to="#sequence.previousCommand.result" on="#sequence.variables" />
				<set alpha.to="0" scaleX.to="0" scaleY.to="0" on="#background" />
				<tween alpha.to="1" scaleX.to="1" scaleY.to="1" on="#background" for="2s" />
				<dispatchEvent withType="beforeImageIntro" on="#owner" />
				<call function="#prepareImage" />
				<tween alpha.to="1" on="#owner.image" for="2s" />
			</sequence>

		private var background:Sprite;
		public var image:DisplayObject;
		private var intro:ISequence;

		/**
		 *
		 */
		public function ImagePopup()
		{
			this.intro = new XMLSequence(
				INTRO_SOURCE,
				{
					createBackground: this.createBackground,
					owner: this,
					prepareImage: this.prepareImage
				}
			);
			this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageHandler);
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function addedToStageHandler(event:Event):void
		{
			this.intro.play();
		}

		/**
		 * 
		 */
		private function createBackground():Sprite
		{
			if (!this.background)
			{
				this.background = new Sprite();
				var g:Graphics = this.background.graphics;
				g.beginFill(0x333333);
				g.drawRect(-150, -100, 300, 200);
				g.endFill();
				this.addChild(this.background);
			}
			return this.background;
		}
		
		/**
		 * 
		 */
		private function prepareImage():void
		{
			if (!this.image)
				throw new Error("No image has been set!");
			
			this.image.alpha = 0;
			this.addChild(this.image);
			this.image.width = 100;
			this.image.height = 100;
			this.image.x = -this.image.width / 2;
			this.image.y = -this.image.height / 2;
		}
		
	}
	
}