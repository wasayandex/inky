﻿package inky.layout.layouts.springLayout
{
		import inky.collections.IList;
		import inky.collections.ArrayList;
		import flash.display.DisplayObject;
		import flash.geom.Rectangle;
		import inky.layout.utils.LayoutUtil;
		import inky.layout.utils.LayoutUtil;

	    /**
	     * A <code>Constraints</code> object holds the
	     * constraints that govern the way a component's size and position
	     * change in a container controlled by a <code>SpringLayout</code>.
	     * A <code>Constraints</code> object is
	     * like a <code>Rectangle</code>, in that it
	     * has <code>x</code>, <code>y</code>,
	     * <code>width</code>, and <code>height</code> properties.
	     * In the <code>Constraints</code> object, however,
	     * these properties have
	     * <code>Spring</code> values instead of integers.
	     * In addition,
	     * a <code>Constraints</code> object
	     * can be manipulated as four edges
	     * -- north, south, east, and west --
	     * using the <code>constraint</code> property.
	     *
	     * <p>
	     * The following formulas are always true
	     * for a <code>Constraints</code> object (here WEST and <code>x</code> are synonyms, as are and NORTH and <code>y</code>):
	     *
	     * <pre>
	     *               EAST = WEST + WIDTH
	     *              SOUTH = NORTH + HEIGHT
	     *  HORIZONTAL_CENTER = WEST + WIDTH/2
	     *    VERTICAL_CENTER = NORTH + HEIGHT/2
	     *  ABSOLUTE_BASELINE = NORTH + RELATIVE_BASELINE*
	     * </pre>
	     * <p>
	     * For example, if you have specified the WIDTH and WEST (X) location
	     * the EAST is calculated as WEST + WIDTH.  If you instead specified
	     * the WIDTH and EAST locations the WEST (X) location is then calculated
	     * as EAST - WIDTH.
	     * <p>
	     * [RELATIVE_BASELINE is a private constraint that is set automatically when
	     * the SpringLayout.Constraints(Component) constuctor is called or when
	     * a constraints object is registered with a SpringLayout object.]
	     * <p>
	     * <b>Note</b>: In this document,
	     * operators represent methods
	     * in the <code>Spring</code> class.
	     * For example, "a + b" is equal to
	     * <code>Spring.sum(a, b)</code>,
	     * and "a - b" is equal to
	     * <code>Spring.sum(a, Spring.minus(b))</code>.
	     * See the
	     * {@link Spring <code>Spring</code> API documentation}
	     * for further details
	     * of spring arithmetic.
	     *
	     * <p>
	     *
	     * Because a <code>Constraints</code> object's properties --
	     * representing its edges, size, and location -- can all be set
	     * independently and yet are interrelated,
	     * a <code>Constraints</code> object can become <em>over-constrained</em>.
	     * For example, if the <code>WEST</code>, <code>WIDTH</code> and
	     * <code>EAST</code> edges are all set, steps must be taken to ensure that
	     * the first of the formulas above holds.  To do this, the
	     * <code>Constraints</code>
	     * object throws away the <em>least recently set</em>
	     * constraint so as to make the formulas hold.
	     * @since 1.4
	     */
		public class SpringLayoutConstraints
		{
			private var x:Spring;
			private var y:Spring;
			private var width:Spring;
			private var height:Spring;
			private var east:Spring;
			private var south:Spring;
			private var horizontalCenter:Spring;
			private var verticalCenter:Spring;
			private var baseline:Spring;

			internal var horizontalHistory:IList = new ArrayList();
			internal var verticalHistory:IList = new ArrayList();

		    private static var ALL_HORIZONTAL:Array = [SpringLayout.WEST, SpringLayout.WIDTH, SpringLayout.EAST, SpringLayout.HORIZONTAL_CENTER];
		    private static var ALL_VERTICAL:Array = [SpringLayout.NORTH, SpringLayout.HEIGHT, SpringLayout.SOUTH, SpringLayout.VERTICAL_CENTER, SpringLayout.BASELINE];
		
private static const CONSTANT_DESCENT:String = "constantDescent";
private static const CENTER_OFFSET:String = "centerOffset";
private static const CONSTANT_ASCENT:String = "constantAscent";

			// Used for baseline calculations
			internal var c:DisplayObject;


	       /**
	        * Creates a <code>Constraints</code> object with the
	        * specified values for its
	        * <code>x</code>, <code>y</code>, <code>width</code>,
	        * and <code>height</code> properties.
	        * Note: If the <code>SpringLayout</code> class
	        * encounters <code>null</code> values in the
	        * <code>Constraints</code> object of a given component,
	        * it replaces them with suitable defaults.
	        *
	        * @param x  the spring value for the <code>x</code> property
	        * @param y  the spring value for the <code>y</code> property
	        * @param width  the spring value for the <code>width</code> property
	        * @param height  the spring value for the <code>height</code> property
	        */
	       	public function SpringLayoutConstraints(x:Spring = null, y:Spring = null, width:Spring = null, height:Spring = null)
			{
				if (x)
	           		setX(x);
				if (y)
	           		setY(y);
				if (width)
					setWidth(width);
				if (height)
					setHeight(height);
			}

	        /**
	         * Creates a <code>Constraints</code> object with
	         * suitable <code>x</code>, <code>y</code>, <code>width</code> and
	         * <code>height</code> springs for component, <code>c</code>.
	         * The <code>x</code> and <code>y</code> springs are constant
	         * springs  initialised with the component's location at
	         * the time this method is called. The <code>width</code> and
	         * <code>height</code> springs are special springs, created by
	         * the <code>Spring.width()</code> and <code>Spring.height()</code>
	         * methods, which track the size characteristics of the component
	         * when they change.
	         *
	         * @param c  the component whose characteristics will be reflected by this Constraints object
	         * @throws NullPointerException if <code>c</code> is null.
	         * @since 1.5
	         */
//!
	        /*public function SpringLayoutConstraints(c:DisplayObject)
			{
	            this.c = c;
	            setX(Spring.constant(c.getX()));
	            setY(Spring.constant(c.getY()));
	            setWidth(Spring.width(c));
	            setHeight(Spring.height(c));
	        }*/

	        private function pushConstraint(name:String, value:Spring, horizontal:Boolean):void {
	            var valid:Boolean = true;
	            var history:IList = horizontal ? horizontalHistory :
	                                                verticalHistory;
	            if (history.containsItem(name)) {
	                history.removeItem(name);
	                valid = false;
	            } else if (history.length == 2 && value != null) {
	                history.removeItemAt(0);
	                valid = false;
	            }
	            if (value != null) {
	                history.addItem(name);
	            }
	            if (!valid) {
	                var all:Array = horizontal ? ALL_HORIZONTAL : ALL_VERTICAL;
//!	                for (String s : all) {
	                for each (var s:String in all) {
	                    if (!history.containsItem(s)) {
	                        setConstraint(s, null);
	                    }
	                }
	            }
	        }

	       private function sum(s1:Spring, s2:Spring):Spring {
	           return (s1 == null || s2 == null) ? null : Spring.sum(s1, s2);
	       }

	       private function difference(s1:Spring, s2:Spring):Spring {
	           return (s1 == null || s2 == null) ? null : Spring.difference(s1, s2);
	       }

	        private function scale(s:Spring, factor:Number):Spring {
	            return (s == null) ? null : Spring.scale(s, factor);
	        }

	        private function getBaselineFromHeight(height:Number):Number {
	            if (height < 0) {
	                // Bad Scott, Bad Scott!
	                return -this.getComponentBaseline(c, LayoutUtil.getPreferredSize(c).width,
	                                      -height);
	            }
	            return this.getComponentBaseline(c, LayoutUtil.getPreferredSize(c).width, height);
	        }

	        private function getHeightFromBaseLine(baseline:Number):Number {
	            var prefSize:Rectangle = LayoutUtil.getPreferredSize(c);
	            var prefHeight:Number = prefSize.height;
	            var prefBaseline:Number = this.getComponentBaseline(c, prefSize.width, prefHeight);
	            if (prefBaseline == baseline) {
	                // If prefBaseline < 0, then no baseline, assume preferred
	                // height.
	                // If prefBaseline == baseline, then specified baseline
	                // matches preferred baseline, return preferred height
	                return prefHeight;
	            }
	            // Valid baseline
	            switch (this.getComponentBaselineResizeBehavior(c)) {
	            case CONSTANT_DESCENT:
	                return prefHeight + (baseline - prefBaseline);
	            case CENTER_OFFSET:
	                return prefHeight + 2 * (baseline - prefBaseline);
	            case CONSTANT_ASCENT:
	                // Component baseline and specified baseline will NEVER
	                // match, fall through to default
	            default: // OTHER
	                // No way to map from baseline to height.
	            }
	            return int.MIN_VALUE;
	        }

	         private function heightToRelativeBaseline(s:Spring):Spring {
//!
throw new Error();
return null;
	            /*return new Spring.SpringMap(s) {
	                 protected int map(int i) {
	                    return getBaselineFromHeight(i);
	                 }

	                 protected int inv(int i) {
	                     return getHeightFromBaseLine(i);
	                 }
	            };*/
	        }

	        private function relativeBaselineToHeight(s:Spring):Spring {
	            /*return new Spring.SpringMap(s) {
	                protected int map(int i) {
	                    return getHeightFromBaseLine(i);
	                 }

	                 protected int inv(int i) {
	                    return getBaselineFromHeight(i);
	                 }
	            };*/
//!
throw new Error();
return null;
	        }

	        private function defined(history:IList, s1:String, s2:String):Boolean {
	            return history.containsItem(s1) && history.containsItem(s2);
	        }

	       /**
	        * Sets the <code>x</code> property,
	        * which controls the <code>x</code> value
	        * of a component's location.
	        *
	        * @param x the spring controlling the <code>x</code> value
	        *          of a component's location
	        *
	        * @see #getX
	        * @see SpringLayout.Constraints
	        */
	       public function setX(x:Spring):void {
	           this.x = x;
	           pushConstraint(SpringLayout.WEST, x, true);
	       }

	       /**
	        * Returns the value of the <code>x</code> property.
	        *
	        * @return the spring controlling the <code>x</code> value
	        *         of a component's location
	        *
	        * @see #setX
	        * @see SpringLayout.Constraints
	        */
	       public function getX():Spring {
	           if (x == null) {
	               if (defined(horizontalHistory, SpringLayout.EAST, SpringLayout.WIDTH)) {
	                   x = difference(east, width);
	               } else if (defined(horizontalHistory, SpringLayout.HORIZONTAL_CENTER, SpringLayout.WIDTH)) {
	                   x = difference(horizontalCenter, scale(width, 0.5));
	               } else if (defined(horizontalHistory, SpringLayout.HORIZONTAL_CENTER, SpringLayout.EAST)) {
	                   x = difference(scale(horizontalCenter, 2), east);
	               }
	           }
	           return x;
	       }

	       /**
	        * Sets the <code>y</code> property,
	        * which controls the <code>y</code> value
	        * of a component's location.
	        *
	        * @param y the spring controlling the <code>y</code> value
	        *          of a component's location
	        *
	        * @see #getY
	        * @see SpringLayout.Constraints
	        */
	       public function setY(y:Spring):void {
	           this.y = y;
	           pushConstraint(SpringLayout.NORTH, y, false);
	       }

	       /**
	        * Returns the value of the <code>y</code> property.
	        *
	        * @return the spring controlling the <code>y</code> value
	        *         of a component's location
	        *
	        * @see #setY
	        * @see SpringLayout.Constraints
	        */
	       public function getY():Spring {
	           if (y == null) {
	               if (defined(verticalHistory, SpringLayout.SOUTH, SpringLayout.HEIGHT)) {
	                   y = difference(south, height);
	               } else if (defined(verticalHistory, SpringLayout.VERTICAL_CENTER, SpringLayout.HEIGHT)) {
	                   y = difference(verticalCenter, scale(height, 0.5));
	               } else if (defined(verticalHistory, SpringLayout.VERTICAL_CENTER, SpringLayout.SOUTH)) {
	                   y = difference(scale(verticalCenter, 2), south);
	               } else if (defined(verticalHistory, SpringLayout.BASELINE, SpringLayout.HEIGHT)) {
	                   y = difference(baseline, heightToRelativeBaseline(height));
	               } else if (defined(verticalHistory, SpringLayout.BASELINE, SpringLayout.SOUTH)) {
	                   y = scale(difference(baseline, heightToRelativeBaseline(south)), 2);
/*
	               } else if (defined(verticalHistory, BASELINE, VERTICAL_CENTER)) {
	                   y = scale(difference(baseline, heightToRelativeBaseline(scale(verticalCenter, 2))), 1f/(1-2*0.5f));
*/
	               }
	           }
	           return y;
	       }

	       /**
	        * Sets the <code>width</code> property,
	        * which controls the width of a component.
	        *
	        * @param width the spring controlling the width of this
	        * <code>Constraints</code> object
	        *
	        * @see #getWidth
	        * @see SpringLayout.Constraints
	        */
	       public function setWidth(width:Spring):void {
	           this.width = width;
	           pushConstraint(SpringLayout.WIDTH, width, true);
	       }

	       /**
	        * Returns the value of the <code>width</code> property.
	        *
	        * @return the spring controlling the width of a component
	        *
	        * @see #setWidth
	        * @see SpringLayout.Constraints
	        */
	       public function getWidth():Spring {
	           if (width == null) {
	               if (horizontalHistory.containsItem(SpringLayout.EAST)) {
	                   width = difference(east, getX());
	               } else if (horizontalHistory.containsItem(SpringLayout.HORIZONTAL_CENTER)) {
	                   width = scale(difference(horizontalCenter, getX()), 2);
	               }
	           }
	           return width;
	       }

	       /**
	        * Sets the <code>height</code> property,
	        * which controls the height of a component.
	        *
	        * @param height the spring controlling the height of this <code>Constraints</code>
	        * object
	        *
	        * @see #getHeight
	        * @see SpringLayout.Constraints
	        */
	       public function setHeight(height:Spring):void {
	           this.height = height;
	           pushConstraint(SpringLayout.HEIGHT, height, false);
	       }

	       /**
	        * Returns the value of the <code>height</code> property.
	        *
	        * @return the spring controlling the height of a component
	        *
	        * @see #setHeight
	        * @see SpringLayout.Constraints
	        */
	       public function getHeight():Spring {
	           if (height == null) {
	               if (verticalHistory.containsItem(SpringLayout.SOUTH)) {
	                   height = difference(south, getY());
	               } else if (verticalHistory.containsItem(SpringLayout.VERTICAL_CENTER)) {
	                   height = scale(difference(verticalCenter, getY()), 2);
	               } else if (verticalHistory.containsItem(SpringLayout.BASELINE)) {
	                   height = relativeBaselineToHeight(difference(baseline, getY()));
	               }
	           }
	           return height;
	       }

	       private function setEast(east:Spring):void {
	           this.east = east;
	           pushConstraint(SpringLayout.EAST, east, true);
	       }

	       private function getEast():Spring {
	           if (east == null) {
	               east = sum(getX(), getWidth());
	           }
	           return east;
	       }

	       private function setSouth(south:Spring):void {
	           this.south = south;
	           pushConstraint(SpringLayout.SOUTH, south, false);
	       }

	       private function getSouth():Spring {
	           if (south == null) {
	               south = sum(getY(), getHeight());
	           }
	           return south;
	       }

	        private function getHorizontalCenter():Spring {
	            if (horizontalCenter == null) {
	                horizontalCenter = sum(getX(), scale(getWidth(), 0.5));
	            }
	            return horizontalCenter;
	        }

	        private function setHorizontalCenter(horizontalCenter:Spring):void {
	            this.horizontalCenter = horizontalCenter;
	            pushConstraint(SpringLayout.HORIZONTAL_CENTER, horizontalCenter, true);
	        }

	        private function getVerticalCenter():Spring {
	            if (verticalCenter == null) {
	                verticalCenter = sum(getY(), scale(getHeight(), 0.5));
	            }
	            return verticalCenter;
	        }

	        private function setVerticalCenter(verticalCenter:Spring):void {
	            this.verticalCenter = verticalCenter;
	            pushConstraint(SpringLayout.VERTICAL_CENTER, verticalCenter, false);
	        }

	        private function getBaseline():Spring {
	            if (baseline == null) {
	                baseline = sum(getY(), heightToRelativeBaseline(getHeight()));
	            }
	            return baseline;
	        }

	        private function setBaseline(baseline:Spring):void {
	            this.baseline = baseline;
	            pushConstraint(SpringLayout.BASELINE, baseline, false);
	        }

	       /**
	        * Sets the spring controlling the specified edge.
	        * The edge must have one of the following values:
	        * <code>SpringLayout.NORTH</code>,
	        * <code>SpringLayout.SOUTH</code>,
	        * <code>SpringLayout.EAST</code>,
	        * <code>SpringLayout.WEST</code>,
	        * <code>SpringLayout.HORIZONTAL_CENTER</code>,
	        * <code>SpringLayout.VERTICAL_CENTER</code>,
	        * <code>SpringLayout.BASELINE</code>,
	        * <code>SpringLayout.WIDTH</code> or
	        * <code>SpringLayout.HEIGHT</code>.
	        * For any other <code>String</code> value passed as the edge,
	        * no action is taken. For a <code>null</code> edge, a
	        * <code>NullPointerException</code> is thrown.
	        *
	        * @param edgeName the edge to be set
	        * @param s the spring controlling the specified edge
	        *
	        * @throws NullPointerException if <code>edgeName</code> is <code>null</code>
	        *
	        * @see #getConstraint
	        * @see #NORTH
	        * @see #SOUTH
	        * @see #EAST
	        * @see #WEST
	        * @see #HORIZONTAL_CENTER
	        * @see #VERTICAL_CENTER
	        * @see #BASELINE
	        * @see #WIDTH
	        * @see #HEIGHT
	        * @see SpringLayout.Constraints
	        */
	       public function setConstraint(edgeName:String, s:Spring):void {
//!	           edgeName = edgeName.intern();
	           if (edgeName == SpringLayout.WEST) {
	               setX(s);
	           } else if (edgeName == SpringLayout.NORTH) {
	               setY(s);
	           } else if (edgeName == SpringLayout.EAST) {
	               setEast(s);
	           } else if (edgeName == SpringLayout.SOUTH) {
	               setSouth(s);
	           } else if (edgeName == SpringLayout.HORIZONTAL_CENTER) {
	               setHorizontalCenter(s);
	           } else if (edgeName == SpringLayout.WIDTH) {
	               setWidth(s);
	           } else if (edgeName == SpringLayout.HEIGHT) {
	               setHeight(s);
	           } else if (edgeName == SpringLayout.VERTICAL_CENTER) {
	               setVerticalCenter(s);
	           } else if (edgeName == SpringLayout.BASELINE) {
	               setBaseline(s);
	           }
	       }

	       /**
	        * Returns the value of the specified edge, which may be
	        * a derived value, or even <code>null</code>.
	        * The edge must have one of the following values:
	        * <code>SpringLayout.NORTH</code>,
	        * <code>SpringLayout.SOUTH</code>,
	        * <code>SpringLayout.EAST</code>,
	        * <code>SpringLayout.WEST</code>,
	        * <code>SpringLayout.HORIZONTAL_CENTER</code>,
	        * <code>SpringLayout.VERTICAL_CENTER</code>,
	        * <code>SpringLayout.BASELINE</code>,
	        * <code>SpringLayout.WIDTH</code> or
	        * <code>SpringLayout.HEIGHT</code>.
	        * For any other <code>String</code> value passed as the edge,
	        * <code>null</code> will be returned. Throws
	        * <code>NullPointerException</code> for a <code>null</code> edge.
	        *
	        * @param edgeName the edge whose value
	        *                 is to be returned
	        *
	        * @return the spring controlling the specified edge, may be <code>null</code>
	        *
	        * @throws NullPointerException if <code>edgeName</code> is <code>null</code>
	        *
	        * @see #setConstraint
	        * @see #NORTH
	        * @see #SOUTH
	        * @see #EAST
	        * @see #WEST
	        * @see #HORIZONTAL_CENTER
	        * @see #VERTICAL_CENTER
	        * @see #BASELINE
	        * @see #WIDTH
	        * @see #HEIGHT
	        * @see SpringLayout.Constraints
	        */
	       public function getConstraint(edgeName:String):Spring {
//!	           edgeName = edgeName.intern();
	           return (edgeName == SpringLayout.WEST)  ? getX() :
	                   (edgeName == SpringLayout.NORTH) ? getY() :
	                   (edgeName == SpringLayout.EAST)  ? getEast() :
	                   (edgeName == SpringLayout.SOUTH) ? getSouth() :
	                   (edgeName == SpringLayout.WIDTH)  ? getWidth() :
	                   (edgeName == SpringLayout.HEIGHT) ? getHeight() :
	                   (edgeName == SpringLayout.HORIZONTAL_CENTER) ? getHorizontalCenter() :
	                   (edgeName == SpringLayout.VERTICAL_CENTER)  ? getVerticalCenter() :
	                   (edgeName == SpringLayout.BASELINE) ? getBaseline() :
	                  null;
	       }

	       /*pp*/
			internal function reset():void
			{
	           var allSprings:Array = [x, y, width, height, east, south,
	               horizontalCenter, verticalCenter, baseline];
//!	           for (Spring s : allSprings) {
				for each (var s:Spring in allSprings)
				{
	               if (s != null) {
	                   s.setValue(Spring.UNSET);
	               }
	           }
	       }


//! temp fix
		private function getComponentBaseline(c:DisplayObject, width:Number, height:Number):Number
		{
			return c.height;
		}

	
		private function getComponentBaselineResizeBehavior(c:DisplayObject):String
		{
			return null;
		}


	   }
	}