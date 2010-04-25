note
	description: "{TC_FDB_API}. The fixed-length database API of Tokyo Cabinet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TC_FDB_API

feature -- Constants

	ESUCCESS : INTEGER is 0
		--error code: success

	ETHREAD : INTEGER is 1
		--error code: threading error

	EINVALID : INTEGER is 2
		--error code: invalid operation

	ENOFILE : INTEGER is 3
		--error code: file not found

	ENOPERM : INTEGER is 4
		--error code: no permission

	EMETA : INTEGER is 5
		--error code: invalid meta data

	ERHEAD : INTEGER is 6
		--error code: invalid record header

	EOPEN : INTEGER is 7
		--error code: open error

	ECLOSE : INTEGER is 8
		--error code: close error

	ETRUNC : INTEGER is 9
		--error code: trunc error

	ESYNC : INTEGER is 10
		--error code: sync error

	ESTAT : INTEGER is 11
		--error code: stat error

	ESEEK : INTEGER is 12
		--error code: seek error

	EREAD : INTEGER is 13
		--error code: read error

	EWRITE : INTEGER is 14
		--error code: write error

	EMMAP : INTEGER is 15
		--error code: mmap error

	ELOCK : INTEGER is 16
		--error code: lock error

	EUNLINK : INTEGER is 17
		--error code: unlink error

	ERENAME : INTEGER is 18
		--error code: rename error

	EMKDIR : INTEGER is 19
		--error code: mkdir error

	ERMDIR : INTEGER is 20
		--error code: rmdir error

	EKEEP : INTEGER is 21
		--error code: existing record

	ENOREC : INTEGER is 22
		--error code: no record found

	EMISC : INTEGER is 9999
   		--error code: miscellaneous error

	OREADER : INTEGER is 1
   		--open mode: open as a reader

	OWRITER : INTEGER is 2
   		--open mode: open as a writer

	OCREAT : INTEGER is 4
   		--open mode: writer creating

	OTRUNC : INTEGER is 8
   		--open mode: writer truncating

	ONOLCK : INTEGER is 16
   		--open mode: open without locking

	OLCKNB : INTEGER is 32
		--open mode: lock without blocking

feature -- Create Fixed Database

	tcfdbnew : POINTER
		--/* Create a fixed-length database object.
		--   The return value is the new fixed-length database object. */
		--TCFDB *tcfdbnew(void)
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbnew()
			}"
		end

feature -- Open-Close Database

	tcfdbopen (an_fdb : POINTER;  a_path: POINTER; an_omode : INTEGER_32) : BOOLEAN
		--/* Open a database file and connect a fixed-length database object.
		--   `fdb' specifies the fixed-length database object which is not opened.
		--   `path' specifies the path of the database file.
		--   `omode' specifies the connection mode: `FDBOWRITER' as a writer, `FDBOREADER' as a reader.
		--   If the mode is `FDBOWRITER', the following may be added by bitwise-or: `FDBOCREAT', which
		--   means it creates a new database if not exist, `FDBOTRUNC', which means it creates a new
		--   database regardless if one exists, `FDBOTSYNC', which means every transaction synchronizes
		--   updated contents with the device.  Both of `FDBOREADER' and `FDBOWRITER' can be added to by
		--   bitwise-or: `FDBONOLCK', which means it opens the database file without file locking, or
		--   `FDBOLCKNB', which means locking is performed without blocking.
		--   If successful, the return value is true, else, it is false. */
		--bool tcfdbopen(TCFDB *fdb, const char *path, int omode);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbopen((TCFDB *)$an_fdb, (const char *)$a_path, (int)$an_omode)
			}"
		end



	tcfdbclose (an_fdb : POINTER) : BOOLEAN
		--/* Close a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   If successful, the return value is true, else, it is false.
		--   Update of a database is assured to be written when the database is closed.  If a writer opens
		--   a database but does not close it appropriately, the database will be broken. */
		--bool tcfdbclose(TCFDB *fdb);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbclose((TCFDB *)$an_fdb)
			}"
		end

feature -- Delele a Fixed Database

	tcfdbdel (an_fdb : POINTER)
		--/* Delete a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   If the database is not closed, it is closed implicitly.  Note that the deleted object and its
		--   derivatives can not be used anymore. */
		--void tcfdbdel(TCFDB *fdb);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbdel((TCFDB *)$an_fdb)
			}"
		end

