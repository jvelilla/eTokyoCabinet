note
	description: "{TC_ADB_API}. The abstract database API of Tokyo Cabinet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	 TC_ADB_API

feature {} -- Create an Abstract Database Object

	tcadbnew : POINTER is
		--	Create an abstract database object.
		--  The return value is the new abstract database object.
 	    external
	                "C inline use <tcadb.h>"
        alias
                "{
               	tcadbnew()
             }"
		end

feature {} -- Delete an Abstract Database Object
	tcadbdel (an_adb : POINTER)
		--	Delete an abstract database object.
		--  `adb' specifies the abstract database object.
		--void tcadbdel(TCADB *adb)
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	tcadbdel((TCADB *)$an_adb)
             }"
		end

feature  {} -- Open an Abstract Database
	tcadbopen (an_adb : POINTER; a_name : POINTER) : BOOLEAN
		--	/* Open an abstract database.
		--   `adb' specifies the abstract database object.
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
		--bool tcadbopen(TCADB *adb, const char *name);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	tcadbopen((TCADB *)$an_adb, (const char *)$a_name)
             }"
		end

feature	{} -- Close an Abstract Database Object

	tcadbclose (an_adb : POINTER) : BOOLEAN
		--	/* Close an abstract database object.
		--   `adb' specifies the abstract database object.
		--   If successful, the return value is true, else, it is false.
		--   Update of a database is assured to be written when the database is closed.  If a writer opens
		--   a database but does not close it appropriately, the database will be broken. */
		--bool tcadbclose(TCADB *adb)
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	tcadbclose((TCADB *)$an_adb)
             }"
		end

feature {} -- Store Records into the Abstract Database Object

	 tcadbput2 (an_adb:POINTER ; a_kstr:POINTER; a_vstr:POINTER) : BOOLEAN
		--	 /* Store a string record into an abstract object.
		--   `adb' specifies the abstract database object.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, it is overwritten. */
		--bool tcadbput2(TCADB *adb, const char *kstr, const char *vstr);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	tcadbput2((TCADB *)$an_adb, (const char	 *)$a_kstr, (const char *)$a_vstr)
             }"
		end


	tcadbputkeep2 (an_adb : POINTER; a_kstr: POINTER; a_vstr: POINTER) : BOOLEAN
		--	/* Store a new string record into an abstract database object.
		--  `adb' specifies the abstract database object.
		--  `kstr' specifies the string of the key.
		--  `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, this function has no effect. */
		--bool tcadbputkeep2(TCADB *adb, const char *kstr, const char *vstr);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	tcadbputkeep2((TCADB *)$an_adb, (const char *)$a_kstr, (const char *)$a_vstr)
             }"
		end


	tcadbputcat2 (an_adb : POINTER; a_kstr : POINTER ; a_vstr: POINTER) : BOOLEAN
		--/* Concatenate a string value at the end of the existing record in an abstract database object.
		--  `adb' specifies the abstract database object.
		--  `kstr' specifies the string of the key.
		--  `vstr' specifies the string of the value.
		--  If successful, the return value is true, else, it is false.
		--  If there is no corresponding record, a new record is created. */
		--bool tcadbputcat2(TCADB *adb, const char *kstr, const char *vstr);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	tcadbputcat2((TCADB *)$an_adb, (const char *)$a_kstr, (const char *)$a_vstr)
             }"
		end


	tcadbaddint(an_adb:POINTER; a_kbuf:POINTER; a_ksiz:INTEGER; a_num:INTEGER): INTEGER
		--/* Add an integer to a record in an abstract database object.
		--   `adb' specifies the abstract database object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `num' specifies the additional value.
		--   If successful, the return value is the summation value, else, it is `INT_MIN'.
		--   If the corresponding record exists, the value is treated as an integer and is added to.  If no
		--   record corresponds, a new record of the additional value is stored. */
		--int tcadbaddint(TCADB *adb, const void *kbuf, int ksiz, int num);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	tcadbaddint((TCADB *)$an_adb, (const void *)$a_kbuf, (int)$a_ksiz, (int)$a_num)
             }"
		end


	tcadbadddouble(an_adb:POINTER; a_kbuf:POINTER; a_ksiz:INTEGER; a_num:DOUBLE) : DOUBLE
		--/* Add a real number to a record in an abstract database object.
		--   `adb' specifies the abstract database object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `num' specifies the additional value.
		--   If successful, the return value is the summation value, else, it is Not-a-Number.
		--   If the corresponding record exists, the value is treated as a real number and is added to.  If
		--   no record corresponds, a new record of the additional value is stored. */
		--double tcadbadddouble(TCADB *adb, const void *kbuf, int ksiz, double num);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	tcadbadddouble((TCADB *)$an_adb, (const void *)$a_kbuf, (int)$a_ksiz, (double)$a_num)
             }"
		end

