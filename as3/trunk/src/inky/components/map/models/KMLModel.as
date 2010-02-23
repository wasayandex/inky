package inky.components.map.models
{
	import flash.events.EventDispatcher;
	import inky.collections.ArrayList;
	import inky.components.map.models.DocumentModel;
	import inky.components.map.events.MapEvent;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Rich Perez
	 *	@since  2010.02.19
	 *
	 */
	public class KMLModel extends EventDispatcher
	{
		private var _documents:ArrayList;
		private var _selectedDocument:DocumentModel;
		
		/**
		 *
		 */
		public function KMLModel()
		{
			this._documents = new ArrayList();			
		}
		
		
		public function get documents():ArrayList
		{
			return this._documents;
		}
		
		public function get selectedDocument():DocumentModel
		{
			return this._selectedDocument;
		}
		
		public function selectDocumentByName(name:String):void
		{
			for (var i:int = 0; i < length; i++)
			{
				var document:DocumentModel = this._documents.getItemAt(i) as DocumentModel;
				if (name == document.name)
				{
					var oldValue:Boolean = document.selected;
					document.selected = true;
					this._selectedDocument = document;
					this.dispatchEvent(new MapEvent(MapEvent.SELECTED_DOCUMENT_CHANGE));
				}
				else
				{
					document.selected = false;
				}
			}
		}
		
	}
}