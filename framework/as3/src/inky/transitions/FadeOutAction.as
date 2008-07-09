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
	public class FadeOutAction extends TweenerAction 
	{

		
		/**
		 *
		 * 
		 * 
		 */
		public function FadeOutAction(userParams:Object = null)
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
			if (!this.target || !this.target.alpha) return;
			this.tweenParams.alpha = this.tweenParams.alpha || 0;
			super.start();
		}	
	}
	
}
