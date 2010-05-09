note
	description: "Summary description for {TC_TDB_QUERY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_TDB_QUERY
	
feature -- Access

	QCSTREQ : INTEGER is 0
		-- query condition: string is equal to

  	QCSTRINC : INTEGER is 1
  		-- query condition: string is included in

  	QCSTRBW : INTEGER is 2
  		-- query condition: string begins with

	QCSTREW : INTEGER is 3
  		-- query condition: string ends with

	QCSTRAND : INTEGER is 4
  		-- query condition: string includes all tokens in

	QCSTROR : INTEGER is 5
  		-- query condition: string includes at least one token in

   	QCSTROREQ : INTEGER is 6
   		-- query condition: string is equal to at least one token in

  	QCSTRRX : INTEGER is 7
		-- query condition: string matches regular expressions of

  	QCNUMEQ : INTEGER is 8
  		-- query condition: number is equal to

	QCNUMGT : INTEGER is 9
  		-- query condition: number is greater than

   	QCNUMGE : INTEGER is 10
  		-- query condition: number is greater than or equal to

  	QCNUMLT : INTEGER is 11
  		-- query condition: number is less than

  	QCNUMLE : INTEGER is 12
  		-- query condition: number is less than or equal to

 	QCNUMBT : INTEGER is 13
  		-- query condition: number is between two tokens of

  	QCNUMOREQ : INTEGER is 14
 		-- query condition: number is equal to at least one token in

   	QCFTSPH : INTEGER is 15
  		-- query condition: full-text search with the phrase of

  	QCFTSAND : INTEGER is 16
    	-- query condition: full-text search with all tokens in

  	QCFTSOR : INTEGER is 17
  		-- query condition: full-text search with at least one token in

  	QCFTSEX : INTEGER is 18
  		-- query condition: full-text search with the compound expression of

  	QCNEGATE : INTEGER
  		-- query condition: negation flag
		once
			Result := 1 |<< 24
		end

  	QCNOIDX : INTEGER
  		-- query condition: no index flag
		once
			Result := 1 |<< 25
		end

   	QOSTRASC : INTEGER is 0
 		-- order type: string ascending

  	QOSTRDESC : INTEGER is 1
  		-- order type: string descending

  	QONUMASC : INTEGER is 2
  		-- order type: number ascending

  	QONUMDESC : INTEGER is 3
		-- order type: number descending

  	MSUNION : INTEGER is 0
		-- set operation type: union

  	MSISECT : INTEGER is 1
		-- set operation type: intersection

 	MSDIFF : INTEGER is 2
  		-- set operation type: difference


  	KWMUTAB : INTEGER
		-- KWIC option: mark up by tabs
		once
			Result := 1 |<< 0
		end

 	KWMUCTRL : INTEGER
  		-- KWIC option: mark up by control characters
		once
			Result := 1 |<< 1
		end

	KWMUBRCT : INTEGER
  		-- KWIC option: mark up by square brackets
		once
			Result := 1 |<< 2
		end
  	KWNOOVER : INTEGER
  		-- KWIC option: do not overlap
		once
			Result := 1 |<< 24
		end

  	KWPULEAD : INTEGER
  		-- KWIC option: pick up the lead string
  		once
			Result := 1 |<< 25
		end
feature -- Create

	tctdbqrynew (a_tdb : POINTER) : POINTER
		--/* Create a query object.
		--   `tdb' specifies the table database object.
		--   The return value is the new query object. */
		--TDBQRY *tctdbqrynew(TCTDB *tdb);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbqrynew((TCTDB *)$a_tdb)
			}"
		end

feature -- Delete
	tctdbqrydel (a_qry : POINTER)
		--/* Delete a query object.
		--   `qry' specifies the query object. */
		--void tctdbqrydel(TDBQRY *qry);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbqrydel((TDBQRY *)$a_qry)
			}"
		end


