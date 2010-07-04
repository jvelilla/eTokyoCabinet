note
	description: "Summary description for {LIST_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIST_API

inherit
	TC_LIST_API

create
	make,
	make_by_pointer,
	make_by_list

feature -- Initialization
	make
		do
			list := tclistnew
		ensure
			empty_list : is_empty
		end

	make_by_pointer ( p : POINTER )
		require
			is_valid_pointer : p /= default_pointer
		do
			list := p
		ensure
			assigned_list : list = p
		end


	make_by_list ( a_list : LIST[STRING])
		do
			list := tclistnew2(a_list.count)
			a_list.do_all (agent push (?) )
		end

feature -- Access

	as_list : LIST[STRING]
			-- return a list of string
		local
			i : INTEGER
			l_result : ARRAYED_LIST[STRING]
		do

			create l_result.make (elements)
			from
				i := 1
			until
				i > elements
			loop
				l_result.force (value (i))
				i := i + 1
			end
			Result := l_result
		end

	is_empty : BOOLEAN
			-- is the list Empty?
		do
			Result := elements = 0
		end

feature -- Change Element

	set_list ( a_list : LIST[STRING])
			-- append a_list of string object to the current list
		do
			a_list.do_all (agent push (?) )
		end


feature -- Remove

	clear
			-- Clear a list object.
			-- All elements are removed.
		do
			tclistclear (list)
		ensure
			empty_list : is_empty
		end

	delete
		-- Delete a list of  objects
		-- Note that the deleted object and its derivatives can not be used anymore.
		do
			tclistdel (list)
		end
feature {NONE}-- Implementation

	elements : INTEGER
			-- Get the number of elements of a list object.
		do
			Result := tclistnum (list)
		end

	value ( i : INTEGER): STRING
			-- Get an element of a list objec
		require
			valid_index : (i >= 1 ) and (i <= elements)
		do
                Result := internal_value_string (i-1)
		end

	push ( v : STRING )
			-- Add an element at the end of a list object.
		do
	            internal_push_string (v)
        ensure
        	added_element : old elements + 1 = elements
		end


	internal_push_string ( v : STRING)
		local
			c_str : C_STRING
		do
			create c_str.make (v)
			tclistpush2 (list, c_str.item)
		end

	internal_value_string (i : INTEGER) : STRING
		local
			r : POINTER
		do
			r := tclistval2 (list, i)
			if r /= default_pointer then
				create Result.make_from_c(r)
			end
		end



	list : POINTER
		-- tc_list object


end
