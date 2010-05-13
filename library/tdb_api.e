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

	KL_SHARED_FILE_SYSTEM

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
			l_b := tctdbopen (tdb,c_path.item,owriter)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
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
			l_b := tctdbopen (tdb,c_path.item,l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
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
			l_b := tctdbopen (tdb,c_path.item,l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
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
			l_b := tctdbopen (tdb,c_path.item,l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
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
			l_b := tctdbopen (tdb,c_path.item,l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
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
			l_b := tctdbopen (tdb,c_path.item,l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
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
			l_b := tctdbopen (tdb,c_path.item,oreader)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
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
			l_b := tctdbopen (tdb,c_path.item, l_om)
			if not l_b then
				has_error := True
			else
				is_open := True
			end
		ensure
			valid_open_mode: is_valid_open_mode (current_open_mode)
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
			l_b := tctdbopen (tdb,c_path.item,l_om)
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

feature -- Database Control

	synchronize
			--Synchronize updated contents of a table database object with the file and the device.
		local
			b : BOOLEAN
		do
			b := tctdbsync (tdb)
			if not b then
				has_error := True
			end
		end

	optimize (a_bnum : INTEGER_64; an_apow: INTEGER_8; a_fpow : INTEGER_8; an_opts : NATURAL_8)
			-- Optimize the file of a table database object.
			-- `a_bnum' specifies the number of elements of the bucket array.  If it is not more than 0, the
			--   default value is specified.  The default value is two times of the number of records.
			-- `an_apow' specifies the size of record alignment by power of 2.  If it is negative, the current
			--   setting is not changed.
			--  `a_fpow' specifies the maximum number of elements of the free block pool by power of 2.  If it
			--   is negative, the current setting is not changed.
			--  `an_opts' specifies options by bitwise-or: `BDBTLARGE' specifies that the size of the database
			--   can be larger than 2GB by using 64-bit bucket array, `BDBTDEFLATE' specifies that each record
			--   is compressed with Deflate encoding, `BDBTBZIP' specifies that each record is compressed with
			--   BZIP2 encoding, `BDBTTCBS' specifies that each record is compressed with TCBS encoding.  If it
			--   is `UINT8_MAX', the current setting is not changed.
			--   This function is useful to reduce the size of the database file with data fragmentation by
			--   successive updating
		local
			b : BOOLEAN
		do
			b := tctdboptimize (tdb, a_bnum, an_apow, a_fpow, an_opts)
			if not b then
				has_error := true
			end
		end

	default_optimize
			-- Optimize the database file.
			-- Call optimize(-1, -1, -1, 0xff)
		do
			optimize(-1, -1, -1, 0xff)
		end

	path  : STRING
			--Get the file path of a table database object.
			--  The return value is the path of the database file or `NULL' if the object does not connect to
			--  any database file.
		local
			r : POINTER
		do
			r := tctdbpath (tdb)
			if r /= default_pointer then
				create Result.make_from_c (r)
			end
		end

	tune (a_bnum : INTEGER_64; an_apow : INTEGER_8; a_fpow : INTEGER_8; an_opts : NATURAL_8)
			-- Set the tuning parameters of a table database object.
			-- `a_bnum' specifies the number of elements of the bucket array.  If it is not more than 0, the
			--   default value is specified.  The default value is 131071.  Suggested size of the bucket array
			--   is about from 0.5 to 4 times of the number of all records to be stored.
			-- `an_apow' specifies the size of record alignment by power of 2.  If it is negative, the default
			--   value is specified.  The default value is 4 standing for 2^4=16.
			-- `an_fpow' specifies the maximum number of elements of the free block pool by power of 2.  If it
			--  is negative, the default value is specified.  The default value is 10 standing for 2^10=1024.
			--  `an_opts' specifies options by bitwise-or: `TDBTLARGE' specifies that the size of the database
			--   can be larger than 2GB by using 64-bit bucket array, `TDBTDEFLATE' specifies that each record
			--   is compressed with Deflate encoding, `TDBTBZIP' specifies that each record is compressed with
			--   BZIP2 encoding, `TDBTTCBS' specifies that each record is compressed with TCBS encoding.
		require
			is_database_close : not is_open
		local
			b:  BOOLEAN
		do
			b := tctdbtune (tdb, a_bnum, an_apow, a_fpow, an_opts)
			if not b then
				has_error := true
			end
		end


	set_cache ( a_rcnum : INTEGER_32; a_lcnum : INTEGER_32; a_ncnum : INTEGER_32)
			--Set the caching parameters of a table database object.
			-- `a_rcnum' specifies the maximum number of records to be cached.  If it is not more than 0, the
			--   record cache is disabled.  It is disabled by default.
			--  `a_lcnum' specifies the maximum number of leaf nodes to be cached.  If it is not more than 0,
			--   the default value is specified.  The default value is 4096.
			--  `a_ncnum' specifies the maximum number of non-leaf nodes to be cached.  If it is not more than 0,
			--   the default value is specified.  The default value is 512.
		require
			is_dabastabase_close : not is_open
		local
			b : BOOLEAN
		do
			b := tctdbsetcache (tdb, a_rcnum, a_lcnum, a_ncnum)
			if not b then
				has_error := true
			end
		end


	set_extra_mapped_memory (a_xmsiz : INTEGER_64)
			-- Set the size of the extra mapped memory of a table database object.
			-- `a_xmsiz' specifies the size of the extra mapped memory.  If it is not more than 0, the extra
			--  mapped memory is disabled.  The default size is 67108864.
		require
			is_database_close : not is_open
		local
			b : BOOLEAN
		do
			b := tctdbsetxmsiz (tdb, a_xmsiz)
		end


	set_defragmentation_unit (a_dfunit : INTEGER_32)
			--Set the unit step number of auto defragmentation of a table database object.
			--`a_dfunit' specifie the unit step number.  If it is not more than 0, the auto defragmentation
			-- is disabled.  It is disabled by default.
		require
			is_database_close : not is_open
		local
			b: BOOLEAN
		do
			b := tctdbsetdfunit (tdb, a_dfunit)
			if not b then
				has_error := true
			end
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

	generate_unique_id : INTEGER_64
		--Generate a unique ID number of a table database object.
		--   The return value is the new unique ID number or -1 on failure. */
		require
			is_database_open : is_open
		do
			Result := tctdbgenuid (tdb)
			if Result = -1 then
				has_error := true
			end
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


	put_cat_string (a_key: STRING; a_value: STRING)
		--	Concatenate columns in a table database object with with a tab separated column string.
		--  `a_key' specifies the string of the primary key.
		--  `a_value' specifies the string of the the tab separated column string where the name and the
		--   value of each column are situated one after the other.
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
			l_b := tctdbputcat3 (tdb, c_key.item, c_value.item)
			if not l_b then
				has_error := True
			end
		end
feature -- Remove
	vanish
		--Remove all records of a table database object.
		require
			is_database_open : is_open
		local
			b : BOOLEAN
		do
		 	b := tctdbvanish (tdb)
		 	if not b then
		 		has_error := True
		 	end
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

feature -- Representation
	tdb: POINTER
		-- Table database object


invariant
	table_database_created: tdb /= default_pointer

end
