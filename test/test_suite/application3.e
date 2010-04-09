note
	description: "Summary description for {APPLICATION3}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION3
		inherit
		TC_HDB_API
create
	make

feature -- Initialization
	make
		do

		end
feature -- Test HDB_API
	test_hdb_api
		do
			prepare_hdb
			test_iterate_records_hdb
			clean_hdb
		end

	test_iterate_records_hdb
		local
		b:BOOLEAN
		name: C_STRING
		k : C_STRING
		v : C_STRING
		pk : POINTER
		pv : POINTER
		do
			create name.make ("casket.tch")
			b :=  tchdbopen (hdb, name.item, owriter.bit_or(ocreat))

			create k.make ("coca")
			create v.make ("hop")
			b := tchdbput2 (hdb, k.item, v.item)

			create k.make ("eiffel")
			create v.make ("jazz")
			b := tchdbput2 (hdb, k.item, v.item)

			from
				b := tchdbiterinit (hdb)

				pk := tchdbiternext2 (hdb)
			until pk = default_pointer

			loop
				pv := tchdbget2 (hdb, pk)
				print ("%Nkey :" + (create {STRING}.make_from_c(pk)) +  " %Nvalue:" +  (create {STRING}.make_from_c(pv)) +"%N")
				pk := tchdbiternext2 (hdb)
			end
		end

	prepare_hdb
		do
			hdb := tchdbnew
		end

	clean_hdb
		local
			b : BOOLEAN
		do
			b := tchdbclose (hdb)
			tchdbdel (hdb)

		end
feature {NONE} -- HDB implementation
	hdb: POINTER
		-- hash database object
end
