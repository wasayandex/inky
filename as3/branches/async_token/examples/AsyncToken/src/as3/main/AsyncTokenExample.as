package
{
	import flash.display.Sprite;
	import inky.async.actions.*;
	import inky.async.*;
	
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2009.07.10
	 *
	 */
	public class AsyncTokenExample extends Sprite
	{
		
		/**
		 *
		 */
		public function AsyncTokenExample()
		{
			var sequence:ActionSequence = new ActionSequence(
				new PlayFrameLabelAction("intro", barf),
				new FunctionAction(trace, ["a"]),
				new ActionGroup(
					new FunctionAction(trace, ["\td"]),
					new PlayFrameLabelAction("outro", barf),
					new FunctionAction(trace, ["\te"]),
					new FunctionAction(trace, ["\tf"])
				),
				new TweenerAction({x: 300, rotation: 45, time: 1, transition: 'easeOutExpo', onComplete: crap, onCompleteParams: ["barf", "crapped"]}, barf),
				new FunctionAction(trace, ["b"]),
				new ActionGroup(
					new ActionSequence(
						new GTweenAction(1, {x: 100, rotation: -270}, {completeListener: crap}, barf),
						new FunctionAction(trace, ["c"])
					)
				)
			);
			
			var token:IAsyncToken = sequence.start();
			trace(token);
		}
		
		
		public function crap(...args:Array):void
		{
			trace(args.join(" "));
		}



		
	}
	
}
