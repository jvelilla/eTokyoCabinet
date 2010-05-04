note
	description: "{TC_TDB_API}. The table database API of Tokyo Cabinet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TC_TDB_API

feature -- Constants

	ESUCCESS : INTEGER is 0
		-- error code: success

	ETHREAD : INTEGER is 1
		-- error code: threading error

	EINVALID : INTEGER is 2
		-- error code: invalid operation

	ENOFILE : INTEGER is 3
		-- error code: file not found

	ENOPERM : INTEGER is 4
		-- error code: no permission

	EMETA : INTEGER is 5
		-- error code: invalid meta data

	ERHEAD : INTEGER is 6
		-- error code: invalid record header

	EOPEN : INTEGER is 7
		-- error code: open error

	ECLOSE : INTEGER is 8
		-- error code: close error

	ETRUNC : INTEGER is 9
		-- error code: trunc error

	ESYNC : INTEGER is 10
		-- error code: sync error

	ESTAT : INTEGER is 11
		-- error code: stat error

	ESEEK : INTEGER is 12
		-- error code: seek error

	EREAD : INTEGER is 13
		-- error code: read error

	EWRITE : INTEGER is 14
		-- error code: write error

	EMMAP : INTEGER is 15
		-- error code: mmap error

	ELOCK : INTEGER is 16
		-- error code: lock error

	EUNLINK : INTEGER is 17
		-- error code: unlink error

	ERENAME : INTEGER is 18
		-- error code: rename error

	EMKDIR : INTEGER is 19
		-- error code: mkdir error

	ERMDIR : INTEGER is 20
		-- error code: rmdir error

	EKEEP : INTEGER is 21
		-- error code: existing record

	ENOREC : INTEGER is 22
		-- error code: no record found

	EMISC : INTEGER is 9999
		-- error code: miscellaneous error


	TLARGE: INTEGER is 1
		-- tuning option: use 64-bit bucket array

	TDEFLATE : INTEGER is 2
		-- tuning option: compress each record with Deflate

	TBZIP : INTEGER is 4
		-- tuning option: compress each record with BZIP2

	TTCBS : INTEGER is 8
		-- tuning option: compress each record with TCBS

	OREADER : INTEGER is 1
		-- open mode: open as a reader

	OWRITER : INTEGER is 2
		-- open mode: open as a writer

	OCREAT : INTEGER is 4
		-- open mode: writer creating

	OTRUNC : INTEGER is 8
		-- open mode: writer truncating

	ONOLCK : INTEGER is 16
		-- open mode: open without locking

	OLCKNB : INTEGER is 32
		-- open mode: lock without blocking

	OTSYNC : INTEGER is 64
		-- open mode: synchronize every transaction

	ITLEXICAL : INTEGER is 0
		-- index type: lexical string

	ITDECIMAL : INTEGER is 1
		-- index type: decimal string

	ITTOKEN : INTEGER is 2
		-- index type: token inverted index

	ITQGRAM : INTEGER is 3
		-- index type: q-gram inverted index

	ITOPT : INTEGER is 9998
		-- index type: optimize

	ITVOID : INTEGER is 9999
		-- index type: void

	ITKEEP : INTEGER is 16777216
		-- index type: keep existing index


