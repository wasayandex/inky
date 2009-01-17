package inky.framework.controls 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import inky.framework.core.Section;
	import inky.framework.core.SPath;
	import inky.framework.events.NavigationEvent;
	import inky.framework.utils.gotoSection;
	
	/**
	 *
	 *  A decorator that provides INavigationButton behavior to a
	 *	DisplayObject. Use this when you can't use NavigationButton.
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
		private var _obj:DisplayObject;
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
		public function NavigationButtonBehavior(obj:DisplayObject)
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
			return this._options;
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
		 *	@copy inky.framework.controls.INavigationButton#toggle
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
			this._toggle = toggle;

			var section:Section = Section.getSection(this._obj);
			if (toggle)
			{
				section.addEventListener(NavigationEvent.GOTO_SECTION, this._gotoSectionHandler);
			}
			else
			{
				section.removeEventListener(NavigationEvent.GOTO_SECTION, this._gotoSectionHandler);
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
					//TODO: Test this. Is it working??
					for (var option:String in this.options)
					{
break;
						selected = e.options.hasOwnProperty(option);
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