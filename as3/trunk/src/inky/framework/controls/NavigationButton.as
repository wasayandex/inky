package inky.framework.controls 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import inky.framework.controls.INavigationButton;
	import inky.framework.controls.NavigationButtonBehavior;

	
	/**
	 *
	 *  A basic implementation of the INavigationButton interface. This class
	 *	can be used to 'wrap' any DisplayObject with its behavior by nesting the
	 *	DisplayObject.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2009.01.12
	 *
	 */
	public class NavigationButton extends MovieClip implements INavigationButton
	{
		private var _proxy:NavigationButtonBehavior;
		private var _selected:Boolean;
		private var _targetButtons:Array;
		private var _toggle:Boolean;

		
		
		/**
		 *	Creates an instance of the NavigationButton class.
		 */
		public function NavigationButton()
		{
			this.buttonMode = true;
			this._proxy = new NavigationButtonBehavior(this);
			this._targetButtons = [];
		}
		
		
		
		
		//
		// accessors
		//
		
		
		/**
		 *	@inheritDoc
		 */
		public function get address():String
		{
			return this._proxy.address;
		}
		public function set address(address:String):void
		{
			this._proxy.address = address;
		}

		
		/**
		 *	@inheritDoc
		 */
		public function get autoSelect():Boolean
		{
			return this._proxy.autoSelect;
		}
		public function set autoSelect(autoSelect:Boolean):void
		{
			this._proxy.autoSelect = autoSelect;
		}
		
		
		/**
		 *	@inheritDoc
		 */
		public function get options():Object
		{
			return this._proxy.options;
		}
		public function set options(options:Object):void
		{
			this._proxy.options = options;
		}
		
		
		/**
		 *	
		 *	The button's selected state. The state will be applied
		 *	to any target buttons (DisplayObjects 'wrapped' by this button).
		 *	
		 *	@see #addTargetButton();
		 *	
		 */
		public function get selected():Boolean
		{
			return this._selected;
		}
		public function set selected(selected:Boolean):void
		{
			this._selected = selected;
			
			for each (var obj:Object in this._targetButtons)
			{
				if (obj.hasOwnProperty('selected'))
				{
					if (obj.selected != selected)
					{
						obj.selected = selected;
					}
				}
			}
		}


		/**
		 *	@inheritDoc
		 */
		public function get sPath():Object
		{
			return this._proxy.sPath;
		}
		public function set sPath(sPath:Object):void
		{
			this._proxy.sPath = sPath;
		}
		
		
		/**
		 *  @inheritDoc
		 */
		public function get toggle():Boolean
		{
			return this._toggle;
		}
		public function set toggle(toggle:Boolean):void
		{
			this._toggle = toggle;

			if (toggle)
			{
				this.selected = this.selected;
			}
			else
			{
				this.selected = false;
			}
		}
		
		
		
		
		//
		// public methods
		//
		
		
		/**
		 *	@inheritDoc
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			this.addTargetButton(child);
			return super.addChild(child);
		}
		

		/**
		 *	@inheritDoc
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			this.addTargetButton(child);
			return super.addChildAt(child, index);
		}
		
		
		/**
		 *
		 *	Add a DisplayObject to the list of objects to be 'wrapped' by this button's behavior.
		 *	Children of the button are automatically added to this list.
		 *	
		 *	@param	button	 
		 *		A DisplayObject that will be 'wrapped' with this button's behavior.
		 *	
		 */
		public function addTargetButton(button:DisplayObject):void
		{
			this._targetButtons.push(button);
		}


		
	}
	
}
