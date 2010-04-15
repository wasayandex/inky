package inky.components.map.controller.mediators 
{
	import inky.components.map.controller.IMapController;
	import inky.utils.IDestroyable;
	
	/**
	 *
	 *  IMapControllerMediator provides a mechanism for separating the knowledge of 
	 *  a map view's implementation from the business logic of a map controller.
	 *	
	 * 	<p>For example, in order to act on a user selecting a placemark view, 
	 *  a mediator such as the PlacemarkSelectionMediator knows what aspects 
	 *  of the user interaction with the view require a response from the controller, 
	 *  and it facilitates the process by monitoring the view for user interaction, 
	 *  and then instructing the controller to make the appropriate responses 
	 *  (usually in the form of model changes).</p>
	 * 
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.04.14
	 *
	 */
	public interface IMapControllerMediator extends IDestroyable
	{
		/**
		 * Gets and sets the map controller.
		 */
		function get controller():IMapController;
		function set controller(value:IMapController):void;
		
		/**
		 * Gets and sets the map view.
		 */
		function get view():Object;
		function set view(value:Object):void;

	}
	
}