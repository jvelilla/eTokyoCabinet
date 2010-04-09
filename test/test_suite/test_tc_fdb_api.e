note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TC_FDB_API

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end
	TC_FDB_API
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			fdb := tcfdbnew
		end

	on_clean
			-- <Precursor>
		local
			b : BOOLEAN
		do
			b:= tcfdbclose (fdb)
			assert ("Expected true", b = true)
			tcfdbdel (fdb)
		end

feature -- Test Open Database

	test_open_database
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
		end


feature -- Test store records

	test_put_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("1")
			create v.make ("hop")
			b := tcfdbput3 (fdb, k.item, v.item)
			assert ("Expected true", b = true)
		end


	test_put_records_add_int
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			assert ("Expected Velue : 2", tcfdbaddint (fdb, 1,2) = 2)
		end

	test_put_records_add_double
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			assert ("Expected Velue : 2", tcfdbadddouble (fdb, 1,2.8) = 2.8)
		end

	test_put_records_exists_add_int
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		i : INTEGER
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("1")
			create v.make ("5")
			b := tcfdbput3 (fdb, k.item, v.item)
			assert ("Expected true", b = true)

			i := tcfdbaddint (fdb, 1,2)
			assert ("Expected Velue INT_MIN: ", i = i.min_value)
		end

	test_put_records_bad_key
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("hola")
			create v.make ("hop")
			b := tcfdbput3 (fdb, k.item, v.item)
			assert ("Expected False", b = false)
		end


	test_put_keep_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("10")
			create v.make ("hop")
			b := tcfdbputkeep3 (fdb, k.item, v.item)
			assert ("Expected True", b = true)
		end

	test_put_keep_records_key_exists
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("10")
			create v.make ("hop")
			b := tcfdbputkeep3 (fdb, k.item, v.item)
			assert ("Expected True", b = true)

			create v.make ("pop")
			b := tcfdbputkeep3 (fdb, k.item, v.item)
			assert ("Expected True", b = False)
			assert ("Expected error code EKEEP", tcfdbecode (fdb) = ekeep)
		end


	test_put_cat_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("10")
			create v.make ("hop")
			b := tcfdbputcat3 (fdb, k.item, v.item)
			assert ("Expected True", b = true)
		end


	test_put_cat_records_exists
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("10")
			create v.make ("hop")
			b := tcfdbput3 (fdb, k.item, v.item)
			assert ("Expected True", b = true)

			create v.make ("hip")
			b := tcfdbputcat3 (fdb, k.item, v.item)
			assert ("Expected True", b = true)

            r := tcfdbget3 (fdb, k.item)
            assert ("Expected True", (create {STRING}.make_from_c(r)).is_equal("hophip"))
		end


feature -- Iterator


	test_iterator_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		pk,pv : POINTER
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("1")
			create v.make ("hop")
			b := tcfdbput3 (fdb, k.item, v.item)
			assert ("Expected true", b = true)

			create k.make ("2")
			create v.make ("h1p")
			b := tcfdbput3 (fdb, k.item, v.item)
			assert ("Expected true", b = true)


			from
				b := tcfdbiterinit (fdb)
				assert ("Expected Iterator true", b = true)
				pk := tcfdbiternext3 (fdb)
			until pk = default_pointer

			loop
				pv := tcfdbget3 (fdb, pk)
				print ("key :" + (create {STRING}.make_from_c(pk)) +  "value:" +  (create {STRING}.make_from_c(pv)) )
				pk := tcfdbiternext3 (fdb)
			end

		end


feature -- Retrieve Records

	test_get_records_exists
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("10")
			create v.make ("hop")
			b := tcfdbput3 (fdb, k.item, v.item)
			assert ("Expected True", b = true)

			r := tcfdbget3 (fdb, k.item)
			assert ("Expected True", (create {STRING}.make_from_c(r)).is_equal("hop"))
		end

	test_get_records_does_not_exists
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		do
			create name.make ("casket.tcf")
			b:= tcfdbopen (fdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("10")

			r := tcfdbget3 (fdb, k.item)
			assert ("Expected True", r = default_pointer)

		end

feature -- Implementation
	fdb : POINTER
		-- fixed length database		

end


