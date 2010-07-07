note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_FDB_API

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
			create fdb.make
		end

	on_clean
			-- <Precursor>
		do
			fdb.close
			fdb.delete
		end

feature -- Test routines

	test_open_modes
		do
				-- Open as WRITER AND CREATE
				fdb.open_writer_create ("casket.tcf")

				assert("open mode as writer", fdb.is_open_mode_writer)

				-- Check the invariant
				assert("not_open_as_reader_and_writder", fdb.is_open implies (not (fdb.is_open_mode_reader and fdb.is_open_mode_writer)))
				assert("open_as_reader               " , (fdb.is_open and then fdb.is_open_mode_reader) implies (not fdb.is_open_mode_writer))
				assert("open_as_writer				  ", (fdb.is_open and then fdb.is_open_mode_writer) implies (not fdb.is_open_mode_reader))

				-- Close DB
				fdb.close
				assert ("database is closed", not fdb.is_open)


				-- Check the invariant
				assert("not_open_as_reader_and_writder", fdb.is_open implies (not (fdb.is_open_mode_reader and fdb.is_open_mode_writer)))
				assert("open_as_reader               " , (fdb.is_open and then fdb.is_open_mode_reader) implies (not fdb.is_open_mode_writer))
				assert("open_as_writer				  ", (fdb.is_open and then fdb.is_open_mode_writer) implies (not fdb.is_open_mode_reader))


				-- Open as READER
				fdb.open_reader ("casket.tcf")

				assert("open mode as reader", fdb.is_open_mode_reader)

				-- Check the invariant
				assert("not_open_as_reader_and_writder", fdb.is_open implies (not (fdb.is_open_mode_reader and fdb.is_open_mode_writer)))
				assert("open_as_reader               " , (fdb.is_open and then fdb.is_open_mode_reader) implies (not fdb.is_open_mode_writer))
				assert("open_as_writer				  ", (fdb.is_open and then fdb.is_open_mode_writer) implies (not fdb.is_open_mode_reader))


		end

	test_file_does_not_exist
		do
			assert("False",fdb.is_valid_path ("casket.tcf") = False)
		end

	test_file_does_exist
		do
			fdb.open_writer_create ("casket.tcf")
			assert("True",fdb.is_valid_path ("casket.tcf") = True)
		end


	test_tune
		do
			fdb.set_tune (100, 200)
			fdb.open_writer_create ("casket.tcf")
			assert ("Not has error", not fdb.has_error)
		end

	test_db_copy
		do
			fdb.open_writer_create ("casket.tcf")
			fdb.db_copy ("casket2.tcf")
			assert ("Not has error", not fdb.has_error)
		end

	test_put
		do
			fdb.open_writer_create ("casket.tcf")
			fdb.put("1", "val1")
			fdb.put("2", "val2")
			fdb.put("3", "val3")
			assert ("three elements", fdb.records_number = 3)
			assert ("expected value val1",fdb.retrieve ("1").is_equal ("val1"))
			assert ("expected value val3",fdb.retrieve ("3").is_equal ("val3"))
			fdb.put("a", "val3") -- the key sould be a decimal key.
			assert ("has error", fdb.has_error = true)
			fdb.clean_error
		end


	test_range
		local
			l_list : LIST[STRING]
		do
			fdb.open_writer_create ("casket.tcf")
			fdb.put("1", "val1")
			fdb.put("2", "val2")
			fdb.put("3", "val3")
			assert ("three elements", fdb.records_number = 3)
			assert ("expected value val1",fdb.retrieve ("1").is_equal ("val1"))
			assert ("expected value val3",fdb.retrieve ("3").is_equal ("val3"))
			fdb.put("4", "val4")
			fdb.put("5", "val5")
			fdb.put("6", "val6")
			fdb.put("7", "val7")
			fdb.put("8", "val8")

			l_list := fdb.range ("2", "5")
			assert("Extected 4 elements", l_list.count = 4)
		end


feature -- Implementation
	fdb : FDB_API

end


