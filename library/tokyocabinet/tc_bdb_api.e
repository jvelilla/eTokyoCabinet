note
	description: "{TC_BDB_API} The B+ tree database API of Tokyo Cabinet"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TC_BDB_API

inherit
	ANY undefine is_equal, copy end
	TC_CONSTANTS undefine default_create end

feature -- Create

	tcbdbnew : POINTER
		--/* Create a B+ tree database object.
		--   The return value is the new B+ tree database object. */
		--TCBDB *tcbdbnew(void);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbnew()
			}"
		end

feature -- Delete

	tcbdbdel(an_bdb:POINTER)
		--/* Delete a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   If the database is not closed, it is closed implicitly.  Note that the deleted object and its
		--   derivatives can not be used anymore. */
		--void tcbdbdel(TCBDB *bdb);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbdel((TCBDB *)$an_bdb)
			}"
		end

feature -- Open

	tcbdbopen (an_bdb:POINTER; a_path:POINTER; an_omode: INTEGER) : BOOLEAN
		--/* Open a database file and connect a B+ tree database object.
		--   `bdb' specifies the B+ tree database object which is not opened.
		--   `path' specifies the path of the database file.
		--   `omode' specifies the connection mode: `BDBOWRITER' as a writer, `BDBOREADER' as a reader.
		--   If the mode is `BDBOWRITER', the following may be added by bitwise-or: `BDBOCREAT', which
		--   means it creates a new database if not exist, `BDBOTRUNC', which means it creates a new
		--   database regardless if one exists, `BDBOTSYNC', which means every transaction synchronizes
		--   updated contents with the device.  Both of `BDBOREADER' and `BDBOWRITER' can be added to by
		--   bitwise-or: `BDBONOLCK', which means it opens the database file without file locking, or
		--   `BDBOLCKNB', which means locking is performed without blocking.
		--   If successful, the return value is true, else, it is false. */
		--bool tcbdbopen(TCBDB *bdb, const char *path, int omode);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbopen((TCBDB *)$an_bdb, (const char *)$a_path, (int)$an_omode)
			}"
		end

feature -- Close

	tcbdbclose (an_bdb: POINTER) : BOOLEAN
		--/* Close a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   If successful, the return value is true, else, it is false.
		--   Update of a database is assured to be written when the database is closed.  If a writer opens
		--   a database but does not close it appropriately, the database will be broken. */
		--bool tcbdbclose(TCBDB *bdb);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbclose((TCBDB *)$an_bdb)
			}"
		end


