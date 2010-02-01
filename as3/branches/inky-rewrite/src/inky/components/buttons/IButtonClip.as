package inky.components.buttons 
{
	import inky.components.buttons.IButton;
	import inky.commands.IAsyncCommand;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2010.02.01
	 *
	 */
	public interface IButtonClip extends IButton
	{

		//
		// accessors
		//
		

		/**
		 * The command that will be executed when the button is in the disabled state.
		 */
		function get disabled():IAsyncCommand;
		function set disabled(value:IAsyncCommand):void;



		/**
		 * The command that will be executed when the button is in the down state.
		 */
		function get down():IAsyncCommand;
		function set down(value:IAsyncCommand):void;



		/**
		 * The command that will be executed when the button is in the emphasized state.
		 */
		function get emphasized():IAsyncCommand;
		function set emphasized(value:IAsyncCommand):void;



		/**
		 * The command that will be executed when the button is in the over state.
		 */
		function get over():IAsyncCommand;
		function set over(value:IAsyncCommand):void;



		/**
		 * The command that will be executed when the button is in the selectedDisabled state.
		 */
		function get selectedDisabled():IAsyncCommand;
		function set selectedDisabled(value:IAsyncCommand):void;



		/**
		 * The command that will be executed when the button is in the selectedDown state.
		 */
		function get selectedDown():IAsyncCommand;
		function set selectedDown(value:IAsyncCommand):void;



		/**
		 * The command that will be executed when the button is in the selectedOver state.
		 */
		function get selectedOver():IAsyncCommand;
		function set selectedOver(value:IAsyncCommand):void;



		/**
		 * The command that will be executed when the button is in the selectedUp state.
		 */
		function get selectedUp():IAsyncCommand;
		function set selectedUp(value:IAsyncCommand):void;



		/**
		 * The command that will be executed when the button is in the up state.
		 */
		function get up():IAsyncCommand;
		function set up(value:IAsyncCommand):void;

		


	}
	
}