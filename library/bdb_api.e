note
	description: "Summary description for {BDB_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BDB_API

inherit
	DBM

	TC_BDB_API

	TC_BDB_CURSOR

create
	make

feature {NONE} -- Initialization

	make
			-- Create a B-tree database object
		do
			bdb := tcbdbnew
			is_open := False
			status_error := False
		end
feature -- Open Database

	open (a_path : STRING; o_mode : INTEGER_32)
		--Open a database file and connect a B+ tree database object.
		-- `a_path' specifies the path of the database file.
		-- `o_mode' specifies the connection mode: `BDBOWRITER' as a writer, `BDBOREADER' as a reader.
		--   If the mode is `BDBOWRITER', the following may be added by bitwise-or: `BDBOCREAT', which
		--   means it creates a new database if not exist, `BDBOTRUNC', which means it creates a new
		--   database regardless if one exists, `BDBOTSYNC', which means every transaction synchronizes
		--   updated contents with the device.  Both of `BDBOREADER' and `BDBOWRITER' can be added to by
		--   bitwise-or: `BDBONOLCK', which means it opens the database file without file locking, or
		--   `BDBOLCKNB', which means locking is performed without blocking.
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
		local
			c_path : C_STRING
			l_b : BOOLEAN
		do
			create c_path.make (a_path)
			l_b := tcbdbopen (bdb,c_path.item,o_mode)
			if not l_b then
				status_error := True
			else
				is_open := True
			end
		end

feature -- Close and Delete

	close
		-- Close a B-tree Database
		require
			is_database_open : is_open
		local
			l_b : BOOLEAN
		do
			l_b := tcbdbclose (bdb)
			if not l_b then
				status_error := True
			else
				is_open := False
			end
		ensure
			is_database_closed : not is_open
		end

	delete
		-- Delete an B-tree Database
		do
			tcbdbdel (bdb)
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
			-- Retrieve a string record in a B+ tree database object. 	
		do
			Result := tcbdbget2 (bdb, a_key)
		end

	records_number_implementation: NATURAL_64
			-- Deferred implementation of records_number
			-- Get the number of records of a B+ tree database object.
		do
			Result := tcbdbrnum (bdb)
		end

	put_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_string
			-- Store a string record into a B+ tree database object.
			-- `a_key' specifies the string of the key.
			-- `a_value' specifies the string of the value.
		do
			Result := tcbdbput2 (bdb, a_key, a_value)
		end

	put_keep_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_keep_string
		do
			Result := tcbdbputkeep2 (bdb, a_key, a_value)
		end

	out_string_implementation (a_key: POINTER): BOOLEAN
			-- Deferred implementation of out_string
		do
			Result := tcbdbout2 (bdb, a_key)
		end

	error_message_implementation (a_code: INTEGER_32): POINTER
			-- Deferred Implementation of error message
		do
			Result := tcbdberrmsg (a_code)
		end

	error_code_implementation: INTEGER_32
			-- Deferred implementation of error_code
		do
			Result := tcbdbecode (bdb)
		end

	file_size_implementation: NATURAL_64
			-- Deferred implementation of full_size
		do
			Result := tcbdbfsiz (bdb)
		end

	iterator_next_string_implementation: POINTER
			-- deferred implementation
		local
			b : BOOLEAN
		do
			Result := tcbdbcurkey2 (bdb_cursor)
			b := tcbdbcurnext (bdb_cursor)
		end

	iterator_init_implementation: BOOLEAN
		do
			bdb_cursor := tcbdbcurnew (bdb)
			Result := tcbdbcurfirst (bdb_cursor)
		ensure then
			bdb_cursor_initialized: bdb_cursor /= default_pointer
		end

	bdb: POINTER
			-- B-tree database object

	bdb_cursor: POINTER
			-- B-tree cursor object	

invariant
	b_tree_database_created: bdb /= default_pointer

end -- class BDB_API

