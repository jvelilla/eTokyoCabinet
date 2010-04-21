note
	description: "{TC_HDB_API}. The hash database API of Tokyo Cabinet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TC_HDB_API

feature  -- Constants

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

	TLARGE  : INTEGER is  1
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


feature -- Create Database

	tchdbnew : POINTER
		--/* Create a hash database object.
		--   The return value is the new hash database object. */
		--TCHDB *tchdbnew(void);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbnew()
			}"
		end

feature -- Delete Database

	tchdbdel(a_hdb : POINTER)
		--/* Delete a hash database object.
		--   `hdb' specifies the hash database object.
		--   If the database is not closed, it is closed implicitly.  Note that the deleted object and its
		--   derivatives can not be used anymore. */
		--void tchdbdel(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbdel((TCHDB *)$a_hdb)
			}"
		end


feature -- Open

	tchdbopen(an_hdb : POINTER; a_path : POINTER; an_omode : INTEGER_32) : BOOLEAN
		--/* Open a  database file and connect a hash database object.
		--   `hdb' specifies the hash database object which is not opened.
		--   `path' specifies the path of the database file.
		--   `omode' specifies the connection mode: `HDBOWRITER' as a writer, `HDBOREADER' as a reader.
		--   If the mode is `HDBOWRITER', the following may be added by bitwise-or: `HDBOCREAT', which
		--   means it creates a new database if not exist, `HDBOTRUNC', which means it creates a new
		--   database regardless if one exists, `HDBOTSYNC', which means every transaction synchronizes
		--   updated contents with the device.  Both of `HDBOREADER' and `HDBOWRITER' can be added to by
		--   bitwise-or: `HDBONOLCK', which means it opens the database file without file locking, or
		--   `HDBOLCKNB', which means locking is performed without blocking.
		--   If successful, the return value is true, else, it is false. */
		--bool tchdbopen(TCHDB *hdb, const char *path, int omode);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbopen((TCHDB *)$an_hdb, (const char *)$a_path, (int)$an_omode)
			}"
		end

feature -- Close

	tchdbclose(an_hdb :POINTER) : BOOLEAN
		--/* Close a hash database object.
		--   `hdb' specifies the hash database object.
		--   If successful, the return value is true, else, it is false.
		--   Update of a database is assured to be written when the database is closed.  If a writer opens
		--   a database but does not close it appropriately, the database will be broken. */
		--bool tchdbclose(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbclose((TCHDB *)$an_hdb)
			}"
		end