feature -- Store records

	tcbdbput (a_bdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_vbuf : POINTER; a_vsiz : POINTER) : BOOLEAN
		--/* Store a record into a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, it is overwritten. */
		--bool tcbdbput(TCBDB *bdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbput((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz, (const void *)$a_vbuf, (int) $a_vsiz)
			}"
		end

	tcbdbput2(an_bdb:POINTER; a_kstr:POINTER; a_vstr:POINTER) : BOOLEAN
		--/* Store a string record into a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, it is overwritten. */
		--bool tcbdbput2(TCBDB *bdb, const char *kstr, const char *vstr);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbput2((TCBDB *)$an_bdb, (const char *)$a_kstr, (const char *)$a_vstr)
			}"
		end


	tcbdbputkeep (a_bdb : POINTER; a_kbuf : POINTER; a_ksiz: INTEGER_32; a_vbuf : POINTER; a_vsiz : INTEGER_32) : BOOLEAN
		--/* Store a new record into a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, this function has no effect. */
		--bool tcbdbputkeep(TCBDB *bdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbputkeep((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz, (const void *)$a_vbuf, (int) $a_vsiz)
			}"
		end


	tcbdbputkeep2 (an_bdb : POINTER; a_kstr : POINTER;  a_vstr : POINTER) : BOOLEAN
		--	/* Store a new string record into a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, this function has no effect. */
		--bool tcbdbputkeep2(TCBDB *bdb, const char *kstr, const char *vstr);	
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbputkeep2((TCBDB *)$an_bdb, (const char *)$a_kstr, (const char *)$a_vstr)
			}"
		end


	tcbdbputcat (a_bdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_vbuf: POINTER; a_vsiz : INTEGER_32) : BOOLEAN
		--/* Concatenate a value at the end of the existing record in a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.
		--   If successful, the return value is true, else, it is false.
		--   If there is no corresponding record, a new record is created. */
		--bool tcbdbputcat(TCBDB *bdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz)
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbputcat((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz, (const void *)$a_vbuf, (int) $a_vsiz)
			}"
		end

	tcbdbputcat2 (an_bdb : POINTER; a_kstr : POINTER; a_vstr : POINTER) : BOOLEAN
		--	/* Concatenate a string value at the end of the existing record in a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If there is no corresponding record, a new record is created. */
		--bool tcbdbputcat2(TCBDB *bdb, const char *kstr, const char *vstr);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbputcat2((TCBDB *)$an_bdb, (const char *)$a_kstr, (const char *)$a_vstr)
			}"
		end


	tcbdbputdup (a_bdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_vbuf: POINTER; a_vsiz : INTEGER_32) : BOOLEAN
		--/* Store a record into a B+ tree database object with allowing duplication of keys.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `vbuf' specifies the pointer to the region of the value.
		--   `vsiz' specifies the size of the region of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, the new record is placed after the
		--   existing one. */
		--bool tcbdbputdup(TCBDB *bdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbputdup((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz, (const void *)$a_vbuf, (int) $a_vsiz)
			}"
		end


	tcbdbputdup2 (an_bdb : POINTER; a_kstr : POINTER;  a_vstr : POINTER) : BOOLEAN
		--	/* Store a string record into a B+ tree database object with allowing duplication of keys.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kstr' specifies the string of the key.
		--   `vstr' specifies the string of the value.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, the new record is placed after the
		--   existing one. */
		--bool tcbdbputdup2(TCBDB *bdb, const char *kstr, const char *vstr);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbputdup2((TCBDB *)$an_bdb, (const char *)$a_kstr, (const char *)$a_vstr)
			}"
		end



	tcbdbputdup3 ( a_bdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32; a_vals : POINTER) : BOOLEAN
		--/* Store records into a B+ tree database object with allowing duplication of keys.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the common key.
		--   `ksiz' specifies the size of the region of the common key.
		--   `vals' specifies a list object containing values.
		--   If successful, the return value is true, else, it is false.
		--   If a record with the same key exists in the database, the new records are placed after the
		--   existing one. */
		--bool tcbdbputdup3(TCBDB *bdb, const void *kbuf, int ksiz, const TCLIST *vals);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbputdup3((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz, (const TCLIST *)$a_vals)
			}"
		end



	tcbdbaddint(an_bdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER; a_num : INTEGER) : INTEGER
		--/* Add an integer to a record in a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `num' specifies the additional value.
		--   If successful, the return value is the summation value, else, it is `INT_MIN'.
		--   If the corresponding record exists, the value is treated as an integer and is added to.  If no
		--   record corresponds, a new record of the additional value is stored. */
		--int tcbdbaddint(TCBDB *bdb, const void *kbuf, int ksiz, int num);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbaddint((TCBDB *)$an_bdb, (const void *)$a_kbuf, (int)$a_ksiz, (int)$a_num)
			}"
		end



	tcbdbadddouble(an_bdb : POINTER; a_kbuf : POINTER;  a_ksiz : INTEGER; a_num : DOUBLE) : DOUBLE
		--/* Add a real number to a record in a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `num' specifies the additional value.
		--   If successful, the return value is the summation value, else, it is Not-a-Number.
		--   If the corresponding record exists, the value is treated as a real number and is added to.  If
		--   no record corresponds, a new record of the additional value is stored. */
		--double tcbdbadddouble(TCBDB *bdb, const void *kbuf, int ksiz, double num);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbadddouble((TCBDB *)$an_bdb, (const void *)$a_kbuf, (int)$a_ksiz, (double)$a_num)
			}"
		end

