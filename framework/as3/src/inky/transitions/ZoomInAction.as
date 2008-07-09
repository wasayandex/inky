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
	public class ZoomInAction extends TweenerAction 
	{

		
		/**
		 *
		 * 
		 * 
		 */
		public function ZoomInAction(userParams:Object = null)
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
			if (!this.target) return;
			this.tweenParams.scaleX = this.tweenParams.scaleX || this.target.scaleX || 1;
			this.tweenParams.scaleY = this.tweenParams.scaleY || this.target.scaleY || 1;
			this.tweenParams.x = this.tweenParams.x || this.target.x;
			this.tweenParams.y = this.tweenParams.y || this.target.y;
			this.target.x = this.tweenParams.x + (this.target.width / 2);
			this.target.y = this.tweenParams.y + (this.target.height / 2);
			this.target.scaleX =
			this.target.scaleY = 0;
			super.start();
		}	
	}


}
