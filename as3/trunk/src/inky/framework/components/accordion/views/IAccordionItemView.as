package inky.framework.components.accordion.views 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import inky.framework.display.IDisplayObject;
	
	public interface IAccordionItemView extends IDisplayObject
	{
		
		/**
		*	Gets and Sets the ItemModel to the view.
		*	
		*	@param model
		*/
		function set model(model:Object):void;
		function get model():Object;
		
		/**
		*	
		*	Returns the value of the height that the mask object will 
		*	expand to when the AccordionItemView is opened.
		*	
		*	@return 
		*		The value of the expanded height.
		*/
		function get maximumHeight():Number;

		/**
		*	
		*	Sets the height that the mask object will expand to when the AccordionItemView is opened.
		*	
		*	@param height
		*		The expanded height of the mask object.
		*/
		function set maximumHeight(height:Number):void;
		
		/**
		*	
		*	Sets the height that the mask object will shrink to when the AccordionItemView is closed.	
		*	
		*	@param height
		*		The minimum height of the mask object.
		*/
		function set minimumHeight(height:Number):void;
		
		/**
		*	Gets the minimum height of the mask object.
		*	
		*	@return
		*		The value of the minimum height.
		*/
		function get minimumHeight():Number;
							
		/**
		*
		*	Expands the height of the mask object in order to reveal the content in the AccordionItemView.
		*		
		*/
		function open():void;
		
		/**
		*	
		*	Decreases the height of the mask object to the height of the button in hte AccordionItemView.
		*	
		*/
		function close():void;
	
	}
}