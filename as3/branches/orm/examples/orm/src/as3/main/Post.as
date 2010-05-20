package  
{
	import inky.orm.DataMapperResource;
	import inky.orm.inspection.XMLTypeInspector;
	import inky.orm.inspection.ITypeInspector;
	import inky.orm.relationships.RelationshipType;
	
	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2010.05.19
	 *
	 */
	public class Post extends DataMapperResource
	{
		private static const XML_CONFIG:XML =
			<type>
				<property name="id" />
				<property name="title" />
				<property name="body" />
				<property name="creationTime" type="Date" />

				<property name="comments" has="n"
				<relationship type={RelationshipType.HAS_N} 

				<belongsTo SOMETHING="category" />
				<belongs to="post" />
			</type>

/*
		class Post
			include DataMapper::Resource

			property :id,         Serial   # An auto-increment integer key
			property :title,      String   # A varchar type string, for short strings
			property :body,       Text     # A text block, for longer string data.
			property :created_at, DateTime # A DateTime, for any date you might like.

			has n, :comments
			has n, :categorizations
			has n, :categories, :through => :categorizations

		end
*/

		//---------------------------------------
		// PROTECTED METHODS
		//---------------------------------------

		/**
		 * @inheritDoc
		 */
		override protected function _createTypeInspector():ITypeInspector
		{
			return new XMLTypeInspector(XML_CONFIG);
		}
		
	}
	
}