feature -- Synchronize

	tcadbsync (an_adb:POINTER) : BOOLEAN
		--/* Synchronize updated contents of an abstract database object with the file and the device.
		--  `adb' specifies the abstract database object.
		--  If successful, the return value is true, else, it is false. */
		--bool tcadbsync(TCADB *adb)
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	tcadbsync((TCADB *)$an_adb)
             }"
		end


	tcadbcopy(an_adb:POINTER; a_path:POINTER) : BOOLEAN
		--	/* Copy the database file of an abstract database object.
		--   `adb' specifies the abstract database object.
		--   `path' specifies the path of the destination file.  If it begins with `@', the trailing
		--   substring is executed as a command line.
		--   If successful, the return value is true, else, it is false.  False is returned if the executed
		--   command returns non-zero code.
		--   The database file is assured to be kept synchronized and not modified while the copying or
		--   executing operation is in progress.  So, this function is useful to create a backup file of
		--   the database file. */
		--bool tcadbcopy(TCADB *adb, const char *path);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	tcadbcopy((TCADB *)$an_adb, (const char *)$a_path)
             }"
		end
feature -- Retrive Records
	tcadbget2 (an_adb : POINTER;  a_kstr: POINTER) : POINTER
		--	/* Retrieve a string record in an abstract database object.
		--   `adb' specifies the abstract database object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is the string of the value of the corresponding record.
		--   `NULL' is returned if no record corresponds.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use. */
		--char *tcadbget2(TCADB *adb, const char *kstr);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbget2((TCADB *)$an_adb, (const char *)$a_kstr)
             }"
		end


	tcadbvsiz2(an_adb:POINTER; a_kstr:POINTER) : INTEGER_32
		--/* Get the size of the value of a string record in an abstract database object.
		--  `adb' specifies the abstract database object.
		--  `kstr' specifies the string of the key.
		--  If successful, the return value is the size of the value of the corresponding record, else,
		--  it is -1. */
		--int tcadbvsiz2(TCADB *adb, const char *kstr);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbvsiz2((TCADB *)$an_adb, (const char *)$a_kstr)
             }"
		end
feature -- Remove Records

	tcadbout2 (an_adb:POINTER; a_kstr:POINTER) : BOOLEAN
		--	/* Remove a string record of an abstract database object.
		--   `adb' specifies the abstract database object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is true, else, it is false. */
		--bool tcadbout2(TCADB *adb, const char *kstr);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbout2((TCADB *)$an_adb, (const char *)$a_kstr)
             }"
		end

	tcadbvanish (an_adb:POINTER) : BOOLEAN
		--	/* Remove all records of an abstract database object.
		--   `adb' specifies the abstract database object.
		--   If successful, the return value is true, else, it is false. */
		--bool tcadbvanish(TCADB *adb);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbvanish((TCADB *)$an_adb)
             }"
		end