feature -- Database Control


	tctdbpath (an_tdb : POINTER) : POINTER
		--/* Get the file path of a table database object.
		--   `tdb' specifies the table database object.
		--   The return value is the path of the database file or `NULL' if the object does not connect to
		--   any database file. */
		--const char *tctdbpath(TCTDB *tdb);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbpath((TCTDB *)$an_tdb)
			}"
		end

	tctdbsetmutex(an_tdb : POINTER) : BOOLEAN
		--/* Set mutual exclusion control of a table database object for threading.
		--   `tdb' specifies the table database object which is not opened.
		--   If successful, the return value is true, else, it is false.
		--   Note that the mutual exclusion control is needed if the object is shared by plural threads and
		--   this function should be called before the database is opened. */
		--bool tctdbsetmutex(TCTDB *tdb);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbsetmutex((TCTDB *)$an_tdb)
			}"
		end

	tctdbtune (an_tdb : POINTER; a_bnum : INTEGER_64; an_apow : INTEGER_8; a_fpow : INTEGER_8; an_opts : NATURAL_8) : BOOLEAN
		--/* Set the tuning parameters of a table database object.
		--   `tdb' specifies the table database object which is not opened.
		--   `bnum' specifies the number of elements of the bucket array.  If it is not more than 0, the
		--   default value is specified.  The default value is 131071.  Suggested size of the bucket array
		--   is about from 0.5 to 4 times of the number of all records to be stored.
		--   `apow' specifies the size of record alignment by power of 2.  If it is negative, the default
		--   value is specified.  The default value is 4 standing for 2^4=16.
		--   `fpow' specifies the maximum number of elements of the free block pool by power of 2.  If it
		--   is negative, the default value is specified.  The default value is 10 standing for 2^10=1024.
		--   `opts' specifies options by bitwise-or: `TDBTLARGE' specifies that the size of the database
		--   can be larger than 2GB by using 64-bit bucket array, `TDBTDEFLATE' specifies that each record
		--   is compressed with Deflate encoding, `TDBTBZIP' specifies that each record is compressed with
		--   BZIP2 encoding, `TDBTTCBS' specifies that each record is compressed with TCBS encoding.
		--   If successful, the return value is true, else, it is false.
		--   Note that the tuning parameters should be set before the database is opened. */
		--bool tctdbtune(TCTDB *tdb, int64_t bnum, int8_t apow, int8_t fpow, uint8_t opts);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbtune((TCTDB *)$an_tdb, (int64_t)$a_bnum, (int8_t)$an_apow, (int8_t)$a_fpow, (uint8_t)$an_opts)
			}"
		end

	tctdbsetcache (an_tdb : POINTER; a_rcnum : INTEGER_32; a_lcnum : INTEGER_32; a_ncnum : INTEGER_32) : BOOLEAN
		--/* Set the caching parameters of a table database object.
		--   `tdb' specifies the table database object which is not opened.
		--   `rcnum' specifies the maximum number of records to be cached.  If it is not more than 0, the
		--   record cache is disabled.  It is disabled by default.
		--   `lcnum' specifies the maximum number of leaf nodes to be cached.  If it is not more than 0,
		--   the default value is specified.  The default value is 4096.
		--   `ncnum' specifies the maximum number of non-leaf nodes to be cached.  If it is not more than 0,
		--   the default value is specified.  The default value is 512.
		--   If successful, the return value is true, else, it is false.
		--   Note that the caching parameters should be set before the database is opened.  Leaf nodes and
		--   non-leaf nodes are used in column indices. */
		--bool tctdbsetcache(TCTDB *tdb, int32_t rcnum, int32_t lcnum, int32_t ncnum);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbsetcache((TCTDB *)$an_tdb, (int32_t)$a_rcnum, (int32_t)$a_lcnum, (int32_t)$a_ncnum)
			}"
		end

	tctdbsetxmsiz (an_tdb : POINTER; a_xmsiz : INTEGER_64) : BOOLEAN
		--/* Set the size of the extra mapped memory of a table database object.
		--   `tdb' specifies the table database object which is not opened.
		--   `xmsiz' specifies the size of the extra mapped memory.  If it is not more than 0, the extra
		--   mapped memory is disabled.  The default size is 67108864.
		--   If successful, the return value is true, else, it is false.
		--   Note that the mapping parameters should be set before the database is opened. */
		--bool tctdbsetxmsiz(TCTDB *tdb, int64_t xmsiz);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbsetxmsiz((TCTDB *)$an_tdb, (int64_t)$a_xmsiz)
			}"
		end

	tctdbsetdfunit (an_tdb :POINTER; a_dfunit : INTEGER_32) : BOOLEAN
		--/* Set the unit step number of auto defragmentation of a table database object.
		--   `tdb' specifies the table database object which is not opened.
		--   `dfunit' specifie the unit step number.  If it is not more than 0, the auto defragmentation
		--   is disabled.  It is disabled by default.
		--   If successful, the return value is true, else, it is false.
		--   Note that the defragmentation parameters should be set before the database is opened. */
		--bool tctdbsetdfunit(TCTDB *tdb, int32_t dfunit);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbsetdfunit((TCTDB *)$an_tdb, (int32_t)$a_dfunit)
			}"
		end



	tctdbsync(an_tdb : POINTER) : BOOLEAN
		--/* Synchronize updated contents of a table database object with the file and the device.
		--   `tdb' specifies the table database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   This function is useful when another process connects to the same database file. */
		--bool tctdbsync(TCTDB *tdb);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbsync((TCTDB *)$an_tdb)
			}"
		end


	tctdboptimize (an_tdb : POINTER; a_bnum : INTEGER_64; an_apow: INTEGER_8; a_fpow : INTEGER_8; an_opts : NATURAL_8)
		--/* Optimize the file of a table database object.
		--   `tdb' specifies the table database object connected as a writer.
		--   `bnum' specifies the number of elements of the bucket array.  If it is not more than 0, the
		--   default value is specified.  The default value is two times of the number of records.
		--   `apow' specifies the size of record alignment by power of 2.  If it is negative, the current
		--   setting is not changed.
		--   `fpow' specifies the maximum number of elements of the free block pool by power of 2.  If it
		--   is negative, the current setting is not changed.
		--   `opts' specifies options by bitwise-or: `BDBTLARGE' specifies that the size of the database
		--   can be larger than 2GB by using 64-bit bucket array, `BDBTDEFLATE' specifies that each record
		--   is compressed with Deflate encoding, `BDBTBZIP' specifies that each record is compressed with
		--   BZIP2 encoding, `BDBTTCBS' specifies that each record is compressed with TCBS encoding.  If it
		--   is `UINT8_MAX', the current setting is not changed.
		--   If successful, the return value is true, else, it is false.
		--   This function is useful to reduce the size of the database file with data fragmentation by
		--   successive updating. */
		--bool tctdboptimize(TCTDB *tdb, int64_t bnum, int8_t apow, int8_t fpow, uint8_t opts);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbsync((TCTDB *)$an_tdb)
			}"
		end


