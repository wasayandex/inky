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
	 * @since  30.01.2008
	 *
	 */
	public class SlideOutTopAction extends TweenerAction
	{
		
		/**
		 *
		 * 
		 * 
		 */
		public function SlideOutTopAction(userParams:Object = null)
		{
			userParams = userParams || new Object();
			userParams.transition = userParams.transition || 'easeInExpo';
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
			this.tweenParams.y = -this.target.getBounds(this.target).height - 50;
			super.start();
		}
		
	}
}