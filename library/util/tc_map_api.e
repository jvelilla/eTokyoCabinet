note
	description: "Summary description for {TC_MAP_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_MAP_API [V,K]

inherit
	TC_MAP

	TC_SERIALIZATION

create
	make

feature {NONE} -- Initialization
	make
			-- Create a TC_MAP_API object
		do
			map := tcmapnew
		end
feature -- Access

	found_element : V
		-- if any, yielded by last has_key operation

	get ( a_key : K ) : V
			-- Item associated with `a_key', if present
			-- otherwise default value of type `STRING'
		require
			is_valid_key : a_key /= Void
		local
			l_internal : INTERNAL
			class_name : STRING
			s8 : STRING
		do
		    create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("TC_MAP_API [STRING_8, STRING_8]") then
                s8 ?= a_key
                Result ?= internal_get_string (s8)
            else
            	Result ?= internal_get (a_key)
            end
		end



	has_key (a_key : K) : BOOLEAN
			-- Is there an element in the map with key `a_key'? Set `found_element' to the found element.
			local
				l_value : V
			do
				l_value := get (a_key)
				if l_value /= Void then
					Result := true
					found_element := l_value
				end
			ensure
				found : Result implies (found_element /= Void)
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

	map_keys : TC_LIST_API[K]
			--  Create a list object containing all keys in a map object.
		local
			r : POINTER

		do
			r:= tcmapkeys (map)
			if r /= default_pointer then
				create Result.make_by_pointer (r)
			end
		end

	map_values : TC_LIST_API[V]
			-- Create a list object containing all values in a map object
		local
			r: POINTER
		do
			r:= tcmapvals (map)
			if r /= default_pointer then
				create Result.make_by_pointer (r)
			end
		end

feature -- Element Change

	put ( a_key : K; a_value : V)
			-- Store a record into a map object.
			-- If a record with the same key exists in the map, it is overwritten.
		local
			l_internal : INTERNAL
			class_name : STRING
			k8,v8 : STRING
		do
		    create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("TC_MAP_API [STRING_8, STRING_8]") then
                k8 ?= a_key
                v8 ?= a_value
                internal_put_string (k8 , v8)
            else
            	internal_put (a_key, a_value)
            end
        ensure
        	added :old is_empty implies (old records_number + 1 = records_number)
        	added_or_ovewriten : not (old is_empty) implies ( (old records_number + 1 = records_number) or (old records_number = records_number))
		end



	put_keep ( a_key : K; a_value : V)
			-- Store a new record into a map object.
			-- If a record with the same key exists in the map, this function has no effect.
		local
			l_internal : INTERNAL
			class_name : STRING
			k8,v8 : STRING
		do
		    create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("TC_MAP_API [STRING_8, STRING_8]") then
                k8 ?= a_key
                v8 ?= a_value
                internal_put_keep_string (k8 , v8)
            else
            	internal_put_keep (a_key, a_value)
            end
		end


	put_cat ( a_key : K; a_value : V)
			-- Concatenate a value at the end of the value of the existing record in a map object
			-- If there is no corresponding record, a new record is created
		local
			l_internal : INTERNAL
			class_name : STRING
			k8,v8 : STRING
		do
		    create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("TC_MAP_API [STRING_8, STRING_8]") then
                k8 ?= a_key
                v8 ?= a_value
                internal_put_cat_string (k8 , v8)
            else
            	internal_put_cat (a_key, a_value)
            end
		end

feature -- Status Report

	is_empty : BOOLEAN
			-- is the map empty?
		do
			Result := records_number = 0
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

	remove ( a_key : K )
		-- Remove a record of a map object.
		require
			has_key : has_key (a_key)
		local
			l_internal : INTERNAL
			class_name : STRING
			k8 : STRING
			c_key : C_STRING
			l_b : BOOLEAN
		do
			create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("TC_MAP_API [STRING_8, STRING_8]") then
                k8 ?= a_key
                internal_remove_string (k8 )
            else
            	internal_remove (a_key)
            end
		ensure
			remove_record : old records_number - 1 = records_number
			not_has_key   : not has_key (a_key)
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


	internal_get (a_key : K) : V
		local
			r : POINTER
			c,str : STRING
			sc,str_p : C_STRING
			i : INTEGER
		do
			str :=serialize (a_key)
			create str_p.make (str)
			r := tcmapget (map, str_p.item, str.count, $i)
			if r /= default_pointer then
				create sc.make_by_pointer_and_count (r, i)
				c := sc.substring (1, i)
		    	Result ?= deserialize (c)
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


	internal_put (a_key : K; a_value : V)
		local
			str_k : STRING
			c_str_k : C_STRING
			str_v : STRING
			c_str_v : C_STRING
		do
			str_k := serialize (a_key)
			create c_str_k.make (str_k)

			str_v := serialize (a_value)
			create c_str_v.make (str_v)
			tcmapput (map, c_str_k.item, str_k.count, c_str_v.item, str_v.count)
		end


	internal_put_keep_string ( a_key : STRING; a_value : STRING)
		local
			c_key : C_STRING
			c_value : C_STRING
			l_b : BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_b:= tcmapputkeep2 (map, c_key.item,c_value.item)
		end

	internal_put_keep (a_key : K; a_value : V)
		local
			str_k : STRING
			c_str_k : C_STRING
			str_v : STRING
			c_str_v : C_STRING
			l_b : BOOLEAN
		do
			str_k := serialize (a_key)
			create c_str_k.make (str_k)

			str_v := serialize (a_value)
			create c_str_v.make (str_v)
			l_b := tcmapputkeep (map, c_str_k.item, str_k.count, c_str_v.item, str_v.count)
		end

	internal_put_cat_string ( a_key : STRING; a_value : STRING)
		local
			c_key : C_STRING
			c_value : C_STRING
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			tcmapputcat2 (map, c_key.item,c_value.item)
		end

	internal_put_cat (a_key : K; a_value : V)
		local
			str_k : STRING
			c_str_k : C_STRING
			str_v : STRING
			c_str_v : C_STRING
			l_b : BOOLEAN
		do
			str_k := serialize (a_key)
			create c_str_k.make (str_k)

			str_v := serialize (a_value)
			create c_str_v.make (str_v)
			tcmapputcat (map, c_str_k.item, str_k.count, c_str_v.item, str_v.count)
		end


	internal_remove_string (a_key : STRING)
		local
			c_key : C_STRING
			l_b : BOOLEAN
		do
			create c_key.make (a_key)
			l_b := tcmapout2 (map, c_key.item)
			check l_b end
		end


	internal_remove (a_key : K)
		local
			str : STRING
			str_p : C_STRING
			l_b : BOOLEAN
		do
			str := serialize (a_key)
			create str_p.make (str)
			l_b := tcmapout (map, str_p.item, str.count)
			check l_b end
		end


	map : POINTER
		-- tc_map object
end