feature -- Remove a Record

	tcbdbout (a_bdb : POINTER; a_kbuf : POINTER; a_ksiz:INTEGER_32) : BOOLEAN
		--/* Remove a record of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   If successful, the return value is true, else, it is false.
		--   If the key of duplicated records is specified, the first one is selected. */
		--bool tcbdbout(TCBDB *bdb, const void *kbuf, int ksiz);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbout((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz)
			}"
		end


	 tcbdbout2 (an_bdb : POINTER; a_kstr : POINTER) : BOOLEAN
		--/* Remove a string record of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is true, else, it is false.
		--   If the key of duplicated records is specified, the first one is selected. */
		--bool tcbdbout2(TCBDB *bdb, const char *kstr)
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbout2((TCBDB *)$an_bdb, (const char *)$a_kstr)
			}"
		end


	tcbdbout3 (a_bdb:POINTER; a_kbuf:POINTER; a_ksiz : INTEGER_32) : BOOLEAN
		--/* Remove records of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   If successful, the return value is true, else, it is false.
		--   If the key of duplicated records is specified, all of them are removed. */
		--bool tcbdbout3(TCBDB *bdb, const void *kbuf, int ksiz);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbout3((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz)
			}"
		end


	tcbdbvanish(an_bdb : POINTER) : BOOLEAN
		--	/* Remove all records of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   If successful, the return value is true, else, it is false. */
		--bool tcbdbvanish(TCBDB *bdb);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbvanish((TCBDB *)$an_bdb)
			}"
		end
