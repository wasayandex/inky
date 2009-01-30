package inky.framework.controls 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import inky.framework.core.Application;
	import inky.framework.core.SPath;
	import inky.framework.events.NavigationEvent;
	import inky.framework.utils.gotoSection;
	
	/**
	 *
	 *  A decorator that provides INavigationButton behavior to an
	 *	INavigationButton. Use this when you can't use NavigationButton.
	 * 
	 *	@see inky.framework.controls.INavigationButton
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  2009.01.14
	 *
	 */
	public class NavigationButtonBehavior extends Object
	{
		private var _obj:INavigationButton;
		private var _address:String;
		private var _options:Object;
		private var _sPath:Object;
		private var _toggle:Boolean;

		
		/**
		 * 
		 *	Creates a proxy for a DisplayObject that implements INavigationButton.
		 *
		 *	@param obj
		 *		The object to decorate.
		 *	
		 */
		public function NavigationButtonBehavior(obj:INavigationButton)
		{
			this._obj = obj;
			this._obj.addEventListener(MouseEvent.CLICK, this._clickHandler, false, 0, true);
		}




		//
		// accessors
		//
		
		
		/**
		 *	@copy inky.framework.controls.INavigationButton#address
		 */
		public function get address():String
		{
			return this._address;
		}
		/**
		 * @private
		 */
		public function set address(address:String):void
		{
			this._address = address;
		}

		
		/**
		 *	@copy inky.framework.controls.INavigationButton#options
		 */
		public function get options():Object
		{
			return this._options || {};
		}
		/**
		*	
		 * @private
		 */
		public function set options(options:Object):void
		{
			this._options = options;
		}


		/**
		 *	@copy inky.framework.controls.INavigationButton#sPath
		 */
		public function get sPath():Object
		{
			return this._sPath;
		}
		/**
		 * @private
		 */
		public function set sPath(sPath:Object):void
		{
			this._sPath = SPath.parse(sPath.toString());
		}


		/**
		 *
		 *	Determines whether this button's selected state is managed by 
		 *	NavigationEvents. If set to true, the button will become 
		 *	selected if the event's target SPath matches its own, and it
		 *	will become deselected if the SPaths do not match. The button's
		 *	options must also be present on the event's options, but the
		 *	event may have other options that the button does not.
		 *	
		 *	@see com.exanimo.controls.IButton#toggle;
		 *	@see inky.framework.events.NavigationEvent;
		 *		
		 */
		public function get toggle():Boolean
		{
			return this._toggle;
		}
		/**
		 * @private
		 */
		public function set toggle(toggle:Boolean):void
		{
			var application:Application = Application.currentApplication;
			this._toggle = toggle;

			if (toggle)
			{
				if (!application)
					throw new ArgumentError('No inky Application found. Cannot set ' + this._obj + ' to toggle.');
				else
					application.addEventListener(NavigationEvent.GOTO_SECTION, this._gotoSectionHandler, false, 0, true);
			}
			else if (application)
			{
				application.removeEventListener(NavigationEvent.GOTO_SECTION, this._gotoSectionHandler);
			}
		}



		
		//
		// private methods
		//
		
		
		/**
		 *	
		 *	Handles the click event and calls gotoSection.
		 *	
		 *	@param e:MouseEvent
		 *		The MouseEvent that triggered the handler.
		 *	
		 *	@see inky.framework.core.Section#gotoSection();
		 *	
		 */
		private function _clickHandler(e:MouseEvent):void
		{
			gotoSection(this._sPath, this._options);
		}
		

		/**
		 *	
		 *	Handles the gotoSectionEvent and toggles the button.
		 *	
		 *	@param e:NavigationEvent
		 *		The NavigationEvent that triggered the handler.
		 *	
		 *	@see #toggle();
		 *	
		 */
		private function _gotoSectionHandler(e:NavigationEvent):void
		{
			var obj:Object = this._obj as Object;
			if (obj.hasOwnProperty('selected'))
			{
				var selected:Boolean = e.sPath.equals(this.sPath);
				if (selected)
				{
					for (var option:String in this.options)
					{
						selected = (e.options.hasOwnProperty(option) && e.options[option] == this.options[option]);
						if (!selected) break;
					}
				}
				if (obj.selected != selected)
				{
					obj.selected = selected;
				}
			}
		}


		

	}
	
}
