note
	description: "Summary description for {LIST_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIST_API [G]

inherit
	TC_LIST_API

	TC_SERIALIZATION

create
	make,
	make_by_pointer

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

feature -- Access

	elements : INTEGER
			-- Get the number of elements of a list object.
		do
			Result := tclistnum (list)
		end

	value ( i : INTEGER): G
			-- Get an element of a list objec
		require
			valid_index : (i >= 1 ) and (i <= elements)
		local
			l_internal : INTERNAL
			class_name : STRING
		do
		    create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("LIST_API [STRING_8]") then
                Result ?= internal_value_string (i-1)
            else
            	Result ?= internal_value (i-1)
            end
		end

feature -- Change Element

	duplicate : LIST_API [G]
			-- Copy a list object.
			-- The return value is the new list object equivalent to the Current object.
		do
			Result.make_by_pointer (tclistdup (list))
		end

	push ( v : like value )
			-- Add an element at the end of a list object.
		local
			s8 : STRING
		do
			if v.conforms_to (a_string_8) then
                s8 ?= v
                internal_push_string (s8)
            else
            	internal_push (v)
            end
        ensure
        	added_element : old elements + 1 = elements
		end

	unshift ( v : like value)
		-- Add an element at the top of a list object.
		local
			s8 : STRING
		do
			if v.conforms_to (a_string_8) then
                s8 ?= v
                internal_unshift_string (s8)
            else
            	internal_unshift (v)
            end
        ensure
        	added_element : old elements + 1 = elements
		end

	insert ( v : like value ; an_index : INTEGER)
		-- Add an element `v' at the specified location `index' of a list object.
		require
			not_empty_list:  not is_empty
			valid_index : (an_index >= 1 ) and (an_index <= elements)
		local
			s8 : STRING
		do
			if v.conforms_to (a_string_8) then
                s8 ?= v
                internal_insert_string (s8, an_index - 1)
            else
            	internal_insert (v, an_index - 1)
            end
        ensure
        	added_element : old elements + 1 = elements
		end


	over ( v : like value ; an_index : INTEGER)
		-- Overwrite an element `v' at the specified location `an_index'of a list object.
		require
			not_empty_list:  not is_empty
			valid_index : (an_index >= 1 ) and (an_index <= elements)
		local
			s8 : STRING
		do
			if v.conforms_to (a_string_8) then
				s8 ?= v
                internal_over_string (s8, an_index - 1)
            else
            	internal_over (v, an_index - 1)
            end
        ensure
        	added_element : old elements = elements
		end

feature -- Status Report
	is_lexical_order : BOOLEAN
		-- is the list sorted in lexical order?

	firt_element : G
		require
			not_empty_list : not is_empty
		do
			Result := value (1)
		end

	last_element : G
		require
			not_empty_list : not is_empty
		do
			Result := value (elements)
		end

	is_empty : BOOLEAN
			-- is the list Empty?
		do
			Result := elements = 0
		end

	last_pop : G
		-- last remove element of the end of the list	

	last_shift : G
		-- last remove element of the top of the list	

	last_remove : G
		-- Last remove element at an specified location of the list

