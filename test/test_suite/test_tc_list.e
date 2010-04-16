note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TC_LIST

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end
	TC_LIST
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			create str_ser
			tc_list := tclistnew
		end

	on_clean
		do
			tclistdel (tc_list)
		end
feature -- Test routines

	test_add_item
			-- New test routine
		local
			p:PERSON
			str_p : C_STRING
			str : STRING
			pr : PERSON
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
		    create p.make ("Javier", "Velilla")
			str := str_ser.serialize (p)

			create str_p.make (str)
		    tclistpush (tc_list, str_p.item, str.count)
		    assert ("List with one element", tclistnum (tc_list) = 1)

			pr := retrive_item (0)

			assert ("Person retrieved", pr.first_name.is_equal("Javier"))

		end

	test_pop_2
		local
          cs : C_STRING
		do
			assert ("Empty List", tclistnum (tc_list) = 0)

			tclistpush2 (tc_list, (create {C_STRING}.make("Element1")).item)

			assert ("List with one element", tclistnum (tc_list) = 1)

			create cs.make_by_pointer( tclistpop2 (tc_list) )
			assert ("Empty List", tclistnum (tc_list) = 0)
			assert ("Expected Element1", cs.string.is_equal ("Element1"))
		end

	test_unshift_2
		local
			cs : C_STRING
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element1")).item)
			assert ("List with one element", tclistnum (tc_list) = 1)

			tclistunshift2 (tc_list,  (create {C_STRING}.make("Element2")).item)
			assert ("List with two element", tclistnum (tc_list) = 2)
			create cs.make_by_pointer (tclistval2 (tc_list, 0))
			assert ("Expected Element2", cs.string.is_equal ("Element2"))
		end

	test_shift_2
		local
			cs : C_STRING
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element1")).item)
			assert ("List with one element", tclistnum (tc_list) = 1)
			tclistunshift2 (tc_list,  (create {C_STRING}.make("Element2")).item)
			assert ("List with two element", tclistnum (tc_list) = 2)


			create cs.make_by_pointer (tclistshift2 (tc_list))
			assert ("Expected Element2", cs.string.is_equal ("Element2"))
			assert ("List with one element", tclistnum (tc_list) = 1)

		end

	test_insert_2
		local
			cs : C_STRING
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element1")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element2")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element3")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element4")).item)
			assert ("List with four element", tclistnum (tc_list) = 4)

			tclistinsert2 (tc_list, 1, (create {C_STRING}.make("Elemento5")).item)
			assert ("List with five element", tclistnum (tc_list) = 5)
			create cs.make_by_pointer (tclistval2 (tc_list, 0))
			assert ("Expected Element1", cs.string.is_equal ("Element1"))
			create cs.make_by_pointer (tclistval2 (tc_list, 2))
			assert ("Expected Element2", cs.string.is_equal ("Element2"))
		end


	test_remove_2
		local
			cs : C_STRING
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element1")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element2")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element3")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element4")).item)
			assert ("List with four element", tclistnum (tc_list) = 4)

			create cs.make_by_pointer (tclistremove2 (tc_list, 1))
			assert ("Expected Element2", cs.string.is_equal ("Element2"))
			assert ("List with five element", tclistnum (tc_list) = 3)
			create cs.make_by_pointer (tclistval2 (tc_list, 0))
			assert ("Expected Element1", cs.string.is_equal ("Element1"))
			create cs.make_by_pointer (tclistval2 (tc_list, 1))
			assert ("Expected Element3", cs.string.is_equal ("Element3"))
		end
	test_serialization
		local
			p1,p2:PERSON
			s : STRING
		do
			create p1.make ("Manuel","Fangio")
			s := str_ser.serialize (p1)
			p2 ?= str_ser.deserialize (s)
		end


	feature -- Implementation

	retrive_item (index : INTEGER) : PERSON
		local
			r : POINTER
			c : STRING
			sc : C_STRING
			i : INTEGER
		do
			r := tclistval (tc_list, index, $i)
			create sc.make_by_pointer_and_count (r, i)
			c := sc.substring (1, i)
		    Result ?= str_ser.deserialize (c)

		end

	tc_list : POINTER

	str_ser : STRING_SERIALIZATION
end


