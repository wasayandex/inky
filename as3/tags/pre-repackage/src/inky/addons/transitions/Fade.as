package inky.addons.transitions 
{
	import inky.addons.transitions.ActionDirection;
	import inky.framework.actions.TweenerAction;

	
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
	dynamic public class Fade extends TweenerAction
	{

		
		/**
		 *
		 *	
		 *	
		 */
		public function Fade(tweenParams:Object = null)
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
			
			var direction:String = this.direction;
			switch (direction)
			{
				case ActionDirection.IN:
					this.alpha = this.alpha || this.target.alpha || 1;
					this.target.alpha = 0;
					break;

				case ActionDirection.OUT:
					this.alpha = this.alpha || 0;
					break;
			}

			this.direction = null;
			super.start();
			this.direction  = direction;
		}	


		
	}
	
}
