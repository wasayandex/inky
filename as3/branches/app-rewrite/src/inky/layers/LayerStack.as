package inky.layers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import inky.layers.LayerDefinition;
	import inky.layers.strategies.IAdditionStrategy;
	import inky.layers.ILayerDefinition;
	import inky.utils.EqualityUtil;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.04.12
	 *
	 */
	public class LayerStack
	{
		private var layerDefinitions:Array;
		private var _root:DisplayObjectContainer;
		
		/**
		 *
		 */
		public function LayerStack(root:DisplayObjectContainer)
		{
			this.layerDefinitions = [];
			this._root = root;
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function get root():DisplayObjectContainer
		{
			return this._root;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function build(...newLayers:Array):void
		{
			var i:int;
			var removeFromIndex:int = this.layerDefinitions.length;
			for (i = 0; i < this.layerDefinitions.length; i++)
			{
				var oldLayer:ILayerDefinition = this.layerDefinitions[i];
				var newLayer:ILayerDefinition = newLayers[i];

				if (!newLayer || newLayer.forceRefresh || !EqualityUtil.objectsAreEqual(newLayer, oldLayer))
				{
					removeFromIndex = i;
					break;
				}
			}

			// Remove the layers that must be removed.
			for (i = this.layerDefinitions.length - 1; i >= removeFromIndex; i--)
			{
				var layerToRemove:ILayerDefinition = this.layerDefinitions[i];
				layerToRemove.removeFrom(this);
			}
			this.layerDefinitions.length = removeFromIndex;

			// Add the layers that must be added.
			for (i = removeFromIndex; i < newLayers.length; i++)
			{
				var layerToAdd:Object = newLayers[i];
				if (!(layerToAdd is ILayerDefinition))
					throw new Error("The layer at index " + i + " is not an ILayerDefinition");
				ILayerDefinition(layerToAdd).addTo(this);
				this.layerDefinitions.push(layerToAdd);
			}
		}

	}
	
}