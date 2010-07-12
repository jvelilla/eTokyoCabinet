note
	description: "[
		Abstract database is a set of interfaces to use on-memory hash database, on-memory tree database, 
		hash database, B+ tree database, fixed-length database, and table database with the same API ADB_API.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADB_API

inherit
	TC_ADB_API
	WRAPPER_BASE
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

feature -- Access

	is_open: BOOLEAN
			-- is the database open?

	error_description: STRING
			-- Textual description of error
		require
			has_error: has_error
		do
			Result := internal_message
		ensure
			result_exists: Result /= Void
			result_not_empty: not Result.is_empty
		end

	retrieve (a_key: STRING): STRING
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
				free (r)
			end
		end

	records_number: NATURAL_64
			--Get the number of records.
		require
			is_open_database: is_open
		do
			Result := records_number_implementation
		end

	size: NATURAL_64
		-- Get the size of the database of an abstract database object.
		-- The return value is the size of the database or 0 if the object does not connect to any
		-- database instance

		require
			is_open_database: is_open
		do
			Result := file_size_implementation
		end


	forward_matching_keys ( a_prefix : STRING) : LIST[STRING]
			-- Get forward matching string keys in an abstract database object.
			-- The return value is a list object of the corresponding keys.
			-- It returns an empty list even if no key corresponds.
		require
			is_open_database : is_open
		local
			l_api : LIST_API
			c_prefix : C_STRING
		do
			create c_prefix.make (a_prefix)
			create l_api.make_by_pointer (tcadbfwmkeys2 (adb, c_prefix.item, -1))
			Result := l_api.as_list
			l_api.delete
		end

	record_size ( a_key : STRING) : INTEGER_32
			-- Get the size of the value of a string record in an abstract database object.
			-- If successful, the return value is the size of the value of the corresponding record, else,
			-- it is -1.
		local
			c_key : C_STRING
		do
			create c_key.make (a_key)
			Result := tcadbvsiz2 (adb, c_key.item)
		end
feature -- Open Database

	open (a_name: STRING)
			--	 Open an abstract database.
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
			is_database_closed: not is_open
			is_valid_name: a_name /= Void and not a_name.is_empty
		local
			c_name: C_STRING
			l_b: BOOLEAN
		do
			create c_name.make (a_name)
			l_b := tcadbopen (adb, c_name.item)
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
			is_database_open: is_open
		local
			l_b: BOOLEAN
		do
			l_b := tcadbclose (adb)
			if not l_b then
				has_error := True
				internal_message := "Close Abstract Database Error"
			else
				is_open := False
			end
		ensure
			is_database_closed: not is_open
		end

	delete
			-- Delete an Abstract Database
		do
			tcadbdel (adb)
			is_open := False
		ensure
			is_database_closed: not is_open
		end

feature -- Change Element

	put (a_key: STRING; a_value: STRING)
			-- Is used in order to store a string record into a database object.
		require
			is_open_database_writer: is_open
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
				internal_message := "Abstract Database put Error"
			end
		end

	put_keep (a_key: STRING; a_value: STRING)
			-- Is used in order to store a new string record into a database object.
			-- If a record with the same key exists in the database, this function has no effect.
		require
			is_open_database_writer: is_open
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
				internal_message := "Abstract Database put_keep Error"
			end
		end



	put_cat (a_key: STRING; a_value: STRING)
			-- Concatenate a string value at the end of the existing record in an abstract database object.
			-- If there is no corresponding record, a new record is created.
		require
			is_open_database_writer: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
			is_valid_value: a_value /= Void and (not a_value.is_empty)
		local
			c_key: C_STRING
			c_value: C_STRING
			l_b: BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_b := tcadbputcat2 (adb,c_key.item, c_value.item)
			if not l_b then
				has_error := True
				internal_message := "Abstract Database put_cat Error"
			end
		end

	prune (a_key: STRING)
			-- remove a record by a key `a_key'
		require
			is_open_database_writer: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
		local
			c_key: C_STRING
			l_b: BOOLEAN
		do
			create c_key.make (a_key)
			l_b := out_string_implementation (c_key.item)
			if not l_b then
				has_error := True
				internal_message := "Abstract Database prune Error"
			end
		end

feature -- Database Control
	synchronize
			-- Synchronize updated contents of an abstract database object with the file and the device.
			--  If not successful, has_error will be true.
		local
			b : BOOLEAN
		do
			 b := tcadbsync (adb)
			 if not b then
			 	has_error := True
			 	internal_message := "Abstract Database synchronize Error"
			 end
		end


	path  : STRING
			--  The return value is the path of the database file or `NULL' if the object does not connect to
			--  any database.
			--  "*" stands for on-memory hash database.
			--	"+" stands for on-memory tree database.
		require
			is_open_database : is_open
		local
			r : POINTER
		do
			r := tcadbpath (adb)
			if r /= default_pointer then
				create Result.make_from_c (r)
			end
	 	end

feature -- Remove
	vanish , wipe_out
			--Remove all records of a abstract database object.
		require
			is_database_open_writer : is_open
		local
			b : BOOLEAN
		do
		 	b := tcadbvanish (adb)
		 	if not b then
		 		has_error := True
		 		internal_message := "Abstract Database wipe_out Error"
		 	end
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
				internal_message := "Abstract Database iterator_init Error"
			end
		end

	iterator_next: STRING
			-- get the next key of the iterator
		require
			is_open_database: is_open
		local
			r: POINTER
		do
			r := iterator_next_string_implementation
			if r /= default_pointer then
				create Result.make_from_c (r)
				free(r)
			end
		end

feature -- Status Report

	has_error: BOOLEAN
			-- Did an error occur?

feature -- Status Settings

	clean_error
			-- Reset the last error.
		do
			has_error := False
		ensure
			no_error: not has_error
		end


feature -- Transaction

	transaction_begin
			-- Begin the transaction of a abstract database object.
		require
			is_open_database_writer: is_open
		local
			l_b : BOOLEAN
		do
			l_b := tcadbtranbegin (adb)
			if not l_b  then
				has_error := True
				internal_message := "Abstract Database transaction_begin Error"
			end
		end


	transaction_commit
			-- Commit the transaction of a abstract database object.
		require
			is_open_database_writer: is_open
		local
			l_b : BOOLEAN
		do
			l_b := tcadbtrancommit (adb)
			if not l_b  then
				has_error := True
				internal_message := "Abstract Database transaction_commit Error"
			end
		end


	transaction_abort
			-- Abort the transaction of a abstract database object.
		require
			is_open_database_writer: is_open
		local
			l_b : BOOLEAN
		do
			l_b := tcadbtranabort (adb)
			if not l_b  then
				has_error := True
				internal_message := "Abstract Database transaction_abort Error"
			end
		end

feature {NONE} -- Implementation

	internal_message: STRING


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
	non_empty_description: has_error implies (error_description /= Void and (not error_description.is_empty))

end -- class ADB_API

