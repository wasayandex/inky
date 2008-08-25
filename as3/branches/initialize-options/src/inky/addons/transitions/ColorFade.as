package inky.addons.transitions 
{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	import flash.geom.ColorTransform;
	import inky.addons.transitions.Fade;
	
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Zack Dolin
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  13.08.2008
	 *
	 */
	dynamic public class ColorFade extends Fade
	{
		ColorShortcuts.init();

		
		/**
		 *
		 *	
		 *	
		 */
		public function ColorFade(tweenParams:Object = null)
		{
			super(tweenParams);
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
			
			var ct:ColorTransform = new ColorTransform();
			switch (this.direction)
			{
				case ActionDirection.IN:
					// set initial values for _colorTransform and alpha.
					ct.color = this._color;
					Tweener.addTween(this.target, {_colorTransform:ct, time:0});

					// set final values for _colorTransform and alpha.
					this.alpha = this.alpha || this.target.alpha || 1;
					this._colorTransform = new ColorTransform();
					break;

				case ActionDirection.OUT:
					// set final values for _colorTransform and alpha.
					ct.color = this._color;
					this._colorTransform = ct;
					this.alpha = this.alpha || 0;
					break;
			}

			this._color = null;
			super.start();
			this._color = ct.color;
		}	



	}
	
}
