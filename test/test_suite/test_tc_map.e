note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TC_MAP

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end
	TC_MAP
		undefine
			default_create
		end
feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			tc_map := tcmapnew
		end

	on_clean
			-- <Precursor>
		do
			tcmapdel (tc_map)
		end

feature -- Test routines


	test_clear
		local
			k : C_STRING
			V : C_STRING
			s : STRING
			r : POINTER
		do
			assert("Empty Map",tcmaprnum (tc_map) = 0)
			create k.make ("key")
			create v.make ("value")
			tcmapput2 (tc_map, k.item, v.item)
			create k.make ("key1")
			create v.make ("value1")
			tcmapput2 (tc_map, k.item, v.item)
			create k.make ("key2")
			create v.make ("value2")

			tcmapput2 (tc_map, k.item, v.item)
			assert("Empty One Record",tcmaprnum (tc_map) = 3)
			create s.make_from_c(tcmapget2 (tc_map, k.item))
			assert("Expected value",s.is_equal ("value2"))

			tcmapclear (tc_map)
			assert("Empty Map",tcmaprnum (tc_map) = 0)
		end


	test_iterator_2
		local
			k : C_STRING
			V : C_STRING
			s : STRING
			r : POINTER
		do
			assert("Empty Map",tcmaprnum (tc_map) = 0)
			create k.make ("key")
			create v.make ("value")
			tcmapput2 (tc_map, k.item, v.item)
			create k.make ("key1")
			create v.make ("value1")
			tcmapput2 (tc_map, k.item, v.item)
			create k.make ("key2")
			create v.make ("value2")

			tcmapput2 (tc_map, k.item, v.item)
			assert("Empty One Record",tcmaprnum (tc_map) = 3)
			create s.make_from_c(tcmapget2 (tc_map, k.item))
			assert("Expected value",s.is_equal ("value2"))

			from
				tcmapiterinit (tc_map)
				r := tcmapiternext2 (tc_map)
			until
				r = default_pointer
			loop
				print (create {STRING}.make_from_c(r))
				r := tcmapiternext2 (tc_map)
			end
		end



	test_put_2
		local
			k : C_STRING
			V : C_STRING
			s : STRING
		do
			assert("Empty Map",tcmaprnum (tc_map) = 0)
			create k.make ("key")
			create v.make ("value")
			tcmapput2 (tc_map, k.item, v.item)
			assert("Empty One Record",tcmaprnum (tc_map) = 1)
			create s.make_from_c(tcmapget2 (tc_map, k.item))
			assert("Expected value",s.is_equal ("value"))
		end


	test_put_keep_2
		local
			k : C_STRING
			V : C_STRING
			s : STRING
			b : BOOLEAN
		do
			assert("Empty Map",tcmaprnum (tc_map) = 0)
			create k.make ("key")
			create v.make ("value")
			b := tcmapputkeep2 (tc_map, k.item, v.item)
			assert ("Expected True", b = True)
			assert("Empty One Record",tcmaprnum (tc_map) = 1)
			create s.make_from_c(tcmapget2 (tc_map, k.item))
			assert("Expected value",s.is_equal ("value"))
		end

	test_put_keep_2_exist
		local
			k : C_STRING
			V : C_STRING
			s : STRING
			b : BOOLEAN
		do
			assert("Empty Map",tcmaprnum (tc_map) = 0)
			create k.make ("key")
			create v.make ("value")
			tcmapput2 (tc_map, k.item, v.item)
			assert("One Record",tcmaprnum (tc_map) = 1)
			create s.make_from_c(tcmapget2 (tc_map, k.item))
			assert("Expected value",s.is_equal ("value"))

			b := tcmapputkeep2 (tc_map, k.item, v.item)
			assert("Expected value false",b = False)
			assert("One Record",tcmaprnum (tc_map) = 1)
		end



	test_put_cat_2
		local
			k : C_STRING
			V : C_STRING
			s : STRING
		do
			assert("Empty Map",tcmaprnum (tc_map) = 0)
			create k.make ("key")
			create v.make ("value")
			tcmapput2 (tc_map, k.item, v.item)
			assert("One Record",tcmaprnum (tc_map) = 1)
			create s.make_from_c(tcmapget2 (tc_map, k.item))
			assert("Expected value",s.is_equal ("value"))

			create v.make ("contact")
			tcmapputcat2 (tc_map, k.item, v.item)
			assert("One Record",tcmaprnum (tc_map) = 1)
			create s.make_from_c(tcmapget2 (tc_map, k.item))
			assert("Expected value",s.is_equal ("valuecontact"))
		end


	test_put_cat_key_does_not_exist_2
		local
			k : C_STRING
			V : C_STRING
			s : STRING
		do
			assert("Empty Map",tcmaprnum (tc_map) = 0)
			create k.make ("key")
			create v.make ("value")
			tcmapput2 (tc_map, k.item, v.item)
			assert("One Record",tcmaprnum (tc_map) = 1)
			create s.make_from_c(tcmapget2 (tc_map, k.item))
			assert("Expected value",s.is_equal ("value"))

			create k.make ("key2")
			create v.make ("contact")
			tcmapputcat2 (tc_map, k.item, v.item)
			assert("Two Records",tcmaprnum (tc_map) = 2)
			create s.make_from_c(tcmapget2 (tc_map, k.item))
			assert("Expected value",s.is_equal ("contact"))
		end



	test_out_2
		local
			k : C_STRING
			V : C_STRING
			b : BOOLEAN
		do
			assert("Empty Map",tcmaprnum (tc_map) = 0)
			create k.make ("key")
			create v.make ("value")
			tcmapput2 (tc_map, k.item, v.item)
			assert("Empty One Record",tcmaprnum (tc_map) = 1)

			b := tcmapout2 (tc_map, k.item)
			assert ("True", b = True )
			assert("Empty Map",tcmaprnum (tc_map) = 0)

			create k.make ("key2")
			b := tcmapout2 (tc_map, k.item)
			assert ("True", b = False )
		end


feature -- Implementation

	tc_map: POINTER
	ser : STRING_SERIALIZATION
end


