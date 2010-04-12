package
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import inky.framework.core.Application;
	public class PetsittersApplication extends Application
	{
		public function PetsittersApplication()
		{
			this.aboutButton.addEventListener(MouseEvent.CLICK, this._aboutButtonClickHandler);
			this.hoursButton.addEventListener(MouseEvent.CLICK, this._hoursButtonClickHandler);
			this.pricingButton.addEventListener(MouseEvent.CLICK, this._pricingButtonClickHandler);
		}
		
		private function _aboutButtonClickHandler(e:MouseEvent):void
		{
			this.gotoSection('about');
		}
		
		private function _hoursButtonClickHandler(e:MouseEvent):void
		{
			this.gotoSection('hours');
		}
		
		private function _pricingButtonClickHandler(e:MouseEvent):void
		{
			this.gotoSection('pricing');
		}
	}
}
