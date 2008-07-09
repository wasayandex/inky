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
	public class ColorFadeInAction extends ColorTweenerAction 
	{

		
		/**
		 *
		 * 
		 * 
		 */
		public function ColorFadeInAction(userParams:Object = null)
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
			this.tweenParams.alpha = this.tweenParams.alpha || this.target.alpha || 1;
			this.tweenParams._color = null;
			Tweener.addTween(this.target, {_color:this.tweenParams._color, alpha:0});
			super.start();
		}	
		
	}
	
}
