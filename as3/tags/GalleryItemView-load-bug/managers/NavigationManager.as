﻿package inky.framework.managers
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import inky.framework.utils.EqualityUtil;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import inky.framework.core.inky_internal;
	import inky.framework.core.Section;
	import inky.framework.core.SectionOptions;
	import inky.framework.core.SPath;
	import inky.framework.core.SectionInfo;
	import inky.framework.events.NavigationEvent;
	import inky.framework.events.SectionEvent;
	import inky.framework.events.TransitionEvent;
	import inky.framework.managers.LoadManager;
	import inky.framework.utils.Debugger;


	/**
	 *
	 * Handles the navigation-related tasks of an application, including
	 * manipulation of the URL and navigation triggered by URL changes. One
	 * NavigationManager is created automatically for each application. This
	 * class should be considered an implementation detail and is subject to
	 * change.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Eric Eldredge
	 * @author Matthew Tretter
	 * @since  2007.11.28
	 *
	 */
	public class NavigationManager
	{
		private var _cmdQueue:Array;
		private var _currentInitializeOptions:Dictionary;
		private var _currentSPath:SPath;
		private var _currentSubsections:Dictionary;
		private var _currentAddress:String;
		private var _lastNav:Dictionary;
		private var _lastRequestedSPath:SPath;
		private var _masterSection:Section;
		private var _nextSPath:SPath;
		private var _navHistory:Array;
		private var _sectionOptions:Object;


		/**
		 *
		 * Creates a new navigation controller for the specified master
		 * section.
		 *	
		 * @param master
		 *     The master section whose subsections should delegate navigation-
		 *     related tasks to this object.
		 *	
		 */
		public function NavigationManager(master:Section)
		{
			this._masterSection = master;
			this._init();
		}




		//
		// public methods
		//


		/**
		 *
		 *	
		 */
		public function closeSection(section:Section):void
		{
			var lastNav:Array = this._lastNav[section];
			if (lastNav != null)
				section.gotoSection.apply(null, lastNav);
			else
				this._gotoAddress('#/');
		}


		/**
		 *
		 * Gets a reference to the current subsection of the provided section.
		 *
		 * @param section
		 *     The section whose current subsection should be determined.
		 * @return
		 *     The current subsection of the provided section, or null if the
		 *     section has no subsection.
		 *	
		 */
		public function getCurrentSubsection(section:Section):Section
		{
			return this._currentSubsections[section];
		}


		/**
		 * 
		 * Inintiates navigation to another section. Sections delegate
		 * navigation resposibility by calling this method.
		 *	
		 * @see inky.framework.core.Section#gotoSection()
		 *	
		 * @param target
		 *     The section to which to navigate, as represented by an SPath
		 *     object or SPath string.
		 * @see inky.framework.core.SPath
		 * @param options
		 *     A map of options to use for the navigation. This map will be
		 *     passed to the target section's <code>initialize</code> method
		 *     and be used (in conjunction with Routes) to construct the
		 *     section's URL.
		 * @see inky.framework.core.Section#initialize()
		 * @see inky.framework.utils.Route
		 *	
		 */
		public function gotoSection(target:Object, options:Object = null):void
		{
			var sPath:SPath = target is String ? SPath.parse(target as String) : target as SPath;

			if (sPath)
			{
				// Use the special _base options property.
				if (options && options.hasOwnProperty('_base') && options['_base'])
				{
					var newOptions:Object = {};
					var prop:String;
					for (prop in options['_base'])
					{
						newOptions[prop] = options['_base'][prop];
					}
					delete options['_base'];
					for (prop in options)
					{
						newOptions[prop] = options[prop];
					}
					options = newOptions;
				}

				// Make the SPath absolute.
				sPath = sPath.absolute ? sPath : sPath.resolve(this._masterSection.sPath);
				sPath = sPath.normalize();

				// Resolve the SPath.
				sPath = this._masterSection.inky_internal::getInfo().resolveSPath(sPath);
				var info:SectionInfo = this._masterSection.inky_internal::getInfo().getSectionInfoBySPath(sPath);

				//
				// Do the actual navigation
				//

				if (!info)
				{
					throw new ArgumentError('Section ' + sPath + ' does not exist');
				}

				if (info.href)
				{
					this._masterSection.gotoURL(info.href, info.hrefTarget);
					return;
				}

				// If inadequate routing information is provided, just goto the section normally.
				var useSPath:Boolean = false;
				try
				{
					var url:String = info.routeMapper.getURL(info.sPath, options);

					if ((url != null) && (url != this._currentAddress))
					{
						this._nextSPath = sPath;
						this._gotoAddress(url, sPath);
						
						// SWFAddress will throw security errors sometimes.
						try
						{
							SWFAddress.setValue(url.replace(/^#(.*)$/, '$1'));
						}
						catch(error:Error)
						{
							Debugger.traceWarning('There was an error generating the URL: ' + error.message);
						}
					}
					else
					{
						useSPath = true;
					}
				}
				catch (error:Error)
				{
					Debugger.traceWarning(error.message);
					useSPath = true;
				}

				if (useSPath)
				{
					this._gotoSection(sPath, options);
				}
			}
		}


		/**
		 *
		 * Initializes the navigation controller, resulting in the immediate
		 * navigation to the application's initial section (as specified by 
		 * either the URL or the defaultSubsection attributes in the inkyXML).
		 *	
		 */
		public function initialize():void
		{
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, this._addressChangeHandler);
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 */
		private function _addCommandCompleteListener(cmd:Object, target:IEventDispatcher, type:String):void
		{
			target.addEventListener(type, this._commandCompleteHandler, false, 0, true);
			cmd.completeListener = {target: target, type: type};
		}


		/**
		 *
		 * 
		 * 
		 *
		 */
		private function _addressChangeHandler(e:SWFAddressEvent):void
		{
			// Sometimes SWFAddress will report false changes. We'll keep it honest by checking against the last value.
			var address:String = e.value == '/' ? '#/' : '#' + e.value;
			if (address != this._currentAddress)
			{
				this._gotoAddress(address);
			}
		}


		/**
		 *
		 *	
		 */
		private function _cancelCommandAt(index:int):void
		{
			var cmd:Object = this._cmdQueue[index];
			if (this.hasOwnProperty(cmd.type + 'Cancel'))
			{
				this[cmd.type + 'Cancel']();
			}
		}


		/**
		 *
		 *	
		 */
		private function _commandCompleteHandler(e:Event = null):void
		{
			// Remove the completed item from the queue.
			var cmd:Object = this._cmdQueue.shift();
			this._removeCommandCompleteListener(cmd);

			// Process the next command in the queue.
			this._runCommandQueue();
		}


		/**
		 *
		 * Gets a reference to the current "leaf" section (the section without any subsection)	
		 *	
		 */
		private function _getLeafSection():Section
		{
			// Get the current section.
			var section:Section = this._masterSection;
			while (section.currentSubsection)
			{
				section = section.currentSubsection;
			}

			return section;
		}


		/**
		 *
		 * Goes to the address specified. Because multiple sections can have
		 * the same routing, the method allows you to specifiy the target
		 * SPath, however it isn't necessary as the RouteMapper can figure out
		 * the section from the address.
		 *	
		 * @param address
		 *     The address to navigate to.
		 * @param sPath
		 *     (optional) The section to navigate to. If not provided, it will
		 *     be determined by the RouteMapper
		 * @see inky.utils.RouteMapper
		 *	
		 */
		private function _gotoAddress(address:String, sPath:SPath = null):void
		{
			this._currentAddress = address;

			sPath = sPath || this._nextSPath || this._masterSection.inky_internal::getInfo().routeMapper.getSPath(address);
			this._nextSPath = null;
			var options:Object = this._masterSection.inky_internal::getInfo().routeMapper.getOptions(address, sPath);

			if (!sPath)
			{
				throw new Error('Couldn\'t resolve the following url hash: ' + address);
			}

			this._gotoSection(sPath, options);
		}


		/**
		 *	
		 * Performs the actual navigation process.
		 *	
		 * @see inky.framework.core.NavigationManager#gotoSection()
		 * @see inky.framework.core.Section#gotoSection()
		 *	
		 * @param target
		 *     The section to which to navigate, as represented by an SPath
		 *     object or SPath string.
		 * @see inky.framework.core.SPath
		 * @param options
		 *     A map of options to use for the navigation. This map will be
		 *     passed to the target section's <code>initialize</code> method
		 *     and be used (in conjunction with Routes) to construct the
		 *     section's URL.
		 * @see inky.framework.core.Section#initialize()
		 * @see inky.framework.utils.Route
		 *	
		 */
		public function _gotoSection(sPath:SPath, options:Object):void
		{
			var i:int;

			// Resolve the SPath.
			sPath = this._masterSection.inky_internal::getInfo().resolveSPath(sPath);
			options = options || this._sectionOptions;

			if (EqualityUtil.objectsAreEqual(sPath, this._lastRequestedSPath) && new SectionOptions(options).equals(new SectionOptions(this._sectionOptions)))
			{
				// We're already there!
				return;
			}

			var info:SectionInfo = this._masterSection.inky_internal::getInfo().getSectionInfoBySPath(sPath);
			this._sectionOptions = options;
			this._lastRequestedSPath = sPath.clone() as SPath;

			// Store the navigation in a history list. This list is used to add
			// the section.close() functionality.
			this._navHistory.push([sPath, options]);
			if (this._navHistory.length > 2)
			{
				this._navHistory = this._navHistory.slice(-2);
			}

			if (!info)
			{
				throw new ArgumentError('Section ' + sPath + ' does not exist');
			}


			//
			// Manipulate the command queue.
			//

			var commandQueueIsRunning:Boolean = this._cmdQueue.length > 0;

			// Should the current nav action be cancelled?
			var cancelCurrentCommand:Boolean = false;
			if (this._currentSPath.length > sPath.length)
			{
				cancelCurrentCommand = true;
			}
			else
			{
				for (i = 0; i < this._currentSPath.length; i++)
				{
					if (this._currentSPath.getItemAt(i) != sPath.getItemAt(i))
					{
						cancelCurrentCommand = true
						break;
					}
				}
			}

			// Remove all but the current command from the command queue.
			this._cmdQueue = this._cmdQueue.length ? [this._cmdQueue[0]] : [];

// Remove progress bars (if they are currently added).
//this._cmdQueue.push({type: '__removeProgressBars'});

			// Determine what sections need to be left.
			var index:int = 0;
			while ((index < sPath.length) && (index < this._currentSPath.length))
			{
				if (this._currentSPath.getItemAt(index) != sPath.getItemAt(index))
				{
					break;
				}
				index++;
			}

// TODO: Eventually, we should have some kind of switch to determine whether to preload
// before or after __leaveSubsection.
			// Update the preload load queue to include everything for preload before gotoSection happens.

			var leafSPath:SPath = this._currentSPath.clone() as SPath;
			while (leafSPath.length > index)
			{
				leafSPath.removeItemAt(leafSPath.length - 1);
			}
			var section:Section = this._getLeafSection();

			while (!section.sPath.equals(leafSPath))
			{
				section = section.owner;
			}
			this._cmdQueue.push({type: '__preload', name: sPath, context: section});
			this._cmdQueue.push({type: '__removeProgressBars', context: section});

			// Insert "leaveSubsection" commands for each section to leave.
			for (i = index; i < this._currentSPath.length; i++)
			{
				this._cmdQueue.push({type: '__leaveSubsection'});
			}

			// Reinitialize the sections that have not been removed.
			this._cmdQueue.push({type: '__updateAllOptions'});

			// Insert "gotoSubsection" commands for each subsection to go to.
			for (i = index; i < sPath.length; i++)
			{
				this._cmdQueue.push({type: '__updateSPath', name: sPath.getItemAt(i)});
				this._cmdQueue.push({type: '__addSubsection'});
			}

			// If the current nav action should be cancelled, cancel it.
			if (cancelCurrentCommand)
			{
				this._cancelCommandAt(0);
			}

			if (!commandQueueIsRunning)
			{
				this._runCommandQueue();
			}

			// Dispatch gotoSection events.
			var sectionChain:Array = [];
			var tmp:Section = this._masterSection;
			while (tmp)
			{
				sectionChain.unshift(tmp);
				tmp = tmp.currentSubsection;
			}
			for each (tmp in sectionChain)
			{
				// TODO: Should we really use the actual options object? Is the options argument passed to this function complete or does it need to be tweaked first?
				tmp.dispatchEvent(new NavigationEvent(NavigationEvent.GOTO_SECTION, false, false, sPath, options, this._currentSPath, this._sectionOptions));
			}
		}


		/**
		 *
		 *	
		 */
		private function _init():void
		{
			this._cmdQueue = [];
			this._currentInitializeOptions = new Dictionary(true);
			this._currentSPath = new SPath();
			this._currentSPath.absolute = true;
			this._currentSubsections = new Dictionary(true);
			this._lastNav = new Dictionary(true);
			this._navHistory = [];
			this._sectionOptions = {};
		}


		/**
		 *
		 * 
		 * 
		 */
 		private function _initializeSection(section:Section):void
		{
			section.initialize();
		}


		/**
		 *
		 *	
		 *	
		 */
		private function _removeCommandCompleteListener(cmd:Object):void
		{
			var obj:Object = cmd.completeListener;

			if (obj && obj.target)
			{
				obj.target.removeEventListener(obj.type, this._commandCompleteHandler);
				cmd.completeListener = undefined;
			}
		}


		/**
		 *
		 *	
		 */
		private function _runCommandQueue():void
		{
			// If the command queue is empty, don't do nuthin.
			if (this._cmdQueue.length == 0) return;

			var nextCommand:Object = this._cmdQueue[0];
			try
			{
				this[nextCommand.type](nextCommand);
			}
			catch (error:Error)
			{
// TODO: Remove listeners on first item?
				// Empty the command queue.
				this._cmdQueue = [];
				throw(error);
			}
		}


		/**
		 *
		 *	
		 */
		private function _updateOptions(section:Section):void
		{
			section.options.update(this._sectionOptions);
		}




		//
		// commands
		//




private static var _sections2SPaths:Dictionary = new Dictionary(true);

public static function getSPath(section:Section):SPath
{
	// FIXME: This shouldn't be required to fall back to '/'
	var sPath:SPath = NavigationManager._sections2SPaths[section];
	if (sPath == null)
	{
		sPath =
		NavigationManager._sections2SPaths[section] = SPath.parse('/');
	}
	return sPath;
}


		/**
		 *
		 *	
		 *	
		 */
		private function __addSubsection(cmd:Object):void
		{
			// Get the section's info.
			var info:SectionInfo = this._masterSection.inky_internal::getInfo().getSectionInfoBySPath(this._currentSPath);

			// Get the section's owner (the section to which the new one should be added).
			var owner:Section = this._getLeafSection();

			// Find the definition for the subsection class.
			var subsectionClassName:String = info.className;
			var subsectionClass:Class;
			try
			{
				subsectionClass = getDefinitionByName(subsectionClassName) as Class;
			}
			catch (error:Error)
			{
				throw new Error('The definition ' + subsectionClassName + ' could not be found.');
			}

			// Create the subsection and add it to the section hierarchy.
			var subsection:Section = new subsectionClass();
			NavigationManager._sections2SPaths[subsection] = this._currentSPath.clone();
			Section.setSection(subsection, owner);
			this._currentSubsections[owner] = subsection;
			this._lastNav[subsection] = this._navHistory[this._navHistory.length - 2];

			// Set the section's info.
			subsection.inky_internal::setInfo(info);

			// Set the section's data.
			var data:XML = info.inky_internal::getData();
			subsection.markupObjectManager.setData(subsection, data);

			// Initialize the subsection.
			owner.dispatchEvent(new SectionEvent(SectionEvent.SUBSECTION_INITIALIZE, true));
			this._initializeSection(subsection);
			this._updateOptions(subsection);
			
			// Listen for the addComplete event from the subsection.
			this._addCommandCompleteListener(cmd, subsection, 'addComplete');

			// Add the section to its owner.
			owner.addSubsection(subsection);
			owner.dispatchEvent(new SectionEvent(SectionEvent.NAVIGATION_COMPLETE, true));
		}


		/**
		 *
		 * Leave the currently active section. (The section with no subsection.)	
		 *	
		 */
		private function __leaveSubsection(cmd:Object):void
		{
			// Remove the section from the current SPath.
			this._currentSPath.removeItemAt(this._currentSPath.length - 1);

			var section:Section = this._getLeafSection();
			var owner:Section = Section.getSection(section);
			delete this._currentSubsections[owner];

			// Leave the current section. When it has been left, continue
			// processing the command queue.
			this._addCommandCompleteListener(cmd, section, 'leaveComplete');
			section.leave();
		}


		/**
		 *
		 * Removes the progress bars from the current section.	
		 *	
		 */
		private function __removeProgressBars(cmd:Object):void
		{
			var loadManager:LoadManager = cmd.context.inky_internal::getLoadManager();
			this._addCommandCompleteListener(cmd, loadManager, 'removeProgressBarsComplete');
			loadManager.removeProgressBars();
		}


		/**
		 *
		 *	
		 *	
		 */
		private function __preload(cmd:Object):void
		{
			var loadManager:LoadManager = cmd.context.inky_internal::getLoadManager();
			this._addCommandCompleteListener(cmd, loadManager, 'preloadComplete');
			loadManager.preload(cmd.name);
		}


		/**
		 *
		 *	
		 *	
		 */
		private function __preloadCancel(cmd:Object):void
		{
// close the loadqueue
// add a command to hide the progressbars after this preload command.

// Mark the command as done and move on to the next.
this._commandCompleteHandler();
		}


		/**
		 *
		 *	
		 */
		private function __updateAllOptions(cmd:Object):void
		{
			var section:Section = this._masterSection;
			while (section)
			{
				this._updateOptions(section);
				section = section.currentSubsection;
			}

			// This command is done. Move on to the next.
			this._commandCompleteHandler();	
		}


		/**
		 *
		 *	
		 */
		private function __updateSPath(cmd:Object):void
		{
			// Update the current SPath.
			this._currentSPath.addItem(cmd.name);

			// This command is done. Move on to the next.
			this._commandCompleteHandler();
		}




	}
}
