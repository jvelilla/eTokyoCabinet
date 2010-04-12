note
	description: "Summary description for {PERSON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PERSON
create
	make
feature -- Initialization
	make (a_first_name : STRING; a_last_name : STRING)
		do
			first_name := a_first_name
			last_name := a_last_name
		end
feature -- Access
	first_name : STRING
	last_name  : STRING

feature -- Element Change

	set_first_name ( a_name : STRING)
		do
			first_name := a_name
		end

	set_last_name ( a_name : STRING)
		do
			first_name := a_name
		end


end