feature -- Error Message

	tchdberrmsg (an_ecode : INTEGER_32) : POINTER
		--/* Get the message string corresponding to an error code.
		--   `ecode' specifies the error code.
		--   The return value is the message string of the error code. */
		--const char *tchdberrmsg(int ecode)
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdberrmsg((int)$an_ecode)
			}"
		end


	tchdbecode (an_hdb : POINTER) : INTEGER_32
		--	/* Get the last happened error code of a hash database object.
		--   `hdb' specifies the hash database object.
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
		--int tchdbecode(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbecode((TCHDB *)$an_hdb)
			}"
		end

feature -- Database Control

	tchdbpath (a_hdb : POINTER) : POINTER
		--	/* Get the file path of a hash database object.
		--   `hdb' specifies the hash database object.
		--   The return value is the path of the database file or `NULL' if the object does not connect to
		--   any database file. */
		--const char *tchdbpath(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbpath((TCHDB *)$a_hdb)
			}"
		end

	tchdboptimize (a_hdb : POINTER; a_bnum : INTEGER_64; an_apow : INTEGER_8; a_fpow: INTEGER_8; an_opts : NATURAL_8) : BOOLEAN
		--/* Optimize the file of a hash database object.
		--   `hdb' specifies the hash database object connected as a writer.
		--   `bnum' specifies the number of elements of the bucket array.  If it is not more than 0, the
		--   default value is specified.  The default value is two times of the number of records.
		--   `apow' specifies the size of record alignment by power of 2.  If it is negative, the current
		--   setting is not changed.
		--   `fpow' specifies the maximum number of elements of the free block pool by power of 2.  If it
		--   is negative, the current setting is not changed.
		--   `opts' specifies options by bitwise-or: `HDBTLARGE' specifies that the size of the database
		--   can be larger than 2GB by using 64-bit bucket array, `HDBTDEFLATE' specifies that each record
		--   is compressed with Deflate encoding, `HDBTBZIP' specifies that each record is compressed with
		--   BZIP2 encoding, `HDBTTCBS' specifies that each record is compressed with TCBS encoding.  If it
		--   is `UINT8_MAX', the current setting is not changed.
		--   If successful, the return value is true, else, it is false.
		--   This function is useful to reduce the size of the database file with data fragmentation by
		--   successive updating. */
		--bool tchdboptimize(TCHDB *hdb, int64_t bnum, int8_t apow, int8_t fpow, uint8_t opts);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdboptimize((TCHDB *)$a_hdb, (int64_t) $a_bnum, (int8_t) $an_apow, (int8_t) $a_fpow, (uint8_t)$an_opts)
			}"
		end

	tchdbsetmutex (an_hdb : POINTER) : BOOLEAN
		--/* Set mutual exclusion control of a hash database object for threading.
		--   `hdb' specifies the hash database object which is not opened.
		--   If successful, the return value is true, else, it is false.
		--   Note that the mutual exclusion control is needed if the object is shared by plural threads and
		--   this function should be called before the database is opened. */
		--bool tchdbsetmutex(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbsetmutex((TCHDB *)$an_hdb)
			}"
		end


	tchdbtune (an_hdb : POINTER; a_bnum : INTEGER_64; an_apow : INTEGER_8; an_fpow : INTEGER_8; an_opts : NATURAL_8) : BOOLEAN
		--/* Set the tuning parameters of a hash database object.
		--   `hdb' specifies the hash database object which is not opened.
		--   `bnum' specifies the number of elements of the bucket array.  If it is not more than 0, the
		--   default value is specified.  The default value is 131071.  Suggested size of the bucket array
		--   is about from 0.5 to 4 times of the number of all records to be stored.
		--   `apow' specifies the size of record alignment by power of 2.  If it is negative, the default
		--   value is specified.  The default value is 4 standing for 2^4=16.
		--   `fpow' specifies the maximum number of elements of the free block pool by power of 2.  If it
		--   is negative, the default value is specified.  The default value is 10 standing for 2^10=1024.
		--   `opts' specifies options by bitwise-or: `HDBTLARGE' specifies that the size of the database
		--   can be larger than 2GB by using 64-bit bucket array, `HDBTDEFLATE' specifies that each record
		--   is compressed with Deflate encoding, `HDBTBZIP' specifies that each record is compressed with
		--   BZIP2 encoding, `HDBTTCBS' specifies that each record is compressed with TCBS encoding.
		--   If successful, the return value is true, else, it is false.
		--   Note that the tuning parameters should be set before the database is opened. */
		--bool tchdbtune(TCHDB *hdb, int64_t bnum, int8_t apow, int8_t fpow, uint8_t opts);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbtune((TCHDB *)$an_hdb, (int64_t)$a_bnum, (int8_t)$an_apow, (int8_t)$an_fpow, (uint8_t)$an_opts)
			}"
		end


	tchdbsetcache(an_hdb : POINTER; a_rcnum : INTEGER_32) : BOOLEAN
		--/* Set the caching parameters of a hash database object.
		--   `hdb' specifies the hash database object which is not opened.
		--   `rcnum' specifies the maximum number of records to be cached.  If it is not more than 0, the
		--   record cache is disabled.  It is disabled by default.
		--   If successful, the return value is true, else, it is false.
		--   Note that the caching parameters should be set before the database is opened. */
		--bool tchdbsetcache(TCHDB *hdb, int32_t rcnum)
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbsetcache((TCHDB *)$an_hdb, (int32_t)$a_rcnum)
			}"
		end


	tchdbsetxmsiz(an_hdb : POINTER; a_xmsiz:INTEGER_64) : BOOLEAN
		--/* Set the size of the extra mapped memory of a hash database object.
		--   `hdb' specifies the hash database object which is not opened.
		--   `xmsiz' specifies the size of the extra mapped memory.  If it is not more than 0, the extra
		--   mapped memory is disabled.  The default size is 67108864.
		--   If successful, the return value is true, else, it is false.
		--   Note that the mapping parameters should be set before the database is opened. */
		--bool tchdbsetxmsiz(TCHDB *hdb, int64_t xmsiz);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbsetxmsiz((TCHDB *)$an_hdb, (int64_t)$a_xmsiz)
			}"
		end


	tchdbsetdfunit(an_hdb : POINTER; a_dfunit : INTEGER_32) : BOOLEAN
		--/* Set the unit step number of auto defragmentation of a hash database object.
		--   `hdb' specifies the hash database object which is not opened.
		--   `dfunit' specifie the unit step number.  If it is not more than 0, the auto defragmentation
		--   is disabled.  It is disabled by default.
		--   If successful, the return value is true, else, it is false.
		--   Note that the defragmentation parameters should be set before the database is opened. */
		--bool tchdbsetdfunit(TCHDB *hdb, int32_t dfunit);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbsetdfunit((TCHDB *)$an_hdb, (int32_t)$a_dfunit)
			}"
		end


	tchdbsync (an_hdb : POINTER) : BOOLEAN
		--/* Synchronize updated contents of a hash database object with the file and the device.
		--   `hdb' specifies the hash database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   This function is useful when another process connects to the same database file. */
		--bool tchdbsync(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbsync((TCHDB *)$an_hdb)
			}"
		end


	tchdbcopy(an_hdb : POINTER; a_path: POINTER) : BOOLEAN
		--/* Copy the database file of a hash database object.
		--   `hdb' specifies the hash database object.
		--   `path' specifies the path of the destination file.  If it begins with `@', the trailing
		--   substring is executed as a command line.
		--   If successful, the return value is true, else, it is false.  False is returned if the executed
		--   command returns non-zero code.
		--   The database file is assured to be kept synchronized and not modified while the copying or
		--   executing operation is in progress.  So, this function is useful to create a backup file of
		--   the database file. */
		--bool tchdbcopy(TCHDB *hdb, const char *path)
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbcopy((TCHDB *)$an_hdb, (const char *)$a_path)
			}"
		end

