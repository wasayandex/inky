﻿package{	import flash.display.*;	import flash.text.*;	import inky.framework.data.*;	import inky.framework.forms.*;	import inky.framework.validation.*;	public class MyForm extends Form	{		public function MyForm()		{			this.action = 'blah.php';			this.addValidator(new EqualityValidator(this.user_tos, 'selected', true), this.invalidTOSIndicator);			this.addValidator(new EmailValidator(this.user_email, 'text', true), this.invalidEmailIndicator);			this.addValidator(new DateValidator(this.user_birthYear, 'selectedLabel', this.user_birthMonth, 'selectedLabel', this.user_birthDay, 'selectedLabel'), this.invalidBirthdayIndicator);			this.restore();		}	}}