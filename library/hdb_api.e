note
	description: "Summary description for {HDB_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HDB_API

inherit
	DBM

	TC_HDB_API

	KL_SHARED_FILE_SYSTEM
	
create
	make

feature {NONE} -- Initialization

	make
			-- Create a hash database object
		do
			hdb := tchdbnew
			is_open := False
			has_error := False
		end

feature -- Open Database

	open (a_path : STRING; o_mode : INTEGER_32)
		-- Open a  database file and connect a hash database object.
		--   `a_path' specifies the path of the database file.
		--   `o_mode' specifies the connection mode: `HDBOWRITER' as a writer, `HDBOREADER' as a reader.
		--   If the mode is `HDBOWRITER', the following may be added by bitwise-or: `HDBOCREAT', which
		--   means it creates a new database if not exist, `HDBOTRUNC', which means it creates a new
		--   database regardless if one exists, `HDBOTSYNC', which means every transaction synchronizes
		--   updated contents with the device.  Both of `HDBOREADER' and `HDBOWRITER' can be added to by
		--   bitwise-or: `HDBONOLCK', which means it opens the database file without file locking, or
		--   `HDBOLCKNB', which means locking is performed without blocking.
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
		local
			c_path : C_STRING
			l_b : BOOLEAN
		do
			create c_path.make (a_path)
			l_b := tchdbopen (hdb,c_path.item,o_mode)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		end

	open_writer (a_path : STRING)
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
			exist_file : is_valid_path (a_path)
		local
			c_path : C_STRING
			l_b : BOOLEAN
		do
			create c_path.make (a_path)
			set_current_open_mode (owriter)
			l_b := tchdbopen (hdb,c_path.item,owriter)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
			is_open_mode_writer : is_open_mode_writer
		end

	open_writer_create (a_path : STRING)
			-- Creates a new database if not exist
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
		local
			c_path : C_STRING
			l_b : BOOLEAN
			l_om : INTEGER
		do
			l_om := owriter.bit_or (ocreat)
			create c_path.make (a_path)
			set_current_open_mode (l_om)
			l_b := tchdbopen (hdb,c_path.item,l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
			is_open_mode_writer : is_open_mode_writer
		end


	open_writer_truncate (a_path : STRING)
			-- Creates a new database regardless if one exists
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
			exist_file : is_valid_path (a_path)
		local
			c_path : C_STRING
			l_b : BOOLEAN
			l_om : INTEGER
		do
			l_om := owriter.bit_or (otrunc)
			create c_path.make (a_path)
			set_current_open_mode (l_om)
			l_b := tchdbopen (hdb,c_path.item,l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
			is_open_mode_writer : is_open_mode_writer
		end

	open_writer_syncronize (a_path : STRING)
			-- Every transaction synchronizes updated contents with the device
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
			exist_file : is_valid_path (a_path)
		local
			c_path : C_STRING
			l_b : BOOLEAN
			l_om : INTEGER
		do
			l_om := owriter.bit_or (otsync)
			create c_path.make (a_path)
			set_current_open_mode (l_om)
			l_b := tchdbopen (hdb,c_path.item,l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
			is_open_mode_writer : is_open_mode_writer
		end

	open_writer_no_locking (a_path : STRING)
			-- Open the database file without file locking
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
			exist_file : is_valid_path (a_path)
		local
			c_path : C_STRING
			l_b : BOOLEAN
			l_om : INTEGER
		do
			l_om := owriter.bit_or (onolck)
			create c_path.make (a_path)
			set_current_open_mode (l_om)
			l_b := tchdbopen (hdb,c_path.item,l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
			is_open_mode_writer : is_open_mode_writer
		end


	open_writer_no_blocking (a_path : STRING)
			-- locking is performed without blocking
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
			exist_file : is_valid_path (a_path)
		local
			c_path : C_STRING
			l_b : BOOLEAN
			l_om : INTEGER
		do
			l_om := owriter.bit_or (olcknb)
			create c_path.make (a_path)
			set_current_open_mode (l_om)
			l_b := tchdbopen (hdb,c_path.item,l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
			is_open_mode_reader : is_open_mode_reader
		end


	open_reader (a_path : STRING)
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
			exist_file : is_valid_path (a_path)
		local
			c_path : C_STRING
			l_b : BOOLEAN
		do
			create c_path.make (a_path)
			set_current_open_mode (oreader)
			l_b := tchdbopen (hdb,c_path.item,oreader)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
			is_open_mode_reader : is_open_mode_reader
		end


	open_reader_no_locking (a_path : STRING)
			--  opens the database file without file locking
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
			exist_file : is_valid_path (a_path)
		local
			c_path : C_STRING
			l_b : BOOLEAN
			l_om : INTEGER
		do
			l_om := oreader.bit_or (onolck)
			create c_path.make (a_path)
			set_current_open_mode (l_om)
			l_b := tchdbopen (hdb,c_path.item, l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
			is_open_mode_reader : is_open_mode_reader
		end

	open_reader_no_blocking (a_path : STRING)
			-- locking is performed without blocking
		require
			is_database_closed : not is_open
			is_valid_path : a_path /= Void and not a_path.is_empty
			exist_file : is_valid_path (a_path)
		local
			c_path : C_STRING
			l_b : BOOLEAN
			l_om : INTEGER
		do
			l_om := oreader.bit_or (olcknb)
			create c_path.make (a_path)
			set_current_open_mode (l_om)
			l_b := tchdbopen (hdb,c_path.item,l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
		end

feature -- Close and Delete

	close
		-- Close a Hash Database
		require
			is_database_open : is_open
		local
			l_b : BOOLEAN
		do
			l_b := tchdbclose (hdb)
			if not l_b then
				has_error := True
			else
				is_open := False
			end
		ensure
			is_database_closed : not is_open
		end

	delete
		-- Delete a Hash Database
		do
			tchdbdel (hdb)
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
	valid_open_modes : ARRAY[INTEGER]
			-- valid open database modes
		once
			Result := <<owriter,owriter.bit_or (ocreat),owriter.bit_or(otrunc),owriter.bit_or (otsync),owriter.bit_or (olcknb),owriter.bit_or (onolck),oreader,oreader.bit_or (olcknb),oreader.bit_or (onolck)>>
		end
feature -- Status Report

	is_valid_path (a_path : STRING) : BOOLEAN
			-- Is `a_path' a valid path ?
			-- The file exist and is readeble?
		do
			if a_path /= void and then not a_path.is_empty then
				Result := file_system.file_exists (a_path) and file_system.is_file_readable (a_path)
			else
				Result := False
			end
		end

	is_valid_open_mode ( a_mode : INTEGER) :BOOLEAN
			-- Does `a_mode' represent a valid open mode?
		 do
		 	Result := valid_open_modes.has (a_mode)
		 end


	current_open_mode : INTEGER
   			-- Represent a valid open mode

feature {NONE} -- Implementation
	set_current_open_mode (a_mode : INTEGER)
	 		-- Set the `current_open_mode' as `a_mode'
	 		do
	 			current_open_mode := a_mode
	 		ensure
	 			set_current_mode : current_open_mode = a_mode
	 		end

	is_open_mode_reader_implementation : BOOLEAN
   			-- is the database open in a reader mode?
   		do
   			if current_open_mode = oreader or else current_open_mode = oreader.bit_or (onolck) or else  current_open_mode = oreader.bit_or (olcknb) then
   				Result := True
   			else
   				Result := False
   			end
   		end

	full_message_implementation : STRING
		do
			Result := error_message (error_code)
		end


	get_string_implementation (a_key: POINTER): POINTER
			-- Deferred implementation of get_string
			-- Retrieve a string record in a Hash database object. 	
		do
			Result := tchdbget2 (hdb, a_key)
		end

	records_number_implementation: NATURAL_64
			-- Deferred implementation of records_number
		do
			Result := tchdbrnum (hdb)
		end

	put_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_string
		do
			Result := tchdbput2 (hdb, a_key, a_value)
		end

	put_keep_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_keep_string
		do
			Result := tchdbputkeep2 (hdb, a_key, a_value)
		end

	out_string_implementation (a_key: POINTER): BOOLEAN
			-- Deferred implementation of out_string
		do
			Result := tchdbout2 (hdb, a_key)
		end

	error_message_implementation (a_code: INTEGER_32): POINTER
			-- Deferred Implementation of error message
		do
			Result := tchdberrmsg (a_code)
		end

	error_code_implementation: INTEGER_32
			-- Deferred implementation of error_code
		do
			Result := tchdbecode (hdb)
		end

	file_size_implementation: NATURAL_64
			-- Deferred implementation of full_size
		do
			Result := tchdbfsiz (hdb)
		end

	iterator_next_string_implementation: POINTER
			-- deferred implementation
		do
			Result := tchdbiternext2 (hdb)
		end

	iterator_init_implementation: BOOLEAN
		do
			Result := tchdbiterinit (hdb)
		end

	hdb: POINTER
		-- Hast database object


invariant
	hash_database_created: hdb /= default_pointer


end -- class HDB_API

