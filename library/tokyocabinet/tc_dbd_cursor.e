note
	description: " TC_BDB_CURSOR is a mechanism to access each record of B+ tree database in ascending or descending order"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TC_BDB_CURSOR

feature -- Constants
	CPCURRENT : INTEGER is 0
		--	cursor put mode: current


	CPBEFORE : INTEGER is 1
		--  cursor put mode: before


	CPAFTER : INTEGER is 2
		--  cursor put mode: after

feature -- Initialization

	tcbdbcurnew(an_bdb : POINTER) : POINTER
		--/* Create a cursor object.
		--   `bdb' specifies the B+ tree database object.
		--   The return value is the new cursor object.
		--   Note that the cursor is available only after initialization with the `tcbdbcurfirst' or the
		--   `tcbdbcurjump' functions and so on.  Moreover, the position of the cursor will be indefinite
		--   when the database is updated after the initialization of the cursor. */
		--BDBCUR *tcbdbcurnew(TCBDB *bdb)
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcurnew((TCBDB *)$an_bdb)
			}"
		end


feature -- Cursor

	tcbdbcurdel(a_cur : POINTER)
		--/* Delete a cursor object.
		--   `cur' specifies the cursor object. */
		--void tcbdbcurdel(BDBCUR *cur);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcurdel((BDBCUR *)$a_cur)
			}"
		end


	tcbdbcurfirst(a_cur : POINTER) : BOOLEAN
		--	/* Move a cursor object to the first record.
		--   `cur' specifies the cursor object.
		--   If successful, the return value is true, else, it is false.  False is returned if there is
		--   no record in the database. */
		--bool tcbdbcurfirst(BDBCUR *cur)
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcurfirst((BDBCUR *)$a_cur)
			}"
		end


	tcbdbcurlast(a_cur : POINTER) : BOOLEAN
		--/* Move a cursor object to the last record.
		--   `cur' specifies the cursor object.
		--   If successful, the return value is true, else, it is false.  False is returned if there is
		--   no record in the database. */
		--bool tcbdbcurlast(BDBCUR *cur);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcurlast((BDBCUR *)$a_cur)
			}"
		end


	tcbdbcurjump2(a_cur : POINTER; a_kstr : POINTER) : BOOLEAN
		--/* Move a cursor object to the front of records corresponding a key string.
		--   `cur' specifies the cursor object.
		--   `kstr' specifies the string of the key.
		--   If successful, the return value is true, else, it is false.  False is returned if there is
		--   no record corresponding the condition.
		--   The cursor is set to the first record corresponding the key or the next substitute if
		--   completely matching record does not exist. */
		--bool tcbdbcurjump2(BDBCUR *cur, const char *kstr);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcurjump2((BDBCUR *)$a_cur, (const char *)$a_kstr)
			}"
		end
		
	
	tcbdbcurprev(a_cur : POINTER) : BOOLEAN
		--	/* Move a cursor object to the previous record.
		--   `cur' specifies the cursor object.
		--   If successful, the return value is true, else, it is false.  False is returned if there is
		--   no previous record. */
		--bool tcbdbcurprev(BDBCUR *cur);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcurprev((BDBCUR *)$a_cur)
			}"
		end


	tcbdbcurnext(a_cur : POINTER) : BOOLEAN
		--/* Move a cursor object to the next record.
		--   `cur' specifies the cursor object.
		--   If successful, the return value is true, else, it is false.  False is returned if there is
		--   no next record. */
		--bool tcbdbcurnext(BDBCUR *cur);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcurnext((BDBCUR *)$a_cur)
			}"
		end


	tcbdbcurput2(a_cur : POINTER; a_vstr : POINTER; a_cpmode : INTEGER_32) : BOOLEAN
		--/* Insert a string record around a cursor object.
		--   `cur' specifies the cursor object of writer connection.
		--   `vstr' specifies the string of the value.
		--   `cpmode' specifies detail adjustment: `BDBCPCURRENT', which means that the value of the
		--   current record is overwritten, `BDBCPBEFORE', which means that the new record is inserted
		--   before the current record, `BDBCPAFTER', which means that the new record is inserted after the
		--   current record.
		--   If successful, the return value is true, else, it is false.  False is returned when the cursor
		--   is at invalid position.
		--   After insertion, the cursor is moved to the inserted record. */
		--bool tcbdbcurput2(BDBCUR *cur, const char *vstr, int cpmode);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcurput2((BDBCUR *)$a_cur, (const char *)$a_vstr, (int)$a_cpmode)
			}"
		end


	tcbdbcurout(a_cur : POINTER) : BOOLEAN
		--/* Remove the record where a cursor object is.
		--   `cur' specifies the cursor object of writer connection.
		--   If successful, the return value is true, else, it is false.  False is returned when the cursor
		--   is at invalid position.
		--   After deletion, the cursor is moved to the next record if possible. */
		--bool tcbdbcurout(BDBCUR *cur);	
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcurout((BDBCUR *)$a_cur)
			}"
		end


	tcbdbcurkey2(a_cur : POINTER) : POINTER
		--/* Get the key string of the record where the cursor object is.
		--   `cur' specifies the cursor object.
		--   If successful, the return value is the string of the key, else, it is `NULL'.  `NULL' is
		--   returned when the cursor is at invalid position.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use. */
		--char *tcbdbcurkey2(BDBCUR *cur);
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcurkey2((BDBCUR *)$a_cur)
			}"
		end
		
	
	tcbdbcurval2 (a_cur : POINTER) : POINTER
		--	/* Get the value string of the record where the cursor object is.
		--   `cur' specifies the cursor object.
		--   If successful, the return value is the string of the value, else, it is `NULL'.  `NULL' is
		--   returned when the cursor is at invalid position.
		--   Because the region of the return value is allocated with the `malloc' call, it should be
		--   released with the `free' call when it is no longer in use. */
		--char *tcbdbcurval2(BDBCUR *cur)
		external
			"C inline use <tcbdb.h>"
		alias
			"{
				tcbdbcurval2((BDBCUR *)$a_cur)
			}"
		end



feature {NONE} -- Implementation

 	bdb_internal : POINTER
 	-- TCB_BDB_API
	-- host database object

end
