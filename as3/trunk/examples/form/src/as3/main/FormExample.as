package
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import inky.framework.core.Application;
	public class FormExample extends Application
	{
		public function FormExample()
		{
			this.aboutButton.addEventListener(MouseEvent.CLICK, this._aboutButtonClickHandler);
			this.contactButton.addEventListener(MouseEvent.CLICK, this._contactButtonClickHandler);
		}
		
		private function _aboutButtonClickHandler(e:MouseEvent):void
		{
			this.gotoSection('about');
		}
		
		private function _contactButtonClickHandler(e:MouseEvent):void
		{
			this.gotoSection('contact');
		}
	}
}
