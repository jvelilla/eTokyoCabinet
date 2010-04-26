note
	description: "Summary description for {TEST_TC_LIST_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_TC_LIST_API

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			create list1.make
			create list2.make
		end

	on_clean
		do
			list1.clear
			list2.clear
		end

feature -- Test
	test_push
		local
			p : PERSON
		do
			assert ("Empty list", list2.elements = 0)
			create p.make ("javier", "velilla")
			list2.push (p)
			create p.make ("placido", "domingo")
			list2.push (p)
			create p.make ("jose", "gimenez")
			list2.push (p)
			assert ("three elements list", list2.elements = 3)
		end


	test_value
		local
			p : PERSON
		do
			assert ("Empty list", list2.elements = 0)
			create p.make ("javier", "velilla")
			list2.push (p)
			create p.make ("placido", "domingo")
			list2.push (p)
			create p.make ("jose", "gimenez")
			list2.push (p)
			assert ("three elements list", list2.elements = 3)
			assert ("three elements list", list2.value (2).first_name.is_equal ("placido"))
		end

	test_pop
		local
			p : PERSON
		do
			assert ("Empty list", list2.elements = 0)
			create p.make ("javier", "velilla")
			list2.push (p)
			create p.make ("placido", "domingo")
			list2.push (p)
			create p.make ("jose", "gimenez")
			list2.push (p)
			assert ("three elements list", list2.elements = 3)
			list2.pop
			assert ("three elements list", list2.elements = 2)
			assert ("The same first name", list2.last_pop.first_name.is_equal ("jose"))
		end
	test_push_string
		do
			assert ("Empty list", list1.elements = 0)
			list1.push ("Element1")
			list1.push ("Element2")
			list1.push ("Element3")
			assert ("three elements list", list1.elements = 3)
		end


	test_value_string
		do
			assert ("Empty list", list1.elements = 0)
			list1.push ("Element1")
			list1.push ("Element2")
			list1.push ("Element3")
			assert ("three elements list", list1.elements = 3)

			assert ("Expected Element2",list1.value (2).is_equal ("Element2"))
		end
feature -- Implementation
	list1: TC_LIST_API [STRING]
		-- string list
	list2: TC_LIST_API [PERSON]
end