feature -- Retrieve Records



	tcbdbget (a_bdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER; a_sp : TYPED_POINTER[INTEGER_32]) : POINTER
		--/* Retrieve a record in a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   If successful, the return value is the pointer to the region of the value of the corresponding
		--   record.  `NULL' is returned if no record corresponds.
		--   If the key of duplicated records is specified, the first one is selected.  Because an
		--   additional zero code is appended at the end of the region of the return value, the return
		--   value can be treated as a character string.  Because the region of the return value is
		--   allocated with the `malloc' call, it should be released with the `free' call when it is no
		--   longer in use. */
		--void *tcbdbget(TCBDB *bdb, const void *kbuf, int ksiz, int *sp);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				int sp;
				void *result = tcbdbget((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz, (int) &sp);
				*(EIF_INTEGER *) $a_sp = (EIF_INTEGER) sp;
				return result;
			]"
		end

	tcbdbget2 (an_bdb:POINTER; a_kstr:POINTER): POINTER
		--/* Retrieve a string record in a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is the string of the value of the corresponding record.
		--   `NULL' is returned if no record corresponds.
		--   If the key of duplicated records is specified, the first one is selected.  Because the region
		--   of the return value is allocated with the `malloc' call, it should be released with the `free'
		--   call when it is no longer in use. */
		--char *tcbdbget2(TCBDB *bdb, const char *kstr);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbget2((TCBDB *)$an_bdb, (const char *)$a_kstr)
			}"
		end


	tcbdbget3 (a_bdb : POINTER; a_kbuf:POINTER; a_ksiz : INTEGER_32; a_sp : TYPED_POINTER[INTEGER_32]) : POINTER
		--/* Retrieve a record in a B+ tree database object as a volatile buffer.
		--   `bdb' specifies the B+ tree database object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   `sp' specifies the pointer to the variable into which the size of the region of the return
		--   value is assigned.
		--   If successful, the return value is the pointer to the region of the value of the corresponding
		--   record.  `NULL' is returned if no record corresponds.
		--   If the key of duplicated records is specified, the first one is selected.  Because an
		--   additional zero code is appended at the end of the region of the return value, the return
		--   value can be treated as a character string.  Because the region of the return value is
		--   volatile and it may be spoiled by another operation of the database, the data should be copied
		--   into another involatile buffer immediately. */
		--const void *tcbdbget3(TCBDB *bdb, const void *kbuf, int ksiz, int *sp);
		external
			"C inline use <tcutil.h>"
		alias
			"[
				int sp;
				void *result = tcbdbget3((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz, (int) &sp);
				*(EIF_INTEGER *) $a_sp = (EIF_INTEGER) sp;
				return result;
			]"
		end



	tcbdbget4 (a_bdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32) : BOOLEAN
		--/* Retrieve records in a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   If successful, the return value is a list object of the values of the corresponding records.
		--   `NULL' is returned if no record corresponds.
		--   Because the object of the return value is created with the function `tclistnew', it should
		--   be deleted with the function `tclistdel' when it is no longer in use. */
		--TCLIST *tcbdbget4(TCBDB *bdb, const void *kbuf, int ksiz);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbget4((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz)
			}"
		end


	tcbdbvnum (a_bdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32) : INTEGER_32
		--* Get the number of records corresponding a key in a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   If successful, the return value is the number of the corresponding records, else, it is 0. */
		--int tcbdbvnum(TCBDB *bdb, const void *kbuf, int ksiz);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbvnum((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz)
			}"
		end


	tcbdbvnum2 (an_bdb : POINTER; a_kstr : POINTER) : INTEGER_32
		--/* Get the number of records corresponding a string key in a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is the number of the corresponding records, else, it is 0. */
		--int tcbdbvnum2(TCBDB *bdb, const char *kstr);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbvnum2((TCBDB *)$an_bdb, (const char *)$a_kstr)
			}"
		end


	tcbdbvsiz (a_bdb : POINTER; a_kbuf : POINTER; a_ksiz : INTEGER_32) : INTEGER_32
		--/* Get the size of the value of a record in a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   `kbuf' specifies the pointer to the region of the key.
		--   `ksiz' specifies the size of the region of the key.
		--   If successful, the return value is the size of the value of the corresponding record, else,
		--   it is -1.
		--   If the key of duplicated records is specified, the first one is selected. */
		--int tcbdbvsiz(TCBDB *bdb, const void *kbuf, int ksiz);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbvsiz((TCBDB *)$a_bdb, (const void *)$a_kbuf, (int) $a_ksiz)
			}"
		end


	tcbdbvsiz2 (an_bdb : POINTER; a_kstr : POINTER) : INTEGER_32
		--	/* Get the size of the value of a string record in a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is the size of the value of the corresponding record, else,
		--   it is -1.
		--   If the key of duplicated records is specified, the first one is selected. */
		--int tcbdbvsiz2(TCBDB *bdb, const char *kstr);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbvsiz2((TCBDB *)$an_bdb, (const char *)$a_kstr)
			}"
		end


	tcbdbpath (an_bdb : POINTER) : POINTER
		--/* Get the file path of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   The return value is the path of the database file or `NULL' if the object does not connect to
		--   any database file. */
		--const char *tcbdbpath(TCBDB *bdb);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbpath((TCBDB *)$an_bdb)
			}"
		end


	tcbdbrnum (an_bdb : POINTER) : NATURAL_64
		--/* Get the number of records of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   The return value is the number of records or 0 if the object does not connect to any database
		--   file. */
		--uint64_t tcbdbrnum(TCBDB *bdb);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbrnum((TCBDB *)$an_bdb)
			}"
		end



	tcbdbfsiz (an_bdb : POINTER) : NATURAL_64
		--/* Get the size of the database file of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   The return value is the size of the database file or 0 if the object does not connect to any
		--   database file. */
		--uint64_t tcbdbfsiz(TCBDB *bdb);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbfsiz((TCBDB *)$an_bdb)
			}"
		end