feature -- Open


	tctdbopen (an_tdb : POINTER; a_path: POINTER; an_omode : INTEGER_32) : BOOLEAN
		--/* Open a database file and connect a table database object.
		--   `tdb' specifies the table database object which is not opened.
		--   `path' specifies the path of the database file.
		--   `omode' specifies the connection mode: `TDBOWRITER' as a writer, `TDBOREADER' as a reader.
		--   If the mode is `TDBOWRITER', the following may be added by bitwise-or: `TDBOCREAT', which
		--   means it creates a new database if not exist, `TDBOTRUNC', which means it creates a new
		--   database regardless if one exists, `TDBOTSYNC', which means every transaction synchronizes
		--   updated contents with the device.  Both of `TDBOREADER' and `TDBOWRITER' can be added to by
		--   bitwise-or: `TDBONOLCK', which means it opens the database file without file locking, or
		--   `TDBOLCKNB', which means locking is performed without blocking.
		--   If successful, the return value is true, else, it is false. */
		--bool tctdbopen(TCTDB *tdb, const char *path, int omode);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbopen((TCTDB *)$an_tdb, (const char *)$a_path, (int)$an_omode)
			}"
		end

feature -- Close

	tctdbclose (an_tdb : POINTER) : BOOLEAN
		--/* Close a table database object.
		--   `tdb' specifies the table database object.
		--   If successful, the return value is true, else, it is false.
		--   Update of a database is assured to be written when the database is closed.  If a writer opens
		--   a database but does not close it appropriately, the database will be broken. */
		--bool tctdbclose(TCTDB *tdb);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbclose((TCTDB *)$an_tdb)
			}"
		end

feature -- Error Message	

	tctdberrmsg (an_ecode:INTEGER_32) : POINTER
		--/* Get the message string corresponding to an error code.
		--   `ecode' specifies the error code.
		--   The return value is the message string of the error code. */
		--const char *tctdberrmsg(int ecode)
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdberrmsg((int)$an_ecode)
			}"
		end


	tctdbecode (an_tdb : POINTER) : INTEGER_32
		--	/* Get the last happened error code of a table database object.
		--   `tdb' specifies the table database object.
		--   The return value is the last happened error code.
		--   The following error code is defined: `TCESUCCESS' for success, `TCETHREAD' for threading
		--   error, `TCEINVALID' for invalid operation, `TCENOFILE' for file not found, `TCENOPERM' for no
		--   permission, `TCEMETA' for invalid meta data, `TCERHEAD' for invalid record header, `TCEOPEN'
		--   for open error, `TCECLOSE' for close error, `TCETRUNC' for trunc error, `TCESYNC' for sync
		--   error, `TCESTAT' for stat error, `TCESEEK' for seek error, `TCEREAD' for read error,
		--   `TCEWRITE' for write error, `TCEMMAP' for mmap error, `TCELOCK' for lock error, `TCEUNLINK'
		--   for unlink error, `TCERENAME' for rename error, `TCEMKDIR' for mkdir error, `TCERMDIR' for
		--   rmdir error, `TCEKEEP' for existing record, `TCENOREC' for no record found, and `TCEMISC' for
		--   miscellaneous error. */
		--int tctdbecode(TCTDB *tdb)
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbecode((TCTDB *)$an_tdb)
			}"
		end