feature -- Store Records



	tchdbput (a_hdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_vbuf : POINTER; a_vsiz : INTEGER_32) : BOOLEAN
		--`hdb' specifies the hash database object connected as a writer.
		--`kbuf' specifies the pointer to the region of the key.
		--`ksiz' specifies the size of the region of the key.
		--`vbuf' specifies the pointer to the region of the value.
		--`vsiz' specifies the size of the region of the value.
		--If successful, the return value is true, else, it is false.
		--If a record with the same key exists in the database, it is overwritten.
		--bool tchdbput(TCHDB *hdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbput((TCHDB *)$a_hdb, (const void *)$a_kbuf, (int) $a_ksiz, (const void *)$a_vbuf, (int) $a_vsiz)
			}"
		end

	tchdbput2(an_hdb : POINTER; a_kstr : POINTER; a_vstr : POINTER) : BOOLEAN
		--/* Store a string record into a hash database object.
		--   `hdb' specifies the hash database object connected as a writer.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, it is overwritten. */
		--bool tchdbput2(TCHDB *hdb, const char *kstr, const char *vstr);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbput2((TCHDB *)$an_hdb, (const char *)$a_kstr, (const char *)$a_vstr)
			}"
		end



	tchdbputkeep (a_hdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_vbuf : POINTER; a_vsiz : INTEGER_32) : BOOLEAN
		--`hdb' specifies the hash database object connected as a writer.
		--`kbuf' specifies the pointer to the region of the key.
		--`ksiz' specifies the size of the region of the key.
		--`vbuf' specifies the pointer to the region of the value.
		--`vsiz' specifies the size of the region of the value.
		--If successful, the return value is true, else, it is false.
		--If a record with the same key exists in the database, this function has no effect.
		--bool tchdbputkeep(TCHDB *hdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbputkeep((TCHDB *)$a_hdb, (const void *)$a_kbuf, (int) $a_ksiz, (const void *)$a_vbuf, (int) $a_vsiz)
			}"
		end


	tchdbputkeep2 (an_hdb : POINTER; a_kstr : POINTER; a_vstr : POINTER) : BOOLEAN
		--	/* Store a new string record into a hash database object.
		--   `hdb' specifies the hash database object connected as a writer.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, this function has no effect. */
		--bool tchdbputkeep2(TCHDB *hdb, const char *kstr, const char *vstr);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbputkeep2((TCHDB *)$an_hdb, (const char *)$a_kstr, (const char *)$a_vstr)
			}"
		end


	tchdbputcat ( a_hdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_vbuf : POINTER; a_vsiz: INTEGER_32)
		--    `hdb' specifies the hash database object connected as a writer.
		--    `kbuf' specifies the pointer to the region of the key.
		--    `ksiz' specifies the size of the region of the key.
		--    `vbuf' specifies the pointer to the region of the value.
		--    `vsiz' specifies the size of the region of the value.
		--    If successful, the return value is true, else, it is false.
		--    If there is no corresponding record, a new record is created.
		--	bool tchdbputcat(TCHDB *hdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbputcat((TCHDB *)$a_hdb, (const void *)$a_kbuf, (int) $a_ksiz, (const void *) $a_vbuf, (int) $a_vsiz)
			}"
		end

	tchdbputcat2 (an_hdb : POINTER; a_kstr : POINTER; a_vstr : POINTER) : BOOLEAN
		--	* Concatenate a string value at the end of the existing record in a hash database object.
		--   `hdb' specifies the hash database object connected as a writer.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If there is no corresponding record, a new record is created. */
		--bool tchdbputcat2(TCHDB *hdb, const char *kstr, const char *vstr);	
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbputcat2((TCHDB *)$an_hdb, (const char *)$a_kstr, (const char *)$a_vstr)
			}"
		end


	tchdbputasync (a_hdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_vbuf : POINTER; a_vsiz : INTEGER_32)
		--    `hdb' specifies the hash database object connected as a writer.
		--    `kbuf' specifies the pointer to the region of the key.
		--    `ksiz' specifies the size of the region of the key.
		--    `vbuf' specifies the pointer to the region of the value.
		--    `vsiz' specifies the size of the region of the value.
		--    If successful, the return value is true, else, it is false.
		--    If a record with the same key exists in the database, it is overwritten. Records passed to this function are accumulated into the inner buffer and wrote into the file at a blast.
		--	bool tchdbputasync(TCHDB *hdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbputasync((TCHDB *)$a_hdb, (const void *)$a_kbuf, (int)$a_ksiz, (const void *)$a_vbuf, (int) $a_vsiz)
			}"
		end

	tchdbputasync2 (an_hdb : POINTER; a_kstr : POINTER; a_vstr : POINTER) : BOOLEAN
		--	/* Store a string record into a hash database object in asynchronous fashion.
		--   `hdb' specifies the hash database object connected as a writer.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, it is overwritten.  Records passed to
		--   this function are accumulated into the inner buffer and wrote into the file at a blast. */
		--bool tchdbputasync2(TCHDB *hdb, const char *kstr, const char *vstr);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbputasync2((TCHDB *)$an_hdb, (const char *)$a_kstr, (const char *)$a_vstr)
			}"
		end

	tchdbaddint (an_hdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_num : INTEGER_32) : INTEGER_32
		--	/* Add an integer to a record in a hash database object.
		--   `hdb' specifies the hash database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `num' specifies the additional value.
		--   If successful, the return value is the summation value, else, it is `INT_MIN'.
		--   If the corresponding record exists, the value is treated as an integer and is added to.  If no
		--   record corresponds, a new record of the additional value is stored. */
		--int tchdbaddint(TCHDB *hdb, const void *kbuf, int ksiz, int num);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbaddint((TCHDB *)$an_hdb, (const void *)$a_kbuf, (int)$a_ksiz, (int)$a_num)
			}"
		end


	tchdbadddouble(an_hdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_num : DOUBLE) : DOUBLE
		--/* Add a real number to a record in a hash database object.
		--   `hdb' specifies the hash database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `num' specifies the additional value.
		--   If successful, the return value is the summation value, else, it is Not-a-Number.
		--   If the corresponding record exists, the value is treated as a real number and is added to.  If
		--   no record corresponds, a new record of the additional value is stored. */
		--double tchdbadddouble(TCHDB *hdb, const void *kbuf, int ksiz, double num);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbadddouble((TCHDB *)$an_hdb, (const void *)$a_kbuf, (int)$a_ksiz, (double)$a_num)
			}"
		end

