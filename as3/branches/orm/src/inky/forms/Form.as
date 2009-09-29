﻿package inky.forms
{
	import inky.collections.ArrayList;
	import inky.collections.IList;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
	import flash.text.TextField;
	import inky.forms.FormController;
	import inky.forms.events.FormEvent;
	import inky.validation.IValidator;
	import inky.validation.IValidatorView;
	import inky.validation.events.ValidationResultEvent;


	/**
	 *	
	 *	Wraps a FormController
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Eric Eldredge
	 *	@author Matthew Tretter
	 *	@since  2008.11.17
	 *	
	 */
	public class Form extends MovieClip
	{
		private var _controller:FormController;
		private var _labelPattern:RegExp;



		/**
		 *
		 *	
		 */
		public function Form()
		{
			this._init();
		}




		//
		// accessors
		//


		/**
		 * @copy inky.forms.FormController#action
		 */
		public function get action():Object
		{
			return this._controller.action;
		}
		/**
		 * @private
		 */
		public function set action(action:Object):void
		{
			this._controller.action = action;
		}


		/**
		 * @copy inky.forms.FormController#controls
		 */
		public function get controls():IList
		{
			return this._controller.controls;
		}


		/**
		 * @copy inky.forms.FormController#debug
		 */
		public function get debug():Boolean
		{
			return this._controller.debug;
		}
		/**
		 * @private
		 */
		public function set debug(debug:Boolean):void
		{
			this._controller.debug = debug;
		}


		/**
		 *
		 *	
		 */
		public function destroy():void
		{
			this._controller.destroy();
		}


		/**
		 * @copy inky.forms.FormController#labels
		 */
		public function get labels():IList
		{
			return this._controller.labels;
		}


		/**
		 * @copy inky.forms.FormController#method
		 */
		public function get method():String
		{
			return this._controller.method;
		}
		/**
		 * @private
		 */
		public function set method(method:String):void
		{
			this._controller.method = method;
		}


		/**
		 * @copy inky.forms.FormController#response
		 */
		public function get response():Object
		{
			return this._controller.response;
		}


		/**
		 * @copy inky.forms.FormController#submitButton
		 */
		public function get submitButton():InteractiveObject
		{
			return this._controller.submitButton;
		}
		/**
		 * @private
		 */
		public function set submitButton(submitButton:InteractiveObject):void
		{
			this._controller.submitButton = submitButton;
		}




		//
		// public methods
		//


		/**
		 * @copy inky.forms.FormController#addControl()
		 */
		public function addControl(control:DisplayObject, controlValueGetter:Object = null, modelOrModelId:Object = null, modelValueGetter:Object = null, submissionName:String = null, emptyValue:* = undefined):void
		{
			this._controller.addControl(control, controlValueGetter, modelOrModelId, modelValueGetter, submissionName, emptyValue);
		}


		/**
		 * 
		 */
		public function addLabel(label:DisplayObject, control:DisplayObject = null):void
		{
			if (label == null)
			{
				throw new ArgumentError('Null label!');
			}
			else if (control == null)
			{
				var controlNameMatch:Array = label.name.match(this._labelPattern);
				if (controlNameMatch != null)
				{
					control = this.getChildByName(controlNameMatch[1]);
				}
			}
			
			if (control == null)
			{
				throw new Error('Could not find control for label ' + label.name);
			}
			else
			{
				this._controller.addLabel(label, control);
			}
		}


		/**
		 * @copy inky.forms.FormController#addValidator()
		 */
		public function addValidator(validator:IValidator, view:IValidatorView = null):void
		{
			this._controller.addValidator(validator, view);
		}


		/**
		 *
		 */
		public function getControlByLabel(label:DisplayObject):DisplayObject
		{
			return this._controller.getControlByLabel(label);
		}


		/**
		 *
		 */
		public function getControlValue(control:DisplayObject):*
		{
			return this._controller.getControlValue(control);
		}


		/**
		 *
		 */
		public function getLabelByControl(control:DisplayObject):DisplayObject
		{
			return this._controller.getLabelByControl(control);
		}


		/**
		 * @copy inky.forms.FormController#removeControl()
		 */
		public function removeControl(control:DisplayObject):void
		{
			this._controller.removeControl(control);
		}


		/**
		 * @copy inky.forms.FormController#removeValidator()
		 */
		public function removeValidator(validator:IValidator):void
		{
			this._controller.removeValidator(validator);
		}


		/**
		 * @copy inky.forms.FormController#restore()
		 */
		public function restore():void
		{
			this._controller.restore();
		}


		/**
		 * @copy inky.forms.FormController#restoreControl()
		 */
		public function restoreControl(control:Object, prop:String, delay:Boolean = false):void
		{
			this._controller.restoreControl(control, prop, delay);
		}


		/**
		 * @copy inky.forms.FormController#submit()
		 */
		public function submit():void
		{
			this._controller.submit();
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 */
		private function _init():void
		{
			this._labelPattern = /(.*)_label$/;

			this.addEventListener(Event.REMOVED_FROM_STAGE, this._removedFromStageHandler);
			
			this._controller = new FormController();
			this._controller.addEventListener(FormEvent.SUBMIT, this._relayEvent);
			this._controller.addEventListener(FormEvent.ERROR, this._relayEvent);
			this._controller.addEventListener(FormEvent.SUBMIT_CANCELLED, this._relayEvent);
			this._controller.addEventListener(FormEvent.VALIDATION_ERROR, this._relayEvent);
			this._controller.addEventListener(Event.COMPLETE, this._relayEvent);
			this._controller.addEventListener(Event.OPEN, this._relayEvent);
            this._controller.addEventListener(ProgressEvent.PROGRESS, this._relayEvent);
            this._controller.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this._relayEvent);
            this._controller.addEventListener(HTTPStatusEvent.HTTP_STATUS, this._relayEvent);
            this._controller.addEventListener(IOErrorEvent.IO_ERROR, this._relayEvent);

			for (var i:int = 0; i < this.numChildren; i++)
			{
				var child:DisplayObject = this.getChildAt(i);
				this._initChild(child);
			}
		}


		/**
		 *
		 *	
		 */
		private function _initChild(child:DisplayObject):void
		{
			var labelMatch:Array = child.name.match(this._labelPattern);
			if (labelMatch != null)
			{
				this.addLabel(child);
			}
			if (!(child is IValidatorView))
			{
				if (child.name == '_submitButton')
				{
					this.submitButton = child as InteractiveObject;
				}
				else if (labelMatch == null)
				{
					try
					{
						this.addControl(child);
					}
					catch(error:Error)
					{
						// TODO: Should this fail silently?
					}
				}
			}
		}


		/**
		 *
		 *	
		 */
		private function _relayEvent(e:Event):void
		{
			this.dispatchEvent(e);
		}


		/**
		 *
		 */
		private function _removedFromStageHandler(e:Event):void
		{
// TODO: What if you remove it and add it back?
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			this.destroy();
		}




	}
}
