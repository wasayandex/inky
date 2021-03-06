﻿package inky.async.actions
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	import inky.async.actions.IAction;
	import inky.async.actions.events.ActionEvent;
	import inky.app.IInkyDataParser;
	
	import com.gskinner.motion.GTween;
	import inky.async.IAsyncToken;
	import inky.async.AsyncToken;
	import inky.async.async_internal;

	/**
	 * @langversion ActionScript 3
	 */
	dynamic public class GTweenAction extends EventDispatcher implements IAction, IInkyDataParser
	{
		private var _target:Object;
		private var _gTween:GTween;
		private var _duration:Number;
		private var _properties:Object;
		private var _token:IAsyncToken;
		private var _tweenProperties:Object;		

		/**
		 */
		public function GTweenAction(duration:Number = 10, properties:Object = null, tweenProperties:Object = null, target:Object = null)
		{
			this._duration = duration;
			if(properties) this._properties = properties;
			if(tweenProperties) this._tweenProperties = tweenProperties;
			if (target) this.target = target;
			
			/*
			for (var prop:String in properties)
			{
				this[prop] = properties[prop];
			}
			*/
		}




		//
		// Get / Set Functions
		//
		
		
		/**
		 * The currently active Ticker object.
		 */
		/*
		public function get activeTicker():ITicker
		{
			return this._GTween.activeTicker;
		}
		*/
		
		
		/**
		 * Indicates whether the tween should automatically play when an end value is changed.
		 */
		public function get autoPlay():Boolean
		{
			return this._gTween.autoPlay;
		}
		public function set autoPlay(value:Boolean):void
		{
			if(value) this._gTween.autoPlay = value;
		}
		
		
		/**
		 * When true, the tween will always rotate in the shortest direction to reach an end rotation value.
		 */
		public function get autoRotation():Boolean
		{
			return this._gTween.autoRotation;
		}
		public function set autoRotation(value:Boolean):void
		{
			if(value) this._gTween.autoRotation = value;
		}
		
		
		/**
		 * Indicates whether the target's visible property should automatically be set to false when its alpha value is tweened to 0 or less.
		 */
		public function get autoVisible():Boolean
		{
			return this._gTween.autoVisible;
		}
		public function set autoVisible(value:Boolean):void
		{
			if(value) this._gTween.autoVisible = value;
		}
		
		
		/**
		 * Allows you to associate arbitrary data with your tween. For example, you might use this to reference specific data when handling events from tweens.
		 */
		public function get data():*
		{
			return this._gTween.data;
		}
		public function set data(value:*):void
		{
			if(value) this._gTween.data = value;
		}
		
		
		/**
		 * Specifies the default easing function to use with new tweens.
		 */
		/*
		public function set defaultEase(value:Function):void
		{
			if(value) GTween.defaultEase = value;
		}
		*/
		
		
		/**
		 * The length of the delay in frames or seconds (depending on the timingMode).
		 */
		public function get delay():Number
		{
			return this._gTween.delay;
		}
		public function set delay(value:Number):void
		{
			if(value) this._gTween.delay = value;
		}
		
		
		/**
		 * The length of the tween in frames or seconds (depending on the timingMode).
		 */
		public function get duration():Number
		{
			return this._duration;
		}
		public function set duration(value:Number):void
		{
			if(value) this._duration = value;
		}
		
		
		/**
		 * The easing function to use for calculating the tween. This can be any standard tween function, such as the tween functions in fl.motion.easing.that come with Flash CS3. New tweens will have this set to the defaultTween. Setting this to null will cause GTween to throw null reference errors.
		 */
		/*
		public function get ease():Function
		{
			return this._gTween.ease;
		}
		public function set ease(value:Function):void
		{
			if(value) this._gTween.ease = value;
		}
		*/
		
		
		/**
		 * If set to true, this prevents the tween from reinitializing its start properties automatically (ex. when end properties change). If start properties have not already been initialized, this will also cause the tween to immediate initialize them. Note that this will prevent new start property values from being initialized when invalidating, so it could cause unexpected behaviour if you modify the tween while it is playing.
		 */
		public function get lockStartProperties():Boolean
		{
			return this._gTween.lockStartProperties;
		}
		public function set lockStartProperties(value:Boolean):void
		{
			if(value) this._gTween.lockStartProperties = value;
		}
		
		
		/**
		 * Specifies another GTween instance that will have paused=false called on it when this tween completes.
		 */
		public function get nextTween():GTween
		{
			return this._gTween.nextTween;
		}
		public function set nextTween(value:GTween):void
		{
			if(value) this._gTween.nextTween = value;
		}
		
		
		/**
		 * Setting this to true pauses all tween instances.
		 */
		public function set pauseAll(value:Boolean):void
		{
			if(value) GTween.pauseAll = value;
		}
		
		
		/**
		 * Indicates whether the tween is currently paused.
		 */
		public function get paused():Boolean
		{
			return this._gTween.paused;
		}
		public function set paused(value:Boolean):void
		{
			if(value) this._gTween.paused = value;
		}
		
		
		/**
		 * Gets and sets the position in the tween in frames or seconds (depending on the timingMode).
		 */
		public function get position():Number
		{
			return this._gTween.position;
		}
		public function set position(value:Number):void
		{
			if(value) this._gTween.position = value;
		}
		
		
		/**
		 * Returns the object that will have its property tweened.
		 */
		public function get propertyTarget():Object
		{
			return this._gTween.propertyTarget;
		}
		
		
		/**
		 * The proxy object allows you to work with the properties and methods of the target object directly through GTween. Numeric property assignments will be used by GTween as end values. The proxy will return GTween end values when they are set, or the target's property values if they are not. Delete operations on properties will result in a deleteProperty call. All other property access and method execution through proxy will be passed directly to the target object.
		 */
		public function get proxy():Object
		{
			return this._gTween.proxy;
		}
		
		
		/**
		 * Indicates whether the tween should use the reflect mode when repeating.
		 */
		public function get reflect():Boolean
		{
			return this._gTween.reflect;
		}
		public function set reflect(value:Boolean):void
		{
			if(value) this._gTween.reflect = value;
		}
		
		
		/**
		 * The number of times this tween will repeat.
		 */
		public function get repeat():int
		{
			return this._gTween.repeat;
		}
		public function set repeat(value:int):void
		{
			if(value) this._gTween.repeat = value;
		}
		
		
		/**
		 * Indicates whether a tween should run in reverse.
		 */
		public function get reversed():Boolean
		{
			return this._gTween.reversed;
		}
		public function set reversed(value:Boolean):void
		{
			if(value) this._gTween.reversed = value;
		}
		
		
		/**
		 * A hash table specifying properties that should be affected by autoRotation.
		 */
		public function get rotationProperties():Object
		{
			return GTween.rotationProperties;
		}
		public function set rotationProperties(value:Object):void
		{
			if(value) GTween.rotationProperties = value;
		}
		
		
		/**
		 * If set to true, tweened values specified by snappingProperties will be rounded (snapped) before they are assigned to the target.
		 */
		public function get snapping():Boolean
		{
			return this._gTween.snapping;
		}
		public function set snapping(value:Boolean):void
		{
			if(value) this._gTween.snapping = value;
		}
		
		
		/**
		 * A hash table specifying properties that should have their value rounded (snapped) before being applied.
		 */
		public function get snappingProperties():Object
		{
			return GTween.snappingProperties;
		}
		public function set snappingProperties(value:Object):void
		{
			if(value) GTween.snappingProperties = value;
		}
		
		
		/**
		 * Returns the current positional state of the tween.
		 */
		public function get state():String
		{
			return this._gTween.state;
		}
		
		
		/**
		 * Sets the time in milliseconds between updates when timingMode is set to GTween.TIME ("time").
		 */
		public function get timeInterval():uint
		{
			return GTween.timeInterval;
		}
		public function set timeInterval(value:uint):void
		{
			if(value) GTween.timeInterval = value;
		}
		
		
		/**
		 * Indicates how GTween should deal with timing.
		 */
		public function get timingMode():String
		{
			return GTween.timingMode;
		}
		public function set timingMode(value:String):void
		{
			if(value) GTween.timingMode = value;
		}
		
		
		/**
		 * Returns the calculated absolute position in the tween.
		 */
		public function get tweenPosition():Number
		{
			return this._gTween.tweenPosition;
		}


		/**
		 *	
		 * @inheritDoc
		 *	
		 */
		public function get cancelable():Boolean
		{
			return true;
		}


		/**
		 * The target object to tween.
		 */
		public function get target():Object
		{
			return this._target;
		}
		public function set target(target:Object):void
		{
			this._target = target;
			
			this._gTween = new GTween(this.target, duration);
			this._gTween.autoPlay = false;
		}


		//
		// Public Functions
		//
		
		
		/**
		 * Jumps the tween to its beginning.
		 */
		public function beginning():void
		{
			this._gTween.beginning();
		}
		
		
		/**
		 * Removes a end value from the tween.
	 	 */
		public function deleteProperty(name:String):Boolean
		{ 
			return this._gTween.deleteProperty(name);
		}
		
		
		/**
		 * Jumps the tween to its end.
	 	 */
		public function end():void
		{ 
			this._gTween.end();
		}
		
		
		/**
		 * Returns the hash table of all end properties and their values.
	 	 */
		public function getProperties():Object
		{ 
			return this._gTween.getProperties();
		}
		
		
		/**
		 * Returns the end value for the specified property if one exists.
	 	 */
		public function getProperty(name:String):Number
		{ 
			return this._gTween.getProperty(name);
		}
		
		
		/**
		 * Returns the hash table of all start properties and their values.
	 	 */
		public function getStartProperties():Object
		{ 
			return this._gTween.getStartProperties();
		}
		
		
		/**
		 * Invalidate forces the tween to repopulate all of the initial properties from the target object, and start playing if autoplay is set to true.
		 */
		public function invalidate():void
		{
			this._gTween.invalidate();
		}
		
		
		/**
	  	 * The default easing function used by GTween.
	 	 */
		public function linearEase(t:Number, b:Number, c:Number, d:Number):void
		{
			GTween.linearEase(t, b, c, d);
		}
		
		
		/**
		 * Pauses the tween by stopping tick from being automatically called.
		 */
		public function pause():void
		{
			this._gTween.pause();
		}
		
		
		/**
		 * Plays a tween by incrementing the position property each frame.
		 */
		public function play():void
		{
			this._gTween.play();
		}
		
		
		/**
		 * Toggles the reversed property and inverts the current tween position.
		 */
		public function reverse(suppressEvents:Boolean = true):void
		{
			this._gTween.reverse(suppressEvents);
		}
		
		
		/**
		 * Allows you to tween objects that require re-assignment whenever they are modified by reassigning the target object to a specified property of another object.
		 */
		public function setAssignment(assignmentTarget:Object = null, assignmentProperty:String = null):void
		{
			this._gTween.setAssignment(assignmentTarget, assignmentProperty);
		}
		
		
		/**
		 * Sets the position of the tween.
		 */
		public function setPosition(position:Number, suppressEvents:Boolean = true):void
		{
			this._gTween.setPosition(position, suppressEvents);
		}
		
		
		/**
		 * Shorthand method for making multiple setProperty calls quickly.
		 */
		public function setProperties(properties:Object):void
		{
			this._gTween.setProperties(properties);
		}
		
		
		/**
		 * Sets the numeric end value for a property on the target object that you would like to tween.
		 */
		public function setProperty(name:String, value:Number):void
		{
			this._gTween.setProperty(name, value);
		}
		
		
		/**
		 * Allows you to manually assign the start property values for a tween.
		 */
		public function setStartProperties(properties:Object):void
		{
			this._gTween.setStartProperties(properties);
		}
		
		
		/**
		 * Shortcut method for setting multiple properties on the tween instance quickly.
		 */
		public function setTweenProperties(properties:Object):void
		{
			this._gTween.setTweenProperties(properties);
		}


		/**
		 */
		public function cancel():void
		{
			if(this._gTween)
			{
				this._gTween.pause();
				this._gTween = null;
			}
		}


		/**
		 * 
		 */
		public function parseData(data:XML):void
		{
			/*
			for each (var item:XML in data.* + data.attributes())
			{
				var name = item.localName();
				this[name] = item.toString();
			}
			*/
		}


		/**
		 */
		public function start():IAsyncToken
		{
			return this.startAction();
		}
		
		
		/**
		 *	
		 */
		public function startAction():IAsyncToken
		{
			if (!this.target)
				throw new Error('target is null.');

			var token:AsyncToken = new AsyncToken();
			this._gTween.setProperties(this._properties);
			this._gTween.setTweenProperties(this._tweenProperties);
			this._gTween.addEventListener(Event.COMPLETE, this._gTweenCompleteHandler);
			this._gTween.addEventListener(Event.CHANGE, this._relayEvent);
			this._gTween.addEventListener(Event.INIT, this._relayEvent);
			this._token = token;
			this._gTween.play();
			return token;
		}
		
		
		//
		// Private Functions
		//


		/**
		 */
		private function _gTweenCompleteHandler(event:Event):void
		{
			this._gTween.pause();
			this._gTween.removeEventListener(Event.COMPLETE, this._gTweenCompleteHandler);
			this._gTween.removeEventListener(Event.CHANGE, this._relayEvent);
			this._gTween.removeEventListener(Event.INIT, this._relayEvent);
			this._token.async_internal::callResponders();
		}
		
		
		/**
		 */
		private function _relayEvent(event:Event):void
		{
			this.dispatchEvent(event);
		}
	}
}
