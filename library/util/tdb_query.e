note
	description: "Summary description for {TDB_QUERY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TDB_QUERY

inherit
	TC_TDB_QUERY

create {TDB_API}
	make_by_pointer
feature {TDB_API} -- Iinitialization

	make_by_pointer ( a_tdb : POINTER)
			-- Create an object Query based on a table database pointer `a_tdb'
		require
			valid_pointer : a_tdb /= default_pointer
		do
			qry := tctdbqrynew (a_tdb)
		ensure
		    query_object_created : qry /= default_pointer
		end

feature -- Access

	search : LIST[STRING]
		-- Execute the search of a query object.
		-- The return value is a list object of the primary keys of the corresponding records.  This
		-- function does never fail.  It returns an empty list even if no record corresponds.
		local
			l_list : LIST_API
		do
			create l_list.make_by_pointer(tctdbqrysearch (qry))
			Result := l_list.as_list
			l_list.delete
		end

	hint : STRING
		-- Get the hint string of a query object.
		--   The return value is the hint string.
		--   This function should be called after the query execution by `search' and so on.
		local
			r : POINTER
		do
			r := tctdbqryhint (qry)
			if r /= default_pointer then
				create Result.make_from_c(r)
			end
		end
feature -- Change Element

	add_condition (a_name : STRING; an_op : INTEGER; an_expr : STRING)
		--   `a_name' specifies the name of a column.  An empty string means the primary key.
		--   `an_op' specifies an operation type: TBD
		--   `an_expr' specifies an operand expression.
		local
			c_name : C_STRING
			c_expr : C_STRING
		do
			create c_name.make (a_name)
			create c_expr.make (an_expr)
			tctdbqryaddcond (qry, c_name.item, an_op, c_expr.item)
		end


	set_order (a_name : STRING; a_type : INTEGER)
		-- Set the order of a query object.
		-- `a_name' specifies the name of a column.  An empty string means the primary key.
		-- `a_type' specifies the order type: `TDBQOSTRASC' for string ascending, `TDBQOSTRDESC' for
		--   string descending, `TDBQONUMASC' for number ascending, `TDBQONUMDESC' for number descending.
		local
			c_name : C_STRING
		do
			create c_name.make (a_name)
			tctdbqrysetorder (qry, c_name.item, a_type)
		end


	set_limit ( a_max : INTEGER;  a_skip : INTEGER)
			--Set the limit number of records of the result of a query object.
			--`a_max' specifies the maximum number of records of the result.  If it is negative, no limit is
			--`a_skip' specifies the number of skipped records of the result.  If it is not more than 0, no
			-- record is skipped.
		do
			tctdbqrysetlimit (qry, a_max, a_skip)
		end


feature -- Status Report
	was_error: BOOLEAN
			-- Indicates that there was an error during the last operation

	error: STRING
			-- Output a related error message.
		local
		do
		end


feature -- Remove

	search_out
			--Remove each record corresponding to a query object.
		local
			b : BOOLEAN
		do
			b := tctdbqrysearchout (qry)
			if not b then
				was_error := True
				-- Set the error message
			end
		end

feature {NONE}-- Implementation
	qry : POINTER
		-- POINTER to a query object	
invariant
	valid_qry_pointer : qry /= default_pointer
end