feature -- Iterator

	tcadbiterinit(an_adb : POINTER) : BOOLEAN
		--/* Initialize the iterator of an abstract database object.
		--   `adb' specifies the abstract database object.
		--   If successful, the return value is true, else, it is false.
		--   The iterator is used in order to access the key of every record stored in a database. */
		--bool tcadbiterinit(TCADB *adb);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbiterinit((TCADB *)$an_adb)
             }"
		end

	tcadbiternext2(an_adb : POINTER) : POINTER
		--	/* Get the next key string of the iterator of an abstract database object.
		--   `adb' specifies the abstract database object.
		--   If successful, the return value is the string of the next key, else, it is `NULL'.  `NULL' is
		--   returned when no record is to be get out of the iterator.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use.  It is possible to access every
		--   record by iteration of calling this function.  However, it is not assured if updating the
		--   database is occurred while the iteration.  Besides, the order of this traversal access method
		--   is arbitrary, so it is not assured that the order of storing matches the one of the traversal
		--   access. */
		--char *tcadbiternext2(TCADB *adb)
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbiternext2((TCADB *)$an_adb)
             }"
		end

feature -- Transaction

	tcadbtranbegin (an_adb : POINTER) : BOOLEAN
		--/* Begin the transaction of an abstract database object.
		--   `adb' specifies the abstract database object.
		--   If successful, the return value is true, else, it is false.
		--   The database is locked by the thread while the transaction so that only one transaction can be
		--   activated with a database object at the same time.  Thus, the serializable isolation level is
		--   assumed if every database operation is performed in the transaction.  All updated regions are
		--   kept track of by write ahead logging while the transaction.  If the database is closed during
		--   transaction, the transaction is aborted implicitly. */
		--bool tcadbtranbegin(TCADB *adb);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbtranbegin((TCADB *)$an_adb)
             }"
		end

	tcadbtrancommit (an_adb: POINTER) : BOOLEAN
		--/* Commit the transaction of an abstract database object.
		--   `adb' specifies the abstract database object.
		--   If successful, the return value is true, else, it is false.
		--   Update in the transaction is fixed when it is committed successfully. */
		--bool tcadbtrancommit(TCADB *adb);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbtrancommit((TCADB *)$an_adb)
             }"
		end

	tcadbtranabort(an_adb : POINTER) : BOOLEAN
		--/* Abort the transaction of an abstract database object.
		--   `adb' specifies the abstract database object.
		--   If successful, the return value is true, else, it is false.
		--   Update in the transaction is discarded when it is aborted.  The state of the database is
		--   rollbacked to before transaction. */
		--bool tcadbtranabort(TCADB *adb);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbtranabort((TCADB *)$an_adb)
             }"
		end

feature -- Queries

	tcadbpath(an_adb : POINTER) : POINTER
		--/* Get the file path of an abstract database object.
		--   `adb' specifies the abstract database object.
		--   The return value is the path of the database file or `NULL' if the object does not connect to
		--   any database.  "*" stands for on-memory hash database.  "+" stands for on-memory tree
		--   database. */
		--const char *tcadbpath(TCADB *adb);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbpath((TCADB *)$an_adb)
             }"
		end


	tcadbrnum(an_adb:POINTER) : NATURAL_64
		--		/* Get the number of records of an abstract database object.
		--   `adb' specifies the abstract database object.
		--   The return value is the number of records or 0 if the object does not connect to any database
		--   instance. */
		--uint64_t tcadbrnum(TCADB *adb)
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbrnum((TCADB *)$an_adb)
             }"
		end


	tcadbsize(an_adb : POINTER) : NATURAL_64
		--/* Get the size of the database of an abstract database object.
		--   `adb' specifies the abstract database object.
		--   The return value is the size of the database or 0 if the object does not connect to any
		--   database instance. */
		--uint64_t tcadbsize(TCADB *adb);
		external
	                "C inline use <tcadb.h>"
        alias
                "{
               	 tcadbsize((TCADB *)$an_adb)
             }"
		end


end -- class TC_ADB_API
