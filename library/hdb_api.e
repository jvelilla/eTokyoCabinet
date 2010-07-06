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

feature -- Access
	forward_matching_string_keys (a_prefix : STRING) : LIST[STRING]
		require
			is_databse_open : is_open
		local
			c_prefix : C_STRING
			l_api : LIST_API
		do
			create c_prefix.make (a_prefix)
			create l_api.make_by_pointer (tchdbfwmkeys2 (hdb, c_prefix.item,-1))
			Result := l_api.as_list
			l_api.delete
		end

	valid_open_modes : ARRAY[INTEGER]
			-- valid open database modes
		once
			Result := <<owriter,owriter.bit_or (ocreat),owriter.bit_or(otrunc),owriter.bit_or (otsync),owriter.bit_or (olcknb),owriter.bit_or (onolck),oreader,oreader.bit_or (olcknb),oreader.bit_or (onolck)>>
		end

feature -- Open Database



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

feature -- Change Element

	put_asyncrhonic_string ( a_key : STRING; a_value : STRING)
		require
			is_open_database_writer: is_open_mode_writer
			is_valid_key: a_key /= Void and (not a_key.is_empty)
			is_valid_value: a_value /= Void and (not a_value.is_empty)
		local
			c_key: C_STRING
			c_value: C_STRING
			l_b: BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_b := tchdbputasync2 (hdb, c_key.item,c_value.item)
			if not l_b then
				has_error := True
			end
		end
