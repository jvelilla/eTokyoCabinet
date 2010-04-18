note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TC_TREE

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end
	TC_TREE
		undefine
			default_create
		end


feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			tc_tree := tctreenew
		end

	on_clean
			-- <Precursor>
		do
			tctreedel (tc_tree)
		end

feature -- Test routines

	test_iterator
		local
			k : C_STRING
			v : C_STRING
			r : POINTER
		do
			assert ("Empty Tree", tctreernum (tc_tree) = 0)
			create k.make ("key")
			create v.make ("value")
			tctreeput2 (tc_tree, k.item, v.item)

			create k.make ("key1")
			create v.make ("value1")
			tctreeput2 (tc_tree, k.item, v.item)

			create k.make ("key2")
			create v.make ("value2")
			tctreeput2 (tc_tree, k.item, v.item)
			assert ("Tree with three records", tctreernum (tc_tree) = 3)

			from
				tctreeiterinit (tc_tree)
				r := tctreeiternext2 (tc_tree)
			until
				r = default_pointer
			loop
				print (create {STRING}.make_from_c(r))
				r := tctreeiternext2 (tc_tree)
			end
		end


	test_clear
		local
			k : C_STRING
			v : C_STRING
			r : POINTER
		do
			assert ("Empty Tree", tctreernum (tc_tree) = 0)
			create k.make ("key")
			create v.make ("value")
			tctreeput2 (tc_tree, k.item, v.item)

			create k.make ("key1")
			create v.make ("value1")
			tctreeput2 (tc_tree, k.item, v.item)

			create k.make ("key2")
			create v.make ("value2")
			tctreeput2 (tc_tree, k.item, v.item)
			assert ("Tree with three records", tctreernum (tc_tree) = 3)

			tctreeclear (tc_tree)
			assert ("Empty tree", tctreernum (tc_tree) = 0)
		end


	test_put_2
		local
			k : C_STRING
			v : C_STRING
		do
			assert ("Empty Tree", tctreernum (tc_tree) = 0)
			create k.make ("key")
			create v.make ("value")
			tctreeput2 (tc_tree, k.item, v.item)
			assert ("Tree with one record", tctreernum (tc_tree) = 1)
			assert ("Expected Record Value", (create {STRING}.make_from_c(tctreeget2 (tc_tree, k.item))).is_equal("value"))
		end


	test_put_keep_2_record_not_exist
		local
			k : C_STRING
			v : C_STRING
			b : BOOLEAN
		do
			assert ("Empty Tree", tctreernum (tc_tree) = 0)
			create k.make ("key")
			create v.make ("value")
			tctreeput2 (tc_tree, k.item, v.item)
			assert ("Tree with one record", tctreernum (tc_tree) = 1)
			assert ("Expected Record Value", (create {STRING}.make_from_c(tctreeget2 (tc_tree, k.item))).is_equal("value"))

			create k.make ("key1")
			create v.make ("value1")
			b := tctreeputkeep2 (tc_tree,k.item,v.item)
			assert ("Expected true", b=true)
			assert ("Tree with two record", tctreernum (tc_tree) = 2)
			assert ("Expected Record Value", (create {STRING}.make_from_c(tctreeget2 (tc_tree, k.item))).is_equal("value1"))
		end


	test_put_keep_2
		local
			k : C_STRING
			v : C_STRING
			b : BOOLEAN
		do
			assert ("Empty Tree", tctreernum (tc_tree) = 0)
			create k.make ("key")
			create v.make ("value")
			tctreeput2 (tc_tree, k.item, v.item)
			assert ("Tree with one record", tctreernum (tc_tree) = 1)
			assert ("Expected Record Value", (create {STRING}.make_from_c(tctreeget2 (tc_tree, k.item))).is_equal("value"))

			create k.make ("key")
			create v.make ("value1")
			b := tctreeputkeep2 (tc_tree,k.item,v.item)
			assert ("Expected true", b=false)
			assert ("Tree with one record", tctreernum (tc_tree) = 1)
		end


	test_put_cat_2
		local
			k : C_STRING
			v : C_STRING
		do
			assert ("Empty Tree", tctreernum (tc_tree) = 0)
			create k.make ("key")
			create v.make ("value")
			tctreeput2 (tc_tree, k.item, v.item)
			assert ("Tree with one record", tctreernum (tc_tree) = 1)
			assert ("Expected Record Value", (create {STRING}.make_from_c(tctreeget2 (tc_tree, k.item))).is_equal("value"))

			create v.make ("_added")
			tctreeputcat2 (tc_tree,k.item,v.item)
			assert ("Tree with one record", tctreernum (tc_tree) = 1)
			assert ("Expected Record Value", (create {STRING}.make_from_c(tctreeget2 (tc_tree, k.item))).is_equal("value_added"))
		end


	test_put_cat_2_records_does_not_exist
		local
			k : C_STRING
			v : C_STRING
		do
			assert ("Empty Tree", tctreernum (tc_tree) = 0)
			create k.make ("key")
			create v.make ("value")
			tctreeputcat2 (tc_tree, k.item, v.item)
			assert ("Tree with one record", tctreernum (tc_tree) = 1)
			assert ("Expected Record Value", (create {STRING}.make_from_c(tctreeget2 (tc_tree, k.item))).is_equal("value"))
		end


	test_out_2
		local
			k : C_STRING
			v : C_STRING
			b : BOOLEAN
		do
			assert ("Empty Tree", tctreernum (tc_tree) = 0)
			create k.make ("key")
			create v.make ("value")
			tctreeput2 (tc_tree, k.item, v.item)
			assert ("Tree with one record", tctreernum (tc_tree) = 1)
			assert ("Expected Record Value", (create {STRING}.make_from_c(tctreeget2 (tc_tree, k.item))).is_equal("value"))
		    b := tctreeout2 (tc_tree, k.item)
		    assert ("Expected true", b=true)
			assert ("Empty Tree", tctreernum (tc_tree) = 0)
		end

	test_out_2_record_does_not_exist
		local
			k : C_STRING
			b : BOOLEAN
		do
			assert ("Empty Tree", tctreernum (tc_tree) = 0)
			create k.make ("key")
		    b := tctreeout2 (tc_tree, k.item)
		    assert ("Expected False", b=False)
		end


feature -- Implementation

	tc_tree : POINTER


end


