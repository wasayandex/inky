package inky.framework.binding 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import inky.framework.binding.Binding;
	import inky.framework.binding.utils.BindingUtils;
	import inky.framework.binding.events.PropertyChangeEvent;
	import inky.framework.binding.events.PropertyChangeEventKind;

	
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
		private var _idMarkupObjects:Object;
		private var _resolvedBindings:Dictionary;
		private var _unresolvedBindings:Array;
		private var _watchers:Array;


		/**
		 *
		 *	
		 *	
		 */
		public function BindingManager(idMarkupObjects:Object)
		{
			this._idMarkupObjects = idMarkupObjects;
			this._unresolvedBindings = [];
			this._resolvedBindings = new Dictionary(true);
			this._watchers = [];
		}


		/**
		 *
		 *	
		 */
		public function destroy():void
		{
			// Clean up the bindings for this section.
			for each (var watcher:* in this._watchers)
			{
				watcher.unwatch();
			}
		}


		/**
		 *
		 *	Try to execute the binding. If it succeeds, move the binding to the resolved list.
		 *	
		 */
		public function executeBinding(binding:Binding):Boolean
		{
			var success:Boolean = false;
			var srcObj:Object;
			var destObj:Object;
			var srcPropChain:Object = binding.srcPropChain;
			var destProp:String = binding.destProp;
			var addListeners:Boolean = false;

			destObj = binding.destObjFunc();
			
			if (destObj)
			{
				srcObj = binding.srcObjFunc();
	
				if (srcObj)
				{
					var watcher = BindingUtils.bindProperty(destObj, destProp, srcObj, srcPropChain);
					this._watchers.push(watcher);
					success = true;
				}
			}

			if (success)
			{
				// Remove the binding from the list of unresolved bindings.
				var index:int = this._unresolvedBindings.indexOf(binding);
				if (index != -1)
				{
					this._unresolvedBindings.splice(index, 1);
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
			// Determine the destination property and create a function for getting the destination object.
			var dotIndex:int = destination.lastIndexOf('.');
			var destProp:String = destination.substr(dotIndex + 1);
			destination = destination.substr(0, dotIndex);
			var destObjFunc:Function = this._parseExpression(destination);

			return this._createBinding(destObjFunc, destProp, source);
		}


		/**
		 *
		 *	
		 *	
		 */
		public function parseBinding2(destObj:Object, destProp:String, source:String):Binding
		{
			// Create a function for getting the destination object.
			var destObjFunc:Function = function():*
			{
				return destObj;
			}
			
			return this._createBinding(destObjFunc, destProp, source);
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 *	
		 */
		private function _createBinding(destObjFunc:Function, destProp:String, source:String):Binding
		{
			// Determine the source property chain.
			var srcPropChain:Array = source.split('.');

			// Create a function for getting the source object.
			var srcObjFunc:Function = function():Object
			{
				return _idMarkupObjects;
			}

			var binding:Binding = new Binding(srcObjFunc, srcPropChain, destObjFunc, destProp);
			this._unresolvedBindings.push(binding);
			return binding;
		}


		/**
		 *
		 * Creates a function that returns the result of the provided string
		 * expression. Essentially a simple eval().
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
					return _idMarkupObjects[expression];
				}
			}
		}




	}
}
