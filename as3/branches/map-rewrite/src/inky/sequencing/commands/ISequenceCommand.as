package inky.sequencing.commands 
{
	import inky.sequencing.ISequence;
	
	/**
	 *
	 *  Tells the sequencer to inject itself into the sequence property of the command.
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.02
	 *
	 */
	public interface ISequenceCommand
	{
		
		/**
		 * 
		 */
		function get sequence():ISequence;
		/**
		 * @private
		 */
		function set sequence(value:ISequence):void;
		
		
	}
	
}