feature -- Message Error Code

	tcfdberrmsg	(an_ecode : INTEGER_32) : POINTER
		--	/* Get the message string corresponding to an error code.
		--   `ecode' specifies the error code.
		--   The return value is the message string of the error code. */
		--const char *tcfdberrmsg(int ecode)
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdberrmsg((int)$an_ecode)
			}"
		end

	tcfdbecode (an_fdb : POINTER) : INTEGER_32
		--/* Get the last happened error code of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   The return value is the last happened error code.
		--   The following error codes are defined: `TCESUCCESS' for success, `TCETHREAD' for threading
		--   error, `TCEINVALID' for invalid operation, `TCENOFILE' for file not found, `TCENOPERM' for no
		--   permission, `TCEMETA' for invalid meta data, `TCERHEAD' for invalid record header, `TCEOPEN'
		--   for open error, `TCECLOSE' for close error, `TCETRUNC' for trunc error, `TCESYNC' for sync
		--   error, `TCESTAT' for stat error, `TCESEEK' for seek error, `TCEREAD' for read error,
		--   `TCEWRITE' for write error, `TCEMMAP' for mmap error, `TCELOCK' for lock error, `TCEUNLINK'
		--   for unlink error, `TCERENAME' for rename error, `TCEMKDIR' for mkdir error, `TCERMDIR' for
		--   rmdir error, `TCEKEEP' for existing record, `TCENOREC' for no record found, and `TCEMISC' for
		--   miscellaneous error. */
		--int tcfdbecode(TCFDB *fdb)
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbecode((TCFDB *)$an_fdb)
			}"
		end

feature -- Database Control


	tcfdbsetmutex(an_fdb : POINTER) : BOOLEAN
		--/* Set mutual exclusion control of a fixed-length database object for threading.
		--   `fdb' specifies the fixed-length database object which is not opened.
		--   If successful, the return value is true, else, it is false.
		--   Note that the mutual exclusion control is needed if the object is shared by plural threads and
		--   this function should be called before the database is opened. */
		--bool tcfdbsetmutex(TCFDB *fdb)
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbsetmutex((TCFDB *)$an_fdb)
			}"
		end


	tcfdbtune (an_fdb : POINTER; a_width : INTEGER_32;  a_limsiz : INTEGER_64) : BOOLEAN
		--	/* Set the tuning parameters of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object which is not opened.
		--   `width' specifies the width of the value of each record.  If it is not more than 0, the
		--   default value is specified.  The default value is 255.
		--   `limsiz' specifies the limit size of the database file.  If it is not more than 0, the default
		--   value is specified.  The default value is 268435456.
		--   If successful, the return value is true, else, it is false.
		--   Note that the tuning parameters should be set before the database is opened. */
		--bool tcfdbtune(TCFDB *fdb, int32_t width, int64_t limsiz);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbtune((TCFDB *)$an_fdb, (int32_t)$a_width, (int64_t)$a_limsiz)
			}"
		end



	 tcfdbsync (an_fdb : POINTER) : BOOLEAN
		--	/* Synchronize updated contents of a fixed-length database object with the file and the device.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   This function is useful when another process connects to the same database file. */
		--bool tcfdbsync(TCFDB *fdb);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbsync((TCFDB *)$an_fdb)
			}"
		end


	tcfdboptimize (an_fdb : POINTER; a_width : INTEGER_32; a_limsiz : INTEGER_64) : BOOLEAN
		--/* Optimize the file of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   `width' specifies the width of the value of each record.  If it is not more than 0, the current
		--   setting is not changed.
		--   `limsiz' specifies the limit size of the database file.  If it is not more than 0, the current
		--   setting is not changed.
		--   If successful, the return value is true, else, it is false. */
		--bool tcfdboptimize(TCFDB *fdb, int32_t width, int64_t limsiz);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdboptimize((TCFDB *)$an_fdb, (int32_t)$a_width, (int64_t)$a_limsiz)
			}"
		end



	tcfdbcopy (an_fdb : POINTER; a_path : POINTER ) : BOOLEAN
		--	/* Copy the database file of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   `path' specifies the path of the destination file.  If it begins with `@', the trailing
		--   substring is executed as a command line.
		--   If successful, the return value is true, else, it is false.  False is returned if the executed
		--   command returns non-zero code.
		--   The database file is assured to be kept synchronized and not modified while the copying or
		--   executing operation is in progress.  So, this function is useful to create a backup file of
		--   the database file. */
		--bool tcfdbcopy(TCFDB *fdb, const char *path);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbcopy((TCFDB *)$an_fdb, (const char *)$a_path)
			}"
		end



	tcfdbpath (an_fdb : POINTER) : POINTER
		--/* Get the file path of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   The return value is the path of the database file or `NULL' if the object does not connect to
		--   any database file. */
		--const char *tcfdbpath(TCFDB *fdb);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbpath((TCFDB *)$an_fdb)
			}"
		end


	tcfdbrnum (an_fdb : POINTER) : NATURAL_64
		--/* Get the number of records of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   The return value is the number of records or 0 if the object does not connect to any database
		--   file. */
		--uint64_t tcfdbrnum(TCFDB *fdb);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbrnum((TCFDB *)$an_fdb)
			}"
		end


	tcfdbfsiz (an_fdb : POINTER) : NATURAL_64
		--/* Get the size of the database file of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   The return value is the size of the database file or 0 if the object does not connect to any
		--   database file. */
		--uint64_t tcfdbfsiz(TCFDB *fdb)
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbfsiz((TCFDB *)$an_fdb)
			}"
		end

