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
	public class SlideInBottomAction extends TweenerAction
	{
		
		/**
		 *
		 * 
		 * 
		 */
		public function SlideInBottomAction(userParams:Object = null)
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
			this.tweenParams.y = this.target.y;
			this.target.y = this.target.parent.getBounds(this.target.parent).height + this.target.getBounds(this.target).height + 50;
			super.start();
		}

	}
}