feature -- Database Control

	tune (a_bnum: INTEGER_64; an_apow, an_fpow: INTEGER_8; an_opts: NATURAL_8)
			--	Set the tuning parameters of a hash database object.
			--   `a_bnum' specifies the number of elements of the bucket array.  If it is not more than 0, the
			--   default value is specified.  The default value is 131071.  Suggested size of the bucket array
			--   is about from 0.5 to 4 times of the number of all records to be stored.
			--   `an_apow' specifies the size of record alignment by power of 2.  If it is negative, the default
			--   value is specified.  The default value is 4 standing for 2^4=16.
			--   `an_fpow' specifies the maximum number of elements of the free block pool by power of 2.  If it
			--   is negative, the default value is specified.  The default value is 10 standing for 2^10=1024.
			--   `an_opts' specifies options by bitwise-or: `HDBTLARGE' specifies that the size of the database
			--   can be larger than 2GB by using 64-bit bucket array, `HDBTDEFLATE' specifies that each record
			--   is compressed with Deflate encoding, `HDBTBZIP' specifies that each record is compressed with
			--   BZIP2 encoding, `HDBTTCBS' specifies that each record is compressed with TCBS encoding.
			--   Note that the tuning parameters should be set before the database is opened.
		require
			is_database_closed : not is_open
		local
			b : BOOLEAN
		do
			b := tchdbtune (hdb, a_bnum, an_apow, an_fpow, an_opts)
			if not b then
				has_error := True
			end
		end

	set_cache (a_rcnum: INTEGER_32)
			--	Set the caching parameters of a hash database object.
			--  `a_rcnum' specifies the maximum number of records to be cached.  If it is not more than 0, the
			--   record cache is disabled.  It is disabled by default.
			--   Note that the caching parameters should be set before the database is opened.
		require
			is_database_close : not is_open
		local
			b : BOOLEAN
		do
			b := tchdbsetcache (hdb, a_rcnum)
			if not b then
				has_error := True
			end
		end

	set_extra_mapped_memory (a_xmsiz: INTEGER_64)
			--	Set the size of the extra mapped memory of a hash database object.
			--  `a_xmsiz' specifies the size of the extra mapped memory.  If it is not more than 0, the extra
			--   mapped memory is disabled.  The default size is 67108864.
			--   Note that the mapping parameters should be set before the database is opened.
		require
			is_database_close : not is_open
		local
			b : BOOLEAN
		do
			b := tchdbsetxmsiz (hdb, a_xmsiz)
			if not b then
				has_error := True
			end
		end


	set_defragmentation_unit (a_dfunit: INTEGER_32)
			-- Set the unit step number of auto defragmentation of a hash database object.
			-- `a_dfunit' specifie the unit step number.  If it is not more than 0, the auto defragmentation
			--  is disabled.  It is disabled by default.
			--  Note that the defragmentation parameters should be set before the database is opened.
		require
			is_database_close : not is_open
		local
			b : BOOLEAN
		do
			b := tchdbsetdfunit (hdb, a_dfunit)
			if not b then
				has_error := True
			end
		end

	optimize (a_bnum : INTEGER_64; an_apow: INTEGER_8; a_fpow : INTEGER_8; an_opts : NATURAL_8)
			-- Optimize the file of a hash database object.
			-- `a_bnum' specifies the number of elements of the bucket array.  If it is not more than 0, the
			--  default value is specified.  The default value is two times of the number of records.
			-- `an_apow' specifies the size of record alignment by power of 2.  If it is negative, the current
			--  setting is not changed.
			--  `a_fpow' specifies the maximum number of elements of the free block pool by power of 2.  If it
			--  is negative, the current setting is not changed.
			--  `an_opts' specifies options by bitwise-or: `HDBTLARGE' specifies that the size of the database
			--   can be larger than 2GB by using 64-bit bucket array, `HDBTDEFLATE' specifies that each record
			--   is compressed with Deflate encoding, `HDBTBZIP' specifies that each record is compressed with
			--   BZIP2 encoding, `HDBTTCBS' specifies that each record is compressed with TCBS encoding.  If it
			--   is `UINT8_MAX', the current setting is not changed.
			--   This function is useful to reduce the size of the database file with data fragmentation by
			--   successive updating.
		require
			is_database_open_writer : is_open_mode_writer
		local
			b : BOOLEAN
		do
			b := tchdboptimize (hdb, a_bnum, an_apow, a_fpow, an_opts)
			if not b then
				has_error := true
			end
		end

	default_optimize
			-- Optimize the database file.
			-- Call optimize(-1, -1, -1, 0xff)
		require
			is_database_open_writer : is_open_mode_writer
		do
			optimize(-1, -1, -1, 0xff)
		end

	db_copy (a_path : STRING)
			-- Copy the database file of a hash database object.
			--	`a_path' specifies the path of the destination file.  If it begins with `@', the trailing
			--	substring is executed as a command line.
			--  The database file is assured to be kept synchronized and not modified while the copying or
			--	executing operation is in progress.  So, this function is useful to create a backup file of
			--	the database file.
		require
			is_database_open : is_open
		local
			c_path : C_STRING
			b : BOOLEAN
		do
			create c_path.make (a_path)
			b := tchdbcopy (hdb, c_path.item)
			if not b then
				has_error := True
			end
		ensure
			is_valid_file : is_valid_path (a_path)
		end


	path : STRING
			-- Get the file path of a table database object.
			-- The return value is the path of the database file.
		require
			is_open_database : is_open
		local
			r : POINTER
		do
			r := tchdbpath (hdb)
			if r /= default_pointer then
				create Result.make_from_c (r)
			end
		end


	synchronize
			--Synchronize updated contents of a table database object with the file and the device.
		require
			is_database_open_writer: is_open_mode_writer
		local
			b : BOOLEAN
		do
			b := tchdbsync (hdb)
			if not b then
				has_error := True
			end
		end


feature -- Remove
	vanish
			-- Remove all records of a hash database object.
		require
			is_database_open_writer : is_open_mode_writer
		local
			b : BOOLEAN
		do
			b := tchdbvanish (hdb)
		end


feature -- Error Message

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

feature -- Transaction
	transaction_begin
			-- Begin the transaction of a hash database object.
		require
			is_open_database_writer: is_open_mode_writer
		local
			l_b : BOOLEAN
		do
			l_b := tchdbtranbegin (hdb)
			if not l_b  then
				has_error := True
			end
		end


	transaction_commit
			-- Commit the transaction of a hash database object.
		require
			is_open_database_writer: is_open_mode_writer
		local
			l_b : BOOLEAN
		do
			l_b := tchdbtrancommit (hdb)
			if not l_b  then
				has_error := True
			end
		end


	transaction_abort
			-- Abort the transaction of a hash database object.
		require
			is_open_database_writer: is_open_mode_writer
		local
			l_b : BOOLEAN
		do
			l_b := tchdbtranabort (hdb)
			if not l_b  then
				has_error := True
			end
		end

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

