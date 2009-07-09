package inky.panel
{
	import com.exanimo.external.JSFLInterface;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import inky.panel.Builder;

	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2008.02.13
	 *
	 */
	public class InkyPanel extends Sprite
	{
		private var _buildButton:Sprite;
		private var _createApplicationButton:Sprite;
		private var _loader:URLLoader;



public static var textField;
		/**
		 *
		 *
		 *
		 */		 		 		
		public function InkyPanel()
		{
			this._init();
		}
		
		
		
		private function _enterFrameHandler(e:Event):void
		{
			if (JSFLInterface.call('checkDocumentChanged'))
			{
				this._documentChangedHandler();
			}
		}


		private function _documentChangedHandler():void
		{
//			JSFLInterface.call('alert', 'document changed');
		}


		private function _init():void
		{
			// Load the JSFL library.
			JSFLInterface.call('fl.runScript', 'file:///Users/rpp/Library/Application%20Support/Adobe/Flash%20CS3/en/Configuration/WindowSWF/InkyPanel.jsfl');
			
			// Check for documentChanged.
			this.addEventListener(Event.ENTER_FRAME, this._enterFrameHandler);

			this._createApplicationButton = this.getChildByName('createApplicationButton') as Sprite;
			this._createApplicationButton.addEventListener(MouseEvent.CLICK, this._createApplication);
			this._buildButton = this.getChildByName('buildButton') as Sprite;
			this._buildButton.addEventListener(MouseEvent.CLICK, this._build);
		}


		/**
		 *
		 *
		 */
		private function _build(e:Event = null):void
		{
			var builder:Builder = new Builder();
var source:String = 'file:///Users/rpp/Documents/Examples/inky/petsitters-1/deploy/flash/PetsittersApplication.inky.xml';
			builder.build(source);
		}		 		 		


		/**
		 *
		 *
		 */		 		 		
		private function _createApplication(e:MouseEvent):void
		{
			// Find out where the user wants to save the application.
			var appLocation:String = JSFLInterface.call('fl.browseForFolderURL', 'Select a Folder for Your Application');
			if (!appLocation) return;
			
			// Find out what template the user wants to use.
			var templateURL:String = JSFLInterface.call('fl.browseForFileURL', 'select', 'Select an Application Template');
			if (!templateURL) return;
			
			if (!templateURL.match(/\.inkytmpl$/))
			{
				this.throwError('Invalid template.');
			}
			
			// Load the template file.
			this._loader.addEventListener(Event.COMPLETE, this._templateCompleteHandler);
			this._loader.load(new URLRequest(templateURL));
		}


		private function _templateCompleteHandler(e:Event):void
		{
			trace(e.currentTarget.data);
		}


public function throwError(msg:String):void
{
	JSFLInterface.call('throwError', msg);
}
public function trace(str:*):void
{
	JSFLInterface.call('fl.trace', String(str));
}



	}
}
