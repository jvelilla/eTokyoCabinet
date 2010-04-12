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
			on_prepare
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

feature -- Test routines

	test_add_item
			-- New test routine
		local
			p:PERSON
			i: INTERNAL
			str_p : C_STRING
			str : STRING
			a : ANY
		do
			assert ("Empty List", tclistnum (tc_list) = 0)
			create i
		    create p.make ("Javier", "Velilla")

			str := str_ser.serialize (p)

            a := str_ser.deserialize (str)
            create str_p.make (str.substring (1, str.count))
            p ?= a
		    tclistpush2 (tc_list, str_p.managed_data.item)
		    assert ("List with one element", tclistnum (tc_list) = 1)



			assert ("Person retrieved", (retrive_item (0)).first_name.is_equal("Javier"))
		end



	feature -- Implementation

	retrive_item (index : INTEGER) : PERSON
		local
			r : POINTER
			c : STRING
			a : ANY
			sc : C_STRING
			i : INTEGER
		do
			r := tclistval (tc_list, index, $i)
            create c.make_from_c (r)
            create sc.make_by_pointer (r)
            a := str_ser.deserialize (c)
            Result ?= c

		end
	tc_list : POINTER

	str_ser : STRING_SERIALIZATION
end


