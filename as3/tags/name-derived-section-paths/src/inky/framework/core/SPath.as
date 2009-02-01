package inky.framework.core {	import com.exanimo.collections.ArrayList;		/**	 *	 * An object that represents the location of a section in an application.	 * An SPath is a list of section names delimited by forward slashes that	 * reflects the location of a Section within the application, as defined	 * by the inky XML. For the sake of simplicity, the framework API rarely	 * requires SPaths. Instead, methods accept both SPaths and their string	 * equivalents and internally parse strings using	 * <code>SPath.parse()</code>. Therefore, the string	 * "/animals/mammals/monkeys" can generally be considered equivalent to	 * SPath created below:	 * 	 * <listing>var mySPath:SPath = new SPath('animals', 'mammals', 'monkeys');	 * mySPath.absolute = true;</listing>	 * 	 * As in other path notation systems, the intial forward slash denotes	 * that the path is absolute (i.e. should be considered relative to the	 * application). Relative paths do not begin with a forward slash and	 * are to be resolved to the Section object that processes them.	 * 	 * The following example shows inky xml for an application that contains	 * sections whose absolute SPaths are "/animals", "/animals/mammals",	 * "/animals/mammals/monkeys", and "/animals/reptiles". 	 * 	 * <listing>&lt;inky:Application xmlns:inky="http://inkyframework.com/2008/inky">	 * 	&lt;inky:Section inky:class="AnimalsSection" name="animals">	 * 		&lt;inky:Section inky:class="MammalsSection" name="mammals">	 * 			&lt;inky:Section inky:class="MonkeysSection" name="monkeys" />	 * 		&lt;/inky:Section>	 * 		&lt;inky:Section inky:class="ReptilesSection" name="reptiles" />	 * 	&lt;/inky:Section>	 * &lt;/inky:Application>	 * </listing>	 *	 * 	 * @see inky.framework.core.Application#dataSource	 * @see inky.framework.core.Section#gotoSection()	 * 	 * 	 * @langversion ActionScript 3	 * @playerversion Flash 9.0.0	 *	 * @author Eric Eldredge	 * @author Matthew Tretter	 * @since  2008.01.24	 *	 */	public class SPath extends ArrayList 	{		// Because of how RouteMapper works, the delimiter probably shouldn't change.		private static var DELIMITER:String = '/';		private static var OWNER_TOKEN:String = '..';		private static var SELF_TOKEN:String = '.';				private var _absolute:Boolean;		/**		 *		 * Creates a new SPath instance. The result is a non-absolute SPath. In		 * most situations, it's probably easier to use <code>SPath.parse()</code>.		 *		 * @see #parse()		 * 		 * @param ...rest		 *     A list of section names with which to construct the SPath.		 * 		 */		public function SPath(...rest:Array)		{			var sPath:Array = [];			if (rest[0] is Array)			{				sPath = rest[0];			}			else			{				sPath = rest;			}			while(sPath.length)			{				this.addItem(sPath.shift());			}			this._absolute = false;		}		//		// accessors		//		/**		 *		 * A boolean value that specifies whether this SPath is absolute. An		 * absolute SPath will be interpreted as being relative to the master		 * section whereas a relative SPath may refer to a different section		 * depending on its context.		 * 		 * @default false		 * 		 */		public function get absolute():Boolean		{			return this._absolute;		}		/**		 * @private		 */		public function set absolute(absolute:Boolean):void		{			this._absolute = absolute;		}		//		// public methods		//		/**		 *		 * Create a copy of this SPath object.		 * 		 * @return		 *      a copy of this SPath		 * 		 */			public function clone():Object		{			var clone:SPath = new SPath(this.toArray());			clone.absolute = this.absolute;			return clone;		}		/**		 *		 * Determines if two SPath objects represent the same path.		 * 		 * @param sPath		 *     the SPath to compare to this one		 *		 * @return		 *     true if the given SPath represents the same path as this one,		 *     otherwise false. Note that this function does NOT tell you		 *     whether or not the paths represent the same Section -- for		 *     example, "/one/two/three" and "three" may point to the same		 *     Section but they are not equal SPaths.		 * 		 */			override public function equals(sPath:Object):Boolean		{			if (!(sPath as SPath)) return false;			if (this.absolute != sPath.absolute) return false;			if (this.length != sPath.length) return false;			for (var i:uint = 0; i < this.length; i++)			{				if (this.getItemAt(i) != sPath.getItemAt(i)) return false;			}			return true;		}		/**		 *		 * Creates an SPath that is the normalized version of this one.		 * Normalization occurs in a manner consistent with URI normalization.		 * If this URI is opaque, or if its path is already in normal form,		 * then this URI is returned. Otherwise, the following occurs:		 * 1) All "." segments are removed.		 * 2) If a ".." segment is preceded by a non-".." segment then both of		 * these segments are removed. The original SPath is not modified.		 * 		 * @return		 *     An SPath object that represents the normalized form of this one.		 *		 */		public function normalize():SPath		{			var result:SPath = this.clone() as SPath;			for (var i:uint = 0; i < result.length; i++)			{				var segment:String = result.getItemAt(i) as String;				if (segment == SPath.SELF_TOKEN)				{					result.removeItemAt(i);					i--;				}				else if (segment == SPath.OWNER_TOKEN)				{					var j:int = i;					var p:String;					while (j >= 0)					{						p = result.getItemAt(j) as String;						if (p != SPath.OWNER_TOKEN)						{							result.removeItemAt(i);							result.removeItemAt(j);							i--;							break;						}						j--;					}				}			}			return result;		}		/**		 *		 * Parses an SPath from a String.		 * 		 * @param path		 *     The string representation of the SPath		 * 		 */		public static function parse(path:String):SPath		{			// If the String is empty, return an empty SPath.			if (!path) return new SPath();			var a:Array = path.split(SPath.DELIMITER);			// If the path starts with the delimiter, it's absolute.			var absolute:Boolean = false;			if (a[0] == '')			{				a.shift();				absolute = true;			}			// Remove empty items from the end.			while (a[a.length - 1] == '')			{				a.pop();			}			// Create and return the SPath.			var sPath:SPath = new SPath(a);			sPath.absolute = absolute;			return sPath;		}		/**		 *		 * ..		 *		 * @param sPath		 *     the SPath to be relativized against this SPath		 * @return		 *     the resolved SPath		 * 		 */			public function relativize(sPath:SPath):SPath		{			var result:SPath;			if (!sPath.absolute || !this.absolute)			{				result = sPath.normalize();			}			else			{				var a:SPath = this.normalize();				var b:SPath = sPath.normalize();				result = new SPath();						// Find the index of the last common element.				var commonIndex:int = -1;				var i:int = 0;				while (i < a.length && i < b.length)				{					if (a.getItemAt(i) == b.getItemAt(i))					{						commonIndex = i;					}					else					{						break;					}					i++;				}						for (i = commonIndex + 1; i < a.length; i++)				{					result.addItem(SPath.OWNER_TOKEN);				}						for (i = commonIndex + 1; i < b.length; i++)				{					result.addItem(b.getItemAt(i));				}			}			return result;		}		/**		 *		 * Creates an SPath that is the result of resolving this SPath to		 * another.		 *		 * @param sPath		 *     the SPath to resolve this one to		 * @return		 *     the resolved path		 * 		 */			public function resolve(sPath:SPath):SPath		{			if (this.absolute) return this.clone() as SPath;			if (!sPath) return this.clone() as SPath;			var result:SPath = new SPath(sPath.toArray().concat(this.toArray()));			result.absolute = sPath.absolute;			return result;		}		/**		 *		 * Returns a String representation of this SPath		 * 		 */			override public function toString():String		{			return (this.absolute ? SPath.DELIMITER : '') + this.toArray().join(SPath.DELIMITER);		}	}}