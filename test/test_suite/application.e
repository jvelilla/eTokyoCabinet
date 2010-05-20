note
	description : "test_suite application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS
	TC_ADB_API
		undefine
			default_create
		end
	TC_CONSTANTS
		undefine
			default_create
		end
	TC_BDB_API
		undefine
			default_create
		end
	TC_BDB_CURSOR
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			app2 : APPLICATION2
			app3 : APPLICATION3
		do
			print ("Equal")
			test_equal
			print ("%N============================== TEST ADB API ======================================%N")
			test_adb_api
			print ("%N============================== TEST BDB API ======================================%N")
			test_bdb_api
			print ("%N============================== TEST FDB API ======================================%N")
			create app2.make
			app2.test_fdb_api
			print ("%N============================== TEST HDB API ======================================%N")
			create app3.make
			app3.test_Hdb_api

		end
feature -- Equal
	test_equal
		local
			p, p1 : PERSON
		do
			create p.make ("javier", "velilla")
			create p1.make ("javier","velilla")

			if p ~ p1 then
				print ("True")
			else
				print ("False")
			end
		end

feature -- Test ADB_API

	test_adb_api
		do
			prepare_adb
			test_iterate_records_adb
			test_copy_file
			test_constants
			clean_adb
		end

	test_iterate_records_adb
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		pk,pv : POINTER
		do
			create name.make ("casket.tch")
			b := tcadbopen (adb,name.item )


			create k.make ("foo")
			create v.make ("hop")
			b := tcadbput2 (adb, k.item,v.item)

			create k.make ("bar")
			create v.make ("step")
			b := tcadbput2 (adb, k.item,v.item)

			create k.make ("baz")
			create v.make ("jazz")
			b := tcadbput2 (adb, k.item,v.item)

			from
				b := tcadbiterinit (adb)
				pk := tcadbiternext2 (adb)
			until pk = default_pointer

			loop
				pv := tcadbget2 (adb, pk)
				print ("%Nkey :" + (create {STRING}.make_from_c(pk)) +  "   value:" +  (create {STRING}.make_from_c(pv))  + "%N")
				pk := tcadbiternext2 (adb)
			end

		end

	test_copy_file
		local
		b:BOOLEAN
		name,path: C_STRING
		do
			create path.make ("tokiodb.txt")
			b := tcadbcopy (adb, path.item)

		end

	test_constants
		do
			print ("%N ============ Enumeration for tunning Options =======================%N")
		    print ("%NConstant BDBTLARGE: " + BDBTLARGE.out + "%N")
		    print ("%NConstant BDBTDEFLATE: " + BDBTDEFLATE.out + "%N")
		    print ("%NConstant BDBTBZIP: " + BDBTBZIP.out + "%N")
		    print ("%NConstant BDBTTCBS: " + BDBTTCBS.out + "%N")
		    print ("%NConstant BDBTEXCODEC: " + BDBTEXCODEC.out + "%N")
		    print ("%N ============ Enumeration for open Modes =======================%N")
		    print ("%NConstant BDBOREADER: " + OREADER.out + "%N")
		    print ("%NConstant BDBOWRITER: " + OWRITER.out + "%N")
		    print ("%NConstant BDBOCREAT: " + OCREAT.out + "%N")
		    print ("%NConstant BDBOTRUNC: " + OTRUNC.out + "%N")
		    print ("%NConstant BDBONOLCK: " + ONOLCK.out + "%N")
		    print ("%NConstant BDBOLCKNB: " + OLCKNB.out + "%N")
		    print ("%NConstant BDBOTSYNC: " + OTSYNC.out + "%N")
		end

	prepare_adb
		do
			adb := tcadbnew
		end

	clean_adb
		local
			b : BOOLEAN
		do
			b := tcadbclose (adb)
			tcadbdel (adb)

		end
feature {NONE} -- ADB implementation
	adb: POINTER
		-- abstract database object	


feature -- Test BDB_API
	test_bdb_api
		do
			prepare_bdb
			test_iterate_records_bdb
			clean_bdb
		end

	test_iterate_records_bdb
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		key : POINTER
		val : POINTER
		do
			create name.make ("casket.tcb")
			b :=  tcbdbopen (bdb, name.item, owriter.bit_or(ocreat))

			create k.make ("foo")
			create v.make ("hop")
			b := tcbdbput2 (bdb, k.item, v.item)

			create k.make ("far")
			create v.make ("jazz")
			b := tcbdbput2 (bdb, k.item, v.item)

			from
				bdb_cursor := tcbdbcurnew (bdb)
				b := tcbdbcurfirst (bdb_cursor)
			until not b
			loop
				key := tcbdbcurkey2 (bdb_cursor)
				val := tcbdbcurval2 (bdb_cursor)
				print ("%N Key:" + create {STRING}.make_from_c(key))
				print ("%N Val:" + create {STRING}.make_from_c(val))
				b := tcbdbcurnext (bdb_cursor)
			end


		end

	prepare_bdb
		do
			bdb := tcbdbnew
		end

	clean_bdb
		local
			b : BOOLEAN
		do
			b := tcbdbclose (bdb)
			tcbdbdel (bdb)

		end
feature {NONE} -- BDB implementation
	bdb: POINTER
		-- abstract database object
	bdb_cursor : POINTER
		-- cursor b tree

	bdbapi: BDB_API

end
