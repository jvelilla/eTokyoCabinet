note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_BDB_API

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
			create bdb.make
		end

	on_clean
			-- <Precursor>
		do
			bdb.close
			bdb.delete
		end

feature -- Test routines

	test_open_modes
		do
				-- Open as WRITER AND CREATE
				bdb.open_writer_create ("casket.tcf")

				assert("open mode as writer", bdb.is_open_mode_writer)

				-- Check the invariant
				assert("not_open_as_reader_and_writder", bdb.is_open implies (not (bdb.is_open_mode_reader and bdb.is_open_mode_writer)))
				assert("open_as_reader               " , (bdb.is_open and then bdb.is_open_mode_reader) implies (not bdb.is_open_mode_writer))
				assert("open_as_writer				  ", (bdb.is_open and then bdb.is_open_mode_writer) implies (not bdb.is_open_mode_reader))

				-- Close DB
				bdb.close
				assert ("database is closed", not bdb.is_open)


				-- Check the invariant
				assert("not_open_as_reader_and_writder", bdb.is_open implies (not (bdb.is_open_mode_reader and bdb.is_open_mode_writer)))
				assert("open_as_reader               " , (bdb.is_open and then bdb.is_open_mode_reader) implies (not bdb.is_open_mode_writer))
				assert("open_as_writer				  ", (bdb.is_open and then bdb.is_open_mode_writer) implies (not bdb.is_open_mode_reader))


				-- Open as READER
				bdb.open_reader ("casket.tcf")

				assert("open mode as reader", bdb.is_open_mode_reader)

				-- Check the invariant
				assert("not_open_as_reader_and_writder", bdb.is_open implies (not (bdb.is_open_mode_reader and bdb.is_open_mode_writer)))
				assert("open_as_reader               " , (bdb.is_open and then bdb.is_open_mode_reader) implies (not bdb.is_open_mode_writer))
				assert("open_as_writer				  ", (bdb.is_open and then bdb.is_open_mode_writer) implies (not bdb.is_open_mode_reader))


		end

	test_file_does_not_exist
		do
			assert("False",bdb.is_valid_path ("casket.tcf") = False)
		end

	test_file_does_exist
		do
			bdb.open_writer_create ("casket.tcf")
			assert("True",bdb.is_valid_path ("casket.tcf") = True)
		end


	test_tune
		do
			bdb.set_tune (10, 64, 64, 10,10, bdb.bdbttcbs.as_natural_8)
			bdb.open_writer_create ("casket.tcf")
			assert ("Not has error", not bdb.has_error)
		end

	test_db_copy
		do
			bdb.open_writer_create ("casket.tcf")
			bdb.db_copy ("casket2.tcf")
			assert ("Not has error", not bdb.has_error)
		end

	test_put
		do
			bdb.open_writer_create ("casket.tcf")
			bdb.put("key1", "val1")
			bdb.put("key2", "val2")
			bdb.put("key3", "val3")
			assert ("three elements", bdb.records_number = 3)
			assert ("expected value val1",bdb.retrieve ("key1").is_equal ("val1"))
			assert ("expected value val3",bdb.retrieve ("key3").is_equal ("val3"))
		end



feature -- Implementation
	bdb : BDB_API

end


