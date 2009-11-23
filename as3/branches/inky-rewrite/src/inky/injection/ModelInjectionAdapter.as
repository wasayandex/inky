package inky.injection 
{
	import inky.injection.IInjectionAdapter;
	import flash.events.Event;
	
	/**
	 *
	 *  The ModelInjectionAdapter is a basic implementation of the IInjectionAdapter interface.
	 *  @see inky.injection.IInjectionAdapter
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Eric Eldredge
	 *	@since  2009.11.19
	 *
	 */
	public class ModelInjectionAdapter implements IInjectionAdapter
	{
		private var _map:Array;
		private var _source:Object;
		private var _modelClass:Class;

		/**
		 *
		 * Creates a new ModelInjectionAdapter.
		 * 
		 * 
		 */
		public function ModelInjectionAdapter(source:Object, modelClass:Class, map:Array)
		{
			this._source = source;
			this._modelClass = modelClass;
			this._map = map;
		}
		
		


		//
		// public methods
		//
		
		
		/**
		 * Creates a model object for the injection target.
		 * 
		 * @param event
		 * 		The event that has triggered this injection. The adapter is mapped to the event through an IInjector.
		 * 
		 */
		public function createModel():Object
		{
			var model:Object = new this._modelClass();
			for each (var prop:String in this._map)
			{
				model[prop] = this._source[prop];
			}
			/*for (var prop:String in this._map)
			{
				model[this._map[prop]] = this._source[prop];
			}*/
			return model;
		}

		
		/**
		 * @inheritDoc
		 */
		public function inject(target:Object):void
		{
			if (!target.hasOwnProperty('model'))
				throw new Error("Target has no model property.")

			target.model = this.createModel();
		}

		

		
	}
	
}