feature -- Command
	tctdbqryaddcond (a_qry : POINTER; a_name : POINTER; an_op: INTEGER; an_expr : POINTER)
		--/* Add a narrowing condition to a query object.
		--   `qry' specifies the query object.
		--   `name' specifies the name of a column.  An empty string means the primary key.
		--   `op' specifies an operation type: `TDBQCSTREQ' for string which is equal to the expression,
		--   `TDBQCSTRINC' for string which is included in the expression, `TDBQCSTRBW' for string which
		--   begins with the expression, `TDBQCSTREW' for string which ends with the expression,
		--   `TDBQCSTRAND' for string which includes all tokens in the expression, `TDBQCSTROR' for string
		--   which includes at least one token in the expression, `TDBQCSTROREQ' for string which is equal
		--   to at least one token in the expression, `TDBQCSTRRX' for string which matches regular
		--   expressions of the expression, `TDBQCNUMEQ' for number which is equal to the expression,
		--   `TDBQCNUMGT' for number which is greater than the expression, `TDBQCNUMGE' for number which is
		--   greater than or equal to the expression, `TDBQCNUMLT' for number which is less than the
		--   expression, `TDBQCNUMLE' for number which is less than or equal to the expression, `TDBQCNUMBT'
		--   for number which is between two tokens of the expression, `TDBQCNUMOREQ' for number which is
		--   equal to at least one token in the expression, `TDBQCFTSPH' for full-text search with the
		--   phrase of the expression, `TDBQCFTSAND' for full-text search with all tokens in the expression,
		--   `TDBQCFTSOR' for full-text search with at least one token in the expression, `TDBQCFTSEX' for
		--   full-text search with the compound expression.  All operations can be flagged by bitwise-or:
		--   `TDBQCNEGATE' for negation, `TDBQCNOIDX' for using no index.
		--   `expr' specifies an operand exression. */
		--void tctdbqryaddcond(TDBQRY *qry, const char *name, int op, const char *expr);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbqryaddcond((TDBQRY *)$a_qry, (const char *)$a_name, (int) $an_op, (const char *)$an_expr)
			}"
		end



	tctdbqrysetorder (a_qry : POINTER; a_name : POINTER; a_type : INTEGER)
		--/* Set the order of a query object.
		--   `qry' specifies the query object.
		--   `name' specifies the name of a column.  An empty string means the primary key.
		--   `type' specifies the order type: `TDBQOSTRASC' for string ascending, `TDBQOSTRDESC' for
		--   string descending, `TDBQONUMASC' for number ascending, `TDBQONUMDESC' for number descending. */
		--void tctdbqrysetorder(TDBQRY *qry, const char *name, int type);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbqrysetorder((TDBQRY *)$a_qry, (const char *)$a_name, (int) $a_type)
			}"
		end


	tctdbqrysetlimit (a_qry : POINTER; a_max : INTEGER; a_skip : INTEGER)
		--/* Set the limit number of records of the result of a query object.
		--   `qry' specifies the query object.
		--   `max' specifies the maximum number of records of the result.  If it is negative, no limit is
		--   specified.
		--   `skip' specifies the number of skipped records of the result.  If it is not more than 0, no
		--   record is skipped. */
		--void tctdbqrysetlimit(TDBQRY *qry, int max, int skip);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbqrysetlimit((TDBQRY *)$a_qry, (int) $a_max, (int)$a_skip)
			}"
		end


feature -- Access
	tctdbqrysearch (a_qry : POINTER) : POINTER
		--/* Execute the search of a query object.
		--   `qry' specifies the query object.
		--   The return value is a list object of the primary keys of the corresponding records.  This
		--   function does never fail.  It returns an empty list even if no record corresponds.
		--   Because the object of the return value is created with the function `tclistnew', it should
		--   be deleted with the function `tclistdel' when it is no longer in use. */
		--TCLIST *tctdbqrysearch(TDBQRY *qry);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbqrysearch((TDBQRY *)$a_qry)
			}"
		end




	tctdbqryhint(a_qry : POINTER) : POINTER
		--/* Get the hint string of a query object.
		--   `qry' specifies the query object.
		--   The return value is the hint string.
		--   This function should be called after the query execution by `tctdbqrysearch' and so on.  The
		--   region of the return value is overwritten when this function is called again. */
		--const char *tctdbqryhint(TDBQRY *qry);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbqryhint((TDBQRY *)$a_qry)
			}"
		end

feature -- Remove

	tctdbqrysearchout(a_qry : POINTER) : BOOLEAN
		--/* Remove each record corresponding to a query object.
		--   `qry' specifies the query object of the database connected as a writer.
		--   If successful, the return value is true, else, it is false. */
		--bool tctdbqrysearchout(TDBQRY *qry);
		external
			"C inline use <tctdb.h>"
		alias
			"{
				tctdbqrysearchout((TDBQRY *)$a_qry)
			}"
		end

end
