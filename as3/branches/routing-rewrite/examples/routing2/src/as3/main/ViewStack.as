package  
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.10.26
	 *
	 */
	public class ViewStack
	{
		private var _stack:Array;
		private static var _stage:DisplayObjectContainer;
		private static var _instance:ViewStack;
		public static function initialize(stage:DisplayObjectContainer):void
		{
			_stage = stage;
		}
		
		/**
		 *
		 */
		public function ViewStack()
		{
			this._stack = [_stage];
		}
		
		public static function getInstance():ViewStack
		{
			if (!_stage)
				throw new Error("You must initialize ViewStack before getting one.")
			return _instance || (_instance = new ViewStack());
		}
		
		
		
		
		
		public function add(child:DisplayObject):void
		{
			this._stack[this._stack.length - 1].addChild(child);
			this._stack.push(child);
		}
		
		
		public function removeAll():void
		{
			while (this._stack.length > 1)
			{
				var leaf:DisplayObjectContainer = this._stack.pop() as DisplayObjectContainer;
				if (leaf.parent)
					leaf.parent.removeChild(leaf);
			}
		}
		
		
	}
	
}