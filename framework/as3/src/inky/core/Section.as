package inky.core
{
	import com.exanimo.collections.E4XHashMap;
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
	import inky.core.inky;
	import inky.core.inky_internal;
	import inky.core.Application;
	import inky.data.SectionInfo;
	import inky.display.ITransitioningObject;
	import inky.display.TransitioningMovieClip;
	import inky.display.TransitioningObjectState;
	import inky.events.TransitionEvent;
	import inky.events.PropertyChangeEvent;
	import inky.events.PropertyChangeEventKind;
	import inky.events.SectionEvent;
	import inky.net.GraphicLoader;
	import inky.net.ImageLoader;
	import inky.net.IAssetLoader;
	import inky.net.LoadQueue;
	import inky.net.SoundLoader;
	import inky.net.SWFLoader;	
	import inky.net.XMLLoader;
	import inky.utils.IAction;
	import inky.utils.SPath;


    /**
     * 
     * Dispatched when a Section's navigation sequence finishes.
     *
     * @eventType inky.events.SectionEvent.NAVIGATION_COMPLETE
     *
     */
	[Event(name="navigationComplete", type="inky.events.SectionEvent")]




	/**
	 *
	 *  A graphical element that can be navigated to. Sections are roughly
	 * analogous to "pages" in a typical website, but may be nested.
	 * 
	 * 	@langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Zack Dolin
	 * @author Eric Eldredge
	 * @author Rich Perez
	 * @author Matthew Tretter
	 * @since  2007.11.28
	 *
	 */
	public class Section extends TransitioningMovieClip
	{
		private var _bindings:Dictionary = new Dictionary(true);
		private var __cumulativeProgressBar:IProgressBar;
		private var _currentInitializeOptions:Object;
		private var _currentSubsection:Section;
		private var _currentSubsectionName:String;
		private var _idMarkupObjects:Object;
		private var _initializedMarkupObjects:E4XHashMap;
		private var _info:SectionInfo;
		private var _loadQueues:Object;
		private var _loadingSubsectionClass:Class;
		private var _loadingSubsectionName:String;
		private var _application:Application;
		private var _name:String;
		private var _noIdMarkupObjects:Array;
		private var __itemProgressBar:IProgressBar;
		private var _initializeOptions:Object;
		private var _isRegistered:Boolean;
		private var _master:Section;
		private var _markupObjects2Data:Dictionary;
		private static var _objects2Sections:Dictionary = new Dictionary(true);
		private var _preloadAssetLoadQueues:Object;
		private var _sPath:SPath;
		private var _subsections:Array;
		private var _unresolvedBindings:Object;
		private var _data2MarkupObjects:Dictionary;

		// Only used on master
		private var _bindingTags:Object;
		private var _currentSPath:SPath;
		private var _masterLoadQueue:LoadQueue;
		private var _queuedSPath:SPath;

		use namespace inky;




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


		private function _init():void
		{
			//
			// Prevent class from being instantialized.
			//
			if (getQualifiedClassName(this) == 'inky.core::Section')
			{
				throw new ArgumentError('Error #2012: Section$ class cannot be instantiated.');
			}
			
			this._initializedMarkupObjects = new E4XHashMap(true);
			this._loadQueues = {};
			this._preloadAssetLoadQueues = {};
			this._unresolvedBindings = {};
			this._idMarkupObjects = {};
			this._noIdMarkupObjects = [];
			this._data2MarkupObjects = new Dictionary();
			this._markupObjects2Data = new Dictionary();
// TODO: only create this object on the master.
			this._bindingTags = {};

			if (this is Application) this._application = this as Application;

			this.addEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler);
			
			this.itemProgressBar = this.getChildByName('_itemProgressBar') as IProgressBar || this.itemProgressBar;
			this.cumulativeProgressBar = this.getChildByName('_cumulativeProgressBar') as IProgressBar || this.cumulativeProgressBar;
			if (this.itemProgressBar) this.removeChild(this.itemProgressBar as DisplayObject);
			if (this.cumulativeProgressBar) this.removeChild(this.cumulativeProgressBar as DisplayObject);
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
			return this._application;
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
		public function get cumulativeProgressBar():IProgressBar
		{
			return this.__cumulativeProgressBar;
		}
		/**
		 * @private
		 */		 		
		public function set cumulativeProgressBar(progressBar:IProgressBar):void
		{
			// Unregister the old queue progress bar.
			if (this.cumulativeProgressBar)
			{
				this.cumulativeProgressBar.source = null;
			}

			if (!progressBar) return;

			// If a subsection is currently loading, set the queue progress bar source to its preload queue.
			if (this._info && this._info.getSubsectionInfoByName(this._loadingSubsectionName))
			{
				var preloadAssetsLoadQueue:LoadQueue = this._getPreloadAssetsLoadQueueByName(this._loadingSubsectionName);
				if (preloadAssetsLoadQueue.numItems && progressBar)
				{
					progressBar.source = preloadAssetsLoadQueue;
					preloadAssetsLoadQueue.addEventListener(LoadQueueEvent.ASSET_ADDED, this._preloadAssetAddedHandler, false, 0, true);
					preloadAssetsLoadQueue.addEventListener(LoadQueueEvent.ASSET_COMPLETE, this._preloadAssetCompleteHandler, false, 0, true);
				}
			}
			progressBar.mode = ProgressBarMode.MANUAL;
			this.__cumulativeProgressBar = progressBar;
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
			return this._currentSubsection;
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
		public function get itemProgressBar():IProgressBar
		{
			return this.__itemProgressBar;
		}
		/**
		 * @private
		 */
		public function set itemProgressBar(progressBar:IProgressBar):void
		{
			// Unregister the old item progress bar.
			if (this.itemProgressBar)
			{
				this.itemProgressBar.source = null;
			}
			
			if (!progressBar) return;
	
			// If a subsection is currently loading, set the item progress bar source to the first item in its load queue.
			if (this._info && this._info.getSubsectionInfoByName(this._loadingSubsectionName))
			{
				var preloadAssetsLoadQueue:LoadQueue = this._getPreloadAssetsLoadQueueByName(this._loadingSubsectionName);
				if (preloadAssetsLoadQueue.numItems && progressBar)
				{
					progressBar.source = preloadAssetsLoadQueue.getItemAt(0);
					preloadAssetsLoadQueue.addEventListener(LoadQueueEvent.ASSET_COMPLETE, this._preloadAssetCompleteHandler, false, 0, true);
				}
			}
			progressBar.mode = ProgressBarMode.EVENT;					
			this.__itemProgressBar = progressBar;
		}


		/**
		 *
		 * The section's name. An application may have several sections with
		 * the same name, but they may not have the same owner. Names are used
		 * for navigating between sections, and for forming default routes.
		 *
		 * @see #gotoSection()
		 * @see inky.utils.SPath;
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
		 * The top-most Section in the owner hierarchy.
		 * 
		 */
		public function get master():Section
		{
			return this._master;
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
		 * @see inky.utils.SPath
		 * 
		 */
		public function get sPath():SPath
		{
			return this._sPath || this._info.sPath;
		}




		//
		// public methods
		//


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
		 * @see inky.net.IAssetLoader#close()
		 *
		 */		 		 		 		
		public function cancelFetchAsset(asset:Object):void
		{
			// Close the item.
			try
			{
				asset.close();
			}
			catch (error:Error)
			{
			}

			// Remove the item from the queue.
			if (this.master._masterLoadQueue.getItemIndex(asset) > -1)
			{
				this.master._masterLoadQueue.removeItem(asset);
			}
		}


		/**
		 * @private
		 */
		public function close():void
		{
// TODO: is this method good?  if you have nested virtual subsections, it won't work correctly.
// Is there really any way to do this so that it always behaves as you want?
			if (this.master._currentSPath && this.master._currentSPath.length)
			{
				var sPath:SPath = this.master._currentSPath.clone() as SPath;
				sPath.removeItemAt(sPath.length - 1);
				this.master.gotoSection(sPath);
			}
			else
			{
				this.remove();
			}
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
		 * @see inky.net.IAssetLoader#load()
		 * 
		 */
		public function fetchAsset(asset:Object, callback:Function = null):void
		{
			this._fetchAsset(asset, callback, false);
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
		 * @see inky.net.IAssetLoader#loadNow()
		 * 
		 */
		public function fetchAssetNow(asset:Object, callback:Function = null):void
		{
			this._fetchAsset(asset, callback, true);
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
		 * @see inky.utils.SPath
		 * @param options
		 *     (optional) A hash map of options that will be passed to the
		 *     initialize function of the target section.
		 * @see #initialize()
		 * @see inky.utils.RouteMapper
		 * 
		 */
		public function gotoSection(target:Object, options:Object = null):void
		{
			var sPath:SPath = target is String ? SPath.parse(target as String) : target as SPath;

			if (sPath)
			{
// TODO: this should only be dispatched once per section per navigation. should be different class. should it bubble?
this.dispatchEvent(new Event('navigate'));
				// Make the SPath absolute.
				sPath = sPath.absolute ? sPath : sPath.resolve(this.sPath);
				sPath = sPath.normalize();

				// Delegate navigation to the master.
				if (this == this.master)
				{
					// Resolve the SPath.
					sPath = this._info.resolveSPath(sPath);
					var info:SectionInfo = this._info.getSectionInfoBySPath(sPath);

					this._initializeOptions = options || {};

					if (!info)
					{
						throw new ArgumentError('Section ' + sPath + ' does not exist');
					}

					if (info.href)
					{
						this.gotoLink(info.href);
						return;
					}

					sPath.absolute = false;
					this._currentSPath = sPath.clone() as SPath;
					this._queuedSPath = sPath;
					this._gotoSubsection(this._queuedSPath);
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
		 */
		public function gotoSubsection(sPath:SPath):void
		{
			// Make sure the current subsection doesn't cause unwanted (old) navigation.
			if (this.currentSubsection)
			{
				this.currentSubsection.removeEventListener(TransitionEvent.TRANSITION_FINISH, this.currentSubsection._loadQueuedSPath);
			}

			// Navigating to an empty path is the same as removing the current subsection.
			if (!sPath.length)
			{
				if (this.currentSubsection)
				{
					this.currentSubsection.remove();
				}

				// Call the initialize method and delete the options object.
				this._initialize();

				return;
			}

			// Load the next subsection in the SPath.
			var name:String = sPath.getItemAt(0) as String;
			if (this._info.getSubsectionInfoByName(name))
			{
				var preloadAssetsLoadQueue:LoadQueue = this._getPreloadAssetsLoadQueueByName(name);
				this._loadingSubsectionName = name;

				if (preloadAssetsLoadQueue.numItems)
				{
					if (this.cumulativeProgressBar) 
					{
						this.cumulativeProgressBar.source = preloadAssetsLoadQueue;
						this.cumulativeProgressBar.maximum = preloadAssetsLoadQueue.numItems;
						preloadAssetsLoadQueue.addEventListener(LoadQueueEvent.ASSET_ADDED, this._preloadAssetAddedHandler, false, 0, true);
						preloadAssetsLoadQueue.addEventListener(LoadQueueEvent.ASSET_COMPLETE, this._preloadAssetCompleteHandler, false, 0, true);
						this.addCumulativeProgressBar(this.cumulativeProgressBar);
					}
					if (this.itemProgressBar)
					{
						this.itemProgressBar.source = preloadAssetsLoadQueue.getItemAt(0);
						preloadAssetsLoadQueue.addEventListener(LoadQueueEvent.ASSET_COMPLETE, this._preloadAssetCompleteHandler, false, 0, true);
						this.addItemProgressBar(this.itemProgressBar);
					}

					// load it!
					preloadAssetsLoadQueue.addEventListener(Event.COMPLETE, this._preloadAssetsCompleteHandler, false, 0, true);
					this.master._masterLoadQueue.addItemAt(preloadAssetsLoadQueue, 0);
					this.master._masterLoadQueue.load();
				}
				else
				{
					// all assets are loaded!
					this._preloadAssetsCompleteHandler();
				}
			}
			else
			{
				throw new Error('Section ' + sPath.resolve(this.sPath) + ' does not exist.');
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
		 * Called as a result of a navigation. Normally this method should not
		 * be called directly (use <code>gotoSection()</code>) but it can be
		 * overridden to change the way that the section is removed when you
		 * navigate to another.
		 * 
		 * @see #gotoSection()
		 * 	
		 * @inheritDoc
		 * 
		 */
		public override function remove():void
		{
			if (this.owner && (this.owner.currentSubsection == this))
			{
				this.owner._currentSubsection = null;
				this.owner._currentSubsectionName = null;
				Section.setSection(this, null);
			}
			super.remove();
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
				var info:SectionInfo = this._info;
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
			Section._objects2Sections[obj] = owner;
			if (owner && obj is Section)
			{
				if (!obj.itemProgressBar) obj.itemProgressBar = owner.itemProgressBar;
				if (!obj.cumulativeProgressBar) obj.cumulativeProgressBar = owner.cumulativeProgressBar;
			}
		}


		/**
		 *
		 * Adds the item progress bar to the display list. This method is
		 * invoked by the framework to add an item progress bar to the stage.
		 * 
		 * @param progressBar
		 *     The progress bar to add to the stage.
		 * 
		 */
		public function addItemProgressBar(progressBar:IProgressBar):void
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
		public function addCumulativeProgressBar(progressBar:IProgressBar):void
		{
			this._addProgressBar(progressBar);
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
		 * @see inky.utils.Route
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
		 * Removes the item progress bar from display list. This method is
		 * invoked by the framework to remove an item progress bar from the
		 * stage.
		 * 
		 * @param progressBar
		 *     The progress bar to remove from the stage.
		 * 
		 */
		public function removeItemProgressBar(progressBar:IProgressBar):void
		{
			this._removeProgressBar(progressBar);
		}


		/**
		 *
		 * Removes the queue progress bar from display list. This method is
		 * invoked by the framework to remove a cumulative progress bar from
		 * the stage.
		 * 
		 * @param progressBar
		 *     The progress bar to remove from the stage.
		 * 
		 */
		public function removeCumulativeProgressBar(progressBar:IProgressBar):void
		{
			this._removeProgressBar(progressBar);
		}
		


		//
		// protected methods
		//

		
		/**
		 *
		 * Adds the subsection to the stage. This method is invoked by the
		 * framework to add a subsection to the stage.
		 *
		 * @param subsection
		 *      The section to add to the stage.
		 * 
		 */
		protected function addSubsection(subsection:Section):void
		{
			this._registerSubsection(subsection);
			this.addChild(subsection);
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
			
			if (this._isRegistered) return;

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

				this._masterLoadQueue = new LoadQueue();
			}
			
			Section.setSection(this, this.owner || owner);
			if (owner)
			{
				owner._registerSubsection(this);
			}
		}


		/**
		 *
		 * Adds the progress bar to the display list
		 * 
		 */
		private function _addProgressBar(progressBar:IProgressBar):void
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
		 * Finishes the navigation and calls addSubsection.
		 * 
		 */
		private function _addSubsectionNow(e:TransitionEvent = null):void
		{
// TODO: Why is this necessary?
if (!this._loadingSubsectionClass)
{
	e.currentTarget.removeEventListener(e.type, arguments.callee);
	return;
}
			// Destroy the previous subsection.
			if (e)
			{
				e.currentTarget._destroy();
			}

			var subsection:Section = new this._loadingSubsectionClass();
			subsection._application = this._application;
			subsection._master = this.master;
			Section.setSection(subsection, this);
			this._currentSubsection = subsection;
			this._currentSubsectionName = this._loadingSubsectionName;
			this._loadingSubsectionClass = null;
			this._loadingSubsectionName = null;

			// Set the data provider. If the section uses a custom data
			// provider, replace the temporary one with it.
			var info:SectionInfo = this._info.getSubsectionInfoByName(this._currentSubsectionName);
			subsection.setInfo(info);

			// Parse the data for the model.
			var data:XML = info.inky_internal::getData();
			subsection.setData(subsection, data);

			this.master._queuedSPath.removeItemAt(0);
			if (!this.master._queuedSPath.length)
			{
				this.master._queuedSPath = null;
			}
			else
			{
				subsection.addEventListener(TransitionEvent.TRANSITION_FINISH, subsection._loadQueuedSPath, false, 0, true);
			}

			this.addSubsection(subsection);
			this.dispatchEvent(new SectionEvent(SectionEvent.NAVIGATION_COMPLETE, true));
			

			// Initialize the subsection.
			subsection._initialize();

//			subsection.dispatchEvent(new SectionEvent(SectionEvent.READY));
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _createMarkupObject(xml:Object):Object
		{
// TODO: Add support for <null />, <inky:Boolean />, etc.
// TODO: If child exists but is not on first frame, a new instance will be created. That shouldn't happen!  Instead just initialize the child when it's added.
			xml = xml is XMLList && (xml.length() == 1) ? xml[0] : xml;
			var child:XML;
			var obj:Object = this._getMarkupObjectByData(xml);
			var tmp:XML;
			var xmlStr:String;
			var item:Object;

			if (!obj)
			{
				if (xml is XMLList)
				{
					// If the object is an XMLList, it is an implied Array value.
					obj = [];
					for each (child in xml)
					{
						item = this._createMarkupObject(child);
						this.setData(item);
						obj.push(item);
					}
					this.setData(obj, xml, false);
				}
				else if (xml is XML)
				{
					if (xml.nodeKind() == 'element')
					{
						// If the xml represents a stage instance, don't create
						// another!
// TODO: handle nested timeline markup objects..
						var name:String = xml.@name.toString() || xml.name.toString();
						if (this.hasOwnProperty(name))
						{
							return null;
						}

						// Get class name from "inky:class" attribute.					
						var className:String = xml.attributes().((namespace() == inky) && (localName() == 'class'));
						
						if (!className && (xml.namespace() == inky))
						{
							switch (xml.localName())
							{
								case 'Section':
									break;
								case 'Model':
									className = 'inky.data.Model';
									break;
								case 'Array':
									obj = [];
									for each (child in xml.*)
									{
// TODO: this is hacky. What if we want to allow capitalized properties??
										if (child.localName().toString().substr(0, 1).toLowerCase() != child.localName().toString().substr(0, 1))
										{
											item = this._createMarkupObject(child);
											this.setData(item);
											obj.push(item);
										}
									}
									break;
								case 'Asset':
								case 'ImageLoader':
								case 'SoundLoader':
								case 'SWFLoader':
								case 'XMLLoader':
									// Get the asset source.
									var base:String;
									var source:String = xml.@source;
									var loaderClass:Class;

// TODO: hack to get around the xml.@source being duplicated the second
// time an object goes through _createMarkupObject. (SEE NEXT TODO).
if (xml.@inky_internal::sourceAlreadyResolved != true)									
{									
									tmp = xml as XML;
									while (tmp)
									{
										if ((base = tmp.attributes().((namespace() == inky) && (localName() == 'base'))))
										{
											source = URLUtil.getFullURL(base, source);
										}
										tmp = tmp.parent();
									}
}
									//
									// Determine which loader class to use.
									//
									
									// Use the class specified by the loaderClass attribute (deprecated).
									var loaderClassName:String = xml.@loaderClass;
									if (loaderClassName)
									{
										loaderClass = getDefinitionByName(loaderClassName) as Class;
										obj = new loaderClass();
									}

									// Use the class specified by the tag name.
									else
									{
										switch (xml.localName())
										{
											case 'ImageLoader':
												obj = new ImageLoader();
												break;
											case 'XMLLoader':
												obj = new XMLLoader();
												break;
											case 'SoundLoader':
												obj = new SoundLoader();
												break;
											case 'SWFLoader':
												obj = new SWFLoader();
												break;
											default:

												// Infer the class from the extension of the file.
												var extension:String = source.split('.').pop().toString().split('?')[0].toLowerCase();
												switch (extension)
												{
													case 'swf':
														obj = new SWFLoader();
														break;
													case 'gif':
													case 'jpg':
													case 'jpeg':
													case 'png':
														obj = new ImageLoader();
														break;
													case 'xml':
													case 'php':
													default:
														throw new Error('Could not find an appropriate loader for extension ' + extension +'.');
														break;
												}
										}
									}

									Section.setSection(obj, this);


// TODO: hack to prevent the xml.@source from being duplicated the second
// time an object goes through _createMarkupObject. Since the @source gets
// stored as a fully resolved URL (using its parent nodes' paths), the @source 
// does not need to go through the process again.
if (xml.@inky_internal::sourceAlreadyResolved != true)									
{									
									xml.@source = source;
xml.@inky_internal::sourceAlreadyResolved = true;
}
									this.setData(obj, xml);

									break;
								case 'Binding':
// TODO: BINDING: this is already being done on source expression in _setBoundValue. Can we centralize it?
									// Create a list of bindings so that we
									// will be able to create the binding once
									// the destination object is created.
									var t:Array = xml.@destination.toString().split('.');
									var id:String = t.shift() as String;
									this.master._bindingTags[id] = this.master._bindingTags[id] || [];
									this.master._bindingTags[id].push({source: xml.@source.toString(), destination: t.join('.')});
									
									// If the destination already exists, bind it immediately.
									var destinationObj:Object = this._getMarkupObjectById(id);
									if (destinationObj)
									{
// TODO: BINDING: isn't this going to redo other bindings? We really only need to do this one!
										this._resolveBindings(destinationObj);
									}
									
									break;
								case 'Number':
									if (xml.hasSimpleContent())
									{
										obj = Number(xml.toString());
									}
									else
									{
										throw new Error('Number nodes may not contain child nodes.');
									}
									break;
								case 'Object':
									obj = {};
									break;
								case 'String':
									if (xml.hasSimpleContent())
									{
										obj = xml.toString();
									}
									else
									{
										throw new Error('String nodes may not contain child nodes.');
									}
									break;
								case 'XML':
// TODO: I'm sure there's a more efficient way to do this than reparsing the XML.. the catch is that we want it parsed exactly as typed (an island), not influenced by the inky XML.
									xmlStr = xml.toXMLString();
									xmlStr = xmlStr.substring(xmlStr.indexOf('<', xmlStr.indexOf('<') + 1), xmlStr.lastIndexOf('<', xmlStr.lastIndexOf('<')));
									var parsedValue:XMLList = new XMLList(xmlStr);
									obj = parsedValue.length() ? parsedValue.length() > 1 ? parsedValue : parsedValue[0] : null;
									this.setData(obj, xml, false);
									break;
								case 'XMLList':
// TODO: I'm sure there's a more efficient way to do this than reparsing the XML.. the catch is that we want it parsed exactly as typed (an island), not influenced by the inky XML.
									// Use the XMLList node if you have a single node
									// of XML but you want it to be parsed as a list.
									// If you have multiple nodes, the XML tag is fine
									// as it will automatically create a list.
									xmlStr = xml.toXMLString();
									xmlStr = xmlStr.substring(xmlStr.indexOf('<', xmlStr.indexOf('<') + 1), xmlStr.lastIndexOf('<', xmlStr.lastIndexOf('<')));
									obj = new XMLList(xmlStr);
									this.setData(obj, xml, false);
									break;
							}
						}
						else if (!className && (xml.name().uri.indexOf('*') != -1))
						{	
							// Get qualified class name using namespace. (Flex style shorthand)
							className = xml.name().uri.replace('*', xml.localName());
						}

						if (!obj && className)
						{
							var cls:Class;
						
							try
							{
								cls = getDefinitionByName(className) as Class;
							}
							catch (error:Error)
							{
trace('Warning: ' + error);
							}

// TODO: Shouldn't we catch if no classname is provided at all??
							if (cls)
							{
								obj = new cls();
							}
						}
					}
				}
				else
				{
					throw new ArgumentError('_createMarkupObject only accepts XML and XMLList objects');
				}

			}

			// Add DisplayObjects to the stage.
			if ((obj is DisplayObject) && !obj.parent)
			{
				// Set the section on the object. If this is a preload asset,
				// its section may not yet have been created.
				var owner:Section = this._getMarkupObjectByData(xml.parent()) as Section;
				if (owner)
				{
					Section.setSection(obj, owner);	
				}

				// Call setData before adding the DisplayObject to its
				// parent so that DisplayObjects are added in the correct
				// order. For example, given the structure
				// <A><B><C/></B></A>, C will be added to B, then B will be
				// added to A. If we did not call setData before adding the
				// DisplayObject to the display list, B would first be added
				// to A, then C would be added to B.
				this.setData(obj, xml);

				// Decide what parent the DisplayObject should be added to.
				var parent:DisplayObjectContainer = this._getMarkupObjectByData(xml.parent()) as DisplayObjectContainer;

				// Add the DisplayObject
				if (parent)
				{
					if (parent.hasOwnProperty('addComponent') && (typeof parent['addComponent'] == 'function'))
					{
						parent['addComponent'](obj as DisplayObject);
					}
					else
					{
						parent.addChild(obj as DisplayObject);
					}
				}
			}

			// Initialize the object.
			this.setData(obj, xml);

			return obj;
		}


		/**
		 *
		 * Creates a LoadQueue comprised only of the assets that should be preloaded
		 * 
		 */
		private function _createPreloadAssetsLoadQueue(info:SectionInfo):LoadQueue
		{
			var result:LoadQueue = new LoadQueue();
			var data:XML = info.inky_internal::getData();
			var preloadAssetList:XMLList = (data..Asset + data..SWFLoader + data..ImageLoader + data..XMLLoader + data..SoundLoader).((attribute('preload') == 'true') || (attribute('preload') == '{true}'));
			var excludeAssets:XMLList = data.Section..Asset + data.Section..SWFLoader + data.Section..ImageLoader + data.Section..XMLLoader + data.Section..SoundLoader;
			var loader:Object;

			for each (var asset:XML in preloadAssetList)
			{
				if (!excludeAssets.contains(asset))
				{
					loader = this._createMarkupObject(asset);
					result.addItem(loader);
				}
			}

			if (info.source)
			{
				loader = new Loader();
				var request:URLRequest = new URLRequest(info.source);
				result.addItemAt(loader, 0);
				result.setLoadArguments(loader, request, new LoaderContext(false, ApplicationDomain.currentDomain));
			}

			return result;
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _deserializeValue(value:String):Object 
		{
			var result:Object;

			if ((value.charAt(0) == '"') && (value.charAt(value.length - 1) == '"'))
			{
				result = value.substr(1, -2);
			}
			else if ((value.charAt(0) == "'") && (value.charAt(value.length - 1) == "'"))
			{
				result = value.substr(1, -2);
			}
			else if (!isNaN(Number(value)))
			{
				result = Number(value);
			}
			else
			{
				result = value;
			}

			return result;
		}


		/**
		 *
		 * Destroys a section so that it doesn't take up room in memory.
		 * 
		 */
		private function _destroy():void
		{
			// Although binding sources are stored with a weak reference, they
			// may not be immediately garbage collected. To insure that
			// instances "in limbo" do not trigger updates, remove their event
			// listeners.
			for (var source:Object in this._bindings)
			{
				if (source is IEventDispatcher)
				{
					source.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._propertyChangeHandler);
					source.removeEventListener(Event.CHANGE, this._propertyChangeHandler);
				}
			}

			// Null all the properties.
			this._bindings = null;
			this.__cumulativeProgressBar = null;
			this._currentSubsection = null;
			this._currentSubsectionName = null;
			this._idMarkupObjects = null;
			this._initializedMarkupObjects.removeAll();
			this._initializedMarkupObjects = null;
			this._info = null;
			this._loadQueues = null;
			this._loadingSubsectionClass = null;
			this._loadingSubsectionName = null;
			this._application = null;
			this._noIdMarkupObjects = null;
			this.__itemProgressBar = null;
			this._initializeOptions = null;
			this._master = null;
			this._markupObjects2Data = null;
			this._preloadAssetLoadQueues = null;
			this._sPath = null;
			this._subsections = null;
			this._unresolvedBindings = null;
			this._data2MarkupObjects = null;
			
			// Remove event listeners.
			this.removeEventListener(Event.ADDED, this._initTimelineMarkupObject);
			this.removeEventListener(Event.ADDED_TO_STAGE, this._addedToStageHandler);
		}


		/**
		 *
		 *
		 *
		 */		 		 		 		
		private function _fetchAsset(asset:Object, callback:Function = null, loadNow:Boolean = false):void
		{
			var loader:Object;
			var args:Array;
			var dispatcher:Object;

			// Get the loader.
			if (asset is IAssetLoader)
			{
				loader =
				dispatcher = asset;
			}
			else
			{
				throw new Error('You can only fetch IAssetLoaders right now.');
			}

			// Handle the callback.

			if (dispatcher.bytesTotal && (dispatcher.bytesLoaded == dispatcher.bytesTotal))
			{
				callback && callback();
			}
			else
			{
				// Load the item.
				if (callback != null)
				{
					var completeHandler:Function = function(e:Event):void
					{
						e.currentTarget.removeEventListener(e.type, arguments.callee);
						callback();
					}
					dispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
				}

				// Put the item in the master queue.
				if (loadNow)
				{
					this.master._masterLoadQueue.addItemAt(loader, 0);
				}
				else
				{
					this.master._masterLoadQueue.addItem(loader);
				}

				// Set the load args.
				if (args && args.length)
				{
					args.unshift(loader);
					this.master._masterLoadQueue.setLoadArguments.apply(null, args);
				}

				// Load the queue.
				this.master._masterLoadQueue.load();
			}
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _getChildByPath(path:String):DisplayObject
		{
			var child:DisplayObject;

			if (path)
			{
				var names:Array = path.split('.');
				var objectWasFound:Boolean = true;
				var tmp:DisplayObject = this;
				while (names.length)
				{
					try
					{
						tmp = tmp.hasOwnProperty(names[0]) && tmp[names[0]] ? tmp[names[0]] : (tmp as DisplayObjectContainer).getChildByName(names[0]);
					}
					catch (error:Error)
					{
						objectWasFound = false;
						break;
					}
					if (!tmp)
					{
						objectWasFound = false;
						break;
					}
					names.shift();
				}
				if (objectWasFound)
				{
					child = tmp;
				}
			}
			else
			{
				return this;
			}

			return child;
		}


		/**
		 *
		 *
		 * 
		 */
		private function _getMarkupObjectByData(data:Object):Object
		{
			var obj:Object;

			// Stage instances.
			if ((data is XML) && (data.@name.length() || data.name.length()))
			{
// TODO: This can be done better. (Without checking for Section or Application nodes or passing path as string)
				// If the display object is on the stage, find it.
				var tmp:XML = data as XML;
				var path:Array = [];
				while (tmp && (tmp.localName() != 'Section') && (tmp.localName() != 'Application'))
				{
					var name:String = String(tmp.@name) || String(tmp.name);
					path.unshift(name);
					tmp = tmp.parent();
				}
// TODO: What if it's not the display object? Just something else with the same name prop?
				if (path.length)
				{
					obj = this._getChildByPath(path.join('.'));
				}
			}

			if (!obj)
			{
				// Dynamically created objects
				// Necessary because flash has issues with using e4x expression results as Dictionary keys.	
				for (var key:Object in this._data2MarkupObjects)
				{
					if ((key is XML) && (data is XML))
					{
						if (key === data)
						{
							obj = this._data2MarkupObjects[key];
							break;
						}
					}
					else if ((key is XMLList) && (data is XMLList))
					{
						var matches:Boolean;
						
						if (key.length() == data.length())
						{
							matches = true;
							for (var i:uint = 0; i < key.length(); i++)
							{
								if (key[i] !== data[i])
								{
									matches = false;
									break;
								}
							}
						}
						
						if (matches)
						{
							obj = this._data2MarkupObjects[key];
							break;
						}
					}
				}
			}

			if (!obj && this.owner)
			{
				obj = this.owner._getMarkupObjectByData(data);
			}

			return obj;
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _getMarkupObjectById(id:String):Object
		{
			return this._master._getMarkupObjectByIdHelper(id);
		}


		/**
		 *
		 * Should not be called directly. Use _getMarkupObjectById().
		 * 
		 */
		private function _getMarkupObjectByIdHelper(id:String):Object
		{
			return this._idMarkupObjects[id] || (this.currentSubsection ? this.currentSubsection._getMarkupObjectByIdHelper(id) : null);
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _getMarkupObjectData(obj:Object):Object
		{
			// Get the data for this object.
			var objData:Object = this._markupObjects2Data[obj];
this._markupObjects2Data[obj] = undefined;

			if (!objData)
			{
				// Object was placed on the stage in the ide (i.e. not created dynamically)
				var owner:DisplayObject = Section.getSection(obj);
				var objectName:String = obj.name;
				var tmp:DisplayObject = obj.parent;
				while (tmp && (tmp != owner))
				{
					objectName = tmp.name + '.' + objectName;
					tmp = tmp.parent;
				}
// TODO: Node shouldn't have to have entire path!! It could be inside of other nodes which have other parts of the path!!
				// Check nodes for name attribute. 
				objData = this._info.inky_internal::getData().*.(attribute('name') == objectName);

				// Check nodes for name child nodes.
				if (!objData.length())
				{
					objData = this._info.inky_internal::getData().*.(name == objectName);
				}
				objData = objData.length() ? objData[0] : null;
			}
			return objData;
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _getMarkupObjectId(obj:Object):String
		{
			for (var id:String in this._idMarkupObjects)
			{
				if (this._idMarkupObjects[id] == obj)
				{
					return id;
				}
			}

			return this.owner ? this.owner._getMarkupObjectId(obj) : null;
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _getPreloadAssetsLoadQueueByName(name:String):LoadQueue
		{
			return this._preloadAssetLoadQueues[name] || (this._preloadAssetLoadQueues[name] = this._createPreloadAssetsLoadQueue(this._info.getSubsectionInfoByName(name)));
		}


		/**
		 *
		 * Goes to a relative SPath
		 * 
		 */
		private function _gotoSubsection(sPath:SPath):void
		{
			if (sPath.length)
			{
				// If we're already at the section, consider the navigation complete.
				var name:String = sPath.getItemAt(0) as String;
				if (name == this._currentSubsectionName)
				{
					sPath.removeItemAt(0);
					this.dispatchEvent(new SectionEvent(SectionEvent.NAVIGATION_COMPLETE, true));
					this.currentSubsection._loadQueuedSPath();
				}
				else
				{
					this.gotoSubsection(sPath);
				}
			}
			else
			{
				this.gotoSubsection(sPath);
			}
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _initialize():void
		{
			var initOptionsChanged:Boolean = this._currentInitializeOptions && this.master._initializeOptions ? false : true;
			if (!initOptionsChanged)
			{
				var key:String;
				for (key in this._currentInitializeOptions)
				{
					if (this._currentInitializeOptions[key] != this.master._initializeOptions[key])
					{
						initOptionsChanged = true;
						break;
					}
				}

				if (!initOptionsChanged)
				{
					for (key in this.master._initializeOptions)
					{
						if (this._currentInitializeOptions[key] != this.master._initializeOptions[key])
						{
							initOptionsChanged = true;
							break;
						}
					}
				}
			}

			if (initOptionsChanged)
			{
				this._currentInitializeOptions = this.master._initializeOptions;
				this.initialize(this._currentInitializeOptions);
			}
		}


		/**
		 *
		 * 
		 */
		private function _initTimelineMarkupObject(e:Event):void
		{
			if (this._info && this._master && (e.currentTarget != e.target) && !(e.target is Section))
			{
				Section.getSection(e.target).setData(e.target);
			}
		}


		/**
		 *
		 * Determines whether a markup object is initialized.
		 * 
		 */
		private function _isInitializedMarkupObject(obj:Object):Boolean
		{
			return this._master._isInitializedMarkupObjectHelper(obj);
		}


		/**
		 *
		 * Do not call this method directly. Use _isInitializedMarkupObject().
		 * 
		 */
		private function _isInitializedMarkupObjectHelper(obj:Object):Boolean
		{
			return this._initializedMarkupObjects.containsKey(obj) || (this.currentSubsection && this.currentSubsection._isInitializedMarkupObjectHelper(obj));
		}


		/**
		 *
		 * Load the next queued section.
		 * 
		 */
		private function _loadQueuedSPath(e:TransitionEvent = null):void
		{
			if (e)
			{
				e.target.removeEventListener(e.type, arguments.callee);
			}
			if (this.master._queuedSPath)
			{
				this._gotoSubsection(this.master._queuedSPath);
			}
		}


		/**
		 *
		 * Updates the cumulativeProgressBar when an asset is added to the preload queue.
		 * 
		 */
		private function _preloadAssetAddedHandler(e:LoadQueueEvent):void
		{
			if (!this.cumulativeProgressBar) return;
			this.cumulativeProgressBar.maximum++;
		}


		/**
		 *
		 * Updates the cumulativeProgressBar when an asset in the preload queue is complete.
		 * 
		 */
		private function _preloadAssetCompleteHandler(e:Event = null):void
		{
			var preloadAssetsLoadQueue:LoadQueue = this._getPreloadAssetsLoadQueueByName(this._loadingSubsectionName);
			if (this.itemProgressBar && preloadAssetsLoadQueue.numItems)
			{
				this.itemProgressBar.source = preloadAssetsLoadQueue.getItemAt(0);
			}
			if (this.cumulativeProgressBar)
			{
				this.cumulativeProgressBar.value++;
			}
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _preloadAssetsCompleteHandler(e:Event = null):void
		{
			// Find the definition for the subsection class.
			var subsectionClassName:String = this._info.getSubsectionInfoByName(this._loadingSubsectionName).className;

			try
			{
				this._loadingSubsectionClass = getDefinitionByName(subsectionClassName) as Class;
			}
			catch (error:Error)
			{
				throw new Error('The definition ' + subsectionClassName + ' could not be found.');
			}

			if (this.cumulativeProgressBar || this.itemProgressBar)
			{
				var preloadAssetsLoadQueue:LoadQueue = this._getPreloadAssetsLoadQueueByName(this._loadingSubsectionName);
				preloadAssetsLoadQueue.removeEventListener(LoadQueueEvent.ASSET_ADDED, this._preloadAssetAddedHandler);
				preloadAssetsLoadQueue.removeEventListener(LoadQueueEvent.ASSET_COMPLETE, this._preloadAssetCompleteHandler);

				if (this.itemProgressBar) this.removeItemProgressBar(this.itemProgressBar);
				if (this.cumulativeProgressBar) this.removeCumulativeProgressBar(this.cumulativeProgressBar);
			}


			if (this._currentSubsection)
			{
				this._currentSubsection.addEventListener(TransitionEvent.TRANSITION_FINISH, this._addSubsectionNow, false, 0, true);
				this._currentSubsection.remove();
			}
			else
			{
				this._addSubsectionNow();
			}
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _propertyChangeHandler(e:Event):void
		{
			var source:Object;
			var sourceProp:String;
			var update:Boolean;
			var newValue:Object;
			var updateAllBoundProperties:Boolean = false;
			var obj:Object;

			if (e is PropertyChangeEvent)
			{
				var evt:PropertyChangeEvent = e as PropertyChangeEvent;
				source = evt.source;
// TODO: Support qname (not just string) properties
				sourceProp = String(evt.property);
				update = evt.kind == PropertyChangeEventKind.UPDATE;
				newValue = evt.newValue;
			}
			else
			{
				source = e.currentTarget;
				update = true;

				// Special handling for CHANGE events.
				if (e.type == Event.CHANGE)
				{
					updateAllBoundProperties = true;
				}
				else
				{
					throw new Error('Unsupported binding!');
				}
			}

			// Update the bound values.
			if (update)
			{
				var properties2Update:Array;
				var prop:String;
				if (updateAllBoundProperties)
				{
					// Update all the bound properties on the source.
					for (sourceProp in this._bindings[source])
					{
						newValue = source[sourceProp];
						for (obj in this._bindings[source][sourceProp])
						{
							properties2Update = this._bindings[source][sourceProp][obj];
							for each (prop in properties2Update)
							{
// TODO: only set value if it's changed?
								Section._setValue(obj, prop, newValue);
							}
						}
					}
				}
				else
				{
					newValue = source[sourceProp];
					// Update only a specific bound property.
					for (obj in this._bindings[source][sourceProp])
					{
						properties2Update = this._bindings[source][sourceProp][obj];
						for each (prop in properties2Update)
						{
// TODO: only set value if it's changed?
							Section._setValue(obj, prop, newValue);
						}
					}
				}
			}
			else
			{
				throw new Error('Unsupported binding kind!');
			}
		}


		/**
		 *
		 * Registers a Section instance as a subsection of this Section
		 * instance.
		 * 
		 */
		private function _registerSubsection(section:Section, sPath:SPath = null):void
		{
// TODO: Is this method needed any more?
			if (sPath)
			{
				section._sPath = sPath;
			}

			Section.setSection(section, this);
			section._master = this.master || section;
			section._application = this.application as Application;
			section._isRegistered = true;
		}


		/**
		 *
		 * Removes the progress bar the from display list
		 * 
		 */
		private function _removeProgressBar(progressBar:IProgressBar):void
		{
			var pb:Object = progressBar as Object;
			if (pb is ITransitioningObject && pb.state == TransitioningObjectState.PLAYING_INTRO)
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
			if (pb.parent)
			{
				if (pb is ITransitioningObject && !(pb.state == TransitioningObjectState.PLAYING_OUTRO))
				{
					pb.remove();
				}
				else if (pb is DisplayObject)
				{
					pb.parent.removeChild(pb as DisplayObject);
				}
			}
		}


		/**
		 *
		 * Resolves values that are bound to the given object.
		 * 
		 */
		private function _resolveBindings(obj:Object, id:String = null):void
		{
			// Handle unresolved bindings.
			id = id || this._getMarkupObjectId(obj);

			if (id && this._unresolvedBindings[id])
			{
				for (var dest:Object in this._unresolvedBindings[id])
				{
					for each (var args:Array in this._unresolvedBindings[id][dest])
					{
						args = args.slice();
						args.unshift(dest);
						args.push(false);
						this._setBoundValue.apply(null, args)
					}
				}
			}

			// Handle binding tags.
			if (id)
			{
// TODO: BINDING: Can we get rid of the binding tags list and use the same list for values bound with Binding tags and bracket notation??
				for each (var bindingTagData:Object in this.master._bindingTags[id])
				{
// TODO: BINDING: This is already being done for the source expression in _setBoundValue. Can we centralize it?
					// Get the property.
					var propertyChain:Array = bindingTagData.destination.split('.');
					var tmp:Object = obj;
					for (var i:uint = 0; i < propertyChain.length - 1; i++)
					{
						var prop:String = propertyChain[i];
						tmp = tmp[prop];
					}

					this._setBoundValue(tmp, propertyChain[propertyChain.length - 1], bindingTagData.source);
				}
			}

			if (this.owner)
			{
				this.owner._resolveBindings(obj, id);
			}
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _setBoundValue(obj:Object, property:Object, expression:String, addToUnresolvedBindings:Boolean = true):Boolean
		{
// TODO: Support qname (not just string) properties
			var propName:String = String(property);

			//
			// Handle "special" expressions (true, false, null, etc.)
			//

			if (expression == 'true')
			{
				Section._setValue(obj, property, true);
				return true;
			}
			else if (expression == 'false')
			{
				Section._setValue(obj, property, false);
				return true;
			}
			else if (expression == 'null')
			{
				Section._setValue(obj, property, null);
				return true;
			}
			else if (expression == 'undefined')
			{
				Section._setValue(obj, property, undefined);
				return true;
			}
			
			//
			// Parse the expression
			//
			
			var argsStr:String;
			var target:Object;
			var segment:String;
			var segments:Array = expression.replace(/;$/, '').split('.');
			var source:Object;
			var sourceProp:String;
			var i:uint;
			var fnName:String;
			var id:String = segments[0];

			target = this._getMarkupObjectById(id);
			source = target;

			if ((target == null) || !this._isInitializedMarkupObject(target))
			{
				// The object to which this binding points has not yet been initialized. At it to a list to be dealt with later.
				if (addToUnresolvedBindings)
				{
// TODO: BINDING: What do we even need _unresolvedBindings for any more? Why not just use _bindings if they're never removed from the list anyway? Are we in trouble if something doesn't get added to the list, and then you navigate to a different section and back?
					this._unresolvedBindings[id] = this._unresolvedBindings[id] || new Dictionary(true);
					this._unresolvedBindings[id][obj] = this._unresolvedBindings[id][obj] || [];
					this._unresolvedBindings[id][obj].push([propName, expression]);
				}
				return false;
			}
			else
			{
				for (i = 1; i < segments.length; i++)
				{
					segment = segments[i];
					var openParenIndex:int = segment.indexOf('(');

					if (openParenIndex > -1)
					{
						// Segment is method call.
						fnName = segment.substring(0, openParenIndex);
						argsStr = segment.substring(openParenIndex + 1, segment.indexOf(')'));
						var args:Array = [];

						if (!target[fnName])
						{
							throw new Error('Binding Error: Could not find "' + segments.slice(0, i + 1).join('.') + '"');
						}

						for each (var arg:String in argsStr.split(','))
						{
							args.push(this._deserializeValue(arg.replace(/^[\s]*/, '').replace(/[\s]*$/, '')));
						}

						target = target[fnName].apply(null, args);
					}
					else
					{
						if (!target.hasOwnProperty(segment))
						{
							throw new Error('Binding Error: Could not find "' + segments.slice(0, i + 1).join('.') + '"');
							break;
						}
						else if (i == segments.length - 1)
						{
							sourceProp = segment;
						}
						target = target[segment];
					}
					
					if (i != segments.length - 1)
					{
						source = target;
					}
				}

				Section._setValue(obj, propName, target);

				if (sourceProp)
				{
					// Remember bound properties.
					this._bindings[source] = this._bindings[source] || {};
					this._bindings[source][sourceProp] = this._bindings[source][sourceProp] || new Dictionary(true);
					this._bindings[source][sourceProp][obj] = this._bindings[source][sourceProp][obj] || [];
					this._bindings[source][sourceProp][obj].push(propName);

					if (source is IEventDispatcher)
					{
						source.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._propertyChangeHandler, false, 0, true);
						source.addEventListener(Event.CHANGE, this._propertyChangeHandler, false, 0, true);
					}
				}
			}
			
			return true;
		}


		/**
		 *
		 * Tries to set an object's value.
		 * 
		 */
		private static function _setValue(obj:Object, propName:*, value:Object):void
		{
// TODO: why is this necessary????? An error will be thrown if you do <inky:String>Hi</inky:String>, but it shouldn't be getting here.
			if (propName == null) return;
// TODO: this is hacky. What if we want to allow capitalized properties??

			var setValue:Boolean = false;
			var typeDescription:XML;
			if (propName.substr(0, 1).toLowerCase() == propName.substr(0, 1))
			{
				if (obj.hasOwnProperty(propName))
				{
					setValue = true;
				}
				else
				{
					typeDescription = describeType(obj);
					if (typeDescription.@isDynamic == 'true')
					{
						setValue = true;
					}
				}
			}

			// Automatically convert "false" (String) to false (Boolean) if the
			// accessor specifies a Boolean type. IMPORTANT: because the
			// accessor may be star-typed, it is better to use "{false}", which
			// will always be evaluated as a Boolean.
			if (value == 'false')
			{
				typeDescription = typeDescription || describeType(obj);
				if (typeDescription.accessor.(attribute('name') == propName).@type == 'Boolean')
				{
					value = false;
				}
			}
			
			if (setValue)
			{
				try
				{
					obj[propName] = value;
				}
				catch(error:Error)
				{
					// Don't try to set names on timeline placed DisplayObjects.
					if (!((error.errorID == 2078) && (obj is DisplayObject)  && (propName == 'name')))
					{
						throw(error);
					}
				}
			}
		}


		/**
		 *
		 * Interprets a value and tries to set it on an object.
		 * 	
		 */
		private function _setXMLValue(obj:Object, propName:String, value:Object):void
		{
			if (value.hasSimpleContent() && (value.length() == 1) /*&& value.nodeKind() == 'text'*/)
			{
				var str:String = value.toString();
				var trimmedStr:String = str.replace(/^[\s]*/, '').replace(/[\s]*$/, '');
				if ((trimmedStr.charAt(0) == '{') && (trimmedStr.charAt(trimmedStr.length - 1) == '}'))
				{
					// Value is bound to another value using {id} syntax
					this._setBoundValue(obj, propName, trimmedStr.substr(1, -2));
					return;
				}
				else
				{
					Section._setValue(obj, propName, str);
					return;
				}
			}
			else
			{
// TODO: this is hacky. What if we want to allow capitalized properties??
				// Parse an XML representation of data (i.e. <Array></Array>,
				// <XML></XML>, <String></String>, etc). Initialize the object
				// immediately to make sure that property values aren't set to
				// empty Arrays, etc.
				if (propName.substr(0, 1) == propName.substr(0, 1).toLowerCase())
				{
					var markupObject:Object = this._createMarkupObject(value.*);
					this.setData(markupObject);
					Section._setValue(obj, propName, markupObject);
				}
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
		internal function getInfo():SectionInfo
		{
			return this._info;
		}


		/**
		 *
		 * @private
		 *
		 * @param obj
		 *     The object on which to set the data.
		 * @param data
		 *     The XML data to provide the specified object with.
		 * 
		 */
		internal function setData(obj:Object, data:Object = null, parseData:Boolean = true):void
		{
			// Don't initialize the same obj twice.
			if (!obj || this._isInitializedMarkupObject(obj)) return;

			// Get the objects data and mark it as initialized.
			data = data || this._getMarkupObjectData(obj);
			this._initializedMarkupObjects.putItemAt(true, obj);

			// If the object has no data, we're done!
			if (!data) return;

			// Store id references to the object.
			var id:String = data.@inky::id.length() ? data.@inky::id : null;
			if (id)
			{
				this._idMarkupObjects[id] = this._idMarkupObjects[id] || obj;
			}
			else if (this._noIdMarkupObjects.indexOf(obj) == -1)
			{
				this._noIdMarkupObjects.push(obj);
			}
			this._data2MarkupObjects[data] = this._data2MarkupObjects[data] || obj;
			this._markupObjects2Data[obj] = this._markupObjects2Data[obj] || data;

			if (parseData)
			{
// TODO: Only section should allow nested objects? Only allow nested display objects?
// TODO: If obj is ISomeInterface, then call its parseData method instead of doing this. Also, separate this out into utility so that it can trigger default functionality (like a super call)
				// Create the nested objects, but leave out the Section nodes.
				for each (var node:XML in data.*)
				{
					if (!data.Section.contains(node))
					{
						this._createMarkupObject(node);
					}
				}

				// Set the properties.
				var i:uint;
				var list:XMLList = data.* + data.attributes();
				for (i = 0; i < list.length(); i++)
				{
					this._setXMLValue(obj, list[i].localName(), list[i]);
				}
			}

			// Resolved any unresolved bindings.
			this._resolveBindings(obj);
		}


		/**
		 *
		 * @private
		 * 
		 * Sets the SectionInfo object for this Section.
		 * 
		 */
		internal function setInfo(info:SectionInfo):void
		{
			this._info = info;
		}




	}
}
