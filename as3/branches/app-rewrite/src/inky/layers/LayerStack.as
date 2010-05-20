package inky.layers 
{
	import flash.display.DisplayObjectContainer;
	import inky.layers.ILayerDefinition;
	import inky.utils.EqualityUtil;
	import inky.layers.sequencing.LayerStackSequence;
	import inky.layers.sequencing.commands.RemoveFromCommand;
	import inky.layers.sequencing.commands.AddToCommand;
	import inky.layers.events.LayerEvent;
	import inky.sequencing.commands.DispatchEventCommand;
	import inky.sequencing.commands.CallCommand;
	
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
//				layerToRemove.removeFrom(this);

// If the layer to remove has an onBeforeRemove callback defined, add a command to trigger it.
if (layerToRemove.onBeforeRemove != null)
{
	var beforeRemoveCallback:CallCommand = new CallCommand();
	beforeRemoveCallback.callee = layerToRemove.onBeforeRemove;
	beforeRemoveCallback.arguments = [layerToRemove];
	this.sequence.addCommand(beforeRemoveCallback);
}

// Add a command to dispatch a BEFORE_REMOVE event for the layer to be removed.
var beforeRemove:DispatchEventCommand = new DispatchEventCommand();
beforeRemove.eventClass = LayerEvent;
beforeRemove.type = LayerEvent.BEFORE_REMOVE;
beforeRemove.target = layerToRemove;
this.sequence.addCommand(beforeRemove);

// Add a command to perform the remove.
this.sequence.addCommand(new RemoveFromCommand(layerToRemove, this));

// If the removed layer has an onRemoveCompmlete callback defined, add a command to trigger it.
if (layerToRemove.onRemoveComplete != null)
{
	var removeCompleteCallback:CallCommand = new CallCommand();
	removeCompleteCallback.callee = layerToRemove.onRemoveComplete;
	removeCompleteCallback.arguments = [layerToRemove];
	this.sequence.addCommand(removeCompleteCallback);
}

// Add a command to dispatch a REMOVE_COMPLETE event for the layer that was removed.
var removeComplete:DispatchEventCommand = new DispatchEventCommand();
removeComplete.eventClass = LayerEvent;
removeComplete.type = LayerEvent.REMOVE_COMPLETE;
removeComplete.target = layerToRemove;
this.sequence.addCommand(removeComplete);

			}
			this.layerDefinitions.length = removeFromIndex;

			// Add the layers that must be added.
			for (i = removeFromIndex; i < newLayers.length; i++)
			{
				var layerToAdd:ILayerDefinition = newLayers[i] as ILayerDefinition;
				if (!layerToAdd)
					throw new Error("The layer at index " + i + " is not an ILayerDefinition");
//				ILayerDefinition(layerToAdd).addTo(this);

// If the layer to add has an onBeforeAdd callback defined, add a command to trigger it.
if (layerToAdd.onBeforeAdd != null)
{
	var beforeAddCallback:CallCommand = new CallCommand();
	beforeAddCallback.callee = layerToAdd.onBeforeAdd;
	beforeAddCallback.arguments = [layerToAdd];
	this.sequence.addCommand(beforeAddCallback);
}

// Add a command to dispatch a BEFORE_ADD event for the layer to be added.
var beforeAdd:DispatchEventCommand = new DispatchEventCommand();
beforeAdd.eventClass = LayerEvent;
beforeAdd.type = LayerEvent.BEFORE_ADD;
beforeAdd.target = layerToAdd;
this.sequence.addCommand(beforeAdd);

// Add a command to perform the add.
this.sequence.addCommand(new AddToCommand(layerToAdd, this));

// If the added layer has an onAddComplete callback defined, add a command to trigger it.
if (layerToAdd.onAddComplete != null)
{
	var addCompleteCallback:CallCommand = new CallCommand();
	addCompleteCallback.callee = layerToAdd.onAddComplete;
	addCompleteCallback.arguments = [layerToAdd];
	this.sequence.addCommand(addCompleteCallback);
}

// Add a command to dispatch an ADD_COMPLETE event for the layer that was added.
var addComplete:DispatchEventCommand = new DispatchEventCommand();
addComplete.eventClass = LayerEvent;
addComplete.type = LayerEvent.ADD_COMPLETE;
addComplete.target = layerToAdd;
this.sequence.addCommand(addComplete);

				this.layerDefinitions.push(layerToAdd);
			}

// If any add or remove commands have been queued up, execute them in sequential order.
if (this.sequence.length)
	this.sequence.play();
		}

	}
	
}