feature -- Error Messages

	tcbdberrmsg (an_ecode : INTEGER) : POINTER
		--/* Get the message string corresponding to an error code.
		--   `ecode' specifies the error code.
		--   The return value is the message string of the error code. */
		--const char *tcbdberrmsg(int ecode)
		external
			"C inline use <tcbdb.h>"
		alias
			"{
			tcbdberrmsg((int)$an_ecode)
			}"
		end


	 tcbdbecode (an_bdb : POINTER) : INTEGER
		--	/* Get the last happened error code of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
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
		--int tcbdbecode(TCBDB *bdb);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbecode((TCBDB *)$an_bdb)
			}"
		end

feature-- Mutual Exclusion

	tcbdbsetmutex (an_bdb : POINTER) : BOOLEAN
		--/* Set mutual exclusion control of a B+ tree database object for threading.
		--   `bdb' specifies the B+ tree database object which is not opened.
		--   If successful, the return value is true, else, it is false.
		--   Note that the mutual exclusion control is needed if the object is shared by plural threads and
		--   this function should be called before the database is opened. */
		--bool tcbdbsetmutex(TCBDB *bdb);		
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbsetmutex((TCBDB *)$an_bdb)
			}"
		end

feature -- Database Control


	tcbdbtune(an_bdb : POINTER; a_lmemb : INTEGER_32; a_nmemb : INTEGER_32; a_bnum : INTEGER_64; an_apow : INTEGER_8; a_fpow : INTEGER_8; a_opts :NATURAL_8 ) : BOOLEAN
		--/* Set the tuning parameters of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object which is not opened.
		--   `lmemb' specifies the number of members in each leaf page.  If it is not more than 0, the
		--   default value is specified.  The default value is 128.
		--   `nmemb' specifies the number of members in each non-leaf page.  If it is not more than 0, the
		--   default value is specified.  The default value is 256.
		--   `bnum' specifies the number of elements of the bucket array.  If it is not more than 0, the
		--   default value is specified.  The default value is 32749.  Suggested size of the bucket array
		--   is about from 1 to 4 times of the number of all pages to be stored.
		--   `apow' specifies the size of record alignment by power of 2.  If it is negative, the default
		--   value is specified.  The default value is 8 standing for 2^8=256.
		--   `fpow' specifies the maximum number of elements of the free block pool by power of 2.  If it
		--   is negative, the default value is specified.  The default value is 10 standing for 2^10=1024.
		--   `opts' specifies options by bitwise-or: `BDBTLARGE' specifies that the size of the database
		--   can be larger than 2GB by using 64-bit bucket array, `BDBTDEFLATE' specifies that each page
		--   is compressed with Deflate encoding, `BDBTBZIP' specifies that each page is compressed with
		--   BZIP2 encoding, `BDBTTCBS' specifies that each page is compressed with TCBS encoding.
		--   If successful, the return value is true, else, it is false.
		--   Note that the tuning parameters should be set before the database is opened. */
		--bool tcbdbtune(TCBDB *bdb, int32_t lmemb, int32_t nmemb,
		--               int64_t bnum, int8_t apow, int8_t fpow, uint8_t opts);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				 tcbdbtune ((TCBDB *)$an_bdb, (int32_t)$a_lmemb, (int32_t)$a_nmemb,
		               (int64_t)$a_bnum, (int8_t)$an_apow, (int8_t)$a_fpow, (uint8_t)$a_opts)
			}"
		end


	tcbdbsetcache (an_bdb : POINTER; a_lcnum:INTEGER_32; a_ncnum: INTEGER_32) : BOOLEAN
		--/* Set the caching parameters of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object which is not opened.
		--   `lcnum' specifies the maximum number of leaf nodes to be cached.  If it is not more than 0,
		--   the default value is specified.  The default value is 1024.
		--   `ncnum' specifies the maximum number of non-leaf nodes to be cached.  If it is not more than 0,
		--   the default value is specified.  The default value is 512.
		--   If successful, the return value is true, else, it is false.
		--   Note that the caching parameters should be set before the database is opened. */
		--bool tcbdbsetcache(TCBDB *bdb, int32_t lcnum, int32_t ncnum);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbsetcache((TCBDB *)$an_bdb, (int32_t)$a_lcnum, (int32_t)$a_ncnum)
			}"
		end


	tcbdbsetxmsiz (an_bdb: POINTER ;  a_xmsiz:INTEGER_64) : BOOLEAN
		--/* Set the size of the extra mapped memory of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object which is not opened.
		--   `xmsiz' specifies the size of the extra mapped memory.  If it is not more than 0, the extra
		--   mapped memory is disabled.  It is disabled by default.
		--   If successful, the return value is true, else, it is false.
		--   Note that the mapping parameters should be set before the database is opened. */
		--bool tcbdbsetxmsiz(TCBDB *bdb, int64_t xmsiz);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbsetxmsiz((TCBDB *)$an_bdb, (int64_t)$a_xmsiz)
			}"
		end


	tcbdbsetdfunit (an_bdb : POINTER; a_dfunit : INTEGER_32) : BOOLEAN
		--	/* Set the unit step number of auto defragmentation of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object which is not opened.
		--   `dfunit' specifie the unit step number.  If it is not more than 0, the auto defragmentation
		--   is disabled.  It is disabled by default.
		--   If successful, the return value is true, else, it is false.
		--   Note that the defragmentation parameter should be set before the database is opened. */
		--bool tcbdbsetdfunit(TCBDB *bdb, int32_t dfunit);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbsetdfunit((TCBDB *)$an_bdb, (int32_t)$a_dfunit)
			}"
		end


	tcbdbsync(an_bdb : POINTER) : BOOLEAN
		--/* Synchronize updated contents of a B+ tree database object with the file and the device.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   This function is useful when another process connects to the same database file. */
		--bool tcbdbsync(TCBDB *bdb);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbsync((TCBDB *)$an_bdb)
			}"
		end


	tcbdbcopy (an_bdb : POINTER; a_path : POINTER) :  BOOLEAN
		--	/* Copy the database file of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object.
		--   `path' specifies the path of the destination file.  If it begins with `@', the trailing
		--   substring is executed as a command line.
		--   If successful, the return value is true, else, it is false.  False is returned if the executed
		--   command returns non-zero code.
		--   The database file is assured to be kept synchronized and not modified while the copying or
		--   executing operation is in progress.  So, this function is useful to create a backup file of
		--   the database file. */
		--bool tcbdbcopy(TCBDB *bdb, const char *path);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcopy((TCBDB *)$an_bdb, (const char *)$a_path)
			}"
		end

