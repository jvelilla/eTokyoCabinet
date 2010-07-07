note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TDB_API

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			create tdb.make
		end

	on_clean
			-- <Precursor>
		do
			tdb.close
			tdb.delete
		end

feature -- Test routines

	test_open_modes
		do
				-- Open as WRITER AND CREATE
				tdb.open_writer_create ("casket.tct")

				assert("open mode as writer", tdb.is_open_mode_writer)

				-- Check the invariant
				assert("not_open_as_reader_and_writder", tdb.is_open implies (not (tdb.is_open_mode_reader and tdb.is_open_mode_writer)))
				assert("open_as_reader               " , (tdb.is_open and then tdb.is_open_mode_reader) implies (not tdb.is_open_mode_writer))
				assert("open_as_writer				  ", (tdb.is_open and then tdb.is_open_mode_writer) implies (not tdb.is_open_mode_reader))

				-- Close DB
				tdb.close
				assert ("database is closed", not tdb.is_open)


				-- Check the invariant
				assert("not_open_as_reader_and_writder", tdb.is_open implies (not (tdb.is_open_mode_reader and tdb.is_open_mode_writer)))
				assert("open_as_reader               " , (tdb.is_open and then tdb.is_open_mode_reader) implies (not tdb.is_open_mode_writer))
				assert("open_as_writer				  ", (tdb.is_open and then tdb.is_open_mode_writer) implies (not tdb.is_open_mode_reader))


				-- Open as READER
				tdb.open_reader ("casket.tct")

				assert("open mode as reader", tdb.is_open_mode_reader)

				-- Check the invariant
				assert("not_open_as_reader_and_writder", tdb.is_open implies (not (tdb.is_open_mode_reader and tdb.is_open_mode_writer)))
				assert("open_as_reader               " , (tdb.is_open and then tdb.is_open_mode_reader) implies (not tdb.is_open_mode_writer))
				assert("open_as_writer				  ", (tdb.is_open and then tdb.is_open_mode_writer) implies (not tdb.is_open_mode_reader))


		end

	test_file_does_not_exist
		do
			assert("False",tdb.is_valid_path ("casket.tct") = False)
		end

	test_file_does_exist
		do
			tdb.open_writer_create ("casket.tct")
			assert("True",tdb.is_valid_path ("casket.tct") = True)
		end

	test_put_invalid_operation_in_open_mode_reader
		do
			tdb.open_writer_create ("casket.tct")
			tdb.put ("key", "value")
			assert ("One element", tdb.records_number = 1)
			tdb.close
			assert ("Database is closed", not tdb.is_open)
			tdb.open_reader ("casket.tct")
			tdb.put ("key1", "value2")
			assert ("Has error", tdb.has_error)
			assert ("Invalid Operation", tdb.error_code = 2)
			assert ("Expected Message",tdb.error_message (tdb.error_code).is_equal ("invalid operation"))
			tdb.clean_error
		end

	test_put_map
			-- New test routine
		local
			l_cols : HASH_TABLE[STRING,STRING]
			r_cols : HASH_TABLE[STRING,STRING]
			str : STRING
		do

			tdb.open_writer_create ("casket.tct")
			assert ("Empty Database", tdb.records_number = 0)
			create l_cols.make (3)
			l_cols.put ("javier","name")
			l_cols.put ("30","age")
			l_cols.put ("es,en","lang")

			tdb.put_map ("key", l_cols)
			assert ("One Element", tdb.records_number = 1)

			create l_cols.make(4)
			l_cols.put ("diego","name")
			l_cols.put ("50","age")
			l_cols.put ("it,en","lang")
			l_cols.put ("db,scripting","skills")
			tdb.put_map ("key2", l_cols)
			assert ("Two Elements", tdb.records_number = 2)

			r_cols  := tdb.retrieve_map ("key")
			assert ("Expected Name", r_cols.at ("name").is_equal ("javier"))
			assert ("Expected age", r_cols.at ("age").is_equal ("30"))

			str := tdb.retrieve ("key")
			assert ("Tab string record", str.is_equal ("age%T30%Tname%Tjavier%Tlang%Tes,en"))
		end


	test_search
			-- New test routine
		local
			l_cols: HASH_TABLE [STRING,STRING]
			str : STRING
			qry : TDB_QUERY
			l_list : LIST[STRING]
			r_cols : HASH_TABLE [STRING,STRING]

		do

			tdb.open_writer_create ("casket.tct")
			assert ("Empty Database", tdb.records_number = 0)
			create l_cols.make(4)
			l_cols.put ("javier","name")
			l_cols.put ("30","age")
			l_cols.put ("es,en","lang")

			tdb.put_map ("key", l_cols)
			assert ("One Element", tdb.records_number = 1)

			create l_cols.make(4)
			l_cols.put ("diego","name")
			l_cols.put ("50","age")
			l_cols.put ("it,en","lang")
			l_cols.put ("db,scripting","skills")
			tdb.put_map ("key2", l_cols)
			assert ("Two Elements", tdb.records_number = 2)

			r_cols := tdb.retrieve_map ("key")
			assert ("Expected Name", r_cols.at ("name").is_equal ("javier"))
			assert ("Expected age", r_cols.at ("age").is_equal ("30"))

			qry := tdb.query

			qry.add_condition ("age", qry.qcnumge, "20")
			qry.add_condition ("lang", qry.qcstror, "es,en")
			qry.set_order ("name", qry.qostrasc)
			qry.set_limit (10,0)

			l_list := qry.search
			assert ("two elements", l_list.count = 2)
			assert ("Expected key2",l_list.at (1).is_equal ("key2"))
			r_cols := tdb.retrieve_map (l_list.at (1))
			assert ("Expected Name diego",r_cols.at ("name").is_equal ("diego"))
			assert ("Expected Age 50",r_cols.at ("age").is_equal ("50"))
			str := tdb.retrieve ("key")
			assert ("Tab string record", str.is_equal ("age%T30%Tname%Tjavier%Tlang%Tes,en"))
		end

feature -- Implementation
	tdb : TDB_API
end


