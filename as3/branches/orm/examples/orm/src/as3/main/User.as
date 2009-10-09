package
{
	import inky.orm.*;


	/**
	 *
	 *  ..
	 *	
	 * 	@langversion ActionScript 3
	 *	@playerversion Flash 9.0.0
	 *
	 *	@author matthew
	 *	@since  2009.09.29
	 *
	 */
	dynamic public class User extends DomainModel
	{
//!		defineRelationship(User, Relationship.HAS_N, "comments");
//!		defineRelationship(User, Relationship.HAS_N, "friends", {className: "User", through: "friendships"});

		addProperty(User, "comments");


		/**
		 *
		 */
		public function User(firstName:String = null, lastName:String = null)
		{
			if (firstName)
				this.firstName = firstName;
			if (lastName)
				this.lastName = lastName;
		}

		
	}
}
