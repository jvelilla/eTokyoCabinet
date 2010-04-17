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

	test_pop

		local
			p,p1,p2:PERSON
			pr : PERSON
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
		    create p.make ("Javier", "Velilla")
		    create p1.make ("Joshua", "Bell")
		    create p2.make ("Carlos", "Gardel")
		    push_item (p)
		    push_item (p1)
		    push_item (p2)

		    assert ("List with three elements", tclistnum (tc_list) = 3)

			pr := retrive_item (0)
			assert ("Person retrieved", pr.first_name.is_equal("Javier"))
			pr := retrive_item (2)
			assert ("Person retrieved", pr.first_name.is_equal("Carlos"))

			assert ("Person retrieved", pop_item.first_name.is_equal("Carlos"))
			assert ("List with two elements", tclistnum (tc_list) = 2)
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


	test_unshift
		local
			p,p1,p2,p3 : PERSON
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
		    create p.make ("Javier", "Velilla")
		    create p1.make ("Joshua", "Bell")
		    create p2.make ("Carlos", "Gardel")
		    push_item (p)
		    push_item (p1)
		    push_item (p2)
			assert ("List with three elements", tclistnum (tc_list) = 3)
		    create p3.make ("Frank", "Sinatra")
		    unshift_item (p3)
		    assert ("List with four elements", tclistnum (tc_list) = 4)
		    assert ("First Element expected Frank",(retrive_item (0).first_name).is_equal(("Frank")))
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

	test_shift
		local
			p,p1,p2 : PERSON
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
		    create p.make ("Javier", "Velilla")
		    create p1.make ("Joshua", "Bell")
		    create p2.make ("Carlos", "Gardel")
		    push_item (p)
		    push_item (p1)
		    push_item (p2)
			assert ("List with three elements", tclistnum (tc_list) = 3)

		    assert ("First Element expected Javier",shift_item.first_name.is_equal(("Javier")))
			assert ("List with two elements", tclistnum (tc_list) = 2)
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


	test_insert

		local
			p,p1,p2,p3:PERSON
			pr : PERSON
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
		    create p.make ("Javier", "Velilla")
		    create p1.make ("Joshua", "Bell")
		    create p2.make ("Carlos", "Gardel")
		    push_item (p)
		    push_item (p1)
		    push_item (p2)

		    assert ("List with three elements", tclistnum (tc_list) = 3)

			create p3.make ("Sol", "Gabbeta")

			insert_item (p3, 1)
			pr := retrive_item (1)
			assert ("Person retrieved", pr.first_name.is_equal("Sol"))
			pr := retrive_item (2)
			assert ("Person retrieved", pr.first_name.is_equal("Joshua"))
			assert ("List with four elements", tclistnum (tc_list) = 4)

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


	test_clear
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element1")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element2")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element3")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element4")).item)
			assert ("List with four element", tclistnum (tc_list) = 4)

			tclistclear (tc_list)
			assert ("Empty List", tclistnum (tc_list) = 0)

		end


	test_dup
		local
			cs,cs2 : C_STRING
			l : POINTER
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element1")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element2")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element3")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element4")).item)
			assert ("List with four element", tclistnum (tc_list) = 4)

			l :=tclistdup (tc_list)

            assert ("Both List have the sames items", tclistnum (tc_list) = tclistnum (l))
            create cs.make_by_pointer (tclistval2 (tc_list, 0))
            create cs2.make_by_pointer (tclistval2 (tc_list, 0))
			assert ("Expected Element1, in both list", cs.string.is_equal (cs2.string))
		end



	test_remove

		local
			p,p1,p2:PERSON
			pr : PERSON
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
		    create p.make ("Javier", "Velilla")
		    create p1.make ("Joshua", "Bell")
		    create p2.make ("Carlos", "Gardel")
		    push_item (p)
		    push_item (p1)
		    push_item (p2)
			assert ("List with three elements", tclistnum (tc_list) = 3)

			pr := remove_item (1)

			assert ("List with two elements", tclistnum (tc_list) = 2)
			assert ("Expected element Joshua", pr.first_name.is_equal ("Joshua"))

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


	test_over
		local
			p,p1,p2:PERSON
			pr : PERSON
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
		    create p.make ("Javier", "Velilla")
		    create p1.make ("Joshua", "Bell")
		    create p2.make ("Carlos", "Gardel")
		    push_item (p)
		    push_item (p1)
		    push_item (p2)
			assert ("List with three elements", tclistnum (tc_list) = 3)

			p1.set_first_name ("Josh")
			over_item (p1,1)
			pr := retrive_item (1)

			assert ("Expected element Josh", pr.first_name.is_equal ("Josh"))
		end


	test_over_2
		local
			cs : C_STRING
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element1")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element2")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element3")).item)
			tclistpush2 (tc_list, (create {C_STRING}.make("Element4")).item)
			assert ("List with four element", tclistnum (tc_list) = 4)

			tclistover2 (tc_list, 1,(create {C_STRING}.make("Element2Changed")).item)
			assert ("List with four element", tclistnum (tc_list) = 4)
			create cs.make_by_pointer (tclistval2 (tc_list, 1))
			assert ("Expected Element2Changed", cs.string.is_equal ("Element2Changed"))
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

	remove_item (index : INTEGER) : PERSON
		local
			r : POINTER
			c : STRING
			sc : C_STRING
			i : INTEGER
		do
			r := tclistremove (tc_list, index, $i)
			create sc.make_by_pointer_and_count (r, i)
			c := sc.substring (1, i)
		    Result ?= str_ser.deserialize (c)
		end

	pop_item : PERSON
		local
			r : POINTER
			c : STRING
			sc : C_STRING
			i : INTEGER
		do
			r := tclistpop (tc_list, $i)
			create sc.make_by_pointer_and_count (r, i)
			c := sc.substring (1, i)
		    Result ?= str_ser.deserialize (c)
		end


	push_item ( item : PERSON)
		local
			str_p : C_STRING
			str : STRING
		do
			str := str_ser.serialize (item)
			create str_p.make (str)
		    tclistpush (tc_list, str_p.item, str.count)
		end


	insert_item ( item : PERSON; an_index: INTEGER_32)
		local
			str_p : C_STRING
			str : STRING
		do
			str := str_ser.serialize (item)
			create str_p.make (str)
			tclistinsert (tc_list, an_index, str_p.item, str.count)
		end

	over_item ( item : PERSON; an_index: INTEGER_32)
		local
			str_p : C_STRING
			str : STRING
		do
			str := str_ser.serialize (item)
			create str_p.make (str)
			tclistover (tc_list, an_index, str_p.item, str.count)
		end
	unshift_item ( item : PERSON)
		local
			str_p : C_STRING
			str : STRING
		do
			str := str_ser.serialize (item)
			create str_p.make (str)
			tclistunshift (tc_list, str_p.item, str.count)
		end

	shift_item : PERSON
		local
			r : POINTER
			c : STRING
			sc : C_STRING
			i : INTEGER
		do
			r := tclistshift (tc_list, $i)
			create sc.make_by_pointer_and_count (r, i)
			c := sc.substring (1, i)
		    Result ?= str_ser.deserialize (c)
		end


	tc_list : POINTER


	str_ser : STRING_SERIALIZATION
end


