package inky.framework.core
{
	import com.exanimo.controls.IProgressBar;
	import com.exanimo.controls.ProgressBarMode;
	import com.exanimo.events.LoadQueueEvent;
	import com.exanimo.utils.URLUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import inky.framework.core.inky_internal;
	import inky.framework.core.Application;
	import inky.framework.core.IInkyDataParser;
	import inky.framework.data.SectionInfo;
	import inky.framework.display.ITransitioningObject;
	import inky.framework.display.TransitioningMovieClip;
	import inky.framework.display.TransitioningObjectState;
	import inky.framework.events.TransitionEvent;
	import inky.framework.events.SectionEvent;
	import inky.framework.managers.LoadManager;
	import inky.framework.managers.MarkupObjectManager;
	import inky.framework.managers.NavigationManager;
	import inky.framework.net.IAssetLoader;
	import inky.framework.net.LoadQueue;
	import inky.framework.utils.IAction;
	import inky.framework.utils.SPath;


    /**
     * 
     * Dispatched when a Section's navigation sequence finishes.
     *
     * @eventType inky.framework.events.SectionEvent.NAVIGATION_COMPLETE
     *
     */
	[Event(name="navigationComplete", type="inky.framework.events.SectionEvent")]




	/**
	 *
	 * A graphical element that can be navigated to. Sections are roughly
	 * analogous to "pages" in a typical website, but may be nested.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2007.11.28
	 *
	 */
	public class Section extends TransitioningMovieClip implements IInkyDataParser
	{
		private var __cumulativeProgressBar:DisplayObject;
		private var _info:SectionInfo;
		private var __itemProgressBar:DisplayObject;
		private var _isRegistered:Boolean;
		private var _loadManager:LoadManager;
		private var _markupObjectManager:MarkupObjectManager;
 		private var _master:Section;
		private var _name:String;
		private var _navigationManager:NavigationManager;
		private static var _objects2Sections:Dictionary = new Dictionary(true);
		private var _sPath:SPath;




		/**
		 *
		 * Creates a new Section instance. The Section constructor should never
		 * be called directly, however. Instead, the framework will create
		 * Sections automatically when you navigate to them.
		 *
		 */
		public function Section()
		{
			this._init();
		}




		//
		// accessors
		//


		/**
		 *
		 * The Application that owns this section. If this Section is not
		 * registered with an Application, the value is null.
		 * 
		 */
		public function get application():Application
		{
			var application:Application;
			var tmp:Section = this;
			while (tmp)
			{
				if (tmp is Application)
				{
					application = tmp as Application;
					break;
				}
				tmp = Section.getSection(tmp);
			}
			return application;
		}


		/**
		 * 
		 * A progress bar that shows the cumulative progress of loading items
		 * for this section. You may set the progress bar directly or place an
		 * instance on the stage in the IDE named "_cumulativeProgressBar".
		 * 
		 * @default null
		 * 
		 */
		public function get cumulativeProgressBar():DisplayObject
		{
			return this.__cumulativeProgressBar;
		}
		/**
		 * @private
		 */		 		
		public function set cumulativeProgressBar(progressBar:DisplayObject):void
		{
			// Unregister the old queue progress bar.
			var oldProgressBar:IProgressBar = this.cumulativeProgressBar as IProgressBar;
			if (oldProgressBar)
			{
				oldProgressBar.source = null;
			}

			if (!progressBar) return;
			
			if (progressBar is IProgressBar)
			{
				(progressBar as IProgressBar).mode = ProgressBarMode.MANUAL;
			}

			this.__cumulativeProgressBar = progressBar;
			Section.setSection(this.__cumulativeProgressBar, this);
		}


		/**
		 *
		 * The current subsection. Navigate to a different subsection using
		 * <code>gotoSection()</code>.
		 *
		 * @default null
		 * @see #gotoSection()
		 * 
		 */
		public function get currentSubsection():Section
		{
			return this.inky_internal::getNavigationManager().getCurrentSubsection(this);
		}


		/**
		 * 
		 * A progress bar that shows the progress of the currently loading item.
		 * You may set the progress bar directly or place an instance on the
		 * stage in the IDE named "_itemProgressBar".
		 * 
		 * @default null
		 * 
		 */
		public function get itemProgressBar():DisplayObject
		{
			return this.__itemProgressBar;
		}
		/**
		 * @private
		 */
		public function set itemProgressBar(progressBar:DisplayObject):void
		{
			// Unregister the old item progress bar.
			var oldProgressBar:IProgressBar = this.cumulativeProgressBar as IProgressBar;
			if (oldProgressBar)
			{
				oldProgressBar.source = null;
			}
			
			if (!progressBar) return;

			this.__itemProgressBar = progressBar;
			Section.setSection(this.__itemProgressBar, this);
		}


		/**
		 * @private
		 */
		public function get markupObjectManager():MarkupObjectManager
		{
			return this._markupObjectManager;
		}


		/**
		 *
		 * The top-most Section in the owner hierarchy.
		 * 
		 */
		public function get master():Section
		{
			return this._master;
		}


		/**
		 *
		 * The section's name. An application may have several sections with
		 * the same name, but they may not have the same owner. Names are used
		 * for navigating between sections, and for forming default routes.
		 *
		 * @see #gotoSection()
		 * @see inky.framework.utils.SPath;
		 * 
		 */
		public override function get name():String
		{
			return this._name;
		}
		/**
		 * @private
		 */
		public override function set name(name:String):void
		{
			this._name = name;
			
			if (name != super.name)
			{
				try
				{
					super.name = name;
				}
				catch (error:Error)
				{
					if (this != this.application)
					{
						throw new Error('Could not set name on ' + this + '. The instance name of a Timeline-placed Section must match the value in its data provider.');
					}
				}
			}
		}


		/**
		 *
		 * The number of subsections that this section has.
		 *	
		 */
		public function get numSubsections():int
		{
			return this.inky_internal::getInfo().numSubsections;
		}


		/**
		 *
		 * The Section that owns this Section. In most cases, this is
		 * equivalent to the first Section anscestor in the display list,
		 * however, it is possible to create a Section that is not a
		 * descendant of its owner.
		 * 
		 */
		public function get owner():Section
		{
			return Section.getSection(this);
		}


		/**
		 *
		 * The location of this section within the application, as represented
		 * by an SPath object.
		 *
		 * @see inky.framework.utils.SPath
		 * 
		 */
		public function get sPath():SPath
		{
			return this._sPath || this.inky_internal::getInfo().sPath;
		}




		//
		// public methods
		//


		/**
		 *
		 * Adds the item progress bar to the display list. This method is
		 * invoked by the framework to add an item progress bar to the stage.
		 * 
		 * @param progressBar
		 *     The progress bar to add to the stage.
		 * 
		 */
		public function addItemProgressBar(progressBar:DisplayObject):void
		{
			this._addProgressBar(progressBar);
		}


		/**
		 *
		 * Adds the queue progress bar to the display list. This method is
		 * invoked by the framework to add a cumulative progress bar to the
		 * stage.
		 * 
		 * @param progressBar
		 *     The progress bar to add to the stage.
		 * 
		 */
		public function addCumulativeProgressBar(progressBar:DisplayObject):void
		{
			this._addProgressBar(progressBar);
		}


		/**
		 *
		 * @private
		 * 
		 * Adds a component as a child of this Section instance. This method is
		 * invoked when a component is created as a result of a component node
		 * in the application XML. By default, this method simply adds the
		 * component to the stage using addChild.
		 *
		 * @param component
		 *     The dynamically created component.
		 *
		 * @see flash.display.DisplayObjectContainer#addChild()
		 * 
		 */
		public function addComponent(component:DisplayObject):void
		{
			this.addChild(component);
		}


		/**
		 *
		 * Adds the subsection to the stage. This method is invoked by the
		 * framework to add a subsection to the stage.
		 *
		 * @param subsection
		 *      The section to add to the stage.
		 * 
		 */
		public function addSubsection(subsection:Section):void
		{
			this.addChild(subsection);
		}


		/**
		 * 
		 * @private
		 *	
		 * Cancels the loading of an asset. In general, this method should not
		 * be called directly. Instead, use the <code>close</code> method on the
		 * AssetLoader instance.
		 * 
		 * @param asset
		 *     The asset whose loading you wish to cancel.
		 * 
		 * @see #fetchAsset()
		 * @see #fetchAssetNow()
		 * @see inky.framework.net.IAssetLoader#close()
		 *
		 */		 		 		 		
		public function cancelFetchAsset(asset:Object):void
		{
			this.inky_internal::getLoadManager().cancelFetchAsset(asset);
		}


		/**
		 * 
		 */
		public function close():void
		{
			this.gotoSection('..', this.inky_internal::getNavigationManager().initializeOptions);
		}


		/**
		 *
		 * Invoked immediately before the section is destroyed.
		 *		
		 */
		public function destroy():void
		{
		}


		/**
		 *
		 * Initiates a file download.
		 *
		 * @param file
		 *     Either the URL of the file or a URLRequest.
		 * 
		 */
		public function download(file:Object):void
		{
			if (this == this.master)
			{
				var request:URLRequest;
				if (file is String)
				{
					request = new URLRequest(file as String);
				}
				else if (file is URLRequest)
				{
					request = file as URLRequest;
				}
				else
				{
					throw new ArgumentError('Section.download can only accept a String or URLRequest');
				}
				this.navigateToURL(request, '_self');
			}
			else
			{
				this.owner.download(file);
			}
		}


		/**
		 *
		 * @private
		 * 
		 * Pushes an asset onto the end of the current loading queue. In
		 * general, this method should not be called directly. Instead, use the
		 * <code>load</code> method on the AssetLoader instance.
		 *
		 * @see #fetchAssetNow()
		 * @see #cancelFetchAsset()
		 * @see inky.framework.net.IAssetLoader#load()
		 * 
		 */
		public function fetchAsset(asset:Object, callback:Function = null):void
		{
			this.inky_internal::getLoadManager().fetchAsset(asset, callback);
		}


		/**
		 *
		 * @private
		 * 
		 * Pushes an asset at the front of the current loading queue. In
		 * general, this method should not be called directly. Instead, use the
		 * <code>loadNow</code> method on the AssetLoader instance.
		 *
		 * @see #fetchAsset()
		 * @see #cancelFetchAsset()
		 * @see inky.framework.net.IAssetLoader#loadNow()
		 * 
		 */
		public function fetchAssetNow(asset:Object, callback:Function = null):void
		{
			this.inky_internal::getLoadManager().fetchAssetNow(asset, callback);
		}


		/**
		 * @private
		 */
		public static function getSection(obj:Object):Section
		{
			var owner:Section = Section._objects2Sections[obj];
			if (!owner && (obj is DisplayObject))
			{
				var tmp:DisplayObject = (obj as DisplayObject).parent;
				while (tmp)
				{
					if (tmp is Section)
					{
						owner = tmp as Section;
						break;
					}
					tmp = tmp.parent;
				}
			}

			return owner;
		}


		/**
		 *
		 * Navigates to a new HTML page. This method should be favored over
		 * navigateToURL. Calls to <code>gotoLink</code> are relayed up the
		 * hierarchy of sections so that overriding this method will change
		 * the behavior for subsections as well.
		 *
		 * @param url
		 *     Either the URL or a URLRequest representing the page to
		 *     navigate to.
		 *
		 */
		public function gotoLink(url:Object):void
		{
			if (this == this.master)
			{
				var request:URLRequest;
				if (url is String)
				{
					request = new URLRequest(url as String);
				}
				else if (url is URLRequest)
				{
					request = url as URLRequest;
				}
				else
				{
					throw new ArgumentError('Section.gotoLink can only accept a String or URLRequest');
				}
				this.navigateToURL(request, '_self');
			}
			else
			{
				this.owner.gotoLink(url);
			}
		}


		/**
		 *
		 * Navigates to a different part of the application. If an options
		 * argument is provided, it will be forwarded to the
		 * <code>initialize</code> method of the target section after the
		 * target section has been instantialized and used by the RouteMapper
		 * to create a deep-link url.
		 *
		 * @param target
		 *     The section to which to navigate. Targets should be provided as
		 *     SPath objects or their string equivalents. If the path is not
		 *     absolute, it will be resolved using the current section's SPath
		 *     as a base.
		 * @see inky.framework.utils.SPath
		 * @param options
		 *     (optional) A hash map of options that will be passed to the
		 *     initialize function of the target section.
		 * @see #initialize()
		 * @see inky.framework.utils.RouteMapper
		 * 
		 */
		public function gotoSection(target:Object, options:Object = null):void
		{
			if (target)
			{
				// Make the SPath absolute.
				var sPath:SPath = target is String ? SPath.parse(target as String) : target as SPath;
				sPath = sPath.absolute ? sPath : sPath.resolve(this.sPath);
				sPath = sPath.normalize();

				// Delegate navigation to the master.
				if (this == this.master)
				{
					this.inky_internal::getNavigationManager().gotoSection(sPath, options);
				}
				else
				{
					this.owner.gotoSection(sPath, options);
				}
			}
			else
			{
				throw new Error('gotoSection currently only accepts SPath Objects and SPath Strings');
			}
		}


		/**
		 * @private
		 *	
		 * Determines whether this section has a subsection with a specific name.
		 * 
		 * @param name
		 *     The name of the subsection to check for
		 * @return
		 *     true if a subsection with the given name exists, else false	
		 * 
		 */
		public function hasSubsection(name:String):Boolean
		{
			return this.sectionExists(name);
		}

		
		/**
		 *
		 * Initializes the section. Called by the framework when the Section is
		 * ready. If the navigation was triggered by Section.gotoSection, this
		 * method will be forwarded the second argument of that function. If
		 * the navigation was triggered by a change in the browser state (back
		 * button, deep link, etc.), the options argument will be a hash map
		 * of the dynamic parts of the route.
		 * 
		 * Override this method if you want your section to have dynamic
		 * content.
		 *
		 * @see inky.framework.utils.Route
		 *
		 * @param options
		 *     A hash map containg the options for this section.
		 * 
		 */
		public function initialize(options:Object):void
		{
		}


		/**
		 *
		 * Leave this section. By default, leaving a section consists of
		 * removing and destroying it, however you may override this method to
		 * alter this behavior (i.e. if you want sections to remain on stage
		 * and/or in memory even after the user has navigated to another
		 * section.) This method is should not be called directly as it does
		 * does not affect the current navigation status (browser URL, etc.).
		 * Instead use <code>gotoSection()</code>.
		 *	
		 * @see inky.framework.core.Section#gotoSection()
		 *	
		 */
		public function leave():void
		{
			this.addEventListener(TransitionEvent.TRANSITION_FINISH, this._outroCompleteHandler);
			this.remove();
		}


		/**
		 *
		 * All application url requests should come through this method, though
		 * in general, this method should not be called directly. Instead use
		 * <code>download()</code> or <code>gotoLink()</code>.
		 * 
		 * @copy reference flash.utils.navigateToURL
		 *
		 * @param request
		 *     The URLRequest to navigate to.
		 * @param window
		 *     (optional) 
		 *
		 */
		public function navigateToURL(request:URLRequest, window:String = null):void
		{
			if (this == this.master)
			{
				flash.net.navigateToURL(request, window);
			}
			else
			{
				this.owner.navigateToURL(request, window);
			}
		}


		/**
		 *
		 * @inheritDoc
		 *	
		 */
		public function parseData(data:XML):void
		{
			this._markupObjectManager.parseData(this, data);
		}


		/**
		 *
		 * Removes the item progress bar from display list.
		 * 
		 * @param progressBar
		 *     The progress bar to remove from the stage.
		 * 
		 */
		public function removeItemProgressBar(progressBar:DisplayObject):void
		{
			this._removeProgressBar(progressBar);
		}


		/**
		 *
		 * Removes the queue progress bar from display list.
		 * 
		 * @param progressBar
		 *     The progress bar to remove from the stage.
		 * 
		 */
		public function removeCumulativeProgressBar(progressBar:DisplayObject):void
		{
			this._removeProgressBar(progressBar);
		}


		/**
		 * @private
		 *	
		 * Determines whether a section has one or more defined progress bars
		 * (itemProgressBar and/or cumulativeProgressBar).
		 * 	
		 * @return
		 *     true if the Section has progress bars defined, otherwise false.
		 * 
		 */
		public function hasProgressBars():Boolean
		{
			return !!this.cumulativeProgressBar || !!this.itemProgressBar;
		}
		

		/**
		 * @private
		 *	
		 * Determines whether a section exists with the provided SPath.
		 *
		 * @param section
		 *     The SPath of the section to check for, either as an SPath object
		 *     or its String equivalent. If the SPath is relative, it will
		 *     first be absolutized using this Section's SPath as a base.
		 *
		 * @return
		 *     true if the Section exists, otherwise false.
		 * 
		 */
		public function sectionExists(section:Object):Boolean
		{
			var sPath:SPath = section is String ? SPath.parse(section as String) : section as SPath;
			var absoluteSPath:SPath = sPath.absolute ? sPath : sPath.resolve(this.sPath);

			if (this == this.master)
			{
				var info:SectionInfo = this.inky_internal::getInfo();
				for (var i:uint = 0; i < absoluteSPath.length; i++)
				{
					var name:String = absoluteSPath.getItemAt(i) as String;
					if (!(info = info.getSubsectionInfoByName(name))) return false;
				}
				return true;
			}
			else
			{
				return this.owner.sectionExists(absoluteSPath);
			}
		}


		/**
		 * @private
		 */
		public static function setSection(obj:Object, owner:Section):void
		{
			if (owner)
			{
				Section._objects2Sections[obj] = owner;
			
				if (owner && obj is Section)
				{
					obj._master = owner._master || owner;
				}
			}
			else
			{
				delete Section._objects2Sections[obj];
			}
		}




		//
		// private methods
		//


		/**
		 *
		 * Gets the owner and application, if the Section hasn't been
		 * registered yet.
		 * 
		 */
// TODO: is this necesssary anymore??
		private function _addedToStageHandler(e:Event):void
		{
			if (e.currentTarget != this)
			{
				return;
			}

			e.currentTarget.removeEventListener(e.type, arguments.callee);
			
//			if (this._isRegistered) return;

			// Get the application and owner.
			var tmp:DisplayObjectContainer = this;
			var owner:Section;
			var master:Section;

			while (tmp)
			{
				if (tmp is Section)
				{
					if (tmp != this)
					{
						owner = owner || (tmp as Section);
					}
					master = tmp as Section;
				}
				tmp = tmp.parent;
			}

			this._master = master;
			
			if (master == this)
			{
				// Add a listener to initialize any timeline-placed markup objects
				// that aren't on the first frame.
				this.addEventListener(Event.ADDED, this._initTimelineMarkupObject);

				this._initMaster();
			}
			
			Section.setSection(this, this.owner || owner);
/*			if (owner)
			{
				owner._registerSubsection(this);
			}*/
		}


		/**
		 *
		 * Adds the progress bar to the display list
		 * 
		 */
		private function _addProgressBar(progressBar:DisplayObject):void
		{
			var pb:Object = progressBar as Object;

			if (pb is ITransitioningObject && pb.state == TransitioningObjectState.PLAYING_OUTRO && pb.parent == this)
			{
				pb.addEventListener(TransitionEvent.TRANSITION_FINISH, this._addProgressBarNow, false, 0, true);
			}
			else
			{
				this._addProgressBarNow(pb);
			}
		}


		/**
		 *
		 * Finishes adding the progress bar to the display list
		 * 
		 */
		private function _addProgressBarNow(pb:Object):void
		{
			if (pb is Event)
			{
				pb.target.removeEventListener(pb.type, arguments.callee);
				pb = pb.target;
			}
			this.addChild(pb as DisplayObject);
		}


		/**
		 *	
		 * Destroys a section so that it doesn't take up room in memory.
		 * 
		 */
		private function _destroy():void
		{
			// Remove any links between owned objects and this section.
			for (var obj:Object in Section._objects2Sections)
			{
				if (Section._objects2Sections[obj] == this)
				{
					delete Section._objects2Sections[obj];
				}
			}

			// Destroy the MarkupObjectManager.
			this.markupObjectManager.destroy();
			
			// Destroy the loadManager.
			this.inky_internal::getLoadManager().destroy();

			Section.setSection(this, undefined);

			// Unset all the properties.
			this.__cumulativeProgressBar = undefined;
			this._info = undefined;
			this.__itemProgressBar = undefined;
			this._master = undefined;
			this._sPath = undefined;
			this._markupObjectManager = undefined;

			// Remove event listeners.
			this.removeEventListener(Event.ADDED, this._initTimelineMarkupObject);
			this.removeEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler);
			
			this.destroy();
		}

		
		/**
		 *
		 *	
		 *	
		 */
		private function _init():void
		{
			//
			// Prevent class from being instantialized.
			//
			if (getQualifiedClassName(this) == 'inky.framework.core::Section')
			{
				throw new ArgumentError('Error #2012: Section$ class cannot be instantiated.');
			}

			this._loadManager = new LoadManager(this);
			this._markupObjectManager = new MarkupObjectManager(this);
			
			this.addEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler, false, 0, true);

			this.itemProgressBar = this.getChildByName('_itemProgressBar') as DisplayObject || this.itemProgressBar;
			this.cumulativeProgressBar = this.getChildByName('_cumulativeProgressBar') as DisplayObject || this.cumulativeProgressBar;
			/*if (this.itemProgressBar) this.removeChild(this.itemProgressBar as DisplayObject);
			if (this.cumulativeProgressBar) this.removeChild(this.cumulativeProgressBar as DisplayObject);*/
		}


		/**
		 *
		 *	
		 *	
		 */
		private function _initMaster():void
		{
			this._navigationManager = new NavigationManager(this);
		}


		/**
		 *
		 * 
		 */
		private function _initTimelineMarkupObject(e:Event):void
		{
			if (this.inky_internal::getInfo() && this.master && (e.currentTarget != e.target) && !(e.target is Section))
			{
				Section.getSection(e.target).markupObjectManager.setData(e.target);
			}
		}


		/**
		 *
		 *	
		 */
		private function _outroCompleteHandler(e:Event):void
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			this._destroy();
			this.dispatchEvent(new Event('leaveComplete'));
		}


		/**
		 *
		 * Removes the progress bar the from display list
		 * 
		 */
		private function _removeProgressBar(progressBar:DisplayObject):void
		{
			var pb:Object = progressBar as Object;
			if (pb.parent && pb is ITransitioningObject && pb.state == TransitioningObjectState.PLAYING_INTRO)
			{
				pb.addEventListener(TransitionEvent.TRANSITION_FINISH, this._removeProgressBarNow, false, 0, true);
			}
			else
			{
				this._removeProgressBarNow(pb);
			}
		}


		/**
		 *	
		 * Finishes removing the progress bar from the display list
		 * 
		 */
		private function _removeProgressBarNow(pb:Object):void
		{
			if (pb is Event)
			{
				pb.target.removeEventListener(pb.type, arguments.callee);
				pb = pb.target;
			}

			if (pb is ITransitioningObject && !(pb.state == TransitioningObjectState.PLAYING_OUTRO))
			{
				pb.remove();
			}
			else if (pb is DisplayObject)
			{
				pb.parent.removeChild(pb as DisplayObject);
			}
		}



		//
		// internal methods
		//


		/**
		 *
		 * @private
		 * 
		 * Gets the SectionInfo object for this Section.
		 * 
		 */
		inky_internal function getInfo():SectionInfo
		{
// TODO: Remove this method
			return this._info;
		}

		/**
		 *
		 * @private
		 *	
		 */
		inky_internal function getLoadManager():LoadManager
		{
			return this._loadManager;
		}


		/**
		 *
		 * @private	
		 *	
		 */
		inky_internal function getNavigationManager():NavigationManager
		{
			return this.master._navigationManager;
		}


		/**
		 *
		 * @private
		 * 
		 * Sets the SectionInfo object for this Section.
		 * 
		 */
 		inky_internal function setInfo(info:SectionInfo):void
		{
// TODO: Remove this method
			this._info = info;
		}




	}
}
