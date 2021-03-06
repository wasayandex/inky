﻿package inky.controls 
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import inky.app.Application;
	import inky.app.Section;
	import inky.app.SPath;
	import inky.app.events.NavigationEvent;
	import inky.app.utils.gotoSection;
	
	/**
	 *
	 *  A decorator that provides INavButton behavior to an
	 *	INavButton. Use this when you can't use NavButton.
	 * 
	 *	@see inky.controls.INavButton
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
	public class NavButtonBehavior extends Object
	{
		private var _obj:InteractiveObject;
		private var _address:String;
		private var _options:Object;
		private var _sPath:Object;
		private var _autoSelect:Boolean;

		
		/**
		 * 
		 *	Creates a proxy for a DisplayObject that implements INavButton.
		 *
		 *	@param obj
		 *		The object to decorate.
		 *	
		 */
		public function NavButtonBehavior(obj:InteractiveObject)
		{
			if (obj == null)
			{
				throw new ArgumentError();
			}
			this._obj = obj;
			this._setSelected(false);

			this._obj.addEventListener(MouseEvent.CLICK, this._clickHandler, false, 0, true);

			if (this._obj.parent)
				this._addedToStageHandler(null);
			else
				this._obj.addEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler);

			this._obj.addEventListener(Event.REMOVED_FROM_STAGE, this._removedFromStageHandler);
		}




		//
		// accessors
		//
		
		
		/**
		 *	@copy inky.controls.INavButton#address
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
		 *
		 *	Determines whether this button's selected state is managed by 
		 *	NavigationEvents. If set to true, the button will become 
		 *	selected if the event's target SPath matches its own, and it
		 *	will become deselected if the SPaths do not match. The button's
		 *	options must also be present on the event's options, but the
		 *	event may have other options that the button does not.
		 *	
		 *	@see inky.components.IButton#toggle;
		 *	@see inky.app.events.NavigationEvent;
		 *		
		 */
		public function get autoSelect():Boolean
		{
			return this._autoSelect;
		}
		/**
		 * @private
		 */
		public function set autoSelect(autoSelect:Boolean):void
		{
			var application:Application = Application.currentApplication;
			this._autoSelect = autoSelect;

			if (autoSelect)
			{
				if (!application)
					throw new ArgumentError('No inky Application found. Cannot set ' + this._obj + ' to autoSelect.');
				else if (this._obj.parent)
					this._addedToStageHandler(null);
			}
			else if (application)
			{
				application.removeEventListener(NavigationEvent.GOTO_SECTION, this._gotoSectionHandler);
			}
		}

		
		/**
		 *	@copy inky.controls.INavButton#options
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
		 *	@copy inky.controls.INavButton#sPath
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
			if (this.autoSelect)
			{
				var selected:Boolean = this._isSPathActive();
				this._setSelected(selected);
			}
		}



		
		//
		// private methods
		//
		
		
		/**
		 *	
		 */
		private function _addedToStageHandler(e:Event):void
		{
			if (this.autoSelect)
			{
				Application.currentApplication.addEventListener(NavigationEvent.GOTO_SECTION, this._gotoSectionHandler, false, 0, true);
				if (this.sPath)
				{
					var selected:Boolean = this._isSPathActive();
					this._setSelected(selected);
				}
			}
		}
		
		
		/**
		 *	
		 */
		private function _isSPathActive():Boolean
		{
			if (!this.sPath) return false;
			var section:Section = Section.getSectionBySPath(this.sPath.toString());
			var selected:Boolean = section != null;

			if (selected)
				selected = this._optionsAreEqual(section.options);

			return selected;
		}

		
		/**
		 *	
		 *	Handles the click event and calls gotoSection.
		 *	
		 *	@param e:MouseEvent
		 *		The MouseEvent that triggered the handler.
		 *	
		 *	@see inky.app.Section#gotoSection();
		 *	
		 */
		private function _clickHandler(e:MouseEvent):void
		{
			var section:Section = Application.activeSection;
			var sPath:String = this._sPath.toString();

			if (!sPath.indexOf('/') == 0)
				sPath = section.sPath.toString() + '/' + sPath;

			section.gotoSection(sPath, this._options);
		}
		

		/**
		 *	
		 *	If autoSelect is true, this handler toggles
		 *	the button's selected state.
		 *	
		 *	@param e:NavigationEvent
		 *		The NavigationEvent that triggered the handler.
		 *	
		 *	@see #autoSelect();
		 *	
		 */
		private function _gotoSectionHandler(e:NavigationEvent):void
		{
			var obj:Object = this._obj as Object;
			var selected:Boolean = e.sPath.equals(this.sPath);

			if (selected)
				selected = this._optionsAreEqual(e.options);

			this._setSelected(selected);
		}

		
		/**
		 *	
		 */
		private function _optionsAreEqual(options:Object):Boolean
		{
			var selected:Boolean = true;
			for (var option:String in this.options)
			{
				selected = (options.hasOwnProperty(option) && options[option] == this.options[option]);
				if (!selected) break;
			}
			return selected;
		}
		
		
		/**
		 *	
		 */
		private function _removedFromStageHandler(e:Event):void
		{
			Application.currentApplication.removeEventListener(NavigationEvent.GOTO_SECTION, this._gotoSectionHandler);
		}
		
		
		/**
		 *	@private
		 */
		private function _setSelected(selected:Boolean):void
		{
			var obj:Object = this._obj;
			if (obj.hasOwnProperty('selected'))
			{
				obj.selected = selected;
			}
		}

		

	}
	
}
