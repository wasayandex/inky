package inky.forms
{
	import inky.collections.ArrayList;
	import inky.collections.IList;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Dictionary;
	import inky.binding.utils.ChangeWatcher;
	import inky.forms.events.FormEvent;
	import inky.validation.IValidator;
	import inky.validation.IValidatorView;
	import inky.validation.ValidationResult;
	import inky.validation.ValidationError;


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
	public class FormController extends EventDispatcher
	{
		private var _action:Object;
		private var _debug:Boolean;
		private static var enterFrameBeacon:Sprite = new Sprite();
		private var formControlsMap:Dictionary;
		private var labels2Controls:Dictionary;
		private var _method:String;
		private var models:Object = {};
		private var _response:Object;
		private var _submitButton:InteractiveObject;
		private static var uiComponentClass:Class; // Flash won't include UIComponent unless you have one in your library. Which means referencing the class would throw an error. So we have to get the class from a string.
		private var urlLoader:URLLoader;
		private var validators:Array;

		/**
		 *
		 *	
		 */
		public function FormController()
		{
			this.init();
		}

		//---------------------------------------
		// ACCESSORS
		//---------------------------------------

		/**
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
		 */
		public function get controls():IList
		{
// TODO: List should be unmodifiable! You can't add labels by doing form.labels.addItem();
			var list:Array = [];
			for (var control:Object in this.formControlsMap)
			{
				list.push(control);
			}
			return new ArrayList(list);
		}

		/**
		 *
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}
		/**
		 * @private
		 */
		public function set debug(debug:Boolean):void
		{
			this._debug = debug;
		}

		/**
		 *
		 */
		public function destroy():void
		{
			for each (var o:Object in this.formControlsMap)
			{
				for each (var m:Object in o)
				{
					if (m.watcher != null)
					{
						m.watcher.unwatch();
					}
				}
			}
			this.formControlsMap = null;
		}

		/**
		 *
		 */
		public function get labels():IList
		{
// TODO: List should be unmodifiable! You can't add labels by doing form.labels.addItem();
			var list:Array = [];
			for (var label:Object in this.labels2Controls)
			{
				list.push(label);
			}
			return new ArrayList(list);
		}

		/**
		 *
		 */
		public function get method():String
		{
			return this._method || URLRequestMethod.POST;
		}
		/**
		 * @private
		 */
		public function set method(method:String):void
		{
			this._method = method;
		}

		/**
		 *
		 */
		public function get response():Object
		{
			return this._response;
		}

		/**
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
				this.submitButton.removeEventListener(MouseEvent.CLICK, this.submitButton_clickHandler);
			}
			if (submitButton)
			{
				submitButton.addEventListener(MouseEvent.CLICK, this.submitButton_clickHandler);
			}
			this._submitButton = submitButton;
		}

		//---------------------------------------
		// PUBLIC METHODS
		//---------------------------------------

		/**
		 *
		 */
		public function addControl(control:DisplayObject, controlValueGetter:Object = null, modelOrModelId:Object = null, modelValueGetter:Object = null, submissionName:String = null, emptyValue:* = undefined):void
		{
// TODO: Remove control if it's already added (with same control prop)
// TODO: Instead of doing all the special handling in this class, just deal with instances of an interface. If control is Combobox or TextField or whatever, wrap it with a ComboBoxControl that behaves normally.
			var modelProp:String;
			var model:Object;
			if (control.name)
			{
				var re:RegExp = /^([^_]+)_([^_]+)/;
				var match:Array = control.name.match(re);
				var modelId:String = modelOrModelId as String;
				model = modelId == null ? modelOrModelId : null;

				// Get the model, modelId, and submission name.
				if (match)
				{
					if (!modelId)
					{
						modelId = match[1];
						model = this.getModel(modelId);
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

			// Default controlValueGetter
			if (controlValueGetter == null)
			{
				if (control is TextField)
				{
					controlValueGetter = 'text';
				}
				else if (getQualifiedClassName(control) == "fl.controls::ComboBox")
				{
					if (control['editable'])
					{
						controlValueGetter = 'text';
					}
					else
					{
						controlValueGetter = FormController.comboBoxValueGetter;
					}
				}
				else if (getQualifiedClassName(control) == "fl.controls::CheckBox")
				{
					controlValueGetter = 'selected';
				}
				else
				{
					controlValueGetter = 'value';
				}
			}
			
			// Default modelValueGetter
			if (modelValueGetter == null)
			{
				if (getQualifiedClassName(control) == "fl.controls::ComboBox")
				{
					modelValueGetter = this.getComboBoxModelValueGetter(model, modelProp, control);
				}
				else
				{
					modelValueGetter = {
						name: modelProp, 
						getter: function(host:Object):*
						{
							return host[modelProp];
						}
					}
				}
			}

			if (!controlValueGetter)
			{
				throw new Error();
			}

			var controlValueProp:String = controlValueGetter as String || controlValueGetter.name;

			if (!control.hasOwnProperty(controlValueProp))
			{
				throw new Error();
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

			// Can't use BindingUtil.bindProperty because the assignment function will be called immediately and the model value will be replaced with the current value of the control.
			var watcher:ChangeWatcher = ChangeWatcher.watch(control, controlValueGetter, null);
            var assign:Function = function(e:Event):void
			{
				model[modelProp] = watcher.getValue();
			}
			watcher.setHandler(assign);

			// If the model doesn't have a value yet, use the control's value.
			if (model[modelProp] === undefined)
			{
				// Since some components don't reflect their initial values immediately, wait a few frames to get it. This also allows users to set the default value on frames.
				var isFirstFrame:Boolean = true;
				var f:Function = function(e:Event):void
				{
					if (!isFirstFrame)
					{
						e.currentTarget.removeEventListener(e.type, arguments.callee);
						assign(null);
					}
					isFirstFrame = false;
				}
				FormController.enterFrameBeacon.addEventListener(Event.ENTER_FRAME, f);
			}

			this.formControlsMap[control] = this.formControlsMap[control] || {};
			this.formControlsMap[control][controlValueProp] = { modelId: modelId, modelProp: modelProp, controlValueProp: controlValueProp, submissionName: submissionName, watcher: watcher, emptyValue: emptyValue, modelValueGetter: modelValueGetter };
		}

		/**
		 *
		 */
		public function addLabel(label:DisplayObject, control:DisplayObject):void
		{
			if (this.labels2Controls[label] != null)
			{
				this.removeLabel(label);
			}
			
			this.labels2Controls[label] = control;
			label.addEventListener(MouseEvent.CLICK, this.label_clickHandler, false, 0, true);
		}

		/**
		 *
		 */
		public function addValidator(validator:IValidator, view:IValidatorView = null):void
		{
			if (view)
			{
				view.validator = validator;
			}
			if (this.validators.indexOf(validator) == -1)
			{
				this.validators.push(validator);
			}
		}

		/**
		 *
		 */
		public function getControlByLabel(label:DisplayObject):DisplayObject
		{
			return this.labels2Controls[label] as DisplayObject;
		}

		/**
		 *
		 */
		public function getControlValue(control:DisplayObject):*
		{
// TODO: Figure out if controls can have multiple values or not. I think this class is inconsistent.
			for each (var o:Object in this.formControlsMap[control])
			{
				return o.watcher.getValue();
			}
			return null;
		}

		/**
		 *
		 */
		public function getLabelByControl(control:DisplayObject):DisplayObject
		{
			for (var label:Object in this.labels2Controls)
			{
				if (this.labels2Controls[label] == control)
					return label as DisplayObject;
			}
			return null;
		}

		/**
		 *
		 */
		public function removeControl(control:DisplayObject):void
		{
			for each (var o:Object in this.formControlsMap[control])
			{
				o.watch.unwatch();
			}

			delete this.formControlsMap[control];
		}

		/**
		 *
		 */
		public function removeLabel(label:DisplayObject):void
		{
			delete this.labels2Controls[label];
			label.removeEventListener(MouseEvent.CLICK, this.label_clickHandler);
		}

		/**
		 *
		 */
		public function removeValidator(validator:IValidator):void
		{
			var index:int = this.validators.indexOf(validator);
			if (index != -1)
			{
				this.validators.splice(index, 1);
			}
		}

		/**
		 *
		 */
		public function restore():void
		{
			for (var control:Object in this.formControlsMap)
			{
				for (var prop:String in this.formControlsMap[control])
				{
					// Determine whether the control is a Flash UIComponent (and therefore the assignment needs to be delayed)
					if (!FormController.uiComponentClass)
					{
						try
						{
							FormController.uiComponentClass = getDefinitionByName("fl.core.UIComponent") as Class;
						}
						catch (error:Error)
						{
						}
					}
					
					var delay:Boolean = FormController.uiComponentClass && (control is FormController.uiComponentClass);
					this.restoreControl(control, prop, delay);
				}
			}
		}

		/**
		 *	
		 */
		public function restoreControl(control:Object, prop:String, delay:Boolean = false):void
		{
			var info:Object = this.formControlsMap[control][prop];
			var model:Object = this.getModel(info.modelId);

			var assign:Function = function():void
			{
				var value:* = info.modelValueGetter.getter(model);
				if (value !== undefined)
				{
					control[info.controlValueProp] = value;
				}
			}

			if (delay)
			{
				FormController.enterFrameBeacon.addEventListener(Event.ENTER_FRAME, function(e:Event):void
				{
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					assign();
				});
			}
			else
			{
				assign();
			}
		}

		/**
		 *	
		 */
		public function submit():void
		{
			if (!this.action)
				throw new Error('You must set an action on a form before submitting it.');
			
			var e:FormEvent = new FormEvent(FormEvent.SUBMIT, false, true);
			this.dispatchEvent(e);
			
			if (e.isDefaultPrevented())
			{
				this.dispatchEvent(new FormEvent(FormEvent.SUBMIT_CANCELLED));
				return;
			}
			
			var validationResults:Array = this._validate();
			var isError:Boolean = false;
			var result:ValidationResult;
			for each (result in validationResults)
			{
				if (result.isError)
				{
					isError = true;
					break;
				}
			}
			
			if (!isError)
			{
				var request:URLRequest = this.getURLRequest();
				var vars:URLVariables = new URLVariables();

				for (var control:Object in this.formControlsMap)
				{
					for (var p:String in this.formControlsMap[control])
					{
						var info:Object = this.formControlsMap[control][p];
						var model:Object = this.getModel(info.modelId);
// TODO: Use serializable interface.
						var value:* = model[info.modelProp];
						vars[info.submissionName] = value === undefined ? '' : String(value);
					}
				}
				request.data = vars;

				// Send the request.
				var ldr:URLLoader = new URLLoader();
				ldr.addEventListener(FormEvent.COMPLETE, this.relayEvent);
				ldr.addEventListener(Event.OPEN, this.relayEvent);
				ldr.addEventListener(ProgressEvent.PROGRESS, this.relayEvent);
				ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.relayEvent);
				ldr.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.relayEvent);
				ldr.addEventListener(IOErrorEvent.IO_ERROR, this.relayEvent);
				this.urlLoader = ldr;
				ldr.data = vars;
				ldr.load(request);

				if (this.debug)
				{
					trace('Submitted Form Data:');
					var oneHundredSpaces:String = '                                                                                                    ';
					for (var prop:String in vars)
					{
						trace('\t' + prop + ' :' + oneHundredSpaces.substr(0, Math.max(0, 30 - prop.length)) + vars[prop]);
					}
				}
			}
			else
			{
				// The form failed validation.
				
				if (this.debug)
				{
					trace('Form Validation Errors:');
					for each (result in validationResults)
					{
						trace(this.getValidationErrors(result));
					}
				}
				
				this.dispatchEvent(new FormEvent(FormEvent.VALIDATION_ERROR));
			}
		}

		//---------------------------------------
		// PRIVATE METHODS
		//---------------------------------------

		/**
		 *	
		 */
		private function cleanupLoader():void
		{
			var ldr:URLLoader = this.urlLoader;
			ldr.removeEventListener(FormEvent.COMPLETE, this.relayEvent);
			ldr.removeEventListener(Event.OPEN, this.relayEvent);
            ldr.removeEventListener(ProgressEvent.PROGRESS, this.relayEvent);
	        ldr.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.relayEvent);
    	    ldr.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.relayEvent);
        	ldr.removeEventListener(IOErrorEvent.IO_ERROR, this.relayEvent);
			this.urlLoader = null;
			
			this._response = ldr.data;
		}

		/**
		 *	
		 */
		private static var comboBoxValueGetter:Object =
		{
			name: 'selectedIndex',
			getter: function(host:Object):*
			{
				var value:* = undefined;
				if (host.selectedItem)
				{
					value = host.selectedItem.data;
					if ((value == null) || (value == ''))
					{
						value = host.selectedItem.label;
					}
				}
				return value;
			}
		};

		/**
		 *
		 */
		private function getComboBoxModelValueGetter(model:Object, modelProp:String, control:Object):Object
		{
			return {
				name: modelProp, 
				getter: function(host:Object):int
				{
					var data:Object = host[modelProp];
					var dp:Object = control.dataProvider;
					var matchingDataIndex:int = -1;
					var matchingLabelIndex:int = -1;

					// Match the model value against the data property of the data provider objects
					for (var i:int = 0; i < dp.length; i++)
					{
						var o:Object = dp.getItemAt(i);
						if (o.data &&  (o.data == data))
						{
							matchingDataIndex = i;
							break;
						}
						else if (o.label && (o.label == data))
						{
							// If we don't find a data match, we'll settle for a matching label.
							matchingLabelIndex = i;
						}
					}

					return matchingDataIndex != -1 ? matchingDataIndex : matchingLabelIndex;
				}
			};
		}

		/**
		 *	
		 */
		private function getEmptyValue(control:Object, prop:String):Object
		{
			var o:Object = this.formControlsMap[control];
			var emptyValue:*;
			if (o)
			{
				var info:Object = o[prop];
				if (info.emptyValue !== undefined)
				{
					emptyValue = info.emptyValue;
				}
			}
			if (emptyValue === undefined)
			{
				if (control is TextField)
				{
					emptyValue = '';
				}
				else
				{
					emptyValue = null;
				}
			}

			return emptyValue;
		}

		/**
		 *	
		 */
		private function getModel(modelId:String):Object
		{
			return this.models[modelId] || (this.models[modelId] = {});
		}

		/**
		 *	
		 */
		private function getURLRequest():URLRequest
		{
			var url:String = this._action as String;
			var request:URLRequest = new URLRequest(url);
			request.method = this.method;
			return request;
		}

		/**
		 * Gets a description of the errors for debugging.	
		 */
		private function getValidationErrors(result:ValidationResult):String
		{
			var lines:Array = [];
			for each (var error:ValidationError in result.errors)
			{
				lines.push('\t[' + result.field + '] ' + error.message);
			}
			for each (var subFieldResult:ValidationResult in result.subFieldResults)
			{
				lines.push(this.getValidationErrors(subFieldResult));
			}
			return lines.join('\n');
		}

		/**
		 *	
		 */
		private function init():void
		{
			this._debug = false;
			this.formControlsMap = new Dictionary(true);
			this.labels2Controls = new Dictionary(true);
			this.validators = [];
		}

		/**
		 *
		 */
		private function label_clickHandler(e:MouseEvent):void
		{
			var label:DisplayObject = e.currentTarget as DisplayObject;
			var control:InteractiveObject = this.labels2Controls[label] as InteractiveObject;
			var stage:Stage = label.stage as Stage || control.stage as Stage;
			if (stage != null)
			{
// TODO: if (control is IFocusable) control.focus()
				stage.focus = control;
			}
		}

		/**
		 *
		 */
		private function relayEvent(e:Event):void
		{
			var cleanup:Boolean = false;
			var isError:Boolean = false;
			var success:Boolean = false;
			switch (e.type)
			{
				case FormEvent.COMPLETE:
					cleanup = true;
					success = true;
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
				case IOErrorEvent.IO_ERROR:
					cleanup = true;
					isError = true;
					break;
			}
			
			if (cleanup)
			{
				this.cleanupLoader();
			}
			
			this.dispatchEvent(e);
			
			if (isError)
			{
				this.dispatchEvent(new FormEvent(FormEvent.SUBMISSION_ERROR));
			}
			else if (success && this.debug)
			{
				trace('Form Response:');
				trace(this.response);
			}
		}

		/**
		 *	
		 */
		private function submitButton_clickHandler(e:Event):void
		{
			if (!(e is MouseEvent)) return;
			this.submit();
		}

		/**
		 *
		 */
		private function _validate():Array
		{
			var results:Array = [];

			for each (var validator:IValidator in this.validators)
			{
				results.push(validator.validate());
			}

			return results;
		}

	}
}
