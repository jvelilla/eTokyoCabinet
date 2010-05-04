note
	description: "Summary description for {TREE_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_API [V,K]
inherit
	TC_TREE_API

	TC_SERIALIZATION

create
	make,
	make_by_pointer
feature -- Initialization

	make
		do
			tree := tctreenew
		ensure
			empty_tree : is_empty
		end

	make_by_pointer ( p : POINTER )
		require
			is_valid_pointer : p /= default_pointer
		do
			tree := p
		ensure
			assigned_tree : tree = p
		end
feature -- Access
	found_element : V
		-- if any, yielded by last has_key operation

	has_key (a_key : K) : BOOLEAN
			-- Is there an element in the tree with key `a_key'? Set `found_element' to the found element.
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

			if class_name.is_equal("TREE_API [STRING_8, STRING_8]") then
                s8 ?= a_key
                Result ?= internal_get_string (s8)
            else
            	Result ?= internal_get (a_key)
            end
		end

	elements : NATURAL_64
		-- number of records stored in a tree object.
	    do
	    	Result  := tctreernum (tree)
	    end

	is_empty : BOOLEAN
	 		-- is the tree empty?
	 	do
	 		Result := elements = 0
	 	end

	 memory_size : NATURAL_64
	 		-- Total size of memory used by a tree object
		do
			Result := tctreemsiz (tree)
		end

	tree_keys : LIST_API[K]
			--  Create a list object containing all keys in a tree object.
		local
			r : POINTER

		do
			r:= tctreekeys (tree)
			if r /= default_pointer then
				create Result.make_by_pointer (r)
			end
		end

	tree_values : LIST_API[V]
			-- Create a list object containing all values in a tree object
		local
			r: POINTER
		do
			r:= tctreevals (tree)
			if r /= default_pointer then
				create Result.make_by_pointer (r)
			end
		end

feature -- Element Change

	duplicate : TREE_API [V,K]
			-- Copy a tree object.
			-- The return value is the new tree object equivalent to the Current object.
		do
			Result.make_by_pointer (tctreedup (tree))
		end

	put ( a_key : K; a_value : V)
			-- Store a record into a tree object.
			-- If a record with the same key exists in the tree, it is overwritten.
		local
			l_internal : INTERNAL
			class_name : STRING
			k8,v8 : STRING
		do
		    create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("TREE_API [STRING_8, STRING_8]") then
                k8 ?= a_key
                v8 ?= a_value
                internal_put_string (k8 , v8)
            else
            	internal_put (a_key, a_value)
            end
        ensure
        	added :old is_empty implies (old elements + 1 = elements)
        	added_or_ovewriten : not (old is_empty) implies ( (old elements + 1 = elements) or (old elements = elements))
		end

	put_keep ( a_key : K; a_value : V)
			-- Store a new record into a tree object.
			-- If a record with the same key exists in the tree, this function has no effect.
		local
			l_internal : INTERNAL
			class_name : STRING
			k8,v8 : STRING
		do
		    create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("TREE_API [STRING_8, STRING_8]") then
                k8 ?= a_key
                v8 ?= a_value
                internal_put_keep_string (k8 , v8)
            else
            	internal_put_keep (a_key, a_value)
            end
		end


	put_cat ( a_key : K; a_value : V)
			-- Concatenate a value at the end of the value of the existing record in a tree object
			-- If there is no corresponding record, a new record is created
		local
			l_internal : INTERNAL
			class_name : STRING
			k8,v8 : STRING
		do
		    create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("TREE_API [STRING_8, STRING_8]") then
                k8 ?= a_key
                v8 ?= a_value
                internal_put_cat_string (k8 , v8)
            else
            	internal_put_cat (a_key, a_value)
            end
		end

feature -- Remove
	clear
			-- Clear a tree object
			-- All records are removed
		do
			tctreeclear (tree)
		ensure
			empty_tree : is_empty
		end


	remove ( a_key : K )
		-- Remove a record of a tree object.
		require
			has_key : has_key (a_key)
		local
			l_internal : INTERNAL
			class_name : STRING
			k8 : STRING
		do
			create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("TREE_API [STRING_8, STRING_8]") then
                k8 ?= a_key
                internal_remove_string (k8 )
            else
            	internal_remove (a_key)
            end
		ensure
			remove_record : old elements - 1 = elements
			not_has_key   : not has_key (a_key)
		end

feature -- Iterator
	iterator_init
			-- Initialize the iterator of a tree object.
		do
			tctreeiterinit (tree)
		end

	iterator_next : V
			-- Get the next key of the iterator of a tree object.
		local
			l_internal : INTERNAL
			class_name : STRING
		do
			create l_internal
		    class_name := l_internal.type_name (Current)

			if class_name.is_equal("TREE_API [STRING_8, STRING_8]") then
                Result ?= internal_iterator_next_string
            else
            	Result ?= internal_iterator_next_string
            end
		end

feature {NONE} -- Implementation
	internal_get_string ( a_key : STRING) : STRING
		local
			c_key : C_STRING
			r : POINTER
		do
			create c_key.make (a_key)
			r:= tctreeget2 (tree, c_key.item)
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
			r := tctreeget (tree, str_p.item, str.count, $i)
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
			tctreeput2 (tree, c_key.item,c_value.item)
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
			tctreeput (tree, c_str_k.item, str_k.count, c_str_v.item, str_v.count)
		end

	internal_put_keep_string ( a_key : STRING; a_value : STRING)
		local
			c_key : C_STRING
			c_value : C_STRING
			l_b : BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_b:= tctreeputkeep2 (tree, c_key.item,c_value.item)
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
			l_b := tctreeputkeep (tree, c_str_k.item, str_k.count, c_str_v.item, str_v.count)
		end

	internal_put_cat_string ( a_key : STRING; a_value : STRING)
		local
			c_key : C_STRING
			c_value : C_STRING
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			tctreeputcat2 (tree, c_key.item,c_value.item)
		end

	internal_put_cat (a_key : K; a_value : V)
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
			tctreeputcat (tree, c_str_k.item, str_k.count, c_str_v.item, str_v.count)
		end



	internal_remove_string (a_key : STRING)
		local
			c_key : C_STRING
			l_b : BOOLEAN
		do
			create c_key.make (a_key)
			l_b := tctreeout2 (tree, c_key.item)
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
			l_b := tctreeout (tree, str_p.item, str.count)
			check l_b end
		end




	internal_iterator_next : V
			-- Get the next key of the iterator of a tree object.
		local
			r: POINTER
			i : INTEGER
			c : STRING
			sc : C_STRING
		do
			r := tctreeiternext (tree, $i)
			if r /= default_pointer then
				create sc.make_by_pointer_and_count (r, i)
				c := sc.substring (1, i)
		    	Result ?= deserialize (c)
			end
		end


	internal_iterator_next_string : STRING
			-- Get the next key of the iterator of a tree object.
		local
			r: POINTER
		do
			r := tctreeiternext2 (tree)
			if r /= default_pointer then
				create Result.make_from_c (r)
			end
		end



	tree : POINTER
		-- tree object pointer

end
