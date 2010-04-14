package inky.sequencing.commands 
{
	import inky.net.utils.toURLRequest;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.utils.getQualifiedClassName;
	import flash.display.Bitmap;
	import flash.events.Event;
	import inky.sequencing.commands.IAsyncCommand;
	import flash.events.EventDispatcher;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.02
	 *
	 */
	public class LoadCommand extends EventDispatcher implements IAsyncCommand
	{
		private static const GRAPHIC_EXTENSION:RegExp = /\.(swf|gif|png|jpg|jpeg)(\?.*)?$/i

		private var _isAsync:Boolean = true;
		public var content:*;
		public var contentType:Object;
		private var formattedContentType:String;
		public var loader:Object;
		public var url:Object;
		
		//---------------------------------------
		// ACCESSORS
		//---------------------------------------
		
		/**
		 *
		 */
		public function get isAsync():Boolean
		{ 
			return this._isAsync; 
		}
		/**
		 * @private
		 */
		public function set isAsync(value:Boolean):void
		{
			this._isAsync = value;
		}
		
		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
			if (!this.url)
				throw new Error("You must set the \"url\" property.");

			var request:URLRequest = toURLRequest(this.url);
			if (!request)
				throw new Error("The url property must be either a String or URLRequest.");
				
			var url:String = request.url;
			
			if (this.contentType)
			{
				if (!(this.contentType is String) && !(this.contentType is Class))
					throw new Error("Content type must be either a String or Class");
				this.formattedContentType = (this.contentType is String ? String(this.contentType) : getQualifiedClassName(this.contentType)).replace(/::/, ".");
			}
			else
			{
				this.formattedContentType = null;
			}

			if (!this.loader)
			{
				if (!this.contentType)
				{
					this.loader = url.match(GRAPHIC_EXTENSION) ? new Loader() : new URLLoader();
				}
				else
				{
					switch (this.formattedContentType)
					{
						case "flash.display.Bitmap":
						{
							this.loader = new Loader();
							break;
						}
						case "XML":
						{
							this.loader = new URLLoader();
							break;
						}
						default:
						{
							throw new Error("Unsupported content type!");
						}
					}
				}
			}

			if (this.loader is URLLoader)
				this.loader.addEventListener(Event.COMPLETE, this.urlLoader_completeHandler);
			else if (this.loader is Loader)
				this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loader_completeHandler);
			else
				throw new Error("How did we get here?!");

			this.loader.load(request);
		}
		
		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 * 
		 */
		private function formatContent(content:*):*
		{
			switch (this.formattedContentType)
			{
				case "flash.display.Bitmap":
				{
					if (!(content is Bitmap))
						throw new Error("Could not convert format of content with type " + getQualifiedClassName(content) + " to flash.display.Bitmap");
					break;
				}
				case "XML":
				{
					content = new XML(content);
					break;
				}
				case null:
				{
					break;
				}
				default:
				{
					throw new Error(this.formattedContentType + " is not supported.");
				}
			}
			
			return content;
		}

		/**
		 * 
		 */
		private function onComplete():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * 
		 */
		private function urlLoader_completeHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
// TODO: Obey contentType (i.e. format as xml)
			this.content = this.formatContent(event.currentTarget.data);
			this.onComplete();
		}

		/**
		 * 
		 */
		private function loader_completeHandler(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type, arguments.callee);
			this.content = this.formatContent(event.currentTarget.loader.content);
			this.onComplete();
		}


	}
	
}