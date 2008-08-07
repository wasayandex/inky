package inky.framework.managers
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import inky.framework.core.inky_internal;
	import inky.framework.core.Section;
	import inky.framework.data.SectionInfo;
	import inky.framework.events.SectionEvent;
	import inky.framework.events.TransitionEvent;
	import inky.framework.managers.LoadManager;
	import inky.framework.utils.SPath;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;


	/**
	 *
	 * Handles the navigation-related tasks of an application, including
	 * manipulation of the URL and navigation triggered by URL changes. One
	 * NavigationManager is created automatically for each application.
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
		private var _currentURL:String;
		public var initializeOptions:Object;
		private var _masterSection:Section;


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
		 * @see inky.framework.utils.SPath
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
				// Make the SPath absolute.
				sPath = sPath.absolute ? sPath : sPath.resolve(this._masterSection.sPath);
				sPath = sPath.normalize();

				// Resolve the SPath.
				sPath = this._masterSection.getInfo().resolveSPath(sPath);
				var info:SectionInfo = this._masterSection.getInfo().getSectionInfoBySPath(sPath);

				if (!info)
				{
					throw new ArgumentError('Section ' + sPath + ' does not exist');
				}

				if (info.href)
				{
					this._masterSection.gotoLink(info.href);
					return;
				}

				// If inadequate routing information is provided, just goto the section normally.
				var useSPath:Boolean = false;
				try
				{
					var url:String = info.routeMapper.getURL(info.sPath, options);

					if ((url != null) && (url != this._currentURL))
					{
						// SWFAddress will throw security errors sometimes. If it does,
						// call the handler directly. (This way we still use url.)
						try
						{
							SWFAddress.setValue(url.replace(/^#(.*)$/, '$1'));
						}
						catch(error:Error)
						{
							this._addressChangeHandler(url);
						}
					}
					else
					{
						useSPath = true;
					}
				}
				catch (error:Error)
				{
					trace('Warning: ' + error.message);
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
			/*this._cmdQueue.push({type: '__initialize'});
			this._runCommandQueue();*/
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
		private function _addressChangeHandler(o:Object):void
		{
			var url:String = o is SWFAddressEvent ? o.value == '/' ? '#/' : '#' + o.value : o as String;
			this._currentURL = url;

			var sPath:SPath = this._masterSection.getInfo().routeMapper.getSPath(url);
			var options:Object = this._masterSection.getInfo().routeMapper.getOptions(url, sPath);

			if (!sPath)
			{
				throw new Error('Couldn\'t resolve the following url hash: ' + url);
			}
			this._gotoSection(sPath, options);
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
		 * Performs the actual navigation process. Unlike gotoSection(), this
		 * method is unrelated to the browser URL. Instead, this method is
		 * called as a result of a changing URL or as a fallback when the
		 * the application has a problem using URL-based navigation.
		 *	
		 * @see inky.framework.core.NavigationManager#gotoSection()
		 * @see inky.framework.core.Section#gotoSection()
		 *	
		 * @param target
		 *     The section to which to navigate, as represented by an SPath
		 *     object or SPath string.
		 * @see inky.framework.utils.SPath
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
			sPath = this._masterSection.getInfo().resolveSPath(sPath);
			var info:SectionInfo = this._masterSection.getInfo().getSectionInfoBySPath(sPath);
			this.initializeOptions = options || {};

			if (!info)
			{
				throw new ArgumentError('Section ' + sPath + ' does not exist');
			}

			if (info.href)
			{
// TODO: Should be called on section that called this.
				this._masterSection.gotoLink(info.href);
				return;
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
			this._cmdQueue.push({type: '__removeProgressBars'});

			// Insert "leaveSubsection" commands for each section to leave.
			for (i = index; i < this._currentSPath.length; i++)
			{
				this._cmdQueue.push({type: '__leaveSubsection'});
			}

			// Reinitialize the sections that have not been removed.
			this._cmdQueue.push({type: '__reinitializeSections'});

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
		}


		/**
		 *
		 *	
		 */
		private function _init():void
		{
			this.initializeOptions = {};
			this._cmdQueue = [];
			this._currentInitializeOptions = new Dictionary(true);
			this._currentSPath = new SPath();
			this._currentSPath.absolute = true;
			this._currentSubsections = new Dictionary(true);
		}



		/**
		 *
		 * 
		 * 
		 */
 		private function _initializeSection(section:Section):void
		{
			var currentInitializeOptions:Object = this._currentInitializeOptions[section];
			var initOptionsChanged:Boolean = currentInitializeOptions && this.initializeOptions ? false : true;
			if (!initOptionsChanged)
			{
				var key:String;
				for (key in currentInitializeOptions)
				{
					if (currentInitializeOptions[key] != this.initializeOptions[key])
					{
						initOptionsChanged = true;
						break;
					}
				}

				if (!initOptionsChanged)
				{
					for (key in this.initializeOptions)
					{
						if (currentInitializeOptions[key] != this.initializeOptions[key])
						{
							initOptionsChanged = true;
							break;
						}
					}
				}
			}

			if (initOptionsChanged)
			{
				this._currentInitializeOptions[section] = this.initializeOptions;
				section.initialize(this.initializeOptions);
			}
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




		//
		// commands
		//


		/**
		 *
		 *	
		 *	
		 */
		private function __addSubsection(cmd:Object):void
		{
			// Get the section's info.
			var info:SectionInfo = this._masterSection.getInfo().getSectionInfoBySPath(this._currentSPath);

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
			Section.setSection(subsection, owner);
			this._currentSubsections[owner] = subsection;

			// Set the section's info.
			subsection.setInfo(info);

			// Set the section's data.
			var data:XML = info.inky_internal::getData();
			subsection.markupObjectManager.setData(subsection, data);

			// Because the section may have no intro (or the intro may finish
			// immediately upon adding the section to the stage), we need to
			// do some special handling to make sure that sections are
			// initialized in the correct order.
			var introIsFinished:Boolean = false;
			var handler:Function = function(e:TransitionEvent):void
			{
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				introIsFinished = true;
			};
			subsection.addEventListener(TransitionEvent.TRANSITION_FINISH, handler, false, 0, true);

			// Add the section to its owner.
			owner.addSubsection(subsection);
			subsection.removeEventListener(TransitionEvent.TRANSITION_FINISH, handler);
			owner.dispatchEvent(new SectionEvent(SectionEvent.NAVIGATION_COMPLETE, true));

			// Initialize the subsection.
			this._initializeSection(subsection);
			
			if (!introIsFinished)
			{
				this._addCommandCompleteListener(cmd, subsection, TransitionEvent.TRANSITION_FINISH);
			}
			else
			{
				this._commandCompleteHandler();
			}
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
			var section:Section = this._getLeafSection();
			if (section.hasProgressBars())
			{
				this._addCommandCompleteListener(cmd, section, 'removeProgressBarsComplete');
				section.removeProgressBars();
			}
			else 
			{
				this._commandCompleteHandler();
			}
		}


		/**
		 *
		 *	
		 *	
		 */
		private function __preload(cmd:Object):void
		{
			var loadManager:LoadManager = cmd.context.loadManager;
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
		private function __reinitializeSections(cmd:Object):void
		{
			var section:Section = this._masterSection;
			while (section)
			{
				this._initializeSection(section);
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


		/**
		 *
		 *	
		 */
		/*private function __initialize(cmd:Object):void
		{
			var info:SectionInfo = this._masterSection.getInfo();
			var data:XML = info.inky_internal::getData();
			var loadManager:LoadManager = this._masterSection.loadManager;

			this._addCommandCompleteListener(cmd, loadManager, 'includeLoadComplete');
			loadManager.loadXMLIncludes(data);
		}*/



	}
}
