package inky.addons.transitions
{
	import inky.framework.utils.IAction;
	import inky.framework.events.ActionEvent;
	import inky.framework.core.IInkyDataParser;
	import flash.events.EventDispatcher;
	
	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 * 	@author Zack Dolin
	 *	@author Eric Eldredge
	 *	@author Rich Perez
	 *	@author Matthew Tretter
	 *	@since  23.07.2008
	 */
	public class SetValueAction extends EventDispatcher implements IAction, IInkyDataParser
	{
		private var _props:Object;
		private var _target:Object;
		
		/**
		 *	@Constructor
		 */
		public function SetValueAction(obj:Object = null)
		{
			this._props = obj || {};
		}
		
		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get cancelable():Boolean
		{
			return false;
		}


		/**
		 *
		 * @inheritDoc
		 * 
		 */
		public function get target():Object
		{
			return this._target;
		}
		
		/**
		*
		*	@private	
		*	
		*/
		public function set target(target:Object):void
		{
			this._target = target;
		}
		
		
		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function cancel():void
		{
			throw new Error('SetValueAction is not cancelable.');
		}


		public function parseData(data:XML):void
		{
			for each (var item:XML in data.* + data.attributes())
			{
				var name = item.localName();
				this._props[name] = item.toString();
			}
		}



		public function start():void
		{
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_START, false, false));
			
			for (var i:String in this._props)
			{
				this.target[i] = this._props[i];
			}
			
			this.dispatchEvent(new ActionEvent(ActionEvent.ACTION_FINISH, false, false));
		}	
	}	
}
