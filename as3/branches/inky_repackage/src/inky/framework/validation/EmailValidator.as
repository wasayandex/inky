﻿package inky.framework.validation
{
	import flash.events.EventDispatcher;
	import inky.framework.binding.utils.BindingUtil;
	import inky.framework.validation.IValidator;


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
	public class EmailValidator extends EventDispatcher implements IValidator
	{
		private var _property:Object;
		private var _required:Boolean;
		private var _source:Object;

		public var invalidCharError:String;
		public var invalidDomainError:String;
		public var invalidIPDomainError:String;
		public var invalidPeriodsInDomainError:String;
		public var missingAtSignError:String;
		public var missingPeriodInDomainError:String;
		public var missingUsernameError:String;
		public var tooManyAtSignsError:String;




		/**
		 *
		 *	
		 */
		public function EmailValidator(source:Object = null, property:Object = null, required:Boolean = true)
		{
			this._init(source, property, required);
		}




		//
		// accessors
		//


		/**
		 * @inheritDoc
		 */
		public function get property():Object
		{
			return this._property;
		}
		/**
		 * @private
		 */
		public function set property(property:Object):void
		{
			this._property = property;
		}


		/**
		 * @inheritDoc
		 */
		public function get required():Boolean
		{
			return this._required;
		}
		/**
		 * @private
		 */
		public function set required(required:Boolean):void
		{
			this._required = required;
		}


		/**
		 * @inheritDoc
		 */
		public function get source():Object
		{
			return this._source;
		}
		/**
		 * @private
		 */
		public function set source(source:Object):void
		{
			this._source = source;
		}




		//
		// public methods
		//


		/**
		 * @inheritDoc
		 */
		public function validate():ValidationResult
		{
			var field:String = 'email';
			var errors:Array = [];
			var tmp:Object = BindingUtil.evaluateBindingChain(this.source, this.property);
			var value:String = tmp ? tmp.toString() : '';

			if (this.required && !value)
			{
				errors.push(new ValidationError('Field is required.'));
			}
			else if (value)
			{
				var atSignIndex:int = value.indexOf('@');
				if (atSignIndex == -1)
				{
					errors.push(new ValidationError(this.missingAtSignError));
				}
				else if (atSignIndex != value.lastIndexOf('@'))
				{
					errors.push(new ValidationError(this.tooManyAtSignsError));
				}
				else
				{
					if (atSignIndex == 0)
					{
						errors.push(new ValidationError(this.missingUsernameError));
					}

					var localPart:String = value.substr(0, atSignIndex);
					var domain:String = value.substr(atSignIndex + 1);
					if (domain.indexOf('.') == -1)
					{
						errors.push(new ValidationError(this.missingPeriodInDomainError));
					}
					else if (/\.\./.test(domain) || /^\./.test(domain))
					{
						errors.push(new ValidationError(this.invalidPeriodsInDomainError));
					}
					if (!(/^[a-zA-Z0-9\!#$%&'\*\+\-\/=\?^_`\{\|\}~\.]+$/.test(localPart)))
					{
						errors.push(new ValidationError(this.invalidCharError));
					}
					// TODO: Support invalidDomainError and invalidIPDomainError
				}
			}

			var isError:Boolean = errors.length > 0;
			var type:String = isError ? ValidationResultEvent.INVALID : ValidationResultEvent.VALID;
			var result:ValidationResult = new ValidationResult(isError, field, errors);
			var e:ValidationResultEvent = new ValidationResultEvent(type, false, false, result);
			this.dispatchEvent(e);
			return result;
		}




		//
		// private methods
		//


		/**
		 *
		 *	
		 */
		private function _init(source:Object, property:Object, required:Boolean = true):void
		{
			this.source = source;
			this.property = property;
			this.required = required;

			this.invalidCharError = 'Your e-mail address contains invalid characters.';
			this.invalidDomainError = 'The domain in your e-mail address is incorrectly formatted.';
			this.invalidIPDomainError = 'The IP domain in your e-mail address is incorrectly formatted.';
			this.invalidPeriodsInDomainError='The domain in your e-mail address has consecutive periods.';
			this.missingAtSignError = 'An at sign (&64;) is missing in your e-mail address.';
			this.missingPeriodInDomainError = 'The domain in your e-mail address is missing a period.';
			this.missingUsernameError = 'The username in your e-mail address is missing.';
			this.tooManyAtSignsError = 'Your e-mail address contains too many &64; characters.';
		}


	}
}
