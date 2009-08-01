/**
 * Adapted from mx.managers.layoutClasses.PriorityQueue
 */
package inky.layout 
{
import flash.utils.Dictionary;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.07.31
	 *
	 */
	public class PriorityQueue
	{
		private var _arrayOfArrays:Array;
		private var _minPriority:int;
		private var _maxPriority:int;
		private var _priorities:Dictionary;
		
		
		/**
		 *
		 */
		public function PriorityQueue()
		{
			this._arrayOfArrays = [];
			this._minPriority = 0;
			this._maxPriority = -1;
			this._priorities = new Dictionary(true);
		}
		
		/**
		 *	
		 */
		public function addObject(obj:Object, priority:int):Object
		{
			var currentPriority:int = this.getPriority(obj);
			
			if (currentPriority == priority)
			{
				// Object is already in the queue.
				return obj;
			}
			else if (currentPriority != -1)
			{
				// Object is already in the queue with another priority.
				throw new ArgumentError("Object already has a different priority");
			}

			var list:Array = this._arrayOfArrays[priority];
			if (!list)
				list = this._arrayOfArrays[priority] = [];

			// Update min priority and max priority
			if (this._maxPriority < this._minPriority)
			{
				this._minPriority =
				this._maxPriority = priority;
			}
			else
			{
				if (priority < this._minPriority)
					this._minPriority = priority;
				if (priority > this._maxPriority)
					this._maxPriority = priority;
			}

			list.push(obj);
			this._priorities[obj] = priority;
			return obj;
		}



		public function contains(obj:Object):Boolean
		{
			return isNaN(this._priorities[obj]) ? false : true;
		}




		public function removeLargest():Object
		{
			var obj:Object = null;

			if (this._minPriority <= this._maxPriority)
			{
				while (!this._arrayOfArrays[this._maxPriority] || this._arrayOfArrays[this._maxPriority].length == 0)
				{
					this._maxPriority--;
					if (this._maxPriority < this._minPriority)
						return null;
				}

				obj = this._arrayOfArrays[this._maxPriority].shift();

				while (!this._arrayOfArrays[this._maxPriority] || this._arrayOfArrays[this._maxPriority].length == 0)
				{
					this._maxPriority--;
					if (this._maxPriority < this._minPriority)
						break;
				}

			}

			delete this._priorities[obj];
			return obj;
		}




		public function removeSmallest():Object
		{
			var obj:Object = null;

			if (this._minPriority <= this._maxPriority)
			{
				while (!this._arrayOfArrays[this._minPriority] || this._arrayOfArrays[this._minPriority].length == 0)
				{
					this._minPriority++;
					if (this._minPriority > this._maxPriority)
						return null;
				}			

				obj = this._arrayOfArrays[this._minPriority].shift();

				while (!this._arrayOfArrays[this._minPriority] || this._arrayOfArrays[this._minPriority].length == 0)
				{
					this._minPriority++;
					if (this._minPriority > this._maxPriority)
						break;
				}			
			}

			delete this._priorities[obj];
			return obj;
		}



		public function getPriority(obj:Object):int
		{
			var priority:Number = this._priorities[obj];
			return isNaN(priority) ? -1 : priority;
		}


		/**
		 *  @private
		 */
		public function removeAll():void
		{
			this._arrayOfArrays.length = 0;
			this._minPriority = 0;
			this._maxPriority = -1;
			this._priorities = new Dictionary(true);
		}

		/**
		 *  @private
		 */
		public function isEmpty():Boolean
		{
			return this._minPriority > this._maxPriority;
		}







	}
	
}