feature -- Remove Records

	tchdbout (a_hdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32) : BOOLEAN
		--    `hdb' specifies the hash database object connected as a writer.
		--    `kbuf' specifies the pointer to the region of the key.
		--    `ksiz' specifies the size of the region of the key.
		--    If successful, the return value is true, else, it is false.
		--	bool tchdbout(TCHDB *hdb, const void *kbuf, int ksiz);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbout ((TCHDB *)$a_hdb, (const void *) $a_kbuf, (int) $a_ksiz)
			}"
		end

	tchdbout2 (an_hdb : POINTER; a_kstr : POINTER) : BOOLEAN
		--/* Remove a string record of a hash database object.
		--   `hdb' specifies the hash database object connected as a writer.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is true, else, it is false. */
		--bool tchdbout2(TCHDB *hdb, const char *kstr);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbout2((TCHDB *)$an_hdb, (const char *)$a_kstr)
			}"
		end


	tchdbvanish (an_hdb : POINTER) : BOOLEAN
		--/* Remove all records of a hash database object.
		--   `hdb' specifies the hash database object connected as a writer.
		--   If successful, the return value is true, else, it is false. */
		--bool tchdbvanish(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbvanish((TCHDB *)$an_hdb)
			}"
		end

feature -- Retrieve Records and Keys

	tchdbget (a_hdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_sp : TYPED_POINTER [INTEGER_32]) : POINTER
		--/* Retrieve a record in a hash database object.
		--   `hdb' specifies the hash database object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   If successful, the return value is the pointer to the region of the value of the corresponding
		--   record.  `NULL' is returned if no record corresponds.
		--   Because an additional zero code is appended at the end of the region of the return value,
		--   the return value can be treated as a character string.  Because the region of the return
		--   value is allocated with the `malloc' call, it should be released with the `free' call when
		--   it is no longer in use. */
		--void *tchdbget(TCHDB *hdb, const void *kbuf, int ksiz, int *sp);
		external
			"C inline use <tchdb.h>"
		alias
			"[
				int sp;
				void *result = tchdbget((TCHDB *)$a_hdb, (const void *)$a_kbuf, (int)$a_ksiz, (int) &sp); 
				*(EIF_INTEGER *) $a_sp = (EIF_INTEGER) sp;
				return result;
			]"
		end


	tchdbget2 (an_hdb : POINTER; a_kstr : POINTER) : POINTER
		--/* Retrieve a string record in a hash database object.
		--   `hdb' specifies the hash database object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is the string of the value of the corresponding record.
		--   `NULL' is returned if no record corresponds.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use. */
		--char *tchdbget2(TCHDB *hdb, const char *kstr)
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbget2((TCHDB *)$an_hdb, (const char *)$a_kstr)
			}"
		end


	tchdbvsiz (a_hdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32) : INTEGER_32
		--	/* Get the size of the value of a record in a hash database object.
		--   `hdb' specifies the hash database object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   If successful, the return value is the size of the value of the corresponding record, else,
		--   it is -1. */
		--int tchdbvsiz(TCHDB *hdb, const void *kbuf, int ksiz);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbvsiz((TCHDB *)$a_hdb, (const void *)$a_kbuf, (int) $a_ksiz)
			}"
		end


	tchdbvsiz2 (an_hdb : POINTER; a_kstr : POINTER) : INTEGER_32
		--	/* Get the size of the value of a string record in a hash database object.
		--   `hdb' specifies the hash database object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is the size of the value of the corresponding record, else,
		--   it is -1. */
		--int tchdbvsiz2(TCHDB *hdb, const char *kstr)
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbvsiz2((TCHDB *)$an_hdb, (const char *)$a_kstr)
			}"
		end



	tchdbrnum (an_hdb : POINTER) : NATURAL_64
		--	/* Get the number of records of a hash database object.
		--   `hdb' specifies the hash database object.
		--   The return value is the number of records or 0 if the object does not connect to any database
		--   file. */
		--uint64_t tchdbrnum(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbrnum((TCHDB *)$an_hdb)
			}"
		end


	tchdbfsiz (an_hdb : POINTER) : NATURAL_64
		--/* Get the size of the database file of a hash database object.
		--   `hdb' specifies the hash database object.
		--   The return value is the size of the database file or 0 if the object does not connect to any
		--   database file. */
		--uint64_t tchdbfsiz(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbfsiz((TCHDB *)$an_hdb)
			}"
		end

	tchdbfwmkeys (a_hdb : POINTER; a_pbuf : POINTER; a_psiz:INTEGER_32; a_max : INTEGER_32) : POINTER
		--/* Get forward matching keys in a hash database object.
		--   `hdb' specifies the hash database object.
		--   `pbuf' specifies the pointer to the region of the prefix.
		--   `psiz' specifies the size of the region of the prefix.
		--   `max' specifies the maximum number of keys to be fetched.  If it is negative, no limit is
		--   specified.
		--   The return value is a list object of the corresponding keys.  This function does never fail.
		--   It returns an empty list even if no key corresponds.
		--   Because the object of the return value is created with the function `tclistnew', it should be
		--   deleted with the function `tclistdel' when it is no longer in use.  Note that this function
		--   may be very slow because every key in the database is scanned. */
		--TCLIST *tchdbfwmkeys(TCHDB *hdb, const void *pbuf, int psiz, int max);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbfwmkeys((TCHDB *)$a_hdb, (const void *)$a_pbuf, (int) $a_psiz, (int) $a_max)
			}"
		end

	tchdbfwmkeys2 (a_hdb : POINTER; a_pstr : POINTER; a_max : INTEGER_32) : POINTER
		--/* Get forward matching string keys in a hash database object.
		--   `hdb' specifies the hash database object.
		--   `pstr' specifies the string of the prefix.
		--   `max' specifies the maximum number of keys to be fetched.  If it is negative, no limit is
		--   specified.
		--   The return value is a list object of the corresponding keys.  This function does never fail.
		--   It returns an empty list even if no key corresponds.
		--   Because the object of the return value is created with the function `tclistnew', it should be
		--   deleted with the function `tclistdel' when it is no longer in use.  Note that this function
		--   may be very slow because every key in the database is scanned. */
		--TCLIST *tchdbfwmkeys2(TCHDB *hdb, const char *pstr, int max);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbfwmkeys2((TCHDB *)$a_hdb, (const char *)$a_pstr, (int) $a_max)
			}"
		end

