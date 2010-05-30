note
	description: "Summary description for {TEST_HDB_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_HDB_API
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
			create hdb.make
		end

	on_clean
			-- <Precursor>
		do
			hdb.close
			hdb.delete
		end

feature -- Test routines

	test_open_modes
		do
				-- Open as WRITER AND CREATE
				hdb.open_writer_create ("casket.tch")

				assert("open mode as writer", hdb.is_open_mode_writer)

				-- Check the invariant
				assert("not_open_as_reader_and_writder", hdb.is_open implies (not (hdb.is_open_mode_reader and hdb.is_open_mode_writer)))
				assert("open_as_reader               " , (hdb.is_open and then hdb.is_open_mode_reader) implies (not hdb.is_open_mode_writer))
				assert("open_as_writer				  ", (hdb.is_open and then hdb.is_open_mode_writer) implies (not hdb.is_open_mode_reader))

				-- Close DB
				hdb.close
				assert ("database is closed", not hdb.is_open)


				-- Check the invariant
				assert("not_open_as_reader_and_writder", hdb.is_open implies (not (hdb.is_open_mode_reader and hdb.is_open_mode_writer)))
				assert("open_as_reader               " , (hdb.is_open and then hdb.is_open_mode_reader) implies (not hdb.is_open_mode_writer))
				assert("open_as_writer				  ", (hdb.is_open and then hdb.is_open_mode_writer) implies (not hdb.is_open_mode_reader))


				-- Open as READER
				hdb.open_reader ("casket.tch")

				assert("open mode as reader", hdb.is_open_mode_reader)

				-- Check the invariant
				assert("not_open_as_reader_and_writder", hdb.is_open implies (not (hdb.is_open_mode_reader and hdb.is_open_mode_writer)))
				assert("open_as_reader               " , (hdb.is_open and then hdb.is_open_mode_reader) implies (not hdb.is_open_mode_writer))
				assert("open_as_writer				  ", (hdb.is_open and then hdb.is_open_mode_writer) implies (not hdb.is_open_mode_reader))


		end

	test_file_does_not_exist
		do
			assert("False",hdb.is_valid_path ("casket.tch") = False)
		end

	test_file_does_exist
		do
			hdb.open_writer_create ("casket.tch")
			assert("True",hdb.is_valid_path ("casket.tch") = True)
		end


	test_tune
		do
			hdb.tune (100, 32, 64, hdb.ttcbs.as_natural_8)
			hdb.open_writer_create ("casket.tch")
			assert ("Not has error", not hdb.has_error)
		end

	test_db_copy
		do
			hdb.open_writer_create ("casket.tch")
			hdb.db_copy ("casket2.tch")
			assert ("Not has error", not hdb.has_error)
		end

	test_put
		do
			hdb.open_writer_create ("casket.tch")
			hdb.put_string("key1", "val1")
			hdb.put_string("key2", "val2")
			hdb.put_string("key3", "val3")
			assert ("three elements", hdb.records_number = 3)
			assert ("expected value val1",hdb.get_string ("key1").is_equal ("val1"))
			assert ("expected value val3",hdb.get_string ("key3").is_equal ("val3"))
		end


	test_put_async
		do
			hdb.open_writer_create ("casket.tch")
			hdb.put_string("key1", "val1")
			hdb.put_string("key2", "val2")
			hdb.put_string("key3", "val3")
			assert ("three elements", hdb.records_number = 3)
			assert ("expected value val1",hdb.get_string ("key1").is_equal ("val1"))
			assert ("expected value val3",hdb.get_string ("key3").is_equal ("val3"))
			hdb.put_asyncrhonic_string ("key4", "val4")
			assert ("Expected val4",hdb.get_string ("key4").is_equal ("val4"))
		end


feature -- Implementation
	hdb : HDB_API
end


