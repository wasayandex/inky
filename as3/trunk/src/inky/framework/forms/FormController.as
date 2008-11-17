package inky.framework.forms
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import inky.framework.binding.utils.BindingUtils;
	import inky.framework.binding.utils.IChangeWatcher;
	import inky.framework.core.inky;
	import inky.framework.core.Application;
	import inky.framework.data.Model;
	import inky.framework.managers.MarkupObjectManager;
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
			if (!(action is String))
			{
				throw new TypeError('FormController action must be a String.');
			}
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
		public function addControl(control:DisplayObject, controlValueProp:String = null, modelOrModelId:Object = null, modelProp:String = null, submissionName:String = null):void
		{
			if (control.name)
			{
				var re:RegExp = /^([^_]+)_([^_]+)/;
				var match:Array = re.exec(control.name);
				var modelId:String = modelOrModelId as String;
				var model:Object = modelId == null ? modelOrModelId : null;

				var mom:MarkupObjectManager = MarkupObjectManager.masterMarkupObjectManager;

				if (match)
				{
					if (!modelId)
					{
						if (model)
						{
							modelId = mom.getMarkupObjectId(model);
						}
						else
						{
							modelId = match[1];
							model = mom.getMarkupObjectById(modelId) || this._createModel(modelId);
						}
					}
					if (modelProp == null)
					{
						modelProp = match[2];
					}
					if (submissionName == null)
					{
						submissionName = modelId + '[' + modelProp + ']';
					}
				}
			}
			
			if (controlValueProp == null)
			{
				if (control is TextField)
				{
					controlValueProp = 'text';
				}
				else
				{
					controlValueProp = 'value';
				}
			}

			if (!model)
			{
				throw new Error();
			}
			else if (!modelProp)
			{
				throw new Error();
			}
			else if (!submissionName)
			{
				throw new Error();
			}
			
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
		 */
		public function submit():void
		{
			if (this.validate())
			{
				var request:URLRequest = this._getURLRequest();
				var vars:URLVariables = new URLVariables();
				for (var control:Object in this._formControlsMap)
				{
// TODO: Should this use model values instead?
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
		private function _createModel(modelId:String):Object
		{
			var mom:MarkupObjectManager = MarkupObjectManager.masterMarkupObjectManager;
// TODO: This is lame. Why should it parse XML? Stupid.
			return mom.createMarkupObject(<inky:Model xmlns:inky={inky.uri} inky:id={modelId} />);
		}


		/**
		 *
		 *	
		 */
		private function _getURLRequest():URLRequest
		{
			return new URLRequest(this._action as String);
		}


		/**
		 *
		 *	
		 */
		private function _submitButtonClickHandler(e:Event):void
		{
			if (!(e is MouseEvent)) return;
			this.submit();
		}




	}
}
