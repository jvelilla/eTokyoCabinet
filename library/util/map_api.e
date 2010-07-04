note
	description: "Summary description for {MAP_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAP_API

inherit
	TC_MAP_API


create
	make,
	make_by_pointer,
	make_by_map

feature {MAP_API} -- Initialization
	make
			-- Create a MAP_API object
		do
			map := tcmapnew
		ensure
		 	empty_map : is_empty
		end

	make_by_pointer ( p : POINTER )
		require
			is_valid_pointer : p /= default_pointer
		do
			map := p
		ensure
			assigned_map : map = p
		end

	make_by_map ( a_map : HASH_TABLE [STRING,STRING])
			-- Create a MAP_API object
		do
			map := tcmapnew2 (a_map.count.as_natural_32)
			set_map (a_map)
		end

feature -- Access

	as_map : HASH_TABLE [STRING,STRING]
			-- return an Eiffel HASH_TABLE from a TC_MAP
		local
			l_key : STRING
		do
			create Result.make (elements.as_integer_32)
			from
				iterator_init
				l_key := iterator_next
			until
				l_key = Void
			loop
				Result.put (get(l_key), l_key)
				l_key := iterator_next
			end
		end





feature -- Element Change
	set_map ( a_map : HASH_TABLE [STRING,STRING])
			-- set a map of string to a tc_map
		do
			from
				a_map.start
			until
				a_map.after
			loop
				put (a_map.key_for_iteration, a_map.item_for_iteration)
				a_map.forth
			end
		end

feature -- Status Report

	is_empty : BOOLEAN
			-- is the map empty?
		do
			Result := elements = 0
		end
feature -- Removal
	clear
			-- Clear a map object.
			-- All records are removed.
		do
			tcmapclear (map)
		ensure
			empty_map : is_empty
		end

	delete
			-- Delete a map of objects
			-- Note that the deleted object and its derivatives can not be used anymore.
		do
			tcmapdel (map)
		end


feature {NONE} -- Implementation
	get ( a_key : STRING ) : STRING
			-- Item associated with `a_key', if present
			-- otherwise default value of type `STRING'
		require
			is_valid_key : a_key /= Void
		do
			Result := internal_get_string (a_key)
		end



	elements : NATURAL_64
			-- Get the number of records in a Map Object
		do
			Result := tcmaprnum (map)
		end

	put ( a_key : STRING; a_value : STRING)
			-- Store a record into a map object.
			-- If a record with the same key exists in the map, it is overwritten.
		do
	            internal_put_string (a_key , a_value)
        ensure
        	added :old is_empty implies (old elements + 1 = elements)
        	added_or_ovewriten : not (old is_empty) implies ( (old elements + 1 = elements) or (old elements = elements))
		end


	iterator_init
			-- Initialize the iterator of a map object.
		do
			tcmapiterinit (map)
		end

	iterator_next : STRING
			-- Get the next key of the iterator of a map object.
		do
                Result := internal_iterator_next_string
  		end

	internal_get_string ( a_key : STRING) : STRING
		local
			c_key : C_STRING
			r : POINTER
		do
			create c_key.make (a_key)
			r:= tcmapget2 (map, c_key.item)
			if r /= default_pointer then
				create Result.make_from_c(r)
			end
		end

	internal_put_string (a_key : STRING; a_value : STRING)
		local
			c_key : C_STRING
			c_value : C_STRING
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			tcmapput2 (map, c_key.item,c_value.item)
		end

	internal_iterator_next_string : STRING
			-- Get the next key of the iterator of a map object.
		local
			r: POINTER
		do
			r := tcmapiternext2 (map)
			if r /= default_pointer then
				create Result.make_from_c (r)
			end
		end

feature {TDB_API}
	map : POINTER
		-- tc_map object
end
