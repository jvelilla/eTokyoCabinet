note
	description: "Summary description for {ADB_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADB_API
inherit
	DBM

	TC_ADB_API

create
	make

feature {NONE} -- Initialization

	make
			-- Create a hash database object
		do
			adb := tcadbnew
			is_open := False
			has_error := False
		end
feature -- Open Database

	open (a_name : STRING)
			--	/* Open an abstract database.
			--   `name' specifies the name of the database.  If it is "*", the database will be an on-memory
			--   hash database.  If it is "+", the database will be an on-memory tree database.  If its suffix
			--   is ".tch", the database will be a hash database.  If its suffix is ".tcb", the database will
			--   be a B+ tree database.  If its suffix is ".tcf", the database will be a fixed-length database.
			--   If its suffix is ".tct", the database will be a table database.  Otherwise, this function
			--   fails.  Tuning parameters can trail the name, separated by "#".  Each parameter is composed of
			--   the name and the value, separated by "=".  On-memory hash database supports "bnum", "capnum",
			--   and "capsiz".  On-memory tree database supports "capnum" and "capsiz".  Hash database supports
			--   "mode", "bnum", "apow", "fpow", "opts", "rcnum", "xmsiz", and "dfunit".  B+ tree database
			--   supports "mode", "lmemb", "nmemb", "bnum", "apow", "fpow", "opts", "lcnum", "ncnum", "xmsiz",
			--   and "dfunit".  Fixed-length database supports "mode", "width", and "limsiz".  Table database
			--   supports "mode", "bnum", "apow", "fpow", "opts", "rcnum", "lcnum", "ncnum", "xmsiz", "dfunit",
			--   and "idx".
			--   If successful, the return value is true, else, it is false.
			--   The tuning parameter "capnum" specifies the capacity number of records.  "capsiz" specifies
			--   the capacity size of using memory.  Records spilled the capacity are removed by the storing
			--   order.  "mode" can contain "w" of writer, "r" of reader, "c" of creating, "t" of truncating,
			--   "e" of no locking, and "f" of non-blocking lock.  The default mode is relevant to "wc".
			--   "opts" can contains "l" of large option, "d" of Deflate option, "b" of BZIP2 option, and "t"
			--   of TCBS option.  "idx" specifies the column name of an index and its type separated by ":".
			--   For example, "casket.tch#bnum=1000000#opts=ld" means that the name of the database file is
			--   "casket.tch", and the bucket number is 1000000, and the options are large and Deflate. */
		require
			is_database_closed : not is_open
			is_valid_name : a_name /= Void and not a_name.is_empty
		local
			c_name : C_STRING
			l_b : BOOLEAN
		do
			create c_name.make (a_name)
			l_b := tcadbopen (adb,c_name.item)
			if not l_b then
				has_error := True
				internal_message := "Open Abstract Database Error"
			else
				is_open := True
			end
		end

feature -- Close and Delete

	close
		-- Close an Abstract Database
		require
			is_database_open : is_open
		local
			l_b : BOOLEAN
		do
			l_b := tcadbclose (adb)
			if not l_b then
				has_error := True
				internal_message := "Close Abstract Database Error"
			else
				is_open := False
			end
		ensure
			is_database_closed : not is_open
		end

	delete
		-- Delete an Abstract Database
		do
			tcadbdel (adb)
			is_open := False
		ensure
			is_database_closed : not is_open

		end
feature -- Error Messages

	error_message (a_code: INTEGER_32): STRING
			-- Get the message string corresponding to an error code.
		do
		end

	error_code: INTEGER_32
			-- 	Get the last happened error code of a database object.
		do
		end


feature {NONE} -- Implementation
	is_open_mode_reader_implementation : BOOLEAN
   			-- is the database open in a reader mode?
		do
   			-- Check this!!!
   		end

	internal_message : STRING

	full_message_implementation : STRING
		do
		end

	get_string_implementation (a_key: POINTER): POINTER
			-- Deferred implementation of get_string
			-- Retrieve a string record in a Hash database object. 	
		do
			Result := tcadbget2 (adb, a_key)
		end

	records_number_implementation: NATURAL_64
			-- Deferred implementation of records_number
		do
			Result := tcadbrnum (adb)
		end

	put_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_string
		do
			Result := tcadbput2 (adb, a_key, a_value)
		end

	put_keep_string_implementation (a_key: POINTER; a_value: POINTER): BOOLEAN
			-- deferred implementation of put_keep_string
		do
			Result := tcadbputkeep2 (adb, a_key, a_value)
		end

	out_string_implementation (a_key: POINTER): BOOLEAN
			-- Deferred implementation of out_string
		do
			Result := tcadbout2 (adb, a_key)
		end

	error_message_implementation (a_code: INTEGER_32): POINTER
			-- Deferred Implementation of error message
		do

		end

	error_code_implementation: INTEGER_32
			-- Deferred implementation of error_code
		do

		end

	file_size_implementation: NATURAL_64
			-- Deferred implementation of full_size
		do
			Result := tcadbsize (adb)
		end

	iterator_next_string_implementation: POINTER
			-- deferred implementation
		do
			Result := tcadbiternext2 (adb)
		end

	iterator_init_implementation: BOOLEAN
		do
			Result := tcadbiterinit (adb)
		end

	adb: POINTER
		-- Abstract database object


invariant
	abstract_database_created: adb /= default_pointer
end