feature -- Remove Records

	tcfdbout (an_fdb : POINTER; an_id : INTEGER_64) : BOOLEAN
		--	/* Remove a record of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   `id' specifies the ID number.  It should be more than 0.  If it is `FDBIDMIN', the minimum ID
		--   number of existing records is specified.  If it is `FDBIDMAX', the maximum ID number of
		--   existing records is specified.
		--   If successful, the return value is true, else, it is false. */
		--bool tcfdbout(TCFDB *fdb, int64_t id);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbout((TCFDB *)$an_fdb, (int64_t)$an_id)
			}"
		end

	tcfdbout3 (an_fdb : POINTER; a_kstr : POINTER) : BOOLEAN
		--/* Remove a string record with a decimal key of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   `kstr' specifies the string of the decimal key.  It should be more than 0.  If it is "min",
		--   the minimum ID number of existing records is specified.  If it is "max", the maximum ID number
		--   of existing records is specified.
		--   If successful, the return value is true, else, it is false. */
		--bool tcfdbout3(TCFDB *fdb, const char *kstr);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbout3((TCFDB *)$an_fdb, (const char *)$a_kstr)
			}"
		end


	tcfdbvanish (an_fdb : POINTER) : BOOLEAN
		--	/* Remove all records of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   If successful, the return value is true, else, it is false. */
		--bool tcfdbvanish(TCFDB *fdb);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbvanish((TCFDB *)$an_fdb)
			}"
		end

feature -- Retrieve Records


	tcfdbget3 (an_fdb : POINTER; a_kstr : POINTER) : POINTER
		--/* Retrieve a string record with a decimal key in a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   `kstr' specifies the string of the decimal key.  It should be more than 0.  If it is "min",
		--   the minimum ID number of existing records is specified.  If it is "max", the maximum ID number
		--   of existing records is specified.
		--   If successful, the return value is the string of the value of the corresponding record.
		--   `NULL' is returned if no record corresponds.
		--   Because an additional zero code is appended at the end of the region of the return value,
		--   the return value can be treated as a character string.  Because the region of the return
		--   value is allocated with the `malloc' call, it should be released with the `free' call when
		--   it is no longer in use. */
		--char *tcfdbget3(TCFDB *fdb, const char *kstr)
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbget3((TCFDB *)$an_fdb, (const char *)$a_kstr)
			}"
		end


	tcfdbvsiz (an_fdb : POINTER; an_id : INTEGER_64) : INTEGER_32
		--/* Get the size of the value of a record in a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   `id' specifies the ID number.  It should be more than 0.  If it is `FDBIDMIN', the minimum ID
		--   number of existing records is specified.  If it is `FDBIDMAX', the maximum ID number of
		--   existing records is specified.
		--   If successful, the return value is the size of the value of the corresponding record, else,
		--   it is -1. */
		--int tcfdbvsiz(TCFDB *fdb, int64_t id);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbvsiz((TCFDB *)$an_fdb, (int64_t)$an_id)
			}"
		end



	tcfdbvsiz3 (an_fdb : POINTER; a_kstr : POINTER) : INTEGER_32
		--/* Get the size of the string value with a decimal key in a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   `kstr' specifies the string of the decimal key.  It should be more than 0.  If it is "min",
		--   the minimum ID number of existing records is specified.  If it is "max", the maximum ID number
		--   of existing records is specified.
		--   If successful, the return value is the size of the value of the corresponding record, else,
		--   it is -1. */
		--int tcfdbvsiz3(TCFDB *fdb, const char *kstr);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbvsiz3((TCFDB *)$an_fdb, (const char *)$a_kstr)
			}"
		end


