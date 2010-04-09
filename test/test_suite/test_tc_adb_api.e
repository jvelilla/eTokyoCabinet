note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TC_ADB_API

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end
	TC_ADB_API
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			adb := tcadbnew
		end

	on_clean
			--<Precursor>
		local
			b : BOOLEAN
		do
			b := tcadbclose (adb)
			assert ("Expected true", b = true)

			tcadbdel (adb)

		end
feature -- Test routines

	test_open_database
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tch")
			b:= tcadbopen (adb,name.item )
			assert ("Expected true", b = true)
		end


	test_close_database
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

		end

feature -- Test to file
	test_copy_file
		local
		b:BOOLEAN
		name,path: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			create path.make ("tokiodb.txt")
			b := tcadbcopy (adb, path.item)
			assert ("Expected true", b = true)
		end



feature -- Test Queries

	test_path_file
		local
		b:BOOLEAN
		name,path: C_STRING
		k : C_STRING
		v : C_STRING
		p : POINTER
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			create path.make ("tokiodb1.txt")
			b := tcadbcopy (adb, path.item)
			assert ("Expected true", b = true)

			p := tcadbpath (adb)

			assert ("The same path",(create {STRING}.make_from_c(p)).is_equal("casket.tch"))
		end

	test_db_size
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		lsize : NATURAL_64
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			lsize := tcadbsize (adb)
			assert("Expected > 0", lsize > 0)

		end


	test_db_row_num
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		lsize : NATURAL_64
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			lsize := tcadbrnum (adb)
			assert("Expected 1", lsize = 1)

		end


feature -- Test Store Records
	test_put_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

		end


	test_put_keep_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("bar")
			create v.make ("union")

			b := tcadbputkeep2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

		end

	test_put_keep_records_key_exists
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("bar")
			create v.make ("union")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			create v.make ("join")
			b := tcadbputkeep2 (adb, k.item,v.item)
			assert ("Expected true", b = false)

			r := tcadbget2 (adb, k.item)
			assert ("Expected Value union",(create {STRING}.make_from_c(r)).is_equal("union"))
		end

	test_put_cat_records_key_exists
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("bar")
			create v.make ("union")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			create v.make ("join")
			b := tcadbputcat2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			r := tcadbget2 (adb, k.item)
			assert ("Expected Value unionjoin",(create {STRING}.make_from_c(r)).is_equal("unionjoin"))
		end


	test_put_cat_records_does_not_key_exists
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("bar")
			create v.make ("union")

			b := tcadbputcat2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			r := tcadbget2 (adb, k.item)
			assert ("Expected Value union",(create {STRING}.make_from_c(r)).is_equal("union"))
		end

	test_add_int_record
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : INTEGER_32
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("bar")
			v := tcadbaddint (adb, k.item, k.bytes_count, 10)
			assert ("Expected value 10", v = 10)
		end

	test_add_int_record_exist
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : INTEGER_32
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("bar")
			v := tcadbaddint (adb, k.item, k.bytes_count, 10)
			assert ("Expected value 10", v = 10)

			v := tcadbaddint (adb, k.item, k.bytes_count, 5)
			assert ("Expected value 15", v = 15)
		end

	test_add_double_record_exist
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : DOUBLE
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("bar")
			v := tcadbadddouble (adb, k.item, k.bytes_count, 10.5)
			assert ("Expected value 10.5", v = 10.5)

			v := tcadbadddouble (adb, k.item, k.bytes_count, 5.1)
			assert ("Expected value 15.6", v = 15.6)
		end


	test_add_int_record_not_int_exist
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : INTEGER
		p : POINTER
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("bar")
			create v.make ("val")
			b := tcadbput2 (adb, k.item, v.item)

			r := tcadbaddint (adb, k.item, k.bytes_count, 10)
			--assert ("Expected value 10", r = 10)

			p := tcadbget2 (adb, k.item)
			assert ("Expected Value val",(create {STRING}.make_from_c(p)).is_equal("val"))
		end


feature -- Test Retrieve Records
	test_retrieve_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			r := tcadbget2 (adb, k.item)
			assert ("Expected Value hop",(create {STRING}.make_from_c(r)).is_equal("hop"))
		end

	test_retrieve_record_size
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		s : INTEGER_32
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			r := tcadbget2 (adb, k.item)
			assert ("Expected Value hop",(create {STRING}.make_from_c(r)).is_equal("hop"))

			s := tcadbvsiz2 (adb, k.item)
			assert ("Expected Value 3", s = 3)

		end


	test_retrieve_record_does_not_exist_size
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		s : INTEGER_32
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("foo")
			s := tcadbvsiz2 (adb, k.item)
			assert ("Expected Value -1", s = -1)

		end


feature -- Test Remove Records

	test_remove_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			b := tcadbout2 (adb, k.item)
			assert ("Expected true", b = true)

			r := tcadbget2 (adb, k.item)
			assert ("Expected Value Void", r = default_pointer)

		end

feature -- Test Iterator

	test_iterate_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		pk,pv : POINTER
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			create k.make ("bar")
			create v.make ("step")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			create k.make ("baz")
			create v.make ("jazz")
			b := tcadbput2 (adb, k.item,v.item)
			assert ("Expected true", b = true)

			from
				b := tcadbiterinit (adb)
				assert ("Expected true", b = true)
				pk := tcadbiternext2 (adb)
			until pk = default_pointer

			loop
				pv := tcadbget2 (adb, pk)
				print ("key :" + (create {STRING}.make_from_c(pk)) +  "value:" +  (create {STRING}.make_from_c(pv)) )
				pk := tcadbiternext2 (adb)
			end

		end



feature {NONE} -- implementation
	adb: POINTER
		-- abstract database object
end


