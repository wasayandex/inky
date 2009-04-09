package inky.framework.components.mapPane.models
{
	import flash.events.EventDispatcher;

	public class PointModel extends EventDispatcher 
	{
		private var _id:String;
		private var _label:String;
		private var _x:Number;
		private var _y:Number;
		
		//
		// accessors
		//
		
		public function set id(id:String):void
		{
			this._id = id;
		}
		public function get id():String
		{
			return this._id;
		}
		
		public function set x(x:Number):void
		{
			this._x = x;
		}
		public function get x():Number
		{
			return this._x;
		}

		public function set y(y:Number):void
		{
			this._y = y;
		}
		public function get y():Number
		{
			return this._y;
		}
		
		//
		// public functions
		//
		
		public function setLabel(label:String):void
		{
			this._label = label;
		}
		
		public function getLabel():String
		{
			return this._label;
		}
	}
}