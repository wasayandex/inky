package inky.framework.binding 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import inky.framework.binding.Binding;
	import inky.framework.core.Section;
	import inky.framework.events.PropertyChangeEvent;
	import inky.framework.events.PropertyChangeEventKind;

	
	/**
	 *
	 * Manages binding. This class should be considered an implementation detail and is subject to change.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @author Eric Eldredge
	 * @since  2008.08.13
	 *
	 */
	public class BindingManager
	{
		private var _resolvedBindings:Dictionary;
		private var _section:Section;
		private var _unresolvedBindings:Array;




		/**
		 *
		 *	
		 *	
		 */
		public function BindingManager(section:Section)
		{
			this._section = section;
			this._unresolvedBindings = [];
			this._resolvedBindings = new Dictionary(true);
		}


		/**
		 *
		 *	
		 */
		public function destroy():void
		{
			// Although binding sources are stored with a weak reference, they
			// may not be immediately garbage collected. To insure that
			// instances "in limbo" do not trigger updates, remove their event
			// listeners.
			for (var source:Object in this._resolvedBindings)
			{
				if (source is IEventDispatcher)
				{
					source.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._propertyChangeHandler);
					source.removeEventListener(Event.CHANGE, this._propertyChangeHandler);
				}
				delete this._resolvedBindings[source];
			}
			
			this._resolvedBindings = undefined;
			this._section = undefined;
			this._unresolvedBindings = undefined;
		}


		/**
		 *
		 *	Try to execute the binding. If it succeeds, move the binding to the resolved list.
		 *	
		 */
		public function executeBinding(binding:Binding):Boolean
		{
			var success:Boolean = true;
			var srcObj:Object;
			var destObj:Object;
			var srcProp:String = binding.srcProp;
			var destProp:String = binding.destProp;
			var addListeners:Boolean = false;

			try
			{
				destObj = binding.destObjFunc();

				if (destObj)
				{
					srcObj = binding.srcObjFunc();

					if (srcObj)
					{
						addListeners = srcProp && (srcObj is IEventDispatcher);
						var value:* = srcProp ? srcObj[srcProp] : srcObj;
						destObj[destProp] = value;
					}
					else
					{
						success = false;
					}
				}
				else
				{
					success = false;
				}
			}
			catch (error:Error)
			{
				success = false;
			}

			if (success)
			{
				// Remove the binding from the list of unresolved bindings.
				var index:int = this._unresolvedBindings.indexOf(binding);
				if (index != -1)
				{
					this._unresolvedBindings.splice(index, 1);
				}

				// Add the binding to list of resolved bindings.
				if (!this._resolvedBindings[srcObj])
				{
					this._resolvedBindings[srcObj] = {};
				}
				if (!this._resolvedBindings[srcObj][srcProp])
				{
					this._resolvedBindings[srcObj][srcProp] = new Dictionary(true);
				}
				if (!this._resolvedBindings[srcObj][srcProp][destObj])
				{
					this._resolvedBindings[srcObj][srcProp][destObj] = {};
				}

				this._resolvedBindings[srcObj][srcProp][destObj][destProp] = binding;

				// Add listeners.
				if (addListeners)
				{
					srcObj.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, this._propertyChangeHandler, false, 0, true);
					srcObj.addEventListener(Event.CHANGE, this._propertyChangeHandler, false, 0, true);
				}
			}
			
			return success;
		}


		/**
		 *
		 * Executes all the bindings in the unresolved list.	
		 *	
		 */
		public function executeUnresolvedBindings():void
		{
			for (var i:int = 0; i < this._unresolvedBindings.length; i++)
			{
				var binding:Binding = this._unresolvedBindings[i];
				if (this.executeBinding(binding))
				{
					i--;
				}
			}
		}


		/**
		 *
		 *	
		 */
		public function parseBinding(source:String, destination:String):Binding
		{
			var dotIndex:int = destination.lastIndexOf('.');
			var destProp:String = destination.substr(dotIndex + 1);
			destination = destination.substr(0, dotIndex);
			var destObjFunc:Function = this._parseExpression(destination);
			dotIndex = source.lastIndexOf('.');
			var srcProp:String = source.substr(dotIndex + 1);
			source = source.substr(0, dotIndex);
			var srcObjFunc:Function = this._parseExpression(source);
			
			var binding:Binding = new Binding(srcObjFunc, srcProp, destObjFunc, destProp);
			this._unresolvedBindings.push(binding);
			return binding;
		}


		/**
		 *
		 *	
		 *	
		 */
		public function parseBinding2(destObj:Object, destProp:String, source:String):Binding
		{
			var destObjFunc:Function = function():*
			{
				return destObj;
			}
			var dotIndex:int = source.lastIndexOf('.');
			var srcProp:String = source.substr(dotIndex + 1);
			source = source.substr(0, dotIndex);
			var srcObjFunc:Function = this._parseExpression(source);
			var binding:Binding = new Binding(srcObjFunc, srcProp, destObjFunc, destProp);
			this._unresolvedBindings.push(binding);
			return binding;
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 */
		private function _parseExpression(expression:String):Function
		{
			// Trim whitespace.
			expression = expression.replace(/^[\s]+|[\s]+$/, '');
			var f:Function;
			var dotIndex:int;
			var propName:String;
		
			if ((dotIndex = expression.lastIndexOf('.')) != -1)
			{
				// The expression is a dot property access.
				f = this._parseExpression(expression.substr(0, dotIndex));
				propName = expression.substr(dotIndex + 1).replace(/\s+/g, '');
				return function():*
				{
					return f()[propName];
				}
			}
			else
			{
				// The expression is an id.
				return function():Object
				{
					return _section.markupObjectManager.getMarkupObjectById(expression);
				}
			}
		}


		/**
		 *
		 * 
		 * 
		 */
		private function _propertyChangeHandler(e:Event):void
		{
			var srcObj:Object;
			var srcProp:String;
			var update:Boolean;
			var newValue:Object;
			var updateAllBoundProperties:Boolean = false;
			var destObj:Object;

			if (e is PropertyChangeEvent)
			{
				var evt:PropertyChangeEvent = e as PropertyChangeEvent;
				srcObj = evt.source;
				srcProp = String(evt.property);
				update = evt.kind == PropertyChangeEventKind.UPDATE;
				newValue = evt.newValue;
			}
			else
			{
				srcObj = e.currentTarget;
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
				var properties2Update:Object;
				var destProp:String;
				if (updateAllBoundProperties)
				{
					// Update all the bound properties on the source.
					for (srcProp in this._resolvedBindings[srcObj])
					{
						newValue = srcObj[srcProp];
						for (destObj in this._resolvedBindings[srcObj][srcProp])
						{
							properties2Update = this._resolvedBindings[srcObj][srcProp][destObj];
							for (destProp in properties2Update)
							{
								destObj[destProp] = newValue;
							}
						}
					}
				}
				else
				{
					newValue = srcObj[srcProp];
					// Update only a specific bound property.
					for (destObj in this._resolvedBindings[srcObj][srcProp])
					{
						properties2Update = this._resolvedBindings[srcObj][srcProp][destObj];
						for (destProp in properties2Update)
						{
							destObj[destProp] = newValue;
						}
					}
				}
			}
			else
			{
				throw new Error('Unsupported binding kind!');
			}
		}




	}
}
