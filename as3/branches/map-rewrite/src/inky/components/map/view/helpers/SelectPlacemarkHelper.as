package inky.components.map.view.helpers 
{
	import inky.components.map.view.helpers.BaseMapHelper;
	import inky.components.map.view.helpers.HelperInfo;
	import inky.components.map.view.helpers.HelperType;
	import inky.binding.utils.BindingUtil;
	import flash.utils.Dictionary;
	import inky.collections.ArrayList;
	import inky.utils.EqualityUtil;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.19
	 *
	 */
	public class SelectPlacemarkHelper extends BaseMapHelper
	{
		private var watchers:Array;
		private var selectedPlacemarks:Dictionary;

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * Updates the view to deselect the associated placemark renderer for a given placemark.
		 * 
		 * 
		 * @param placemark
		 * 		The placemark to deselect.
		 */
		public function deselectPlacemark(placemark:Object):void
		{
			if (this.info && placemark)
				this.toggleSelectedFor(placemark, false);
		}

		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			super.destroy();
			if (this.watchers)
			{
				while (this.watchers.length)
					this.watchers.pop().unwatch();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize(info:HelperInfo):void
		{
			super.initialize(info);
			this.selectedPlacemarks = new Dictionary(true);
			this.watchers =
			[
				BindingUtil.bindSetter(this.setSelectedPlacemarks, this.info.map, ["model", "selectedPlacemarks"])
			];
		}
		
		/**
		 * Updates the view to select the associated placemark renderer for a given placemark.
		 * 
		 * @param placemark
		 * 		The placemark to select.
		 */
		public function selectPlacemark(placemark:Object):void
		{
			if (this.info && placemark)
				this.toggleSelectedFor(placemark, true);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		private function setSelectedPlacemarks(placemarks:Array):void
		{
			var marks:ArrayList;
			
			for each (var placemark:Object in this.selectedPlacemarks)
			{
				if (!marks)
					marks = new ArrayList(placemarks);

				if (!marks.containsItem(placemark))
					this.deselectPlacemark(placemark);
			}
		
			if (placemarks)
			{
				while (placemarks.length)
					this.selectPlacemark(placemarks.shift());
			}
		}
		
		/**
		 * 
		 */
		private function toggleSelectedFor(placemark:Object, value:Boolean):void
		{
			var placemarkRenderer:Object;
			
			if (value)
			{
				placemarkRenderer = this.info.map.getHelper(HelperType.PLACEMARK_HELPER).getPlacemarkRendererFor(placemark);
				this.selectedPlacemarks[placemarkRenderer] = placemark;
			}
			else
			{
				for (var key:Object in this.selectedPlacemarks)
				{
					var obj:Object = this.selectedPlacemarks[key];
					if (EqualityUtil.objectsAreEqual(obj, placemark))
					{
						placemarkRenderer = key;
						break;
					}
				}
				
				if (placemarkRenderer)
					delete this.selectedPlacemarks[placemarkRenderer];
			}
			
			if (placemarkRenderer && placemarkRenderer.hasOwnProperty('selected'))
				placemarkRenderer.selected = value;
		}

	}
	
}