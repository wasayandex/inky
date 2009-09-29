﻿package inky.validation
{
	import caurina.transitions.Tweener;
	import flash.display.*;
	import flash.text.*;
	import inky.validation.IValidator;
	import inky.validation.events.ValidationResultEvent;


	/**
	 *	
	 *	..
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Eric Eldredge
	 *	@author Matthew Tretter
	 *	@since  2008.11.17
	 *	
	 */
	public class InvalidFieldIndicator extends Sprite implements IValidatorView
	{
		private var _valid:Boolean;
		private var _validator:IValidator;


		/**
		 *
		 *
		 */
		public function InvalidFieldIndicator()
		{
			this.reset();
		}




		//
		// accessors
		//


		/**
		 *
		 *
		 *
		 */
		public function get valid():Boolean
		{
			return this._valid;
		}


		/**
		 *
		 *
		 *
		 */
		public function get validator():IValidator
		{
			return this._validator;
		}
		/**
		 * @private
		 */
		public function set validator(validator:IValidator):void
		{
			if (this._validator)
			{
				this._validator.removeEventListener(ValidationResultEvent.INVALID, this._validateHandler);
				this._validator.removeEventListener(ValidationResultEvent.VALID, this._validateHandler);
			}
			if (validator)
			{
				validator.addEventListener(ValidationResultEvent.INVALID, this._validateHandler, false, 0, true);
				validator.addEventListener(ValidationResultEvent.VALID, this._validateHandler, false, 0, true);
			}
			this._validator = validator;
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			this.alpha = 0;
		}


		/**
		 *
		 *	
		 */
		public function update():void
		{
			Tweener.addTween(this, {alpha: this.valid ? 0 : 1, time: 1});
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 */
		private function _validateHandler(e:ValidationResultEvent):void
		{
			this._valid = e.type == ValidationResultEvent.VALID;
			this.update();
		}




	}
}
