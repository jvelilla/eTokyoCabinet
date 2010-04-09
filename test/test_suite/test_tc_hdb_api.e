note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TC_HDB_API

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end
	TC_HDB_API
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			hdb := tchdbnew
		end

	on_clean
			-- <Precursor>
		local
			b : BOOLEAN
		do
			b:= tchdbclose (hdb)
			assert ("Expected true", b = true)
			tchdbdel (hdb)
		end

feature -- Test Open Database

	test_open_database
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tch")
			b:= tchdbopen (hdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
		end

feature -- Test Store Records
	test_put_records
		local
			b : BOOLEAN
			name: C_STRING
			k,v : C_STRING
		do
			create name.make ("casket.tch")
			b:= tchdbopen (hdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("key")
			create v.make ("value")
			b := tchdbput2 (hdb, k.item, v.item)
			assert ("Expected put true", b = true)
		end


	test_put_keep_records
		local
			b : BOOLEAN
			name: C_STRING
			k,v : C_STRING
		do
			create name.make ("casket.tch")
			b:= tchdbopen (hdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("key")
			create v.make ("value")
			b := tchdbputkeep2 (hdb, k.item, v.item)
			assert ("Expected put keep true", b = true)
		end


	test_put_keep_records_exists
		local
			b : BOOLEAN
			name: C_STRING
			k,v : C_STRING

		do
			create name.make ("casket.tch")
			b:= tchdbopen (hdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("key")
			create v.make ("value")
			b := tchdbput2 (hdb, k.item, v.item)
			assert ("Expected put true", b = true)

			create v.make ("test")
			b := tchdbputkeep2 (hdb, k.item, v.item)
			assert ("Expected error code EKEEP",tchdbecode (hdb) = ekeep)
			assert ("Expected put keep false", b = false)
		end

	test_put_cat_records
		local
			b : BOOLEAN
			name: C_STRING
			k,v : C_STRING
		do
			create name.make ("casket.tch")
			b:= tchdbopen (hdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("key")
			create v.make ("value")
			b := tchdbputcat2 (hdb, k.item, v.item)
			assert ("Expected put cat true", b = true)
		end


	test_put_cat_records_exist
		local
			b : BOOLEAN
			name: C_STRING
			k,v : C_STRING
			r : POINTER
		do
			create name.make ("casket.tch")
			b:= tchdbopen (hdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("key")
			create v.make ("value")
			b := tchdbput2 (hdb, k.item, v.item)
			assert ("Expected put cat true", b = true)

			create v.make ("added")
			b := tchdbputcat2 (hdb, k.item, v.item)
			r := tchdbget2 (hdb, k.item)

			assert ("Expected put cat valueadded", (create {STRING}.make_from_c(r)).is_equal("valueadded"))
			assert ("Expected put cat true", b = true)
		end


feature -- Test Iterator

test_iterator_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		pk,pv : POINTER
		do
			create name.make ("casket.tch")
			b:= tchdbopen (hdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create k.make ("1")
			create v.make ("hop")
			b := tchdbput2 (hdb, k.item, v.item)
			assert ("Expected true", b = true)

			create k.make ("2")
			create v.make ("h1p")
			b := tchdbput2 (hdb, k.item, v.item)
			assert ("Expected true", b = true)


			from
				b := tchdbiterinit (hdb)
				assert ("Expected Iterator true", b = true)
				pk := tchdbiternext2 (hdb)
			until pk = default_pointer

			loop
				pv := tchdbget2 (hdb, pk)
				print ("key :" + (create {STRING}.make_from_c(pk)) +  "value:" +  (create {STRING}.make_from_c(pv)) )
				pk := tchdbiternext2 (hdb)
			end

		end

feature -- Implementation
	hdb : POINTER
		-- Hash Database Implementation
end


