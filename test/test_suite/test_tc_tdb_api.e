note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TC_TDB_API

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end
	TC_TDB_API
		undefine
			default_create
		end
	TC_MAP_API
		undefine
			default_create
		end
	TC_LIST_API
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			tdb := tctdbnew
		end

	on_clean
			-- <Precursor>
		local
			b : BOOLEAN
		do
			b:= tctdbclose (tdb)
			assert ("Expected true", b = true)
			tctdbdel (tdb)
		end
feature -- Test Open Database

	test_open_database
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
		end

	test_insert
		local
			k : C_STRING
			v : C_STRING
			name : C_STRING
			b : BOOLEAN
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			map := tcmapnew
			create k.make ("name")
			create v.make ("javier")
			tcmapput2 (map, k.item, v.item)
			create k.make ("age")
			create v.make ("30")
			tcmapput2 (map, k.item, v.item)
			create k.make ("lang")
			create v.make ("en,es")

			create k.make ("key")
			b:=tctdbput (tdb, k.item, k.count, map)
			assert ("Expected true", b = true)
			assert ("One Element", tctdbrnum (tdb) = 1)

		end

	test_search
		local
			k : C_STRING
			v : C_STRING
			name : C_STRING
			b : BOOLEAN
			qry : TC_TDB_QUERY
			tc_qry : POINTER
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			map := tcmapnew
			create k.make ("name")
			create v.make ("javier")
			tcmapput2 (map, k.item, v.item)
			create k.make ("age")
			create v.make ("30")
			tcmapput2 (map, k.item, v.item)
			create k.make ("lang")
			create v.make ("en,es")
			tcmapput2 (map, k.item, v.item)

			create k.make ("key")
			b:=tctdbput (tdb, k.item, k.count, map)
			assert ("Expected true", b = true)
			assert ("One Element", tctdbrnum (tdb) = 1)

			create k.make ("name")
			create v.make ("lara")
			tcmapput2 (map, k.item, v.item)
			create k.make ("age")
			create v.make ("3")
			tcmapput2 (map, k.item, v.item)
			create k.make ("lang")
			create v.make ("es")
			tcmapput2 (map, k.item, v.item)

			create k.make ("key1")
			b:=tctdbput (tdb, k.item, k.count, map)
			assert ("Expected true", b = true)
			assert ("Two Elements", tctdbrnum (tdb) = 2)


			create k.make ("name")
			create v.make ("pedro")
			tcmapput2 (map, k.item, v.item)
			create k.make ("age")
			create v.make ("24")
			tcmapput2 (map, k.item, v.item)
			create k.make ("lang")
			create v.make ("en,es,it")
			tcmapput2 (map, k.item, v.item)

			create k.make ("key2")
			b:=tctdbput (tdb, k.item, k.count, map)
			assert ("Expected true", b = true)
			assert ("Three Element", tctdbrnum (tdb) = 3)

            create qry
            tc_qry := qry.tctdbqrynew (tdb)

            create k.make ("age")
			create v.make ("20")
            qry.tctdbqryaddcond (tc_qry, k.item, qry.qcnumge, v.item)


            create k.make ("lang")
			create v.make ("en,es")
            qry.tctdbqryaddcond (tc_qry, k.item, qry.qcstror,v.item)

			create k.make ("name")
			qry.tctdbqrysetorder(tc_qry, k.item, qry.qostrasc)
            qry.tctdbqrysetlimit (tc_qry, 10,0)

    		list := qry.tctdbqrysearch (tc_qry)
    		assert ("Expected two elements", tclistnum (list) = 2)
		end

feature -- Implementation
	tdb : POINTER
		-- Table Database Object

	map : POINTER
		-- Map Object

	list : POINTER
		-- List Object
end


