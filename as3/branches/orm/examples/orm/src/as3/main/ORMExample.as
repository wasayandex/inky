package 
{
	import Author;
	import Book;
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
					<book id="0" title="James and the Giant Peach" author="1" />
					<book id="1" title="On The Road" author="5" />
					<book id="2" title="Nine Stories" author="4" />
					<book id="3" title="The Bible" author="0" />
					<book id="4" title="The Mouse and the Motorcycle" author="2" />
					<book id="5" title="Flannery" author="3" />

					<author id="1" firstName="Roald" lastName="Dahl" />
					<author id="5" firstName="Jack" lastName="Kerouac" />
					<author id="4" firstName="J. D." lastName="Salinger" />
					<author id="0" firstName="God" lastName="" />
					<author id="2" firstName="Beverly" lastName="Cleary" />
					<author id="3" firstName="Brad" lastName="Gooch" />
				</db>
			);

			var bookMapper:DataMapper = new DataMapper(db);
			var myBook:Book;

			// Create a new book.
			myBook = new Book();
			myBook.id = "6";
			myBook.title = "It Came From Outer Space!";
			myBook.author = new Author("Matthew", "Tretter");
			bookMapper.save(myBook);


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
