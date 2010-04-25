note
	description: "Summary description for {TDB_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TDB_API
inherit
	DBM

	TC_TDB_API

create
	make

feature {NONE} -- Initialization

	make
			-- Create a hash database object
		do
			tdb := tctdbnew
			is_open := False
			status_error := False
		end
feature -- Open Database

	open (a_path : STRING; o_mode : INTEGER_32)
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
		local
			c_path : C_STRING
			l_b : BOOLEAN
		do
			create c_path.make (a_path)
			l_b := tctdbopen (tdb,c_path.item,o_mode)
			if not l_b then
				status_error := True
			else
				is_open := True
			end
		end

feature -- Close and Delete

	close
		-- Close a Table Database
		require
			is_database_open : is_open
		local
			l_b : BOOLEAN
		do
			l_b := tctdbclose (tdb)
			if not l_b then
				status_error := True
			else
				is_open := False
			end
		ensure
			is_database_closed : not is_open
		end

	delete
		-- Delete a Table Database
		do
			tctdbdel (tdb)
			is_open := False
		ensure
			is_database_closed : not is_open

		end

feature -- Error Messages

	error_message (a_code: INTEGER_32): STRING
			-- Get the message string corresponding to an error code.
		local
			r: POINTER
		do
			r := error_message_implementation (a_code)
			if r /= default_pointer then
				create Result.make_from_c (r)
			else
				status_error := True
			end
		end

	error_code: INTEGER_32
			-- 	Get the last happened error code of a database object.
		do
			Result := error_code_implementation
		end


feature {NONE} -- Implementation

	full_message_implementation : STRING
		do
			Result := error_message (error_code)
		end

	get_string_implementation (a_key: POINTER): POINTER
			-- Deferred implementation of get_string
			-- Retrieve a string record in a Table database object. 	
		do
			Result := tctdbget3 (tdb, a_key)
		end

	records_number_implementation: NATURAL_64
			-- Deferred implementation of records_number
		do
			Result := tctdbrnum (tdb)
		end

	put_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_string
		do
			Result := tctdbput3 (tdb, a_key, a_value)
		end

	put_keep_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_keep_string
		do
			Result := tctdbputkeep3 (tdb, a_key, a_value)
		end

	out_string_implementation (a_key: POINTER): BOOLEAN
			-- Deferred implementation of out_string
		do
			Result := tctdbout2 (tdb, a_key)
		end

	error_message_implementation (a_code: INTEGER_32): POINTER
			-- Deferred Implementation of error message
		do
			Result := tctdberrmsg (a_code)
		end

	error_code_implementation: INTEGER_32
			-- Deferred implementation of error_code
		do
			Result := tctdbecode (tdb)
		end

	file_size_implementation: NATURAL_64
			-- Deferred implementation of full_size
		do
			Result := tctdbfsiz (tdb)
		end

	iterator_next_string_implementation: POINTER
			-- deferred implementation
		do
			Result := tctdbiternext2 (tdb)
		end

	iterator_init_implementation: BOOLEAN
		do
			Result := tctdbiterinit (tdb)
		end

	tdb: POINTER
		-- Table database object


invariant
	table_database_created: tdb /= default_pointer

end
