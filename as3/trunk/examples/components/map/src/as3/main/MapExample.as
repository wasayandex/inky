package  
{
	import flash.display.Sprite;
	import inky.components.map.model.deserializers.KMLDeserializer;

	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author Matthew Tretter
	 *	@since  2010.04.30
	 *
	 */
	public class MapExample extends Sprite
	{
		/**
		 * The KML. Normally this would be loaded in from an external file.
		 */
		private static const MAP_KML:XML =
			<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
			<Document>
				<name>Alexan Riverdale</name>
				<Folder id="shopping &amp; entertainment">
					<name>Shopping &amp; Entertainment</name>

					<Placemark>
						<name>Meadows Golf Club</name>
						<Point>
							<coordinates>-74.283112,40.907288,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>North Jersey Country Club Inc</name>
						<description><![CDATA[594 Hamburg Turnpike<br />Wayne, NJ 07470<br /><a href="/maps?f=q&amp;source=s_q&amp;hl=en&amp;geocode=&amp;q=594+Hamburg+Turnpike,+Wayne,+NJ+07470-2091+%28North+Jersey+Country+Club+Inc%29&amp;vps=5&amp;jsv=192a&amp;sll=40.963826,-74.266548&amp;sspn=0.110959,0.269165&amp;ie=UTF8&amp;ei=0JUYS_KOLIO6yATx95i1Dg&amp;sig2=blIVqKcqf6NenmNA8mZE7Q&amp;dtab=5"></a>]]></description>
						<Point>
							<coordinates>-74.21573600000001,40.961105,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>High Mountain Golf Club</name>
						<Point>
							<!-- <coordinates>-74.197777,40.987888,0</coordinates> -->
							<coordinates>-74.197777,40.969888,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Sunset Valley Golf Course</name>
						<Point>
							<coordinates>-74.32531,40.961399,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>NJ Equestrian Center</name>
						<description><![CDATA[Pequannock Township, NJ 07444<br />]]></description>
						<Point>
							<coordinates>-74.288872,40.975979,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Clearview Kinnelon Cinema</name>
						<description><![CDATA[<div dir="ltr">25 Kinnelon Rd Kinnelon, NJ 07405</div>]]></description>
						<Point>
							<coordinates>-74.361282,41.002907,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Hawthorne Theater</name>
						<description><![CDATA[300 Lafayette Ave<br />Hawthorne, NJ 07506<br />]]></description>
						<Point>
							<coordinates>-74.15531900000001,40.948357,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Golden Sakura Japanese Steakhouse</name>
						<description><![CDATA[<div dir="ltr">88 Newark Pompton Turnpike<br />Riverdale, NJ 07457<br /></div>]]></description>
						<Point>
							<coordinates>-74.303825,40.988747,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Sonny&apos;s Italian Restaurant</name>
						<description><![CDATA[72 Hamburg Turnpike<br />Wayne, NJ 07470<br />]]></description>
						<Point>
							<coordinates>-74.20253,40.942871,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Rosemary and Sage</name>
						<description><![CDATA[26 Hamburg Turnpike<br />Wayne, NJ 07470<br />]]></description>
						<Point>
							<coordinates>-74.20195,40.942196,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>AMC Loews Theatres - Wayne 14</name>
						<Point>
							<coordinates>-74.25102200000001,40.888618,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Riverdale Food Store</name>
						<description><![CDATA[41 Hamburg Turnpike<br />Wayne, NJ 07470<br />]]></description>
						<Point>
							<coordinates>-74.202202,40.942429,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Petco</name>
						<description><![CDATA[<br />]]></description>
						<Point>
							<coordinates>-74.356499,41.001217,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Riverdale Plaza</name>
						<description><![CDATA[<div dir="ltr">110 State Rte. 23<br />Riverdale, NJ 07457<br /></div>]]></description>
						<Point>
							<coordinates>-74.323921,40.988701,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Curly&apos;s Ice Cream &amp; Frozen Desserts</name>
						<description><![CDATA[30 New Jersey 23<br />Riverdale, NJ 07457<br />]]></description>
						<Point>
							<coordinates>-74.303055,40.984467,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Target</name>
						<description><![CDATA[<br />]]></description>
						<Point>
							<coordinates>-74.324715,40.987736,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Willowbrook Mall</name>
						<Point>
							<coordinates>-74.260712,40.88834,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Riverdale Square Shopping Center</name>
						<description><![CDATA[<div dir="ltr">92 Route 23 North<br />Riverdale, NJ 07457<br /></div>]]></description>
						<Point>
							<coordinates>-74.323921,40.988701,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Riverdale Crossing Shopping Center</name>
						<Point>
							<coordinates>-74.30901299999999,40.988457,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Riverdale Plaza</name>
						<Point>
							<coordinates>-74.327072,40.987885,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>shopping &amp; entertainment</value></Data></ExtendedData>
					</Placemark>

				</Folder>
				<Folder id="hotels &amp; services">
					<name>Hotels &amp; Services</name>

					<Placemark>
						<name>Saint Josephs Wayne Hospital</name>
						<description><![CDATA[224 Hamburg Turnpike<br />Wayne, NJ 07470<br />]]></description>
						<Point>
							<coordinates>-74.204758,40.945354,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>hotels &amp; services</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Ramada Inn Wayne Fairfield</name>
						<description><![CDATA[<div dir="ltr">334 Rte 46 East Service Rd</div>]]></description>
						<Point>
							<coordinates>-74.245796,40.894115,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>hotels &amp; services</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>UPS Store</name>
						<description><![CDATA[55 Wanaque Ave<br />Pompton Lakes, NJ 07442<br />]]></description>
						<Point>
							<coordinates>-74.293053,41.007271,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>hotels &amp; services</value></Data></ExtendedData>			
					</Placemark>

					<Placemark>
						<name>US Post Office</name>
						<description><![CDATA[56 Hamburg Turnpike<br />Riverdale, NJ 07457<br />]]></description>
						<Point>
							<coordinates>-74.3032,40.99865,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>hotels &amp; services</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Alexan Riverdale</name>
						<description><![CDATA[6000 Riverdale Road<br />Riverdale, NJ 07457<br /><a href="/maps?f=q&amp;source=s_q&amp;hl=en&amp;geocode=&amp;q=6000+Riverdale+Road,+Riverdale,+NJ&amp;vps=1&amp;jsv=192a&amp;sll=40.898982,-74.264832&amp;sspn=0.223175,0.584335&amp;ie=UTF8&amp;ei=kt8XS6T0JJXwNJLmzZYB&amp;sig2=GLDj71JJFf2cRSE5tI8inQ&amp;dtab=5"></a>]]></description>
						<Point>
							<coordinates>-74.297325,40.987568,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>hotels &amp; services</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>A &amp; P Food Store</name>
						<description><![CDATA[<div dir="ltr">500 State Rt 23 <br />Pompton Plains, NJ 07444-1853</div>]]></description>
						<Point>
							<coordinates>-74.283157,40.967857,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>hotels &amp; services</value></Data></ExtendedData>			
					</Placemark>

				</Folder>
				<Folder id="transportation">
					<name>Transportation</name>

					<Placemark>
						<name>NJ Transit</name>
						<Point>
							<coordinates>-74.253502,40.889252,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>transportation</value></Data></ExtendedData>
					</Placemark>

				</Folder>
				<Folder id="culture">
					<name>Landmarks/Culture</name>

					<Placemark>
						<name>Ramapo Valley Reservation</name>
						<Point>
							<coordinates>-74.203506,41.095417,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>culture</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Wanaque Reservoir</name>
						<description><![CDATA[New Jersey<br />]]></description>
						<Point>
							<coordinates>-74.297157,41.058064,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>culture</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Mountainside Park</name>
						<Point>
							<coordinates>-74.323967,40.976917,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>culture</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Icehouse Pottery</name>
						<description><![CDATA[3 Paterson-Hamburg Turnpike<br />Pompton Lakes, NJ 07442<br />]]></description>
						<Point>
							<coordinates>-74.297668,40.999077,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>culture</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Riverdale Art Center</name>
						<description><![CDATA[<div dir="ltr">2 Newark Pompton Turnpike<br />Pequannock, NJ 07440<br /></div>]]></description>
						<Point>
							<coordinates>-74.28016700000001,40.944485,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>culture</value></Data></ExtendedData>
					</Placemark>

					<Placemark>
						<name>Riverdale Library</name>
						<description><![CDATA[93 Newark Pompton Turnpike<br />Wayne, NJ 07470<br />]]></description>
						<Point>
							<coordinates>-74.27273599999999,40.926975,0</coordinates>
						</Point>
						<ExtendedData><Data name="category"><value>culture</value></Data></ExtendedData>
					</Placemark>

				</Folder>

				<GroundOverlay>
					<name>Alexan Riverdale Map Overlay</name>
					<Icon>
						<!-- Tell the component to use the MapOverlay class. -->
						<href>lib://MapOverlay</href>
					</Icon>
					<LatLonBox>
						<north>41.10117284777638</north>
						<south>40.80128317673854</south>
						<east>-74.08232101194581</east>
						<west>-74.43751483468741</west>
					</LatLonBox>
				</GroundOverlay>

			</Document>
			</kml>
			
		/**
		 *
		 */
		public function MapExample()
		{
			this.map.model = new KMLDeserializer().deserialize(MAP_KML)
		}
	
	}
	
}