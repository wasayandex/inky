﻿/*
 * Copyright 2001-2006 Sun Microsystems, Inc.  All Rights Reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.  Sun designates this
 * particular file as subject to the "Classpath" exception as provided
 * by Sun in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
 * CA 95054 USA or visit www.sun.com if you need additional information or
 * have any questions.
 */
package inky.layout.layouts.springLayout
{
	import inky.collections.ISet;
	import inky.layout.layouts.springLayout.SpringLayoutConstraints;
	import inky.layout.layouts.springLayout.Spring;
	import inky.layout.layouts.springLayout.WidthSpring;
	import inky.collections.IList;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import inky.collections.Set;
	import flash.display.Stage;


	/**
	 * A <code>SpringLayout</code> lays out the children of its associated container
	 * according to a set of constraints.
	 * See <a href="http://java.sun.com/docs/books/tutorial/uiswing/layout/spring.html">How to Use SpringLayout</a>
	 * in <em>The Java Tutorial</em> for examples of using
	 * <code>SpringLayout</code>.
	 *
	 * <p>
	 * Each constraint,
	 * represented by a <code>Spring</code> object,
	 * controls the vertical or horizontal distance
	 * between two component edges.
	 * The edges can belong to
	 * any child of the container,
	 * or to the container itself.
	 * For example,
	 * the allowable width of a component
	 * can be expressed using a constraint
	 * that controls the distance between the west (left) and east (right)
	 * edges of the component.
	 * The allowable <em>y</em> coordinates for a component
	 * can be expressed by constraining the distance between
	 * the north (top) edge of the component
	 * and the north edge of its container.
	 *
	 * <P>
	 * Every child of a <code>SpringLayout</code>-controlled container,
	 * as well as the container itself,
	 * has exactly one set of constraints
	 * associated with it.
	 * These constraints are represented by
	 * a <code>SpringLayout.Constraints</code> object.
	 * By default,
	 * <code>SpringLayout</code> creates constraints
	 * that make their associated component
	 * have the minimum, preferred, and maximum sizes
	 * returned by the component's
	 * {@link java.awt.Component#getMinimumSize},
	 * {@link java.awt.Component#getPreferredSize}, and
	 * {@link java.awt.Component#getMaximumSize}
	 * methods. The <em>x</em> and <em>y</em> positions are initially not
	 * constrained, so that until you constrain them the <code>Component</code>
	 * will be positioned at 0,0 relative to the <code>Insets</code> of the
	 * parent <code>Container</code>.
	 *
	 * <p>
	 * You can change
	 * a component's constraints in several ways.
	 * You can
	 * use one of the
	 * {@link #putConstraint putConstraint}
	 * methods
	 * to establish a spring
	 * linking the edges of two components within the same container.
	 * Or you can get the appropriate <code>SpringLayout.Constraints</code>
	 * object using
	 * {@link #getConstraints getConstraints}
	 * and then modify one or more of its springs.
	 * Or you can get the spring for a particular edge of a component
	 * using {@link #getConstraint getConstraint},
	 * and modify it.
	 * You can also associate
	 * your own <code>SpringLayout.Constraints</code> object
	 * with a component by specifying the constraints object
	 * when you add the component to its container
	 * (using
	 * {@link Container#add(Component, Object)}).
	 *
	 * <p>
	 * The <code>Spring</code> object representing each constraint
	 * has a minimum, preferred, maximum, and current value.
	 * The current value of the spring
	 * is somewhere between the minimum and maximum values,
	 * according to the formula given in the
	 * {@link Spring#sum} method description.
	 * When the minimum, preferred, and maximum values are the same,
	 * the current value is always equal to them;
	 * this inflexible spring is called a <em>strut</em>.
	 * You can create struts using the factory method
	 * {@link Spring#constant(int)}.
	 * The <code>Spring</code> class also provides factory methods
	 * for creating other kinds of springs,
	 * including springs that depend on other springs.
	 *
	 * <p>
	 * In a <code>SpringLayout</code>, the position of each edge is dependent on
	 * the position of just one other edge. If a constraint is subsequently added
	 * to create a new binding for an edge, the previous binding is discarded
	 * and the edge remains dependent on a single edge.
	 * Springs should only be attached
	 * between edges of the container and its immediate children; the behavior
	 * of the <code>SpringLayout</code> when presented with constraints linking
	 * the edges of components from different containers (either internal or
	 * external) is undefined.
	 *
	 * <h3>
	 * SpringLayout vs. Other Layout Managers
	 * </h3>
	 *
	 * <blockquote>
	 * <hr>
	 * <strong>Note:</strong>
	 * Unlike many layout managers,
	 * <code>SpringLayout</code> doesn't automatically set the location of
	 * the components it manages.
	 * If you hand-code a GUI that uses <code>SpringLayout</code>,
	 * remember to initialize component locations by constraining the west/east
	 * and north/south locations.
	 * <p>
	 * Depending on the constraints you use,
	 * you may also need to set the size of the container explicitly.
	 * <hr>
	 * </blockquote>
	 *
	 * <p>
	 * Despite the simplicity of <code>SpringLayout</code>,
	 * it can emulate the behavior of most other layout managers.
	 * For some features,
	 * such as the line breaking provided by <code>FlowLayout</code>,
	 * you'll need to
	 * create a special-purpose subclass of the <code>Spring</code> class.
	 *
	 * <p>
	 * <code>SpringLayout</code> also provides a way to solve
	 * many of the difficult layout
	 * problems that cannot be solved by nesting combinations
	 * of <code>Box</code>es. That said, <code>SpringLayout</code> honors the
	 * <code>LayoutManager2</code> contract correctly and so can be nested with
	 * other layout managers -- a technique that can be preferable to
	 * creating the constraints implied by the other layout managers.
	 * <p>
	 * The asymptotic complexity of the layout operation of a <code>SpringLayout</code>
	 * is linear in the number of constraints (and/or components).
	 * <p>
	 * <strong>Warning:</strong>
	 * Serialized objects of this class will not be compatible with
	 * future Swing releases. The current serialization support is
	 * appropriate for short term storage or RMI between applications running
	 * the same version of Swing.  As of 1.4, support for long term storage
	 * of all JavaBeans<sup><font size="-2">TM</font></sup>
	 * has been added to the <code>java.beans</code> package.
	 * Please see {@link java.beans.XMLEncoder}.
	 *
	 * @see Spring
	 * @see SpringLayout.Constraints
	 *
	 * @author      Philip Milne
	 * @author      Scott Violet
	 * @author      Joe Winchester
	 * @since       1.4
	 */
	public class SpringLayout
	{
	    private var componentConstraints:Dictionary = new Dictionary(true);

	    private var cyclicReference:Spring = Spring.constant(Spring.UNSET);
	    private var cyclicSprings:ISet;
	    private var acyclicSprings:ISet;


	    /**
	     * Specifies the top edge of a component's bounding rectangle.
	     */
	    public static const NORTH:String = "north";

	    /**
	     * Specifies the bottom edge of a component's bounding rectangle.
	     */
	    public static const SOUTH:String = "south";

	    /**
	     * Specifies the right edge of a component's bounding rectangle.
	     */
	    public static const EAST:String = "east";

	    /**
	     * Specifies the left edge of a component's bounding rectangle.
	     */
	    public static const WEST:String = "west";

	    /**
	     * Specifies the horizontal center of a component's bounding rectangle.
	     *
	     * @since 1.6
	     */
	    public static const HORIZONTAL_CENTER:String = "horizontalCenter";

	    /**
	     * Specifies the vertical center of a component's bounding rectangle.
	     *
	     * @since 1.6
	     */
	    public static const VERTICAL_CENTER:String = "verticalCenter";

	    /**
	     * Specifies the baseline of a component.
	     *
	     * @since 1.6
	     */
	    public static const BASELINE:String = "baseline";

	    /**
	     * Specifies the width of a component's bounding rectangle.
	     *
	     * @since 1.6
	     */
	    public static const WIDTH:String = "width";

	    /**
	     * Specifies the height of a component's bounding rectangle.
	     *
	     * @since 1.6
	     */
	    public static const HEIGHT:String = "height";





	    /**
	     * Constructs a new <code>SpringLayout</code>.
	     */
	    public function SpringLayout()
		{
		}


		private function resetCyclicStatuses():void
		{
	        cyclicSprings = new Set();
	        acyclicSprings = new Set();
	    }

	    private function setParent(p:DisplayObjectContainer):void
		{
	        resetCyclicStatuses();
	        var pc:SpringLayoutConstraints = getConstraints(p);

	        pc.setX(Spring.constant(0));
	        pc.setY(Spring.constant(0));
	        // The applyDefaults() method automatically adds width and
	        // height springs that delegate their calculations to the
	        // getMinimumSize(), getPreferredSize() and getMaximumSize()
	        // methods of the relevant component. In the case of the
	        // parent this will cause an infinite loop since these
	        // methods, in turn, delegate their calculations to the
	        // layout manager. Check for this case and replace the
	        // the springs that would cause this problem with a
	        // constant springs that supply default values.
	        var width:Spring = pc.getWidth();
	        if (width is WidthSpring && (WidthSpring(width).c == p)) {
	            pc.setWidth(Spring.constant(0, 0, int.MAX_VALUE));
	        }
	        var height:Spring = pc.getHeight();
	        if (height is HeightSpring && (HeightSpring(height).c == p)) {
	            pc.setHeight(Spring.constant(0, 0, int.MAX_VALUE));
	        }
	    }

	    internal function isCyclic(s:Spring):Boolean
		{
// FIXME: This is not giving the corrent result. Always says spring is cyclic!
return false;
	        if (s == null) {
	            return false;
	        }
	        if (cyclicSprings.containsItem(s)) {
	            return true;
	        }
	        if (acyclicSprings.containsItem(s)) {
	            return false;
	        }

	        cyclicSprings.addItem(s);
	        var result:Boolean = s.isCyclic(this);
	        if (!result) {
	            acyclicSprings.addItem(s);
	            cyclicSprings.removeItem(s);
	        }
	        else {
	            throw new Error(s + " is cyclic. ");
	        }

	        return result;
	    }


	    private function abandonCycles(s:Spring):Spring
		{
	        return isCyclic(s) ? cyclicReference : s;
	    }













	    // LayoutManager methods.


	    /**
	     * Removes the constraints associated with the specified component.
	     *
	     * @param c the component being removed from the container
	     */
	    public function removeLayoutComponent(c:DisplayObject):void
		{
	        componentConstraints.remove(c);
	    }

	    
		private static function addInsets(width:Number, height:Number, p:DisplayObjectContainer):Rectangle
		{
//!
	        /*var i:Insets = p.getInsets();
	        return new Rectangle(0, 0, width + i.left + i.right, height + i.top + i.bottom);*/
return new Rectangle(0, 0, width, height);
	    }


	    public function minimumLayoutSize(parent:DisplayObjectContainer):Rectangle
		{
	        setParent(parent);
	        var pc:SpringLayoutConstraints = getConstraints(parent);
	        return addInsets(abandonCycles(pc.getWidth()).getMinimumValue(),
	                         abandonCycles(pc.getHeight()).getMinimumValue(),
	                         parent);
	    }

	    public function preferredLayoutSize(parent:DisplayObjectContainer):Rectangle
		{
	        setParent(parent);
	        var pc:SpringLayoutConstraints = getConstraints(parent);
	        return addInsets(abandonCycles(pc.getWidth()).getPreferredValue(),
	                         abandonCycles(pc.getHeight()).getPreferredValue(),
	                         parent);
	    }
















	    // LayoutManager2 methods.

	    public function maximumLayoutSize(parent:DisplayObjectContainer):Rectangle
		{
	        setParent(parent);
	        var pc:SpringLayoutConstraints = getConstraints(parent);
	        return addInsets(abandonCycles(pc.getWidth()).getMaximumValue(),
	                         abandonCycles(pc.getHeight()).getMaximumValue(),
	                         parent);
	    }


	    /**
	     * If <code>constraints</code> is an instance of
	     * <code>SpringLayout.Constraints</code>,
	     * associates the constraints with the specified component.
	     * <p>
	     * @param   component the component being added
	     * @param   constraints the component's constraints
	     *
	     * @see SpringLayout.Constraints
	     */
	    public function addLayoutComponent(component:DisplayObject, constraints:Object):void
		{
	        if (constraints is SpringLayoutConstraints)
			{
	            putConstraints(component, SpringLayoutConstraints(constraints));
	        }
	    }



	    /**
	     * Returns 0.5f (centered).
	     */
	    public function getLayoutAlignmentX(p:DisplayObjectContainer):Number
		{
			return 0.5;
//!	        return 0.5f;
	    }

	    /**
	     * Returns 0.5f (centered).
	     */
	    public function getLayoutAlignmentY(p:DisplayObjectContainer):Number
		{
//!	        return 0.5f;
			return 0.5;
	    }



	    public function invalidateLayout(p:DisplayObjectContainer):void
		{
		}













		public function putConstraint(...args:Array):void
		{
			if (args.length == 3)
			{
				this.putConstraint3.apply(null, args);
			}
			else if (args.length == 5)
			{
				if (args[4] is Spring)
					this.putConstraint5b.apply(null, args);
				else if (args[4] is Number)
					this.putConstraint5a.apply(null, args);
				else
					throw new ArgumentError();
			}
			else
			{
				throw new ArgumentError();
			}
		}




	   /**
	     * Links edge <code>e1</code> of component <code>c1</code> to
	     * edge <code>e2</code> of component <code>c2</code>,
	     * with a fixed distance between the edges. This
	     * constraint will cause the assignment
	     * <pre>
	     *     value(e1, c1) = value(e2, c2) + pad</pre>
	     * to take place during all subsequent layout operations.
	     * <p>
	     * @param   e1 the edge of the dependent
	     * @param   c1 the component of the dependent
	     * @param   pad the fixed distance between dependent and anchor
	     * @param   e2 the edge of the anchor
	     * @param   c2 the component of the anchor
	     *
	     * @see #putConstraint(String, Component, Spring, String, Component)
	     */
	    private function putConstraint5a(e1:String, c1:DisplayObject, e2:String, c2:DisplayObject, pad:Number):void
		{
	        putConstraint(e1, c1, e2, c2, Spring.constant(pad));
	    }




	    /**
	     * Links edge <code>e1</code> of component <code>c1</code> to
	     * edge <code>e2</code> of component <code>c2</code>. As edge
	     * <code>(e2, c2)</code> changes value, edge <code>(e1, c1)</code> will
	     * be calculated by taking the (spring) sum of <code>(e2, c2)</code>
	     * and <code>s</code>.
	     * Each edge must have one of the following values:
	     * <code>SpringLayout.NORTH</code>,
	     * <code>SpringLayout.SOUTH</code>,
	     * <code>SpringLayout.EAST</code>,
	     * <code>SpringLayout.WEST</code>,
	     * <code>SpringLayout.VERTICAL_CENTER</code>,
	     * <code>SpringLayout.HORIZONTAL_CENTER</code> or
	     * <code>SpringLayout.BASELINE</code>.
	     * <p>
	     * @param   e1 the edge of the dependent
	     * @param   c1 the component of the dependent
	     * @param   s the spring linking dependent and anchor
	     * @param   e2 the edge of the anchor
	     * @param   c2 the component of the anchor
	     *
	     * @see #putConstraint(String, Component, int, String, Component)
	     * @see #NORTH
	     * @see #SOUTH
	     * @see #EAST
	     * @see #WEST
	     * @see #VERTICAL_CENTER
	     * @see #HORIZONTAL_CENTER
	     * @see #BASELINE
	     */
	    private function putConstraint5b(e1:String, c1:DisplayObject, e2:String, c2:DisplayObject, s:Spring):void
		{
	        putConstraint(e1, c1, Spring.sum(s, getConstraint(e2, c2)));
	    }


	    private function putConstraint3(e:String, c:DisplayObject, s:Spring):void
		{
	        if (s != null) {
	            getConstraints(c).setConstraint(e, s);
	        }
	     }


		private function applyDefaults(...args:Array):SpringLayoutConstraints
		{
			var result:SpringLayoutConstraints;
			if (args.length == 2)
				result = this.applyDefaults2.apply(null, args);
			else if (args.length == 6)
				this.applyDefaults6.apply(null, args);
			else
				throw new ArgumentError();
				
			return result;
		}

	    private function applyDefaults2(c:DisplayObject, constraints:SpringLayoutConstraints):SpringLayoutConstraints {
	        if (constraints == null) {
	            constraints = new SpringLayoutConstraints();
	        }
	        if (constraints.c == null) {
	            constraints.c = c;
	        }
	        if (constraints.horizontalHistory.length < 2) {
	            applyDefaults(constraints, WEST, Spring.constant(0), WIDTH,
	                          Spring.width(c), constraints.horizontalHistory);
	        }
	        if (constraints.verticalHistory.length < 2) {
	            applyDefaults(constraints, NORTH, Spring.constant(0), HEIGHT,
	                          Spring.height(c), constraints.verticalHistory);
	        }
	        return constraints;
	    }



	    private function applyDefaults6(constraints:SpringLayoutConstraints, name1:String,
	                               spring1:Spring, name2:String, spring2:Spring,
	                               history:IList):void {
	        if (history.length == 0) {
	            constraints.setConstraint(name1, spring1);
	            constraints.setConstraint(name2, spring2);
	        } else {
	            // At this point there must be exactly one constraint defined already.
	            // Check width/height first.
	            if (constraints.getConstraint(name2) == null) {
	                constraints.setConstraint(name2, spring2);
	            } else {
	                // If width/height is already defined, install a default for x/y.
	                constraints.setConstraint(name1, spring1);
	            }
	            // Either way, leave the user's constraint topmost on the stack.
//!	            Collections.rotate(history, 1);
var obj:Object = history.removeItemAt(history.length - 1);
history.addItemAt(obj, 0);
	        }
	    }




	    private function putConstraints(component:DisplayObject, constraints:SpringLayoutConstraints):void
		{
	        componentConstraints[component] = applyDefaults(component, constraints);
	    }

	    /**
	     * Returns the constraints for the specified component.
	     * Note that,
	     * unlike the <code>GridBagLayout</code>
	     * <code>getConstraints</code> method,
	     * this method does not clone constraints.
	     * If no constraints
	     * have been associated with this component,
	     * this method
	     * returns a default constraints object positioned at
	     * 0,0 relative to the parent's Insets and its width/height
	     * constrained to the minimum, maximum, and preferred sizes of the
	     * component. The size characteristics
	     * are not frozen at the time this method is called;
	     * instead this method returns a constraints object
	     * whose characteristics track the characteristics
	     * of the component as they change.
	     *
	     * @param       c the component whose constraints will be returned
	     *
	     * @return      the constraints for the specified component
	     */
	    public function getConstraints(c:DisplayObject):SpringLayoutConstraints
		{
	       var result:SpringLayoutConstraints = componentConstraints[c];
	       if (result == null) {
//!
/*
	           if (c is JComponent) {
	                var cp:Object = JComponent(c).getClientProperty(SpringLayout["class"]);
	                if (cp is SpringLayoutConstraints) {
	                    return applyDefaults(c, SpringLayoutConstraints(cp));
	                }
	            }
*/
	            result = new SpringLayoutConstraints();
	            putConstraints(c, result);
	       }
	       return result;
	    }

	    /**
	     * Returns the spring controlling the distance between
	     * the specified edge of
	     * the component and the top or left edge of its parent. This
	     * method, instead of returning the current binding for the
	     * edge, returns a proxy that tracks the characteristics
	     * of the edge even if the edge is subsequently rebound.
	     * Proxies are intended to be used in builder envonments
	     * where it is useful to allow the user to define the
	     * constraints for a layout in any order. Proxies do, however,
	     * provide the means to create cyclic dependencies amongst
	     * the constraints of a layout. Such cycles are detected
	     * internally by <code>SpringLayout</code> so that
	     * the layout operation always terminates.
	     *
	     * @param edgeName must be one of
	     * <code>SpringLayout.NORTH</code>,
	     * <code>SpringLayout.SOUTH</code>,
	     * <code>SpringLayout.EAST</code>,
	     * <code>SpringLayout.WEST</code>,
	     * <code>SpringLayout.VERTICAL_CENTER</code>,
	     * <code>SpringLayout.HORIZONTAL_CENTER</code> or
	     * <code>SpringLayout.BASELINE</code>
	     * @param c the component whose edge spring is desired
	     *
	     * @return a proxy for the spring controlling the distance between the
	     *         specified edge and the top or left edge of its parent
	     *
	     * @see #NORTH
	     * @see #SOUTH
	     * @see #EAST
	     * @see #WEST
	     * @see #VERTICAL_CENTER
	     * @see #HORIZONTAL_CENTER
	     * @see #BASELINE
	     */
	    public function getConstraint(edgeName:String, c:DisplayObject):Spring
		{
	        // The interning here is unnecessary; it was added for efficiency.
	        return new SpringProxy(edgeName, c, this);
	    }


	    public function layoutContainer(parent:DisplayObjectContainer):void {
			var i:int;
	        setParent(parent);

	        var n:int = parent.numChildren;
	        getConstraints(parent).reset();
	        for (i = 0 ; i < n ; i++) {
	            getConstraints(parent.getChildAt(i)).reset();
	        }
// TODO: Actually use insets (or content area) rectangle.
//!	        var insets:Rectangle = parent.getInsets();
	        var insets:Rectangle = new Rectangle();
	        var pc:SpringLayoutConstraints = getConstraints(parent);
	        abandonCycles(pc.getX()).setValue(0);
	        abandonCycles(pc.getY()).setValue(0);
	        abandonCycles(pc.getWidth()).setValue(parent.width -
	                                              insets.left - insets.right);
	        abandonCycles(pc.getHeight()).setValue(parent.height -
	                                               insets.top - insets.bottom);

	        for (i = 0 ; i < n ; i++) {
	            var c:DisplayObject = parent.getChildAt(i);
	            var cc:SpringLayoutConstraints = getConstraints(c);
	            var x:Number = abandonCycles(cc.getX()).getValue();
	            var y:Number = abandonCycles(cc.getY()).getValue();
	            var width:Number = abandonCycles(cc.getWidth()).getValue();
	            var height:Number = abandonCycles(cc.getHeight()).getValue();
//!	            c.setBounds(insets.left + x, insets.top + y, width, height);
c.x = insets.left + x;
c.y = insets.top + y;
c.width = width;
c.height = height;
	        }
	    }
	}



	
}