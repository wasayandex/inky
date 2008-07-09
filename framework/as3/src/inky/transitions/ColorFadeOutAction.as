package inky.transitions 
{
	import caurina.transitions.Tweener;
	import inky.transitions.ColorTweenerAction;

	
	/**
	 *
	 *  ..
	 * 
	 * 	@langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @since  13.04.2008
	 *
	 */
	public class ColorFadeOutAction extends ColorTweenerAction 
	{

		
		/**
		 *
		 * 
		 * 
		 */
		public function ColorFadeOutAction(userParams:Object = null)
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
