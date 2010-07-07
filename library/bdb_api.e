note
	description: "B-Tree database; keys may have multiple values"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BDB_API

inherit
	DBM

	TC_BDB_API

	TC_BDB_CURSOR

	KL_SHARED_FILE_SYSTEM
create
	make

feature {NONE} -- Initialization

	make
			-- Create a B-tree database object
		do
			bdb := tcbdbnew
			is_open := False
			has_error := False
		end

feature -- Access
	valid_open_modes : ARRAY[INTEGER]
			-- valid open database modes
		once
			Result := <<owriter,owriter.bit_or (ocreat),owriter.bit_or(otrunc),owriter.bit_or (otsync),owriter.bit_or (olcknb),owriter.bit_or (onolck),oreader,oreader.bit_or (olcknb),oreader.bit_or (onolck)>>
		end

	range ( a_start_key : STRING; key_start_inclusive:BOOLEAN; an_end_key : STRING; key_end_inclusive:BOOLEAN) : LIST[STRING]
			--	Get string keys of ranged records in a B+ tree database object.
			-- `a_start_key' specifies the string of the key of the beginning border.  If it is `NULL', the first
			-- record is specified.
			-- `key_start_inclusive' specifies whether the beginning border is inclusive or not.
			-- `an_end_key' specifies the string of the key of the ending border.  If it is `NULL', the last
			-- record is specified.
			-- `key_end_inclusive' specifies whether the ending border is inclusive or not.
			-- The return value is a list object of the keys of the corresponding records.
			-- It returns an empty list even if no record corresponds.
			-- Because the object of the return value is created with the function `tclistnew', it should
			-- be deleted with the function `tclistdel' when it is no longer in use.
		require
			is_database_open : is_open
		local
			c_skey: C_STRING
			c_ekey: C_STRING
			l_list : LIST_API
		do
				create c_skey.make (a_start_key)
				create c_ekey.make (an_end_key)
				create l_list.make_by_pointer(tcbdbrange2 (bdb, c_skey.item,key_start_inclusive, c_ekey.item, key_end_inclusive,-1))
				--   `max' specifies the maximum number of keys to be fetched.  If it is negative, no limit is specified.
				Result := l_list.as_list
				l_list.delete
		end


	retrieve_list ( a_key : STRING ) : LIST[STRING]
			-- retrieve records in a B+ tree database object.
			-- If successful, the return value is a list object of the values of the corresponding records. `NULL' is returned if no record corresponds.
		require
			is_database_open : is_open
		local
			c_key :C_STRING
			l_list : LIST_API
		do
			create c_key.make (a_key)
			create l_list.make_by_pointer (tcbdbget4 (bdb, c_key.item,a_key.count))
			Result := l_list.as_list
			l_list.delete
		end


	forward_matching_keys ( a_prefix : STRING) : LIST[STRING]
			--  Get forward matching string keys in a B+ tree database object.
			--   `a_prefix' specifies the string of the prefix.
			--   The return value is a list object of the corresponding keys.
			--   It returns an empty list even if no key corresponds.
		require
			is_open_database : is_open
		local
			c_prefix : C_STRING
			l_list : LIST_API
		do
			create c_prefix.make (a_prefix)
			create l_list.make_by_pointer (tcbdbfwmkeys2 (bdb, c_prefix.item,-1))
			--   `max' specifies the maximum number of keys to be fetched.  If it is negative, no limit is
			--   specified.
			Result := l_list.as_list
			l_list.delete
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
			l_b := tcbdbopen (bdb,c_path.item,owriter)
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
			l_b := tcbdbopen (bdb,c_path.item,l_om)
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
			l_b := tcbdbopen (bdb,c_path.item,l_om)
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
			l_b := tcbdbopen (bdb,c_path.item,l_om)
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
			l_b := tcbdbopen (bdb,c_path.item,l_om)
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
			l_b := tcbdbopen (bdb,c_path.item,l_om)
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
			l_b := tcbdbopen (bdb,c_path.item,oreader)
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
			l_b := tcbdbopen (bdb,c_path.item, l_om)
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
			l_b := tcbdbopen (bdb,c_path.item,l_om)
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
		-- Close a B-tree Database
		require
			is_database_open : is_open
		local
			l_b : BOOLEAN
		do
			l_b := tcbdbclose (bdb)
			if not l_b then
				has_error := True
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

feature -- Change Element
	put_dup ( a_key : STRING; a_value : STRING)
			--	Store a string record into a B+ tree database object with allowing duplication of keys.
			--  `a_key' specifies the string of the key.
			--  `a_value' specifies the string of the value.
			--  If a record with the same key exists in the database, the new record is placed after the
			--  existing one.
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
			l_b := tcbdbputdup2 (bdb, c_key.item,c_value.item)
			if not l_b then
				has_error := True
			end
		end

feature -- Database Control

	set_tune (a_lmemb : INTEGER_32; a_nmemb : INTEGER_32; a_bnum : INTEGER_64; an_apow : INTEGER_8; a_fpow : INTEGER_8; a_opts :NATURAL_8 )
			-- Set the tuning parameters of a B+ tree database object.
			-- `a_lmemb' specifies the number of members in each leaf page.  If it is not more than 0, the
			--  default value is specified.  The default value is 128.
			-- `a_nmemb' specifies the number of members in each non-leaf page.  If it is not more than 0, the
			--  default value is specified.  The default value is 256.
			-- `a_bnum' specifies the number of elements of the bucket array.  If it is not more than 0, the
			--  default value is specified.  The default value is 32749.  Suggested size of the bucket array
			--  is about from 1 to 4 times of the number of all pages to be stored.
			-- `an_apow' specifies the size of record alignment by power of 2.  If it is negative, the default
			--  value is specified.  The default value is 8 standing for 2^8=256.
			-- `an_fpow' specifies the maximum number of elements of the free block pool by power of 2.  If it
			--  is negative, the default value is specified.  The default value is 10 standing for 2^10=1024.
			-- `a_opts' specifies options by bitwise-or: `TLARGE' specifies that the size of the database
			--  can be larger than 2GB by using 64-bit bucket array, `TDEFLATE' specifies that each page
			--  is compressed with Deflate encoding, `TBZIP' specifies that each page is compressed with
			--  BZIP2 encoding, `TTCBS' specifies that each page is compressed with TCBS encoding.
			--  Note that the tuning parameters should be set before the database is opened.
		require
			is_database_close : not is_open
		local
			b : BOOLEAN
		do
			b := tcbdbtune (bdb, a_lmemb, a_nmemb, a_bnum, an_apow, a_fpow, a_opts)
			if not b then
				has_error := True
			end
		end


	set_cache ( a_lcnum:INTEGER_32; a_ncnum: INTEGER_32)
			--Set the caching parameters of a B+ tree database object.
			--`a_lcnum' specifies the maximum number of leaf nodes to be cached.  If it is not more than 0,
			-- the default value is specified.  The default value is 1024.
			--`a_ncnum' specifies the maximum number of non-leaf nodes to be cached.  If it is not more than 0,
			--the default value is specified.  The default value is 512.
			--Note that the caching parameters should be set before the database is opened.
		require
			is_database_close: not is_open
		local
			b : BOOLEAN
		do
			b := tcbdbsetcache (bdb, a_lcnum, a_ncnum)
			if not b then
				has_error := True
			end
		end


	set_extra_mapped_memory (a_xmsiz:INTEGER_64)
			--Set the size of the extra mapped memory of a B+ tree database object.
			--`a_xmsiz' specifies the size of the extra mapped memory.  If it is not more than 0, the extra
			-- mapped memory is disabled.  It is disabled by default.
			-- Note that the mapping parameters should be set before the database is opened.
		require
			is_database_close : not is_open
		local
			b : BOOLEAN
		do
			b := tcbdbsetxmsiz (bdb, a_xmsiz)
			if not b then
				has_error := True
			end
		end


	set_defragmentation_unit ( a_dfunit : INTEGER_32)
			--Set the unit step number of auto defragmentation of a B+ tree database object.
			-- `a_dfunit' specifie the unit step number.  If it is not more than 0, the auto defragmentation
			--  is disabled.  It is disabled by default.
			--  Note that the defragmentation parameter should be set before the database is opened. */
			--bool tcbdbsetdfunit(TCBDB *bdb, int32_t dfunit);
		require
			is_database_close : not is_open
		local
			b : BOOLEAN
		do
			b := tcbdbsetdfunit (bdb, a_dfunit)
			if not b then
				has_error := True
			end
		end


	synchronize
			--Synchronize updated contents of a B+ tree database object with the file and the device.
			--This function is useful when another process connects to the same database file.
		require
			is_open_mode_writer : is_open_mode_writer
		local
			b : BOOLEAN
		do
			b := tcbdbsync (bdb)
			if not b then
				has_error := True
			end
		end


	db_copy (a_path : STRING)
			--   `a_path' specifies the path of the destination file.  If it begins with `@', the trailing
			--   substring is executed as a command line.
			--   The database file is assured to be kept synchronized and not modified while the copying or
			--   executing operation is in progress.  So, this function is useful to create a backup file of
			--   the database file.
		require
			is_database_open : is_open
		local
			c_path : C_STRING
			b : BOOLEAN
		do
			create c_path.make (a_path)
			b := tcbdbcopy (bdb, c_path.item)
			if not b then
				has_error := True
			end
		ensure
			is_valid_file : is_valid_path (a_path)
		end

	path  : STRING
			--Get the file path of a B+ tree database object.
			--The return value is the path of the database file.
		require
			is_open_database : is_open
		local
			r : POINTER
		do
			r := tcbdbpath (bdb)
			if r /= default_pointer then
				create Result.make_from_c (r)
			end
		end
feature -- Remove
	vanish, wipe_out
			-- Remove all records of a btree database object.
		require
			is_database_open_writer : is_open_mode_writer
		local
			b : BOOLEAN
		do
			b := tcbdbvanish (bdb)
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


feature -- Status Report
	current_open_mode : INTEGER
   			-- Represent a valid open mode


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


feature -- Transaction
	transaction_begin
			-- Begin the transaction of a B-tree database object.
		require
			is_open_database_writer: is_open_mode_writer
		local
			l_b : BOOLEAN
		do
			l_b := tcbdbtranbegin (bdb)
			if not l_b  then
				has_error := True
			end
		end


	transaction_commit
			-- Commit the transaction of a B-tree database object.
		require
			is_open_database_writer: is_open_mode_writer
		local
			l_b : BOOLEAN
		do
			l_b := tcbdbtrancommit (bdb)
			if not l_b  then
				has_error := True
			end
		end


	transaction_abort
			-- Abort the transaction of a B-tree database object.
		require
			is_open_database_writer: is_open_mode_writer
		local
			l_b : BOOLEAN
		do
			l_b := tcbdbtranabort (bdb)
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

