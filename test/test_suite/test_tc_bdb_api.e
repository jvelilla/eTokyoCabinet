note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TC_BDB_API

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end
	TC_BDB_API
		undefine
			default_create
		end
	TC_BDB_CURSOR
		undefine
			default_create
		end
	TC_CONSTANTS
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			bdb := tcbdbnew
		end

	on_clean
			-- <Precursor>
		local
			b : BOOLEAN
		do
			b:= tcbdbclose (bdb)
			assert ("Expected true", b = true)
			tcbdbdel (bdb)
		end


feature -- Test Open Database



	test_open_database
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tcb")
			b :=  tcbdbopen (bdb, name.item, owriter.bit_or (ocreat))
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
			create name.make ("casket.tcb")
			b :=  tcbdbopen (bdb, name.item, owriter.bit_or (ocreat))
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcbdbput2 (bdb, k.item, v.item)
			assert ("Expected true", b = true)
		end


	test_put_keep_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tcb")
			b :=  tcbdbopen (bdb, name.item, owriter.bit_or (ocreat))
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcbdbputkeep2 (bdb, k.item, v.item)
			assert ("Expected true", b = true)

		end


	test_put_keep_records_key_exists
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v,v1 : C_STRING
		r : POINTER
		i : INTEGER
		do
			create name.make ("casket.tcb")

		 	b :=  tcbdbopen (bdb, name.item, owriter.bit_or(ocreat))
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcbdbput2 (bdb, k.item, v.item)
			assert ("Expected true", b = true)


			create v1.make ("jazz")
			b := tcbdbputkeep2 (bdb, k.item, v1.item)
			i := tcbdbecode (bdb)
			assert ("Expected False", b = false)

			r := tcbdbget2 (bdb, k.item)
			assert ("Expected Value hop",(create {STRING}.make_from_c(r)).is_equal("hop"))
		end


	test_put_cat_record_does_not_exist
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		do
			create name.make ("casket.tcb")
			b :=  tcbdbopen (bdb, name.item, owriter.bit_or (ocreat))
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcbdbputcat2 (bdb, k.item, v.item)
			assert ("Expected true", b = true)
		end

	test_put_cat_record_key_exists
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		do
			create name.make ("casket.tcb")
			b :=  tcbdbopen (bdb, name.item, owriter.bit_or (ocreat))
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcbdbput2 (bdb, k.item, v.item)
			assert ("Expected true", b = true)

			create v.make ("jazz")
			b := tcbdbputcat2 (bdb, k.item, v.item)
			assert ("Expected true", b = true)

			r := tcbdbget2 (bdb, k.item)
			assert ("Expected hopjazz", (create {STRING}.make_from_c(r)).is_equal("hopjazz"))

		end

feature -- Test iterator

	test_iterator
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
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcbdbput2 (bdb, k.item, v.item)
			assert ("Expected true", b = true)

			create k.make ("far")
			create v.make ("jazz")
			b := tcbdbput2 (bdb, k.item, v.item)
			assert ("Expected true", b = true)

			from
				bdb_cursor := tcbdbcurnew (bdb)
				b := tcbdbcurfirst (bdb_cursor)
			until not b
			loop
				key := tcbdbcurkey2 (bdb_cursor)
				val := tcbdbcurval2 (bdb_cursor)
				b := tcbdbcurnext (bdb_cursor)
			end


		end

feature -- Test retrieve records

	test_retrieve_records
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		do
			create name.make ("casket.tcb")
			b :=  tcbdbopen (bdb, name.item, owriter.bit_or (ocreat))
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcbdbput2 (bdb, k.item, v.item)
			assert ("Expected true", b = true)

			r := tcbdbget2 (bdb, k.item)
			assert ("Expected Value hop",(create {STRING}.make_from_c(r)).is_equal("hop"))
		end

feature -- Test Error Messages

	test_error_msg
		local
			error : STRING
		do
			create error.make_from_c (tcbdberrmsg (eclose))
			assert ("Expected error: close error", error.is_equal("close error"))
		end



	test_last_error
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		r : POINTER
		i : INTEGER
		do
			create name.make ("casket.tcb")
			b :=  tcbdbopen (bdb, name.item, owriter.bit_or (ocreat))
			assert ("Expected true", b = true)

			create k.make ("foo")
			create v.make ("hop")
			b := tcbdbput2 (bdb, k.item, v.item)
			assert ("Expected true", b = true)
		end

feature {NONE} -- implementation
	bdb: POINTER
		-- B-tree database object

	bdb_cursor : POINTER
		-- cursor

end


