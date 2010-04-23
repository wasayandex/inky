package inky.cursors 
{
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import inky.display.utils.removeFromDisplayList;
	import flash.display.Sprite;
	import flash.ui.Mouse;
	import inky.utils.getClass;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import inky.cursors.CursorToken;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.20
	 *
	 */
	public class CursorManager
	{
		private var buttonCursorToken:CursorToken;
		private var cursorContainer:Sprite;
		private var activeCursors:Object = {};
		private static var instance:CursorManager;
		private var priorityMap:Array = [];
		private var idMap:Object = {};
		private var stage:Stage;
		
		public static const DEFAULT:String = "default";
		public static const POINTER:String = "pointer";
		

		/**
		 * Do not use; create instances using getInstance()
		 * @see	#getInstance()
		 */
		public function CursorManager(stage:Stage)
		{
			this.stage = stage;
			
			this.registerCursors([
				{id: CursorManager.DEFAULT, showSystemCursor: true},
				{id: CursorManager.POINTER, showSystemCursor: true}
			]);

			this.setCursor(CursorManager.DEFAULT);

			this.stage.addEventListener(Event.MOUSE_LEAVE, this.stage_mouseLeaveHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_OVER, this.stage_mouseOverHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_OUT, this.stage_mouseOutHandler);
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * 
		 */
		public function getPriority(id:String):int
		{
			var priority:int = -1;
			var data:Object = this.idMap[id];
			if (data)
				priority = this.priorityMap.indexOf(data);
			return priority;
		}

		/**
		 * 
		 */
		public function removeCursor(token:CursorToken):Boolean
		{
			var removed:Boolean = false;
			var id:String = token.cursorId;
			var arr:Array = this.activeCursors[id];
			if (arr)
			{
				var index:int = arr.indexOf(token);
				if (index != -1)
				{
					removed = true;
					arr.splice(index, 1);
					if (!arr.length)
						delete this.activeCursors[id];
				}
			}

			if (removed)
				this.updateCursor();

			return removed;
		}

		/**
		 * Register a cursor type.
		 */
		public function registerCursor(id:String, cursorOrCursorClass:Object, showSystemCursor:Boolean = false, priority:int = -1):void
		{
// TODO: Add hideSystemCursor boolean.
			this.unregisterCursor(id);
			
			if (priority == -1)
				priority = this.priorityMap.length;
			else if (priority < 0)
				throw new RangeError();
			else if (priority > this.priorityMap.length)
				throw new RangeError();

			var data:Object = {
				id: id,
				cursorOrCursorClass: cursorOrCursorClass,
				showSystemCursor: showSystemCursor
			};
			this.idMap[id] = data;
			this.priorityMap.splice(priority, 0, data);
			
			this.updateCursor();
		}
		
		/**
		 * 
		 */
		public function registerCursors(cursorDataObjects:Array, priority:int = -1):void
		{
			for each (var cursorData in cursorDataObjects)
			{
				this.registerCursor(cursorData.id, cursorData.cursor, cursorData.showSystemCursor, priority);
				if (priority != -1)
					priority++;
			}
		}

		/**
		 * 
		 */
		public function setCursor(id:String):CursorToken
		{
			if (!this.idMap[id])
				throw new ArgumentError("No cursor has been registered for id \"" + id + "\"");
			
			var token:CursorToken = new CursorToken(this, id);
			
			if (!this.activeCursors[id])
				this.activeCursors[id] = [];
			this.activeCursors[id].push(token);

			this.updateCursor();
			
			return token;
		}

		/**
		 * 
		 */
		public function unregisterCursor(id:String):Object
		{
			var removed:Boolean = false;
			var data:Object = this.idMap[id];
			if (data)
			{
				var priority:int = this.priorityMap.indexOf(data);
				this.priorityMap.splice(priority, 1);
				removed = true;
			}
			return data;
		}

		/**
		 * 
		 */
		public static function getInstance(stage:Stage):CursorManager
		{
			if (!CursorManager.instance)
				CursorManager.instance = new CursorManager(stage);
			return CursorManager.instance;
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function stage_mouseLeaveHandler(event:Event):void
		{
			this.cursorContainer.visible = false;
		}

		/**
		 * 
		 */
		private function stage_mouseOverHandler(event:MouseEvent):void
		{
			if (event.target is Sprite && event.target.buttonMode && (!event.relatedObject || !event.target.contains(event.relatedObject)))
			{
				if (this.buttonCursorToken)
					this.buttonCursorToken.remove();
				this.buttonCursorToken = this.setCursor(CursorManager.POINTER);
			}
		}

		/**
		 * 
		 */
		private function stage_mouseOutHandler(event:MouseEvent):void
		{
			if (this.buttonCursorToken && event.target is Sprite && event.target.buttonMode && (!event.relatedObject || !event.target.contains(event.relatedObject)))
			{
				this.buttonCursorToken.remove();
				this.buttonCursorToken = null;
			}
		}

		/**
		 * 
		 */
		private function updateCursor():void
		{
			var dataToShow:Object;

			for (var i:int = this.priorityMap.length - 1; i >= 0; i--)
			{
				var data:Object = this.priorityMap[i];
				if (this.activeCursors[data.id] && this.activeCursors[data.id].length)
				{
					dataToShow = data;
					break;
				}
			}

			// Show the cursor.
			if (dataToShow)
			{
				if (!this.cursorContainer)
				{
					this.cursorContainer = new Sprite();
					this.cursorContainer.mouseEnabled =
					this.cursorContainer.mouseChildren = false;
				}

				while (this.cursorContainer.numChildren)
					this.cursorContainer.removeChildAt(0);

				var cursor:DisplayObject = DisplayObject(dataToShow.cursor);
				var showSystemCursor:Boolean = dataToShow.showSystemCursor;

				// If the cursor was registered with a class, we'll have to create it.
				if (!dataToShow.hasOwnProperty("cursor"))
				{
					if (dataToShow.cursorOrCursorClass)
					{
						if (dataToShow.cursorOrCursorClass is DisplayObject)
						{
							cursor = DisplayObject(dataToShow.cursorOrCursorClass);
						}
						else
						{
							var cls:Class = getClass(dataToShow.cursorOrCursorClass);
							var tmp:Object = new cls();
							if (!(tmp is DisplayObject))
								throw new Error(dataToShow.cursorOrCursorClass + " is not a DisplayObject");
							cursor = DisplayObject(tmp);
						}
					}
					else
					{
						// There's no cursor.
						cursor = null;
					}
					dataToShow.cursor = cursor;
				}
				
				if (showSystemCursor)
					Mouse.show();
				else
					Mouse.hide();
				
				if (cursor)
				{
					this.stage.addChild(this.cursorContainer);
					this.cursorContainer.addChild(cursor);
					this.updateCursorPosition();
					this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.updateCursorPosition, false, 0, true);
				}
				else
				{
					removeFromDisplayList(this.cursorContainer);
					this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.updateCursorPosition);
				}
			}
		}
		
		/**
		 * 
		 */
		private function updateCursorPosition(event:MouseEvent = null):void
		{
			this.cursorContainer.visible = true;
			this.cursorContainer.x = this.stage.mouseX;
			this.cursorContainer.y = this.stage.mouseY;
		}
	}
	
}