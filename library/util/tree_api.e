note
	description: "Summary description for {TREE_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_API
inherit
	TC_TREE_API

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
	found_element : STRING
		-- if any, yielded by last has_key operation

	has_key (a_key : STRING) : BOOLEAN
			-- Is there an element in the tree with key `a_key'? Set `found_element' to the found element.
			local
				l_value : STRING
			do
				l_value := get (a_key)
				if l_value /= Void then
					Result := true
					found_element := l_value
				end
			ensure
				found : Result implies (found_element /= Void)
			end

	get ( a_key : STRING ) : STRING
			-- Item associated with `a_key', if present
			-- otherwise default value of type `STRING'
		require
			is_valid_key : a_key /= Void
		do
		        Result := internal_get_string (a_key)
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

	tree_keys : LIST[STRING]
			--  Create a list object containing all keys in a tree object.
		local
			r : POINTER
			l_list : LIST_API
		do
			r:= tctreekeys (tree)
			if r /= default_pointer then
				create l_list.make_by_pointer (r)
				Result := l_list.as_list
			end
		end

	tree_values : LIST[STRING]
			-- Create a list object containing all values in a tree object
		local
			r: POINTER
			l_list : LIST_API
		do
			r:= tctreevals (tree)
			if r /= default_pointer then
				create l_list.make_by_pointer (r)
				Result := l_list.as_list
			end
		end

feature -- Element Change

	duplicate : TREE_API
			-- Copy a tree object.
			-- The return value is the new tree object equivalent to the Current object.
		do
			Result.make_by_pointer (tctreedup (tree))
		end

	put ( a_key : STRING; a_value : STRING)
			-- Store a record into a tree object.
			-- If a record with the same key exists in the tree, it is overwritten.
		do
                internal_put_string (a_key, a_value)
        ensure
        	added :old is_empty implies (old elements + 1 = elements)
        	added_or_ovewriten : not (old is_empty) implies ( (old elements + 1 = elements) or (old elements = elements))
		end

	put_keep ( a_key : STRING; a_value : STRING)
			-- Store a new record into a tree object.
			-- If a record with the same key exists in the tree, this function has no effect.
		do
	            internal_put_keep_string (a_key , a_value)
    	end


	put_cat ( a_key : STRING; a_value : STRING)
			-- Concatenate a value at the end of the value of the existing record in a tree object
			-- If there is no corresponding record, a new record is created
		do
	        	internal_put_cat_string (a_key, a_value)
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


	remove ( a_key : STRING )
		-- Remove a record of a tree object.
		require
			has_key : has_key (a_key)
		do
	            internal_remove_string (a_key )
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

	iterator_next : STRING
			-- Get the next key of the iterator of a tree object.
		local
			l_internal : INTERNAL
			class_name : STRING
		do
                Result := internal_iterator_next_string
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


	internal_put_string (a_key : STRING; a_value : STRING)
		local
			c_key : C_STRING
			c_value : C_STRING
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			tctreeput2 (tree, c_key.item,c_value.item)
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


	internal_put_cat_string ( a_key : STRING; a_value : STRING)
		local
			c_key : C_STRING
			c_value : C_STRING
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			tctreeputcat2 (tree, c_key.item,c_value.item)
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
