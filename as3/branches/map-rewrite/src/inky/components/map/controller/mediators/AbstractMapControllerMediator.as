package inky.components.map.controller.mediators 
{
	import inky.components.map.controller.IMapController;
	import flash.events.Event;
	import inky.components.map.controller.mediators.IMapControllerMediator;
	import flash.utils.getQualifiedClassName;
	import inky.components.map.view.events.MapFeatureEvent;
	import flash.utils.Dictionary;
	import inky.utils.IDestroyable;
	
	/**
	 *
	 *  Abstract implementation of IMapControllerMediator
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.14
	 *
	 */
	public class AbstractMapControllerMediator implements IMapControllerMediator
	{
		private var _controller:IMapController;
		private var _selectionFilter:Function;
		private var _trigger:String;
		private var _view:Object;
		private var triggers2SiteFilters:Dictionary;
		private var triggers2TargetValidators:Dictionary;

		/**
		 * AbstractMapControllerMediator cannot be directly instantiated. 
		 * It can be extended to create subclasses that specialize in various 
		 * aspects of map view implementation that the controller shouldn't 
		 * need to know about (such as what kind of event triggers a placemark 
		 * selection, among others).
		 * 
		 * @see inky.components.map.controller.IMapController
		 */
		public function AbstractMapControllerMediator()
		{
			if (getQualifiedClassName(this) == 'inky.components.map.controller.mediators::AbstractMapControllerMediator')
				throw new ArgumentError('Error #2012: AbstractMapControllerMediator$ class cannot be instantiated.');
			
			this.triggers2SiteFilters = new Dictionary(true);
			this.triggers2TargetValidators = new Dictionary(true);
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		public function get controller():IMapController
		{ 
			return this._controller; 
		}
		/**
		 * @private
		 */
		public function set controller(value:IMapController):void
		{
			this._controller = controller;
			var oldValue:IMapController = this._controller;
			if (value != oldValue)
			{
				this._controller = value;
				this.initialize();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get view():Object
		{ 
			return this._view; 
		}
		/**
		 * @private
		 */
		public function set view(value:Object):void
		{
			var oldValue:Object = this._view;
			if (value != oldValue)
			{
				this._view = value;
				this.initialize();
			}
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Adds a trigger (event type) that this mediator should listen for. 
		 * The trigger is typically the result of user interaction with the view, 
		 * such as a click event, and the mediator typically responds to the 
		 * trigger by executing methods on the controller.
		 * 
		 * @param trigger
		 * 		The trigger (event type) to handle.
		 * 
		 * @param targetValidator
		 * 		A method used to determine whether or not the trigger is from the desired target.
		 * 
		 * @param siteFilter
		 * 		A method used to determine the intended site for the action invoked by the trigger. 
		 * 
		 * @see #getSiteFilter
		 * @see #setSiteFilter
		 * @see #removeTrigger
		 */
		public function addTrigger(trigger:String, targetValidator:Function = null, siteFilter:Function = null):void
		{
			this._setTargetValidator(trigger, targetValidator);
			this._setSiteFilter(trigger, siteFilter);
			if (this.view)
				this.view.addEventListener(trigger, this.triggerHandler, false, 0, true);
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			for (var trigger:String in this.triggers2SiteFilters)
				this.removeTrigger(trigger);
		}

		/**
		 * Gets a method used to determine the intended site for the action invoked
		 * by the trigger. By default, a triggering event's <code>target</code> 
		 * is used as the action site, unless the event is a <code>MapFeatureEvent</code>, 
		 * in which case the MapFeatureEvent's <code>feature</code> is used.
		 * 
		 * @param trigger
		 * 		The trigger (event type) the site filter is used for.
		 * 
		 * @return The method used to determine the intended site for the action invoked by the trigger.
		 * 
		 * @see #setSiteFilter
		 * @see #addTrigger
		 * @see inky.components.map.events.MapFeatureEvent#feature
		 */
		public function getSiteFilter(trigger:String):Function
		{ 
			return this.triggers2SiteFilters[trigger];
		}
		
		/**
		 * Gets a method used to check a trigger event target. If the event 
		 * target is not matched by the filter, the trigger action is not invoked.
		 * 
		 * @param trigger
		 * 		The trigger (event type) the target filter is used for.
		 * 
		 * @return The method used to check the specified trigger target.
		 * 
		 * @see #setTargetValidator
		 * @see #addTrigger
		 */
		public function getTargetValidator(trigger:String):Function
		{
			return this.triggers2TargetValidators[trigger];
		}
		
		/**
		 * Sets a method used to determine the intended site for the action invoked
		 * by the trigger. If a filter is not set, a triggering event's 
		 * <code>target</code> is used as the action site, unless the event 
		 * is a <code>MapFeatureEvent</code>, in which case the MapFeatureEvent's 
		 * <code>feature</code> is used.
		 * 
		 * @param trigger
		 * 		The trigger (event type) the site filter is used for.
		 * 
		 * @param siteFilter
		 * 		A method used to determine the intended site for the action invoked 
		 * 		by the trigger. 
		 * 
		 * @see #getSiteFilter
		 * @see #addTrigger
		 * @see inky.components.map.events.MapFeatureEvent#feature
		 */
		public function setSiteFilter(trigger:String, siteFilter:Function):void
		{
			if (!this.triggers2SiteFilters[trigger])
				throw new ArgumentError('trigger ' + trigger + ' needs to be added before a selection filter can be defined for it.');
			this._setSiteFilter(trigger, siteFilter);
		}
		
		/**
		 * Sets a method used to check a trigger event target. If the event 
		 * target is not matched by the filter, the trigger action is not invoked.
		 * 
		 * @param trigger
		 * 		The trigger (event type) the target filter is used for.
		 * 
		 * @param targetValidator
		 * 		A method used to check a trigger event target.
		 * 
		 * @see #getTargetValidator
		 * @see #addTrigger
		 */
		public function setTargetValidator(trigger:String, targetValidator:Function):void
		{
			if (!this.triggers2TargetValidators[trigger])
				throw new ArgumentError('trigger ' + trigger + ' needs to be added before a target filter can be defined for it.');
			this._setTargetValidator(trigger, targetValidator);
		}
		
		/**
		 * Removes a trigger (event type) that this mediator should no longer listen for. 
		 * 
		 * @param trigger
		 * 		The trigger (event type) to be removed.
		 * 
		 * @see #addTrigger
		 */
		public function removeTrigger(trigger:String):void
		{
			delete this.triggers2TargetValidators[trigger];
			delete this.triggers2SiteFilters[trigger];
			if (this.view)
				this.view.removeEventListener(trigger, this.triggerHandler);
		}

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * The default site filter.
		 * A triggering event's target is used as the selection site, unless the 
		 * event is a MapFeatureEvent, in which case the MapFeatureEvent's feature is used.
		 */
		protected function defaultSiteFilter(event:Event):Object 
		{ 
			if (event is MapFeatureEvent)
				return MapFeatureEvent(event).feature;
			else
				return event.target;
		}
		
		/**
		 * Override this method to easily create specialized mediator behavior 
		 * for custom view and controller implementations
		 */
		protected function handleTrigger(trigger:String, site:Object):void
		{
			throw new Error("You must overide handleTrigger.");
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * This method is called when a controller or view is set for the mediator.
		 */
		private function initialize():void
		{
			if (this.view)
			{
				for (var trigger:String in this.triggers2SiteFilters)
					this.view.addEventListener(trigger, this.triggerHandler, false, 0, true);
			}
		}
		
		/**
		 * 
		 */
		private function _setSiteFilter(trigger:String, siteFilter:Function = null):void
		{
			var filter:Function = siteFilter;
			if (filter == null)
				filter = this.defaultSiteFilter;

			this.triggers2SiteFilters[trigger] = filter;
		}
		
		/**
		 * 
		 */
		private function _setTargetValidator(trigger:String, targetValidator:Function = null):void
		{
			this.triggers2TargetValidators[trigger] = targetValidator;
		}
		
		/**
		 * This method is called whenever a trigger event is detected in the view.
		 */
		private function triggerHandler(event:Event):void
		{
			var filter:Function = this.triggers2TargetValidators[event.type];
			
			if (filter == null || filter.apply(null, [event.target]))
				this.handleTrigger(event.type, this.triggers2SiteFilters[event.type](event));
		}
	}
	
}