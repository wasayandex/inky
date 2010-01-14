package inky.commands 
{
	import inky.commands.IAsyncCommand;
	import inky.commands.tokens.IAsyncToken;
	import inky.commands.tokens.AsyncToken;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@author Matthew Tretter
	 *	@since  2010.01.14
	 *
	 */
	public class FunctionCommand implements IAsyncCommand
	{
		private var _args:Array;
		private var _fn:Function;
		private var _scope:Object;
		
		/**
		 *
		 */
		public function FunctionCommand(fn:Function, args:Array = null, scope:Object = null)
		{
			this._fn = fn;
			this._args = args || [];
			this._scope = scope;
		}
		
		
		
		
		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function execute(params:Object = null):IAsyncToken
		{
			var token:IAsyncToken = this._fn.apply(this._scope, this._args) as IAsyncToken;
			var fnReturnsToken:Boolean = !!token;
			token = token || new AsyncToken();

			if (!fnReturnsToken)
				token.callResponders();

			return token;
		}

		


	}
	
}