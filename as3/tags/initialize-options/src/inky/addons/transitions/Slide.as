package inky.addons.transitions 
{
	import inky.addons.transitions.ActionDirection;
	import inky.addons.transitions.TweenerAction;

	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  13.08.2008
	 *
	 */
	dynamic public class Slide extends TweenerAction
	{

		
		/**
		 *
		 *	
		 *	
		 */
		public function Slide(tweenParams:Object = null)
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
				case ActionDirection.IN_BOTTOM:
					this.y = this.y || this.target.y;
					this.target.y = this.target.parent.getBounds(this.target.parent).height + this.target.getBounds(this.target).height + 50;
					break;

				case ActionDirection.IN_LEFT:
					this.x = this.x || this.target.x;
					this.target.x = -this.target.getBounds(this.target).width - 50;
					break;

				case ActionDirection.IN_RIGHT:
					this.x = this.x || this.target.x;
					this.target.x = this.target.parent.getBounds(this.target.parent).width + this.target.getBounds(this.target).width + 50;
					break;

				case ActionDirection.IN_TOP:
					this.y = this.y || this.target.y;
					this.target.y = -this.target.getBounds(this.target).height - 50;
					break;

				case ActionDirection.OUT_BOTTOM:
					this.y = this.y || this.target.parent.getBounds(this.target.parent).height + this.target.getBounds(this.target).height + 50;
					break;

				case ActionDirection.OUT_LEFT:
					this.x = this.x || -this.target.getBounds(this.target).width - 50;
					break;

				case ActionDirection.OUT_RIGHT:
					this.x = this.x || this.target.parent.getBounds(this.target.parent).width + this.target.getBounds(this.target).width + 50;
					break;

				case ActionDirection.OUT_TOP:
					this.y = this.y || -this.target.getBounds(this.target).height - 50;
					break;
			}

			this.direction = null;
			super.start();
			this.direction  = direction;
		}	



	}
	
}
