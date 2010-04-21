note
	description: "Summary description for {HDB_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HDB_API

inherit
	TC_HDB_API

create
	make

feature {NONE} -- Initialization

	make
			-- Create a hash database object
		do
			hdb := tchdbnew
			is_open := False
		end

feature -- Access

	is_open: BOOLEAN
			-- is the hdb open?

	database_file_size: NATURAL_64
			--Size of the database file of a hash database object.
			--The return value is the size of the database file or 0 if the object does not connect to any
			--database file.
		require
			is_open_hdb: is_open
		do
			Result := tchdbfsiz (hdb)
		ensure
			database_size: Result >= 0
		end

	size: NATURAL_64
			--	get the number of records of a hash database object
		require
			is_open_hdb: is_open
		do
			Result := tchdbrnum (hdb)
		ensure
			number_of_records: Result >= 0
		end

	get_string (a_key: STRING_8): STRING_8
		require
			is_open_hdb: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
		local
			c_key: C_STRING
			l_r: POINTER
		do
			create c_key.make (a_key)
			l_r := tchdbget2 (hdb, c_key.item)
			if l_r /= default_pointer then
				create Result.make_from_c (l_r)
			end
		end

	get_size_record_string (a_key: STRING_8): INTEGER_32
			--get the size of the value of a string record in a hash database object.
		require
			is_open_hdb: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
		local
			c_key: C_STRING
		do
			create c_key.make (a_key)
			Result := tchdbvsiz2 (hdb, c_key.item)
		end

feature -- Open Database

	open (a_path: STRING_8; an_omode: INTEGER_32)
			-- to open a database file `a_path' and connect a hash database object
			-- using an specific mode of connection `an_omode'
		require
			database_is_closed: is_open = False
			valid_path: (a_path /= Void) and (not a_path.is_empty)
		local
			l_boolean: BOOLEAN
			l_path: C_STRING
		do
			create l_path.make (a_path)
			l_boolean := tchdbopen (hdb, l_path.item, an_omode)
			if l_boolean = True then
				is_open := True
			end
		ensure
			database_opened: is_open = True
		end

feature -- Close Database

	delete
			-- 	the current database object is deleted
		do
			tchdbdel (hdb)
			is_open := False
		ensure
			database_closed: is_open = False
		end

feature -- Change Element

	put_string (a_key: STRING_8; a_value: STRING_8)
			-- Is used in order to store a string record into a hash database object.
		require
			is_open_hdb: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
			is_valid_value: a_value /= Void and (not a_value.is_empty)
		local
			c_key: C_STRING
			c_value: C_STRING
			l_b: BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_b := tchdbput2 (hdb, c_key.item, c_value.item)
		end

	put_keep_string (a_key: STRING_8; a_value: STRING_8)
			-- Is used in order to store a new string record into a hash database object.
			-- If a record with the same key exists in the database, this function has no effect.
		require
			is_open_hdb: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
			is_valid_value: a_value /= Void and (not a_value.is_empty)
		local
			c_key: C_STRING
			c_value: C_STRING
			l_b: BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_b := tchdbputkeep2 (hdb, c_key.item, c_value.item)
		end

	put_cat_string (a_key: STRING_8; a_value: STRING_8)
		require
			is_open_hdb: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
			is_valid_value: a_value /= Void and (not a_value.is_empty)
		local
			c_key: C_STRING
			c_value: C_STRING
			l_b: BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_b := tchdbputcat2 (hdb, c_key.item, c_value.item)
		end

	put_asyncronic_string (a_key: STRING_8; a_value: STRING_8)
		require
			is_open_hdb: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
			is_valid_value: a_value /= Void and (not a_value.is_empty)
		local
			c_key: C_STRING
			c_value: C_STRING
			l_b: BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_b := tchdbputasync2 (hdb, c_key.item, c_value.item)
		end

	remove_string (a_key: STRING_8)
		require
			is_open_hdb: is_open
			is_valid_key: a_key /= Void and (not a_key.is_empty)
		local
			c_key: C_STRING
			l_b: BOOLEAN
		do
			create c_key.make (a_key)
			l_b := tchdbout2 (hdb, c_key.item)
		end

	vanish
			-- to remove all records of a hash database object.	
		require
			is_open_hdb: is_open
		local
			l_b: BOOLEAN
		do
			l_b := tchdbvanish (hdb)
		end

feature -- Iterator

	initialize_iterator: BOOLEAN
			-- Initialize the iterator of a hash database object.
		require
			is_open_hdb: is_open
		do
			Result := tchdbiterinit (hdb)
		end

	iterator_next_string : STRING
			-- Get the next key string of the iterator of a hash database object.
		require
			is_open_hdb: is_open
		local
			c_key : STRING
			r : POINTER
		do
			r := tchdbiternext2 (hdb)
			if r /= default_pointer then
				create Result.make_from_c(r)
			end
		end

feature -- Error Message

	error_message (an_ecode: INTEGER_32) : STRING
			-- get the message string corresponding to an error code `an_ecode'
		require
			is_open_hdb: is_open
		do
			create Result.make_from_c(tchdberrmsg (an_ecode))
		end

	error_code 	: INTEGER_32
			--Get the last happened error code of a hash database object.
		require
			is_open_hdb: is_open
		do
			Result := tchdbecode (hdb)
		end

feature -- Transaction

	begin_transaction
			-- Begin the transaction of a hash database object.
		require
			is_open_hdb: is_open
		local
			l_b : BOOLEAN
		do
			l_b := tchdbtranbegin (hdb)
		end


	commit_transaction
			-- Commit the transaction of a hash database object.
		require
			is_open_hdb: is_open
		local
			l_b : BOOLEAN
		do
			l_b := tchdbtrancommit (hdb)
		end


	abort_transaction
		-- Abort the transaction of a hash database object.
		require
			is_open_hdb: is_open
		local
			l_b : BOOLEAN
		do
			l_b := tchdbtranabort (hdb)
		end
feature {NONE} -- Implementation

	hdb: POINTER

invariant
	hash_database_created: hdb /= default_pointer

end -- class HDB_API

