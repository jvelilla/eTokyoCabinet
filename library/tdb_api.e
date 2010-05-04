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

	TC_SERIALIZATION
create
	make

feature {NONE} -- Initialization

	make
			-- Create a hash database object
		do
			tdb := tctdbnew
			is_open := False
			has_error := False
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
				has_error := True
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
				has_error := True
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
				has_error := True
			end
		end

	error_code: INTEGER_32
			-- 	Get the last happened error code of a database object.
		do
			Result := error_code_implementation
		end

feature -- Access
	get_map ( a_key : STRING ) : POINTER
			-- Retrieve a record in a table database object.
			-- The return value is a pointer to a map object of the columns of the corresponding record `a_key'.
		require
			is_open : is_open
		local
			r : POINTER
			c_key : C_STRING
		do
			create c_key.make (a_key)
			Result := tctdbget (tdb, c_key.item, a_key.count)
		end

feature -- Element Change
	put_map ( a_key : ANY; a_map : MAP_API[ANY,ANY])
			-- Store a record into a table database object.
			-- `a_map' specifies a map object containing columns
		require
			is_open : is_open
		local
			s8 : STRING
		do
			if a_key.conforms_to (a_string_8) then
				s8 ?= a_key
                internal_put_map_string (s8,a_map)
            else
            	internal_put_map (a_key, a_map)
            end
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



	internal_put_map_string ( a_key : STRING; a_map : MAP_API [ANY,ANY])
		local
			c_key : C_STRING
			b : BOOLEAN
		do
			create c_key.make (a_key)
			b := tctdbput (tdb, c_key.item, a_key.count, a_map.map)
			if not b then
				has_error := true
			end
		end

	internal_put_map ( a_key : ANY; a_map : MAP_API [ANY,ANY])
		local
			str : STRING
			c_key : C_STRING
			b : BOOLEAN
		do
			str := serialize (a_key)
			create c_key.make (str)
			b := tctdbput (tdb, c_key.item, str.count, a_map.map)
			if not b then
				has_error := true
			end
		end

	a_string_8: STRING_8 is
        once
            Result := ""
        end

	tdb: POINTER
		-- Table database object


invariant
	table_database_created: tdb /= default_pointer

end
