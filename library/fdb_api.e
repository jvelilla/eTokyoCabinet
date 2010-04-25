note
	description: "Summary description for {FDB_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FDB_API

inherit
	DBM

	TC_FDB_API

create
	make

feature {NONE} -- Initialization

	make
			-- Create a hash database object
		do
			fdb := tcfdbnew
			is_open := False
			status_error := False
		end
feature -- Open Database

	open (a_path : STRING; o_mode : INTEGER_32)
		-- Open a database file and connect a fixed-length database object.
		--   `a_path' specifies the path of the database file.
		--   `o_mode' specifies the connection mode: `FDBOWRITER' as a writer, `FDBOREADER' as a reader.
		--   If the mode is `FDBOWRITER', the following may be added by bitwise-or: `FDBOCREAT', which
		--   means it creates a new database if not exist, `FDBOTRUNC', which means it creates a new
		--   database regardless if one exists, `FDBOTSYNC', which means every transaction synchronizes
		--   updated contents with the device.  Both of `FDBOREADER' and `FDBOWRITER' can be added to by
		--   bitwise-or: `FDBONOLCK', which means it opens the database file without file locking, or
		--   `FDBOLCKNB', which means locking is performed without blocking.
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
		local
			c_path : C_STRING
			l_b : BOOLEAN
		do
			create c_path.make (a_path)
			l_b := tcfdbopen (fdb,c_path.item,o_mode)
			if not l_b then
				status_error := True
			else
				is_open := True
			end
		end

feature -- Close and Delete

	close
		-- Close a Fixed Database
		require
			is_database_open : is_open
		local
			l_b : BOOLEAN
		do
			l_b := tcfdbclose (fdb)
			if not l_b then
				status_error := True
			else
				is_open := False
			end
		ensure
			is_database_closed : not is_open
		end

	delete
		-- Delete an Fixed Database
		do
			tcfdbdel (fdb)
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
			-- Retrieve a string record in a Fixed database object. 	
		do
			Result := tcfdbget3 (fdb, a_key)
		end

	records_number_implementation: NATURAL_64
			-- Deferred implementation of records_number
		do
			Result := tcfdbrnum (fdb)
		end

	put_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_string
		do
			Result := tcfdbput3 (fdb, a_key, a_value)
		end

	put_keep_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_keep_string
		do
			Result := tcfdbputkeep3 (fdb, a_key, a_value)
		end

	out_string_implementation (a_key: POINTER): BOOLEAN
			-- Deferred implementation of out_string
		do
			Result := tcfdbout3 (fdb, a_key)
		end

	error_message_implementation (a_code: INTEGER_32): POINTER
			-- Deferred Implementation of error message
		do
			Result := tcfdberrmsg (a_code)
		end

	error_code_implementation: INTEGER_32
			-- Deferred implementation of error_code
		do
			Result := tcfdbecode (fdb)
		end

	file_size_implementation: NATURAL_64
			-- Deferred implementation of full_size
		do
			Result := tcfdbfsiz (fdb)
		end

	iterator_next_string_implementation: POINTER
			-- deferred implementation
		do
			Result := tcfdbiternext3 (fdb)
		end

	iterator_init_implementation: BOOLEAN
		do
			Result := tcfdbiterinit (fdb)
		end

	fdb : POINTER
		-- Fixed Database Object

invariant
	fixed_database_created: fdb /= default_pointer


end
