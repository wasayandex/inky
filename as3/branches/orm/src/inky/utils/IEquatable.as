package inky.utils
{


	/**
	 *
	 * 
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 *
	 * @author Matthew Tretter
	 * @since  2008.08.27
	 *
	 */
    public interface IEquatable
    {


    	/**
    	 *
    	 *
    	 * Indicates whether some other object is "equal to" this one.
    	 *
    	 * The equals method implements an equivalence relation:
		 * - It is reflexive: for any reference value x, x.equals(x) should
		 *   return true.
		 * - It is symmetric: for any reference values x and y, x.equals(y)
		 *   should return true if and only if y.equals(x) returns true.
		 * - It is transitive: for any reference values x, y, and z, if
		 *   x.equals(y) returns true and y.equals(z) returns true, then
		 *   x.equals(z) should return true.
		 * - It is consistent: for any reference values x and y, multiple
		 *   invocations of x.equals(y) consistently return true or consistently
		 *   return false, provided no information used in equals comparisons on
		 *   the object is modified.
		 * - For any non-null reference value x, x.equals(null) should return
		 *   false.
		 * 
		 * @param obj
		 *     the reference object with which to compare.
		 * @return
		 *     true if this object is the same as the obj argument; false
		 *     otherwise.
    	 *
    	 * @see http://java.sun.com/j2se/1.3/docs/api/java/lang/Object.html#equals(java.lang.Object)
    	 *
    	 */
		function equals(obj:Object):Boolean;


    }
}
