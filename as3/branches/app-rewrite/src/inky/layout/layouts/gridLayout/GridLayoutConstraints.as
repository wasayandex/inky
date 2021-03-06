﻿package inky.layout.layouts.gridLayout
{
	import inky.layout.ILayoutConstraints;


	/**
	 *
	 *  Specifies the placement of a DisplayObject within a GridLayout
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author    Eric Eldredge
	 *	@author    Matthew Tretter (matthew@exanimo.com)
	 *	@since     01.10.2007
	 *	
	 */
	public class GridLayoutConstraints implements ILayoutConstraints
	{
		public var gridX:int;
		public var gridY:int;
		public var horizontalAlignment:String;
		public var verticalAlignment:String;

//TODO: make constant to represent automatic positioning (gridX and gridY) instead of -1.		
		public function GridLayoutConstraints(gridX:int = -1, gridY:int = -1, horizontalAlignment:String = "left", verticalAlignment:String = "top")
		{
			this.gridX = gridX;
			this.gridY = gridY;
			this.horizontalAlignment = horizontalAlignment;
			this.verticalAlignment = verticalAlignment;
		}
		
		
		/**
		 *	@inheritDoc
		 */
		public function clone():Object
		{
			return new GridLayoutConstraints(this.gridX, this.gridY, this.horizontalAlignment, this.verticalAlignment);
		}

	}
}