feature -- Iterator

	tcfdbiterinit (an_fdb : POINTER) : BOOLEAN
		-- /* Initialize the iterator of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   If successful, the return value is true, else, it is false.
		--   The iterator is used in order to access the key of every record stored in a database. */
		--bool tcfdbiterinit(TCFDB *fdb);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbiterinit((TCFDB *)$an_fdb)
			}"
		end


	tcfdbiternext (an_fdb : POINTER) : NATURAL_64
		--/* Get the next ID number of the iterator of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   If successful, the return value is the next ID number of the iterator, else, it is 0.  0 is
		--   returned when no record is to be get out of the iterator.
		--   It is possible to access every record by iteration of calling this function.  It is allowed to
		--   update or remove records whose keys are fetched while the iteration.  The order of this
		--   traversal access method is ascending of the ID number. */
		--uint64_t tcfdbiternext(TCFDB *fdb)
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbiternext((TCFDB *)$an_fdb)
			}"
		end



	tcfdbiternext3(an_fdb : POINTER) : POINTER
		--/* Get the next decimay key string of the iterator of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object.
		--   If successful, the return value is the string of the next decimal key, else, it is `NULL'.
		--   `NULL' is returned when no record is to be get out of the iterator.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use.  It is possible to access every
		--   record by iteration of calling this function.  It is allowed to update or remove records whose
		--   keys are fetched while the iteration.  The order of this traversal access method is ascending
		--   of the ID number. */
		--char *tcfdbiternext3(TCFDB *fdb)
		external
				"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbiternext3((TCFDB *)$an_fdb)
			}"
		end



