package inky.components.buttons 
{
	import flash.display.MovieClip;
	import inky.components.buttons.IButtonClip;
	import inky.components.buttons.ButtonClipBehavior;
	import inky.commands.IAsyncCommand;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.02.01
	 *
	 */
	public class ButtonClip extends MovieClip implements IButtonClip
	{
		private var _proxy:ButtonClipBehavior;
		
		
		/**
		 *
		 */
		public function ButtonClip()
		{
			this._proxy = new ButtonClipBehavior(this);
		}
		
		
		
		
		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get disabled():IAsyncCommand
		{
			return this._proxy.disabled;
		}
		/**
		 * @private
		 */
		public function set disabled(value:IAsyncCommand):void
		{
			this._proxy.disabled = value;
		}


		/**
		 * @inheritDoc
		 */
		public function get down():IAsyncCommand
		{
			return this._proxy.down;
		}
		/**
		 * @private
		 */
		public function set down(value:IAsyncCommand):void
		{
			this._proxy.down = value;
		}


		/**
		 * @inheritDoc
		 */
		public function get emphasized():IAsyncCommand
		{
			return this._proxy.emphasized;
		}
		/**
		 * @private
		 */
		public function set emphasized(value:IAsyncCommand):void
		{
			this._proxy.emphasized = value;
		}


		/**
		 * @inheritDoc
		 */
		public function get over():IAsyncCommand
		{
			return this._proxy.over;
		}
		/**
		 * @private
		 */
		public function set over(value:IAsyncCommand):void
		{
			this._proxy.over = value;
		}


		/**
		 * @inheritDoc
		 */
		public function get selectedDisabled():IAsyncCommand
		{
			return this._proxy.selectedDisabled;
		}
		/**
		 * @private
		 */
		public function set selectedDisabled(value:IAsyncCommand):void
		{
			this._proxy.selectedDisabled = value;
		}


		/**
		 * @inheritDoc
		 */
		public function get selectedDown():IAsyncCommand
		{
			return this._proxy.selectedDown;
		}
		/**
		 * @private
		 */
		public function set selectedDown(value:IAsyncCommand):void
		{
			this._proxy.selectedDown = value;
		}


		/**
		 * @inheritDoc
		 */
		public function get selectedOver():IAsyncCommand
		{
			return this._proxy.selectedOver;
		}
		/**
		 * @private
		 */
		public function set selectedOver(value:IAsyncCommand):void
		{
			this._proxy.selectedOver = value;
		}


		/**
		 * @inheritDoc
		 */
		public function get selectedUp():IAsyncCommand
		{
			return this._proxy.selectedUp;
		}
		/**
		 * @private
		 */
		public function set selectedUp(value:IAsyncCommand):void
		{
			this._proxy.selectedUp = value;
		}


		/**
		 * @inheritDoc
		 */
		public function get up():IAsyncCommand
		{
			return this._proxy.up;
		}
		/**
		 * @private
		 */
		public function set up(value:IAsyncCommand):void
		{
			this._proxy.up = value;
		}
		

		/**
		 *
		 */
		override public function get enabled():Boolean
		{ 
			return this._proxy.enabled; 
		}
		/**
		 * @private
		 */
		override public function set enabled(value:Boolean):void
		{
			this._proxy.enabled = value;
		}
		

		/**
		 *
		 */
		public function get selected():Boolean
		{ 
			return this._proxy.selected; 
		}
		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			this._proxy.selected = value;
		}


		/**
		 *
		 */
		public function get toggle():Boolean
		{ 
			return this._proxy.toggle; 
		}
		/**
		 * @private
		 */
		public function set toggle(value:Boolean):void
		{
			this._proxy.toggle = value;
		}

		


	}
	
}