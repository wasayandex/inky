package inky.sequencing 
{
	import inky.utils.getClass;
	import inky.sequencing.commands.CallFunctionCommand;
	import inky.sequencing.commands.WaitCommand;
	import inky.sequencing.ISequence;
	import inky.sequencing.CommandData;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.03.29
	 *
	 */
	public class XMLSequence implements ISequence
	{
		private var commandData:Array = [];
		private var commandRegistry:Object = {};
		private var source:XML;
		
		/**
		 *
		 */
		public function XMLSequence(source:XML)
		{
			this.source = source;
			this.registerCommand("call", CallFunctionCommand);
			this.registerCommand("wait", WaitCommand);
		}
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get length():int
		{
			return this.source.*.length();
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function getCommandAt(index:int):Object
		{
			if (index < 0 || index >= this.length)
				throw new RangeError("The specified index is out of bounds.");

			var data:Object = this.getCommandDataAt(index);
			return data.command;
		}

		/**
		 * 
		 */
		public function getCommandDataAt(index:int):CommandData
		{
			var data:CommandData = this.commandData[index];
			if (!data)
			{
				var xml:XML = this.source.*[index];
				data =
				this.commandData[index] = this.parseCommandData(xml);
			}
			return data;
		}

		/**
		 * @inheritDoc
		 */
		public function registerCommand(name:Object, type:Class):void
		{
			var qName:QName;
			
			if (name is QName)
				qName = QName(name);
			else if (name is String)
				qName = new QName("", String(name));
			else throw new ArgumentError("Name parameter must be either a String or QName");

			this.commandRegistry[name] = type;
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function parseCommandData(xml:XML):CommandData
		{
// TODO: Allow custom parser objects. (Third arg of registerCommand?)
			var data:CommandData;
			var name:QName = xml.name();

			if (!this.commandRegistry[name])
				throw new Error("There is no command registered for the name " + name);

			var commandClass:Class = getClass(this.commandRegistry[name]);
			if (!commandClass)
				throw new Error("Could not find the class " + this.commandRegistry[name]);

			var command:Object = new commandClass();
			var propertyGetters:Object = {};

			for each (var prop:XML in xml.attributes())
			{
				var propName:String = prop.name();
				var value:String = prop.toString();

				if (value.charAt(0) == "#")
					propertyGetters[propName] = value.substr(1);
				else
					command[propName] = value;
			}

			return new CommandData(command, propertyGetters);
		}

		
	}
	
}