feature -- Create Database

	tctdbnew : POINTER
		--/* Create a table database object.
		--   The return value is the new table database object. */
		--TCTDB *tctdbnew(void);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbnew()
			}"
		end

feature -- Delete Database

	tctdbdel (an_tdb : POINTER)
		--/* Delete a table database object.
		--   `tdb' specifies the table database object.
		--   If the database is not closed, it is closed implicitly.  Note that the deleted object and its
		--   derivatives can not be used anymore. */
		--void tctdbdel(TCTDB *tdb);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbdel((TCTDB *)$an_tdb)
			}"
		end

feature -- Store Records

	tctdbput(a_tdb : POINTER; a_pkbuf : POINTER; a_pksiz : INTEGER; a_cols : POINTER) : BOOLEAN
		--	/* Store a record into a table database object.
		--   `tdb' specifies the table database object connected as a writer.
		--   `pkbuf' specifies the pointer to the region of the primary key.
		--   `pksiz' specifies the size of the region of the primary key.
		--   `cols' specifies a map object containing columns.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, it is overwritten. */
		--bool tctdbput(TCTDB *tdb, const void *pkbuf, int pksiz, TCMAP *cols);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbput((TCTDB *)$a_tdb, (const void *)$a_pkbuf, (int) $a_pksiz, (TCMAP *)$a_cols)
			}"
		end

	tctdbput3 (an_tdb : POINTER; a_pkstr : POINTER; a_cstr : POINTER) : BOOLEAN
		--/* Store a string record into a table database object with a tab separated column string.
		--   `tdb' specifies the table database object connected as a writer.
		--   `pkstr' specifies the string of the primary key.
		--   `cstr' specifies the string of the the tab separated column string where the name and the
		--   value of each column are situated one after the other.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, it is overwritten. */
		--bool tctdbput3(TCTDB *tdb, const char *pkstr, const char *cstr);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbput3((TCTDB *)$an_tdb, (const char *)$a_pkstr, (const char *)$a_cstr)
			}"
		end



	tctdbputkeep3 (an_tdb : POINTER; a_pkstr: POINTER; a_cstr : POINTER) : BOOLEAN
		--/* Store a new string record into a table database object with a tab separated column string.
		--   `tdb' specifies the table database object connected as a writer.
		--   `pkstr' specifies the string of the primary key.
		--   `cstr' specifies the string of the the tab separated column string where the name and the
		--   value of each column are situated one after the other.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, this function has no effect. */
		--bool tctdbputkeep3(TCTDB *tdb, const char *pkstr, const char *cstr)
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbputkeep3((TCTDB *)$an_tdb, (const char *)$a_pkstr, (const char *)$a_cstr)
			}"
		end


	tctdbputcat3 (an_tdb : POINTER; a_pkstr : POINTER; a_cstr : POINTER) : BOOLEAN
		--	/* Concatenate columns in a table database object with with a tab separated column string.
		--   `tdb' specifies the table database object connected as a writer.
		--   `pkstr' specifies the string of the primary key.
		--   `cstr' specifies the string of the the tab separated column string where the name and the
		--   value of each column are situated one after the other.
		--   If successful, the return value is true, else, it is false.
		--   If there is no corresponding record, a new record is created. */
		--bool tctdbputcat3(TCTDB *tdb, const char *pkstr, const char *cstr);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbputcat3((TCTDB *)$an_tdb, (const char *)$a_pkstr, (const char *)$a_cstr)
			}"
		end


	tctdbaddint (an_tdb : POINTER; a_pkbuf : POINTER; a_pksiz : INTEGER_32; a_num : POINTER) : INTEGER_32
		--/* Add an integer to a column of a record in a table database object.
		--   `tdb' specifies the table database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the primary key.
		--   `ksiz' specifies the size of the region of the primary key.
		--   `num' specifies the additional value.
		--   If successful, the return value is the summation value, else, it is `INT_MIN'.
		--   The additional value is stored as a decimal string value of a column whose name is "_num".
		--   If no record corresponds, a new record with the additional value is stored. */
		--int tctdbaddint(TCTDB *tdb, const void *pkbuf, int pksiz, int num);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbaddint((TCTDB *)$an_tdb, (const void *)$a_pkbuf, (int)$a_pksiz, (int)$a_num)
			}"
		end


	tctdbadddouble (an_tdb : POINTER; a_pkbuf : POINTER; a_pksiz : INTEGER_32; a_num : DOUBLE) : DOUBLE
		--/* Add a real number to a column of a record in a table database object.
		--   `tdb' specifies the table database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the primary key.
		--   `ksiz' specifies the size of the region of the primary key.
		--   `num' specifies the additional value.
		--   If successful, the return value is the summation value, else, it is Not-a-Number.
		--   The additional value is stored as a decimal string value of a column whose name is "_num".
		--   If no record corresponds, a new record with the additional value is stored. */
		--double tctdbadddouble(TCTDB *tdb, const void *pkbuf, int pksiz, double num);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbadddouble((TCTDB *)$an_tdb, (const void *)$a_pkbuf, (int)$a_pksiz, (double)$a_num)
			}"
		end