feature -- Store Records

	tcfdbput (a_fdb : POINTER; an_id : INTEGER_64; a_vbuf : POINTER; a_vsiz : INTEGER_32)
		--/* Store a record into a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   `id' specifies the ID number.  It should be more than 0.  If it is `FDBIDMIN', the minimum ID
		--   number of existing records is specified.  If it is `FDBIDPREV', the number less by one than
		--   the minimum ID number of existing records is specified.  If it is `FDBIDMAX', the maximum ID
		--   number of existing records is specified.  If it is `FDBIDNEXT', the number greater by one than
		--   the maximum ID number of existing records is specified.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.  If the size of the value is greater
		--   than the width tuning parameter of the database, the size is cut down to the width.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, it is overwritten. */
		--bool tcfdbput(TCFDB *fdb, int64_t id, const void *vbuf, int vsiz);
		external
				"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbput((TCFDB *)$a_fdb, (int64_t) $an_id, (const void *)$a_vbuf, (int) $a_vsiz)
			}"
		end

		--/* Store a record with a decimal key into a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the decimal key.  It should be more than 0.  If
		--   it is "min", the minimum ID number of existing records is specified.  If it is "prev", the
		--   number less by one than the minimum ID number of existing records is specified.  If it is
		--   "max", the maximum ID number of existing records is specified.  If it is "next", the number
		--   greater by one than the maximum ID number of existing records is specified.
		--   `ksiz' specifies the size of the region of the key.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.  If the size of the value is greater
		--   than the width tuning parameter of the database, the size is cut down to the width.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, it is overwritten. */
		--bool tcfdbput2(TCFDB *fdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);

	tcfdbput3 (an_fdb : POINTER; a_kstr : POINTER;  a_vstr : POINTER) : BOOLEAN
		--/* Store a string record with a decimal key into a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   `kstr' specifies the string of the decimal key.  It should be more than 0.  If it is "min",
		--   the minimum ID number of existing records is specified.  If it is "prev", the number less by
		--   one than the minimum ID number of existing records is specified.  If it is "max", the maximum
		--   ID number of existing records is specified.  If it is "next", the number greater by one than
		--   the maximum ID number of existing records is specified.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, it is overwritten. */
		--bool tcfdbput3(TCFDB *fdb, const char *kstr, const void *vstr);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbput3((TCFDB *)$an_fdb, (const char *)$a_kstr, (const void *)$a_vstr)
			}"
		end


	tcfdbputkeep3 (an_fdb : POINTER;  a_kstr: POINTER;  a_vstr : POINTER) : BOOLEAN
		--	/* Store a new string record with a decimal key into a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   `kstr' specifies the string of the decimal key.  It should be more than 0.  If it is "min",
		--   the minimum ID number of existing records is specified.  If it is "prev", the number less by
		--   one than the minimum ID number of existing records is specified.  If it is "max", the maximum
		--   ID number of existing records is specified.  If it is "next", the number greater by one than
		--   the maximum ID number of existing records is specified.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, this function has no effect. */
		--bool tcfdbputkeep3(TCFDB *fdb, const char *kstr, const void *vstr);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbputkeep3((TCFDB *)$an_fdb, (const char *)$a_kstr, (const void *)$a_vstr)
			}"
		end


	tcfdbputcat3 (an_fdb : POINTER; a_kstr : POINTER;  a_vstr : POINTER ) : BOOLEAN
		--	/* Concatenate a string value with a decimal key in a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   `kstr' specifies the string of the decimal key.  It should be more than 0.  If it is "min",
		--   the minimum ID number of existing records is specified.  If it is "prev", the number less by
		--   one than the minimum ID number of existing records is specified.  If it is "max", the maximum
		--   ID number of existing records is specified.  If it is "next", the number greater by one than
		--   the maximum ID number of existing records is specified.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If there is no corresponding record, a new record is created. */
		--bool tcfdbputcat3(TCFDB *fdb, const char *kstr, const void *vstr);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbputcat3((TCFDB *)$an_fdb, (const char *)$a_kstr, (const void *)$a_vstr)
			}"
		end


	tcfdbaddint (an_fdb : POINTER; an_id : INTEGER_64; a_num : INTEGER) : INTEGER
		--	/* Add an integer to a record in a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   `id' specifies the ID number.  It should be more than 0.  If it is `FDBIDMIN', the minimum ID
		--   number of existing records is specified.  If it is `FDBIDPREV', the number less by one than
		--   the minimum ID number of existing records is specified.  If it is `FDBIDMAX', the maximum ID
		--   number of existing records is specified.  If it is `FDBIDNEXT', the number greater by one than
		--   the maximum ID number of existing records is specified.
		--   `num' specifies the additional value.
		--   If successful, the return value is the summation value, else, it is `INT_MIN'.
		--   If the corresponding record exists, the value is treated as an integer and is added to.  If no
		--   record corresponds, a new record of the additional value is stored. */
		--int tcfdbaddint(TCFDB *fdb, int64_t id, int num);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbaddint((TCFDB *)$an_fdb, (int64_t)$an_id, (int)$a_num)
			}"
		end


	tcfdbadddouble (an_fdb : POINTER; an_id: INTEGER_64; a_num : DOUBLE) : DOUBLE
		--/* Add a real number to a record in a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   `id' specifies the ID number.  It should be more than 0.  If it is `FDBIDMIN', the minimum ID
		--   number of existing records is specified.  If it is `FDBIDPREV', the number less by one than
		--   the minimum ID number of existing records is specified.  If it is `FDBIDMAX', the maximum ID
		--   number of existing records is specified.  If it is `FDBIDNEXT', the number greater by one than
		--   the maximum ID number of existing records is specified.
		--   `num' specifies the additional value.
		--   If successful, the return value is the summation value, else, it is Not-a-Number.
		--   If the corresponding record exists, the value is treated as a real number and is added to.  If
		--   no record corresponds, a new record of the additional value is stored. */
		--double tcfdbadddouble(TCFDB *fdb, int64_t id, double num);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbadddouble((TCFDB *)$an_fdb, (int64_t)$an_id, (double)$a_num)
			}"
		end



feature -- Transaction	

	tcfdbtranbegin (an_fdb : POINTER) : BOOLEAN
		--/* Begin the transaction of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   The database is locked by the thread while the transaction so that only one transaction can be
		--   activated with a database object at the same time.  Thus, the serializable isolation level is
		--   assumed if every database operation is performed in the transaction.  All updated regions are
		--   kept track of by write ahead logging while the transaction.  If the database is closed during
		--   transaction, the transaction is aborted implicitly. */
		--bool tcfdbtranbegin(TCFDB *fdb);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbtranbegin((TCFDB *)$an_fdb)
			}"
		end



	tcfdbtrancommit (an_fdb : POINTER) : BOOLEAN
		--/* Commit the transaction of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   Update in the transaction is fixed when it is committed successfully. */
		--bool tcfdbtrancommit(TCFDB *fdb)
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbtrancommit((TCFDB *)$an_fdb)
			}"
		end



	tcfdbtranabort (an_fdb : POINTER) : BOOLEAN
		--/* Abort the transaction of a fixed-length database object.
		--   `fdb' specifies the fixed-length database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   Update in the transaction is discarded when it is aborted.  The state of the database is
		--   rollbacked to before transaction. */
		--bool tcfdbtranabort(TCFDB *fdb);
		external
			"C inline use <tcfdb.h>"
		alias
			"{
				tcfdbtranabort((TCFDB *)$an_fdb)
			}"
		end

end
