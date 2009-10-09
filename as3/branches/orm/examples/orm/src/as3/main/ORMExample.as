package 
{
	import Comment;
	import User;
	import flash.display.Sprite;
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
	public class ORMExample extends Sprite
	{
		/**
		 *	
		 */
		public function ORMExample()
		{
			var db:Repository = new Repository(
				<db>
					<comment id="0" body="Lorem ipsum dolor sit amet." authorId="1" />
					<comment id="1" body="Consectetur adipisicing elit." authorId="5" />
					<comment id="2" body="Sed do eiusmod tempor incididunt ut labore" authorId="4" />
					<comment id="3" body="Et dolore magna aliqua." authorId="0" />
					<comment id="4" body="Ut enim ad minim veniam, quis." authorId="2" />
					<comment id="5" body="Nostrud exercitation ullamco laboris." authorId="3" />

					<user id="1" firstName="Roald" lastName="Dahl" />
					<user id="5" firstName="Jack" lastName="Kerouac" />
					<user id="4" firstName="J. D." lastName="Salinger" />
					<user id="0" firstName="God" lastName="" />
					<user id="2" firstName="Beverly" lastName="Cleary" />
					<user id="3" firstName="Brad" lastName="Gooch" />
				</db>
			);

			var commentMapper:DataMapper = new DataMapper(db);
			var myComment:Comment;

			// Create a new book.
			myComment = new Comment();
			myComment.id = "6";
			myComment.body = "ORM is rad!";
			myComment.author = new User("Matthew", "Tretter");
			myComment.save();

			// Test the getter.
			myComment.user;

return;
db.dump();


/*			
			// Update an existing book.
			book = new Book();
			book.id = 1;
			book.title = "The Little Engine That Could";
			bookMapper.save(book);
*/

/*
			// Update an ActiveRecord based on current value.
			book = new Book();
			var token:AsyncToken = new ASyncToken();
			token.result = function(info:Object):void
			{
				var book:Book = ???;
				book.title = book.title + "!";
				book.save();
			}
			book.load({id: 1}, token);

			// Update an ActiveRecord based on current value (alt).			
			book = new Book();
			new ActionSequence(
				new FAction(book.load, {id: 1}, book, "complete"),
				function():void {
					var book:Book = ???;
					book.title = book.title + "!";
				},
				book.save
			).start();
*/
		}




	}
}
