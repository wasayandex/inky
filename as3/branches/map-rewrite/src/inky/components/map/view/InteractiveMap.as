package inky.components.map.view 
{
	import inky.components.map.view.Map;
	import inky.components.map.view.helpers.PanningHelper;
	import inky.components.map.view.helpers.ZoomingHelper;
	import flash.display.InteractiveObject;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.11
	 *
	 */
	public class InteractiveMap extends Map
	{
		private var panningHelper:PanningHelper;
		private var zoomingHelper:ZoomingHelper;
		
		/**
		 * 
		 */
		public function InteractiveMap()
		{
			// TODO: Should we store exposed PanningHelper and ZoomingHelper values to account for a situation where a subclass sets them before calling super()?
			this.panningHelper = new PanningHelper(this);
			this.zoomingHelper = new ZoomingHelper(this);
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function get contentRotation():Number
		{ 
			return this.zoomingHelper.contentRotation; 
		}
		/**
		 * @private
		 */
		override public function set contentRotation(value:Number):void
		{
			this.zoomingHelper.contentRotation = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get contentX():Number
		{ 
			return this.panningHelper.contentX; 
		}
		/**
		 * @private
		 */
		override public function set contentX(value:Number):void
		{
			this.panningHelper.contentX = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get contentY():Number
		{ 
			return this.panningHelper.contentY; 
		}
		/**
		 * @private
		 */
		override public function set contentY(value:Number):void
		{
			this.panningHelper.contentY = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get contentScaleX():Number
		{ 
			return this.zoomingHelper.contentScaleX; 
		}
		/**
		 * @private
		 */
		override public function set contentScaleX(value:Number):void
		{
			this.zoomingHelper.contentScaleX = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get contentScaleY():Number
		{ 
			return this.zoomingHelper.contentScaleY; 
		}
		/**
		 * @private
		 */
		override public function set contentScaleY(value:Number):void
		{
			this.zoomingHelper.contentScaleY = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#maximumZoom
		 */
		public function get maximumZoom():Number
		{ 
			return this.zoomingHelper.maximumZoom; 
		}
		/**
		 * @private
		 */
		public function set maximumZoom(value:Number):void
		{
			this.zoomingHelper.maximumZoom = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#minimumZoom
		 */
		public function get minimumZoom():Number
		{ 
			return this.zoomingHelper.minimumZoom; 
		}
		/**
		 * @private
		 */
		public function set minimumZoom(value:Number):void
		{
			this.zoomingHelper.minimumZoom = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.PanningHelper#panningProxy
		 */
		public function get panningProxy():Object
		{ 
			return this.panningHelper.panningProxy; 
		}
		/**
		 * @private
		 */
		public function set panningProxy(value:Object):void
		{
			this.panningHelper.panningProxy = value;
		}

		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#zoomInButton
		 */
		public function get zoomInButton():InteractiveObject
		{ 
			return this.zoomingHelper.zoomInButton; 
		}
		/**
		 * @private
		 */
		public function set zoomInButton(value:InteractiveObject):void
		{
			this.zoomingHelper.zoomInButton = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#zoomingProxy
		 */
		public function get zoomingProxy():Object
		{ 
			return this.zoomingHelper.zoomingProxy; 
		}
		/**
		 * @private
		 */
		public function set zoomingProxy(value:Object):void
		{
			this.zoomingHelper.zoomingProxy = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#zoomInterval
		 */
		public function get zoomInterval():Number
		{ 
			return this.zoomingHelper.zoomInterval; 
		}
		/**
		 * @private
		 */
		public function set zoomInterval(value:Number):void
		{
			this.zoomingHelper.zoomInterval = value;
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#zoomOutButton
		 */
		public function get zoomOutButton():InteractiveObject
		{ 
			return this.zoomingHelper.zoomOutButton; 
		}
		/**
		 * @private
		 */
		public function set zoomOutButton(value:InteractiveObject):void
		{
			this.zoomingHelper.zoomOutButton = value;
		}
		
		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------
		
		/**
		 * @copy inky.components.map.view.helpers.PanningHelper#moveContent
		 */
		protected function moveContent(x:Number, y:Number):void
		{
			this.panningHelper.moveContent(x, y);
		}
		
		/**
		 * @copy inky.components.map.view.helpers.ZoomingHelper#scaleContent
		 */
		protected function scaleContent(scaleX:Number, scaleY:Number):void
		{
			this.zoomingHelper.scaleContent(scaleX, scaleY);
		}
	}
	
}