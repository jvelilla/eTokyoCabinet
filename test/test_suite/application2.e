note
	description: "Summary description for {APPLICATION2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION2
	inherit
		TC_FDB_API
create
	make

feature -- Initialization
	make
		do

		end
feature -- Test FDB_API
	test_fdb_api
		do
			prepare_fdb
			test_iterate_records_fdb
			clean_fdb
		end

	test_iterate_records_fdb
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		pk : POINTER
		pv : POINTER
		do
			create name.make ("casket.tcf")
			b :=  tcfdbopen (fdb, name.item, owriter.bit_or(ocreat))

			create k.make ("1")
			create v.make ("hop")
			b := tcfdbput3 (fdb, k.item, v.item)

			create k.make ("2")
			create v.make ("jazz")
			b := tcfdbput3 (fdb, k.item, v.item)

			from
				b := tcfdbiterinit (fdb)

				pk := tcfdbiternext3 (fdb)
			until pk = default_pointer

			loop
				pv := tcfdbget3 (fdb, pk)
				print ("%Nkey :" + (create {STRING}.make_from_c(pk)) +  " %Nvalue:" +  (create {STRING}.make_from_c(pv)) +"%N")
				pk := tcfdbiternext3 (fdb)
			end
		end

	prepare_fdb
		do
			fdb := tcfdbnew
		end

	clean_fdb
		local
			b : BOOLEAN
		do
			b := tcfdbclose (fdb)
			tcfdbdel (fdb)

		end
feature {NONE} -- FDB implementation
	fdb: POINTER
		-- abstract database object
end