feature -- Remove Records

	tctdbout2 (an_tdb : POINTER; a_pkstr : POINTER) : BOOLEAN
		--/* Remove a string record of a table database object.
		--   `tdb' specifies the table database object connected as a writer.
		--   `pkstr' specifies the string of the primary key.
		--   If successful, the return value is true, else, it is false. */
		--bool tctdbout2(TCTDB *tdb, const char *pkstr);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbout2((TCTDB *)$an_tdb, (const char *)$a_pkstr)
			}"
		end




	tctdbvanish	(an_tdb: POINTER) : BOOLEAN
		--/* Remove all records of a table database object.
		--   `tdb' specifies the table database object connected as a writer.
		--   If successful, the return value is true, else, it is false. */
		--bool tctdbvanish(TCTDB *tdb);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbvanish((TCTDB *)$an_tdb)
			}"
		end


	tctdbcopy (an_tdb : POINTER; a_path : POINTER) : BOOLEAN
		--	/* Copy the database file of a table database object.
		--   `tdb' specifies the table database object.
		--   `path' specifies the path of the destination file.  If it begins with `@', the trailing
		--   substring is executed as a command line.
		--   If successful, the return value is true, else, it is false.  False is returned if the executed
		--   command returns non-zero code.
		--   The database file is assured to be kept synchronized and not modified while the copying or
		--   executing operation is in progress.  So, this function is useful to create a backup file of
		--   the database file. */
		--bool tctdbcopy(TCTDB *tdb, const char *path);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbcopy((TCTDB *)$an_tdb, (const char *)$a_path)
			}"
		end

