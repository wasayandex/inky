package inky.components 
{
	import inky.components.IComponent;
	import inky.components.ComponentBehavior;
	import inky.components.transitioningObject.TransitioningMovieClip;
	
	/**
	 *
	 *  An implementation of IComponent that extends TransitioningMovieClip
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.25
	 *
	 */
	public class TransitioningComponentClip extends TransitioningMovieClip implements IComponent
	{
		private var _explicitHeight:Number;
		private var _explicitWidth:Number;
		private var _proxy:ComponentBehavior;

		/**
		 *
		 */
		public function TransitioningComponentClip()
		{
			this._explicitHeight =
			this._explicitWidth = NaN;
			this._proxy = new ComponentBehavior(this);
		}
		
		
		

		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{ 
			return isNaN(this._explicitHeight) ? super.height : this._explicitHeight;
		}
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			var oldHeight:Number = this.height;
			this._explicitHeight = value;
			if (value != oldHeight)
				this.invalidateLayout();
		}


		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{ 
			return isNaN(this._explicitWidth) ? super.width : this._explicitWidth;
		}
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			var oldWidth:Number = this.width;
			this._explicitWidth = value;
			if (value != oldWidth)
				this.invalidateLayout();
		}
		
		
		

		//
		// public methods
		//
		

		/**
		 *	
		 */
		public function destroy():void
		{
		}
		
		
		/**
		 *	
		 */
		public function invalidateLayout():void
		{
			this._proxy.invalidateLayout();
		}
		

		/**
		 *	
		 */
		public function invalidateParentLayout():void
		{
			this._proxy.invalidateParentLayout();
		}
		
		
		/**
		 *	
		 */
		public function validateLayout():void
		{
			this._proxy.validateLayout();
		}
		
		
		

	}
	
}