feature -- Transaction

	tcbdbtranbegin(an_bdb : POINTER) :  BOOLEAN
		--/* Begin the transaction of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   The database is locked by the thread while the transaction so that only one transaction can be
		--   activated with a database object at the same time.  Thus, the serializable isolation level is
		--   assumed if every database operation is performed in the transaction.  Because all pages are
		--   cached on memory while the transaction, the amount of referred records is limited by the
		--   memory capacity.  If the database is closed during transaction, the transaction is aborted
		--   implicitly. */
		--bool tcbdbtranbegin(TCBDB *bdb);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbtranbegin((TCBDB *)$an_bdb)
			}"
		end


	tcbdbtrancommit(an_bdb : POINTER) : BOOLEAN
		--/* Commit the transaction of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   Update in the transaction is fixed when it is committed successfully. */
		--bool tcbdbtrancommit(TCBDB *bdb);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbtrancommit((TCBDB *)$an_bdb)
			}"
		end



	tcbdbtranabort(an_bdb : POINTER) : BOOLEAN
		--/* Abort the transaction of a B+ tree database object.
		--   `bdb' specifies the B+ tree database object connected as a writer.
		--   If successful, the return value is true, else, it is false.
		--   Update in the transaction is discarded when it is aborted.  The state of the database is
		--   rollbacked to before transaction. */
		--bool tcbdbtranabort(TCBDB *bdb);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbtranabort((TCBDB *)$an_bdb)
			}"
		end

end
