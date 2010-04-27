note
	description: "Summary description for {DBM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DBM

feature -- Access

	is_open: BOOLEAN
			-- is the database open?

	error_description: STRING
			-- Textual description of error
		require
			has_error: has_error
		do
			Result := full_message
		ensure
			result_exists: Result /= Void
			result_not_empty: not Result.is_empty
		end

	get_string (a_key: STRING): STRING
			--  Retrieve a string record by `a_key'
		require
			is_open_database: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
		local
			c_key: C_STRING
			r: POINTER
		do
			create c_key.make (a_key)
			r := get_string_implementation (c_key.item)
			if r /= default_pointer then
				create Result.make_from_c (r)
			end
		end

	records_number: NATURAL_64
			--Get the number of records.
		require
			is_open_database: is_open
		do
			Result := records_number_implementation
		end

	file_size: NATURAL_64
			-- Get the size of the database file. 	
		require
			is_open_database: is_open
		do
			Result := file_size_implementation
		end

feature -- Change Element

	put_string (a_key: STRING; a_value: STRING)
			-- Is used in order to store a string record into a database object.
		require
			is_open_database: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
			is_valid_value: a_value /= Void and (not a_value.is_empty)
		local
			c_key: C_STRING
			c_value: C_STRING
			l_b: BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_b := put_string_implementation (c_key.item, c_value.item)
			if not l_b then
				has_error := True
			end
		end

	put_keep_string (a_key: STRING; a_value: STRING)
			-- Is used in order to store a new string record into a database object.
			-- If a record with the same key exists in the database, this function has no effect.
		require
			is_open_database: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
			is_valid_value: a_value /= Void and (not a_value.is_empty)
		local
			c_key: C_STRING
			c_value: C_STRING
			l_b: BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_b := put_keep_string_implementation (c_key.item, c_value.item)
			if not l_b then
				has_error := True
			end
		end

	out_string (a_key: STRING)
			-- remove a record by a key `a_key'
		require
			is_open_database: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
		local
			c_key: C_STRING
			l_b: BOOLEAN
		do
			create c_key.make (a_key)
			l_b := out_string_implementation (c_key.item)
		end

feature -- Iterator

	iterator_init
			-- Initialize the iterator
		require
			is_open_database: is_open
		local
			l_b: BOOLEAN
		do
			l_b := iterator_init_implementation
			if not l_b then
				has_error := True
			end
		end

	iterator_next_string: STRING
			-- get the next key of the iterator
		require
			is_open_database: is_open
		local
			r: POINTER
		do
			r := iterator_next_string_implementation
			if r /= default_pointer then
				create Result.make_from_c (r)
			end
		end

feature -- Status Report

	has_error: BOOLEAN
			-- Did an error occur?


feature {DBM} -- Implementation

	get_string_implementation (a_key: POINTER): POINTER
			-- Deferred implementation of get_string	
		deferred
		end

	records_number_implementation: NATURAL_64
			-- Deferred implementation of records_number
		deferred
		end

	put_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_string
		deferred
		end

	put_keep_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_keep_string
		deferred
		end

	out_string_implementation (a_key: POINTER): BOOLEAN
			-- Deferred implementation of out_string
		deferred
		end

	error_message_implementation (a_code: INTEGER_32): POINTER
			-- Deferred Implementation of error message
		deferred
		end

	error_code_implementation: INTEGER_32
			-- Deferred implementation of error_code
		deferred
		end

	file_size_implementation: NATURAL_64
			-- Deferred implementation of full_size
		deferred
		end

	iterator_next_string_implementation: POINTER
			-- deferred implementation
		deferred
		end

	iterator_init_implementation: BOOLEAN
		deferred
		end

	full_message: STRING
			-- Full error message
		require
			has_error: has_error
		do
			Result := full_message_implementation
		end

	full_message_implementation : STRING
		deferred
		end

invariant
	non_empty_description: has_error implies (error_description /= Void and not error_description.is_empty)

end -- class DBM

