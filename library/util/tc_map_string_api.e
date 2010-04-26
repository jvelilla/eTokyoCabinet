note
	description: "Summary description for {TC_MAP_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_MAP_STRING_API

inherit
	TC_MAP

create
	make
feature {NONE} -- Initialization
	make
			-- Create a TC_MAP_API object
		do
			map := tcmapnew
		end
feature -- Access

	get ( a_key :STRING ) : STRING
			-- Item associated with `a_key', if present
			-- otherwise default value of type `STRING'
		require
			is_valid_key : a_key /= Void and not a_key.is_empty
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

	records_number : NATURAL_64
			-- Get the number of records in a Map Object
		do
			Result := tcmaprnum (map)
		end

	memory_size : NATURAL_64
		do
			Result := tcmapmsiz (map)
		end

	map_keys : ARRAY[STRING]
			--  Create a list object containing all keys in a map object.
		local
			r : POINTER
		do
			r:= tcmapkeys (map)
		end

	map_values : ARRAY[STRING]
			-- Create a list object containing all values in a map object
		local
			r: POINTER
		do
			r:= tcmapvals (map)
		end
feature -- Element Change

	put ( a_key : STRING; a_value : STRING)
		local
			c_key : C_STRING
			c_value : C_STRING
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			tcmapput2 (map, c_key.item,c_value.item)
		end

	put_keep ( a_key : STRING; a_value : STRING)
		local
			c_key : C_STRING
			c_value : C_STRING
			l_b : BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_b:= tcmapputkeep2 (map, c_key.item,c_value.item)
		end


	put_cat ( a_key : STRING; a_value : STRING)
		local
			c_key : C_STRING
			c_value : C_STRING
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			tcmapputcat2 (map, c_key.item,c_value.item)
		end

feature -- Removal
	clear
			-- Clear a map object.
			-- All records are removed.
		do
			tcmapclear (map)
		ensure
			-- map is empty
		end

	remove ( a_key : STRING )
		local
			c_key : C_STRING
			l_b : BOOLEAN
		do
			create c_key.make (a_key)
			l_b := tcmapout2 (map, c_key.item)
		end

feature -- Iterator
	iterator_init
			-- Initialize the iterator of a map object.
		do
			tcmapiterinit (map)
		end

	interator_next : STRING
			-- Get the next key of the iterator of a map object.
		local
			r: POINTER
		do
			r := tcmapiternext2 (map)
			if r /= default_pointer then
				create Result.make_from_c (r)
			end
		end

feature {NONE} -- Implementation
	map : POINTER
		-- tc_map object
end