feature -- Retrieve Records
	tctdbget (a_tdb : POINTER; a_pkbuf : POINTER; a_pksiz : INTEGER) : POINTER
		--/* Retrieve a record in a table database object.
		--   `tdb' specifies the table database object.
		--   `pkbuf' specifies the pointer to the region of the primary key.
		--   `pksiz' specifies the size of the region of the primary key.
		--   If successful, the return value is a map object of the columns of the corresponding record.
		--   `NULL' is returned if no record corresponds.
		--   Because the object of the return value is created with the function `tcmapnew', it should be
		--   deleted with the function `tcmapdel' when it is no longer in use. */
		--TCMAP *tctdbget(TCTDB *tdb, const void *pkbuf, int pksiz);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbget((TCTDB *)$a_tdb, (const void *)$a_pkbuf, (int)$a_pksiz)
			}"
		end

	tctdbget3 (an_tdb : POINTER; a_pkstr : POINTER) : POINTER
		--/* Retrieve a string record in a table database object as a tab separated column string.
		--   `tdb' specifies the table database object.
		--   `pkstr' specifies the string of the primary key.
		--   If successful, the return value is the tab separated column string of the corresponding
		--   record.  `NULL' is returned if no record corresponds.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use. */
		--char *tctdbget3(TCTDB *tdb, const char *pkstr);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbget3((TCTDB *)$an_tdb, (const char *)$a_pkstr)
			}"
		end


	tctdbvsiz2 (an_tdb : POINTER; a_pkstr : POINTER) : INTEGER_32
		--/* Get the size of the value of a string record in a table database object.
		--   `tdb' specifies the table database object.
		--   `kstr' specifies the string of the primary key.
		--   If successful, the return value is the size of the value of the corresponding record, else,
		--   it is -1. */
		--int tctdbvsiz2(TCTDB *tdb, const char *pkstr)
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbvsiz2((TCTDB *)$an_tdb, (const char *)$a_pkstr)
			}"
		end




	tctdbrnum (an_tdb : POINTER) : NATURAL_64
		--/* Get the number of records ccccof a table database object.
		--   `tdb' specifies the table database object.
		--   The return value is the number of records or 0 if the object does not connect to any database
		--   file. */
		--uint64_t tctdbrnum(TCTDB *tdb);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbrnum((TCTDB *)$an_tdb)
			}"
		end


	tctdbfsiz (an_tdb : POINTER) : NATURAL_64
		--/* Get the size of the database file of a table database object.
		--   `tdb' specifies the table database object.
		--   The return value is the size of the database file or 0 if the object does not connect to any
		--   database file. */
		--uint64_t tctdbfsiz(TCTDB *tdb);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbfsiz((TCTDB *)$an_tdb)
			}"
		end



feature -- Iterator

	tctdbiterinit (an_tdb : POINTER) : BOOLEAN
		--/* Initialize the iterator of a table database object.
		--   `tdb' specifies the table database object.
		--   If successful, the return value is true, else, it is false.
		--   The iterator is used in order to access the primary key of every record stored in a
		--   database. */
		--bool tctdbiterinit(TCTDB *tdb)
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbiterinit((TCTDB *)$an_tdb)
			}"
		end


	tctdbiternext2 (an_tdb : POINTER) : POINTER
		--	/* Get the next primary key string of the iterator of a table database object.
		--   `tdb' specifies the table database object.
		--   If successful, the return value is the string of the next primary key, else, it is `NULL'.
		--   `NULL' is returned when no record is to be get out of the iterator.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use.  It is possible to access every
		--   record by iteration of calling this function.  However, it is not assured if updating the
		--   database is occurred while the iteration.  Besides, the order of this traversal access method
		--   is arbitrary, so it is not assured that the order of storing matches the one of the traversal
		--   access. */
		--char *tctdbiternext2(TCTDB *tdb);	
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbiternext2((TCTDB *)$an_tdb)
			}"
		end

feature -- Transaction


	tctdbtranbegin (an_tdb : POINTER) : BOOLEAN
		--/* Begin the transaction of a table database object.
		--   `tdb' specifies the table database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   The database is locked by the thread while the transaction so that only one transaction can be
		--   activated with a database object at the same time.  Thus, the serializable isolation level is
		--   assumed if every database operation is performed in the transaction.  Because all pages are
		--   cached on memory while the transaction, the amount of referred records is limited by the
		--   memory capacity.  If the database is closed during transaction, the transaction is aborted
		--   implicitly. */
		--bool tctdbtranbegin(TCTDB *tdb)
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbtranbegin((TCTDB *)$an_tdb)
			}"
		end


	tctdbtrancommit (an_tdb : POINTER) : BOOLEAN
		--/* Commit the transaction of a table database object.
		--   `tdb' specifies the table database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   Update in the transaction is fixed when it is committed successfully. */
		--bool tctdbtrancommit(TCTDB *tdb)
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbtrancommit((TCTDB *)$an_tdb)
			}"
		end


	tctdbtranabort (an_tdb : POINTER) : BOOLEAN
		--/* Abort the transaction of a table database object.
		--   `tdb' specifies the table database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   Update in the transaction is discarded when it is aborted.  The state of the database is
		--   rollbacked to before transaction. */
		--bool tctdbtranabort(TCTDB *tdb)
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbtranabort((TCTDB *)$an_tdb)
			}"
		end


end