feature -- Iterator


	tchdbiterinit (an_hdb : POINTER) : BOOLEAN
		--/* Initialize the iterator of a hash database object.
		--   `hdb' specifies the hash database object.
		--   If successful, the return value is true, else, it is false.
		--   The iterator is used in order to access the key of every record stored in a database. */
		--bool tchdbiterinit(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbiterinit((TCHDB *)$an_hdb)
			}"
		end


	tchdbiternext (a_hdb : POINTER; a_sp : TYPED_POINTER[INTEGER_32]) : POINTER
		--/* Get the next key of the iterator of a hash database object.
		--   `hdb' specifies the hash database object.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   If successful, the return value is the pointer to the region of the next key, else, it is
		--   `NULL'.  `NULL' is returned when no record is to be get out of the iterator.
		--   Because an additional zero code is appended at the end of the region of the return value, the
		--   return value can be treated as a character string.  Because the region of the return value is
		--   allocated with the `malloc' call, it should be released with the `free' call when it is no
		--   longer in use.  It is possible to access every record by iteration of calling this function.
		--   It is allowed to update or remove records whose keys are fetched while the iteration.
		--   However, it is not assured if updating the database is occurred while the iteration.  Besides,
		--   the order of this traversal access method is arbitrary, so it is not assured that the order of
		--   storing matches the one of the traversal access. */
		--void *tchdbiternext(TCHDB *hdb, int *sp);
		external
			"C inline use <tchdb.h>"
		alias
			"[
				int sp;
				void *result = tchdbiternext((TCHDB *)$a_hdb, (int)&sp);
				*(EIF_INTEGER *) $a_sp = (EIF_INTEGER) sp;
				return result;
			]"
		end

	tchdbiternext2 (an_hdb : POINTER) : POINTER
		--/* Get the next key string of the iterator of a hash database object.
		--   `hdb' specifies the hash database object.
		--   If successful, the return value is the string of the next key, else, it is `NULL'.  `NULL' is
		--   returned when no record is to be get out of the iterator.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use.  It is possible to access every
		--   record by iteration of calling this function.  However, it is not assured if updating the
		--   database is occurred while the iteration.  Besides, the order of this traversal access method
		--   is arbitrary, so it is not assured that the order of storing matches the one of the traversal
		--   access. */
		--char *tchdbiternext2(TCHDB *hdb)
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbiternext2((TCHDB *)$an_hdb)
			}"
		end

