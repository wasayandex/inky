on run argv
	set	snippet_code to read (POSIX file(item 1 of argv)) as «class utf8»
	tell app "TextMate" to insert snippet_code as snippet true
end run