package inky.layers 
{
	import flash.display.DisplayObjectContainer;
	import inky.layers.ILayerDefinition;
	import inky.layers.sequencing.LayerStackSequence;
	import inky.layers.sequencing.commands.RemoveFromCommand;
	import inky.layers.sequencing.commands.AddToCommand;
	import inky.layers.events.LayerEvent;
	import inky.sequencing.commands.DispatchEventCommand;
	import inky.sequencing.commands.CallCommand;
	import flash.utils.getQualifiedClassName;
	
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
		
		private var sequence:LayerStackSequence;
		
		/**
		 *
		 */
		public function LayerStack(root:DisplayObjectContainer)
		{
			this.layerDefinitions = [];
			this._root = root;
			this.sequence = new LayerStackSequence();
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
			// If a build sequence is currently running for this stack, abort it.
			if (this.sequence)
				this.sequence.abort();
			this.sequence = new LayerStackSequence()

			var removeFromIndex:int = this.layerDefinitions.length;
			var i:int;

			// Determine the point at which the new layer set and the old layer set first differ.
			for (i = 0; i < this.layerDefinitions.length; i++)
			{
				var oldLayer:ILayerDefinition = this.layerDefinitions[i];
				var newLayer:ILayerDefinition = newLayers[i];

				if (!newLayer || newLayer.forceRefresh || newLayer.replaces(oldLayer))
				{
					removeFromIndex = i;
					break;
				}
			}

			// Keep a list of removed layers, so that newly added layers can be cloned 
			// in the event that they are equal to a layer that may still be on stage. 
			// This is necessary because REMOVED_FROM_STAGE is dispatched before a 
			// DisplayObject is actually removed, which potentially means an object 
			// that is added back to stage in the handling of the REMOVED_FROM_STAGE 
			// event will actually be removed immediately after the event is handled, 
			// effectively negating the add.
			var removedLayers:Array = [];

			// Remove the layers that must be removed.
			for (i = this.layerDefinitions.length - 1; i >= removeFromIndex; i--)
			{
				var layerToRemove:ILayerDefinition = this.layerDefinitions[i];
				removedLayers.push(layerToRemove);
				// Add the set of commands to remove this layer to the sequence.
				this.addCommandSet(layerToRemove, RemoveFromCommand, LayerEvent.BEFORE_REMOVE, LayerEvent.REMOVE_COMPLETE, layerToRemove.onBeforeRemove, layerToRemove.onRemoveComplete);
			}
			this.layerDefinitions.length = removeFromIndex;

			// Add the layers that must be added.
			for (i = removeFromIndex; i < newLayers.length; i++)
			{
				var layerToAdd:ILayerDefinition = newLayers[i] as ILayerDefinition;
				if (!layerToAdd)
					throw new Error("The layer at index " + i + " is not an ILayerDefinition");

				if (this.layerDefinitions.indexOf(layerToAdd) != -1 || removedLayers.indexOf(layerToAdd) != -1)
					layerToAdd = layerToAdd.clone();

				this.layerDefinitions.push(layerToAdd);
				// Add the set of commands to add this layer to the sequence.
				this.addCommandSet(layerToAdd, AddToCommand, LayerEvent.BEFORE_ADD, LayerEvent.ADD_COMPLETE, layerToAdd.onBeforeAdd, layerToAdd.onAddComplete);
			}

			if (this.sequence.length)
				this.sequence.play();
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function addCommandSet(layer:ILayerDefinition, commandClass:Class, beforeEventType:String, completeEventType:String, beforeCallback:Function = null, completeCallback:Function = null):void
		{
			// If a before callback is defined, add a command to trigger it.
			if (beforeCallback != null)
			{
				var beforeCallbackCommand:CallCommand = new CallCommand();
				beforeCallbackCommand.callee = beforeCallback;
				beforeCallbackCommand.arguments = [layer];
				this.sequence.addCommand(beforeCallbackCommand);
			}

			// Add a command to dispatch the before event.
			var beforeEventCommand:DispatchEventCommand = new DispatchEventCommand();
			beforeEventCommand.eventClass = LayerEvent;
			beforeEventCommand.type = beforeEventType;
			beforeEventCommand.target = layer;
			this.sequence.addCommand(beforeEventCommand);

			// Add the command.
			this.sequence.addCommand(new commandClass(layer, this));

			// If a complete callback defined, add a command to trigger it.
			if (completeCallback != null)
			{
				var completeCallbackCommand:CallCommand = new CallCommand();
				completeCallbackCommand.callee = completeCallback;
				completeCallbackCommand.arguments = [layer];
				this.sequence.addCommand(completeCallbackCommand);
			}

			// Add a command to dispatch the complete event.
			var afterEventCommand:DispatchEventCommand = new DispatchEventCommand();
			afterEventCommand.eventClass = LayerEvent;
			afterEventCommand.type = completeEventType;
			afterEventCommand.target = layer;
			this.sequence.addCommand(afterEventCommand);
		}

	}
	
}