feature -- Remove

	clear
			-- Clear a list object.
			-- All elements are removed.
		do
			tclistclear (list)
		ensure
			empty_list : is_empty
		end

	pop
		-- Remove an element of the end of a list object.
		-- Store the last removed element in last_pop
		require
			not_empty_list : not is_empty
		local
			l_internal : INTERNAL
			class_name : STRING
		do
			create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("LIST_API [STRING_8]") then
                last_pop ?= internal_pop_string
            else
            	last_pop ?= internal_pop
            end
		ensure
			remove_one_element : old elements -1 = elements
		end


	shift
		-- Remove an element of the top of a list object.
		-- Store the last removed element in last_shift
		require
			not_empty_list : not is_empty
		local
			l_internal : INTERNAL
			class_name : STRING
		do
			create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("LIST_API [STRING_8]") then
                last_shift ?= internal_shift_string
            else
            	last_shift ?= internal_shift
            end
		ensure
			remove_one_element : old elements -1 = elements
		end


	remove (index : INTEGER)
		-- Remove an element at the specified location `index' of a list object.
		-- Store the last removed element in last_remove
		require
			not_empty_list : not is_empty
			valid_index : (index >= 1 ) and (index <= elements)
		local
			l_internal : INTERNAL
			class_name : STRING
		do
			create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("LIST_API [STRING_8]") then
                last_remove ?= internal_remove_string (index - 1)
            else
            	last_remove ?= internal_remove (index - 1)
            end
		ensure
			remove_one_element : old elements -1 = elements
		end


feature -- Sort
	sort
			-- Sort elements of a list object in lexical order.
		require
			not_empty_list : not is_empty
		do
			tclistsort (list)
			is_lexical_order := true
		ensure
			sorted_in_lexical_order : is_lexical_order
		end

feature -- Search
	linear_search (a_val : G) : INTEGER
			--  Search a list object for an element using liner search.
			--  The return value is the index of a corresponding element or -1 if there is no corresponding
  			--  element.
		local
			s8 : STRING
		do
			if a_val.conforms_to (a_string_8) then
                s8 ?= a_val
                Result := internal_linear_search (s8)
            else
            	s8 := serialize (a_val)
            	Result := internal_linear_search (s8)
            end

           if Result /= -1 then
           		Result := Result + 1
           end
		end

	binary_search (a_val : G) : INTEGER
			--  Search a list object for an element using binary search.
			--  The return value is the index of a corresponding element or -1 if there is no corresponding
  			--  element.
  		require
  			sorted_in_lexical_order : is_lexical_order
		local
			s8 : STRING
		do
			if a_val.conforms_to (a_string_8) then
                s8 ?= a_val
                Result := internal_binary_search (s8)
            else
            	s8 := serialize (a_val)
            	Result := internal_binary_search (s8)
            end

           if Result /= -1 then
           		Result := Result + 1
           end
		end
feature {NONE}-- implementation

	internal_push_string ( v : STRING)
		local
			c_str : C_STRING
		do
			create c_str.make (v)
			tclistpush2 (list, c_str.item)
		end

	internal_push ( v : like value )
		local
			c_str : C_STRING
			s : STRING
		do
			s := serialize (v)
			create c_str.make (s)
			tclistpush (list, c_str.item, s.count)
		end

	internal_unshift_string ( v : STRING)
		local
			c_str : C_STRING
		do
			create c_str.make (v)
			tclistunshift2 (list, c_str.item)
		end

	internal_unshift ( v : like value )
		local
			c_str : C_STRING
			s : STRING
		do
			s := serialize (v)
			create c_str.make (s)
			tclistunshift (list, c_str.item, s.count)
		end

	internal_shift_string : STRING
		local
			r : POINTER
		do
			r := tclistshift2 (list)
			if r /= default_pointer then
				create Result.make_from_c(r)
			end
		end


	internal_shift : G
		local
			r : POINTER
			c : STRING
			sc : C_STRING
			i : INTEGER
		do
			r := tclistshift (list, $i)
			create sc.make_by_pointer_and_count (r, i)
			c := sc.substring (1, i)
		    Result ?= deserialize (c)
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

	internal_value (index : INTEGER) : G
		local
			r : POINTER
			c : STRING
			sc : C_STRING
			i : INTEGER
		do
			r := tclistval (list, index, $i)
			create sc.make_by_pointer_and_count (r, i)
			c := sc.substring (1, i)
		    Result ?= deserialize (c)

		end

	internal_pop_string : STRING
		local
			r: POINTER
		do
			r := tclistpop2 (list)
			if r /= default_pointer then
				create Result.make_from_c(r)
			end
		end

	internal_pop : G
		local
			r : POINTER
			c : STRING
			sc : C_STRING
			i : INTEGER
		do
			r := tclistpop (list, $i)
			create sc.make_by_pointer_and_count (r, i)
			c := sc.substring (1, i)
		    Result ?= deserialize (c)
		end

	internal_insert_string ( item : STRING; an_index: INTEGER_32)
		local
			c_item : C_STRING
		do
			create c_item.make (item)
			tclistinsert2 (list, an_index, c_item.item)
		end

	internal_insert ( item : like value; an_index: INTEGER_32)
		local
			str_p : C_STRING
			str : STRING
		do
			str :=serialize (item)
			create str_p.make (str)
			tclistinsert (list, an_index, str_p.item, str.count)
		end

	internal_remove_string ( index : INTEGER) : STRING
		local
			r : POINTER
		do
			r := tclistremove2 (list, index)
			if r /= default_pointer then
				create Result.make_from_c (r)
			end
		end


	internal_remove (index : INTEGER) : G
		local
			r : POINTER
			c : STRING
			sc : C_STRING
			i : INTEGER
		do
			r := tclistremove (list, index, $i)
			create sc.make_by_pointer_and_count (r, i)
			c := sc.substring (1, i)
		    Result ?= deserialize (c)
		end


	internal_over_string ( item : STRING; an_index: INTEGER_32)
		local
			str_p : C_STRING
		do
			create str_p.make (item)
			tclistover2 (list, an_index, str_p.item)
		end



	internal_over ( item : like value; an_index: INTEGER_32)
		local
			str_p : C_STRING
			str : STRING
		do
			str := serialize (item)
			create str_p.make (str)
			tclistover (list, an_index, str_p.item, str.count)
		end

	internal_linear_search ( a_val : STRING) : INTEGER
		local
			c_val : C_STRING
		do
			create c_val.make (a_val)
			Result := tclistlsearch (list, c_val.item, a_val.count)
		end

	internal_binary_search ( a_val : STRING) : INTEGER
		local
			c_val : C_STRING
		do
			create c_val.make (a_val)
			Result := tclistbsearch (list, c_val.item, a_val.count)
		end

	list : POINTER
		-- tc_list object

	a_string_8: STRING_8 is
        once
            Result := ""
        end

end
