package
{
	import Book;
	import flash.display.Sprite;
	import inky.framework.db.*;


	public class ActiveRecordTest extends Sprite
	{
		public function ActiveRecordTest()
		{
			var myBook:ActiveRecord;
			
			// Create a new ActiveRecord
			myBook = new Book();
			myBook.title = "It Came From Outer Space!";
			myBook.save();
			
			// Update an ActiveRecord
			myBook = new Book();
			myBook.id = 1;
			myBook.title = "The Little Engine That Could";
			myBook.save();

/*
			// Update an ActiveRecord based on current value.
			myBook = new Book();
			var token:AsyncToken = new ASyncToken();
			token.result = function(info:Object):void
			{
				var myBook:Book = ???;
				myBook.title = myBook.title + "!";
				myBook.save();
			}
			myBook.load({id: 1}, token);
			
			// Update an ActiveRecord based on current value (alt).			
			myBook = new Book();
			new ActionSequence(
				new FAction(myBook.load, {id: 1}, myBook, "complete"),
				function():void {
					var myBook:Book = ???;
					myBook.title = myBook.title + "!";
				},
				myBook.save
			).start();
*/
		}


	}
}