feature -- Transaction


	tchdbtranbegin(an_hdb : POINTER) : BOOLEAN
		--/* Begin the transaction of a hash database object.
		--   `hdb' specifies the hash database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   The database is locked by the thread while the transaction so that only one transaction can be
		--   activated with a database object at the same time.  Thus, the serializable isolation level is
		--   assumed if every database operation is performed in the transaction.  All updated regions are
		--   kept track of by write ahead logging while the transaction.  If the database is closed during
		--   transaction, the transaction is aborted implicitly. */
		--bool tchdbtranbegin(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbtranbegin((TCHDB *)$an_hdb)
			}"
		end


	tchdbtrancommit(an_hdb : POINTER) : BOOLEAN
		--/* Commit the transaction of a hash database object.
		--   `hdb' specifies the hash database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   Update in the transaction is fixed when it is committed successfully. */
		--bool tchdbtrancommit(TCHDB *hdb)
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbtrancommit((TCHDB *)$an_hdb)
			}"
		end


	tchdbtranabort(an_hdb : POINTER) : BOOLEAN
		--/* Abort the transaction of a hash database object.
		--   `hdb' specifies the hash database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   Update in the transaction is discarded when it is aborted.  The state of the database is
		--   rollbacked to before transaction. */
		--bool tchdbtranabort(TCHDB *hdb);
		external
			"C inline use <tchdb.h>"
		alias
			"{
				tchdbtranabort((TCHDB *)$an_hdb)
			}"
		end



end
