package inky.framework.forms
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import inky.framework.binding.utils.BindingUtils;
	import inky.framework.binding.utils.IChangeWatcher;
	import inky.framework.validation.*;


	/**
	 *	
	 *	..
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2008.09.09
	 *	
	 */
	public class FormController
	{
		private var _action:Object;
		private var _formControlsMap:Dictionary;
		private var _submitButton:InteractiveObject;


		/**
		 *
		 *	
		 */
		public function FormController()
		{
			this._formControlsMap = new Dictionary(true);
		}




		//
		// accessors
		//


		/**
		 *
		 *
		 *
		 */
		public function get action():Object
		{
			return this._action;
		}
		/**
		 * @private
		 */
		public function set action(action:Object):void
		{
			this._action = action;
		}


		/**
		 *
		 *
		 *
		 */
		public function get submitButton():InteractiveObject
		{
			return this._submitButton;
		}
		/**
		 * @private
		 */
		public function set submitButton(submitButton:InteractiveObject):void
		{
			if (this.submitButton)
			{
				this.submitButton.removeEventListener(MouseEvent.CLICK, this._submitButtonClickHandler);
			}
			if (submitButton)
			{
				submitButton.addEventListener(MouseEvent.CLICK, this._submitButtonClickHandler);
			}
			this._submitButton = submitButton;
		}




		//
		// public methods
		//


		/**
		 *
		 *	
		 */
		public function addControl(control:DisplayObject, controlValueProp:String, model:Object, modelProp:String, submissionName:String = null):void
		{
			var watchers:Array = [];
			watchers.push(BindingUtils.bindProperty(control, controlValueProp, model, modelProp));
			watchers.push(BindingUtils.bindProperty(model, modelProp, control, controlValueProp));
			
			this._formControlsMap[control] = {controlValueProp: controlValueProp, submissionName: submissionName, watchers: watchers};
		}


		/**
		 *
		 *	
		 */
		public function addValidator(validator:IValidator):void
		{
		}


		/**
		 *
		 *	
		 */
		public function removeControl(control:DisplayObject):void
		{
			var obj:Object = this._formControlsMap[control];
			for each (var watcher:IChangeWatcher in obj)
			{
				watcher.unwatch();
			}

			delete this._formControlsMap[control];
		}


		/**
		 *
		 *	
		 *	
		 */
		public function validate():Boolean
		{
			var isValid:Boolean = true;
/*
			for (var validator:IValidator in this._validators)
			{
				if (!validator.validate())
				{
					isValid = false;
					break;
				}
			}

*/			return isValid;
		}


		//
		// private methods
		//


		/**
		 *
		 *	
		 */
		private function _getURLRequest():URLRequest
		{
			var request:URLRequest;
			
			if (this._action is String)
			{
				request = new URLRequest(this._action as String);
			}
			else
			{
				throw new Error('A form action must be a String right now');
			}
			
			return request;
		}


		/**
		 *
		 *	
		 */
		private function _submitButtonClickHandler(e:Event):void
		{
			if (!(e is MouseEvent)) return;
			
			if (this.validate())
			{
				var request:URLRequest = this._getURLRequest();
				var vars:URLVariables = new URLVariables();
				for (var control:Object in this._formControlsMap)
				{
					var info:Object = this._formControlsMap[control];
					vars[info.submissionName] = control[info.controlValueProp];
				}
				request.data = vars;

				// Send the request.
trace('Form:');
for (var prop:String in vars)
{
	trace('\t' + prop + '\t:\t\t' + vars[prop]);
}
			}
			else
			{
trace('there are errors!');
			}
		}




	}
}
