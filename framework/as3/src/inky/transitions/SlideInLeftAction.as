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
	 * @since  21.05.2008
	 *
	 */
	public class SlideInLeftAction extends TweenerAction
	{
		
		/**
		 *
		 * 
		 * 
		 */
		public function SlideInLeftAction(userParams:Object = null)
		{
			userParams = userParams || new Object();
			userParams.transition = userParams.transition || 'easeOutExpo';
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
			this.tweenParams.x = this.target.x;
			this.target.x = -this.target.getBounds(this.target).width - 50;
			super.start();
		}

	}
}