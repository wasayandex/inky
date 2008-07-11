package inky.transitions 
{
	import inky.transitions.TweenerAction;

	
	/**
	 *
	 *  ..
	 * 
	 * 	@langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @since  15.02.2008
	 *
	 */
	public class ZoomOutAction extends TweenerAction 
	{

		
		/**
		 *
		 * 
		 * 
		 */
		public function ZoomOutAction(userParams:Object = null)
		{
			super(userParams);
		}

		
		//
		// public methods
		//


		/**
		 *
		 * 
		 * 
		 */
		public override function start():void
		{
			if (!this.target || !this.target.scaleX || !this.target.scaleY) return;
			this.tweenParams.scaleX = this.tweenParams.scaleX || 0;
			this.tweenParams.scaleY = this.tweenParams.scaleY || 0;
			this.tweenParams.x = this.tweenParams.x || this.target.x + (this.target.width / 2);
			this.tweenParams.y = this.tweenParams.y || this.target.y + (this.target.height / 2);
			super.start();
		}	
	}
	
}
