note
	description: "Summary description for {TEST_LIST_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_LIST_API

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

	test_linear_search
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
			assert ("Last Element", list2.value (3).first_name.is_equal ("jose"))

			create p.make ("placido", "domingo")
			assert ("Second Element",list2.linear_search (p) = 2)
			create p.make ("luciano", "domingo")
			assert ("No Element",list2.linear_search (p) = -1)
		end


	test_linear_search_string
		do
			assert ("Empty list", list1.elements = 0)
			list1.push ("Element1")
			list1.push ("Element2")
			list1.push ("Element3")
			assert ("three elements list", list1.elements = 3)
			assert ("First Element",list1.linear_search ("Element1") = 1)
			assert ("No Element", list1.linear_search ("Element10") = -1)
		end

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
			assert ("Last Element", list2.value (3).first_name.is_equal ("jose"))
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
			assert ("Last Element", list2.value (3).first_name.is_equal ("jose"))
			list2.pop
			assert ("Two elements list", list2.elements = 2)
			assert ("Last Element", list2.value (list2.elements).first_name.is_equal ("placido"))
			assert ("Last Pop element", list2.last_pop.first_name.is_equal ("jose"))
		end

	test_unshift
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
			create p.make ("pedro", "sosa")
			list2.unshift (p)
			assert ("four elements list", list2.elements =4)
			assert ("First Element", list2.value (1).first_name.is_equal ("pedro"))
		end

	test_unshift_string
		do
			assert ("Empty list", list1.elements = 0)
			list1.push ("element1")
			list1.push ("element2")
			list1.push ("element3")
			assert ("three elements list", list1.elements = 3)
			list1.unshift ("first")
			assert ("four elements list", list1.elements =4)
			assert ("First Element", list1.value (1).is_equal ("first"))
		end

	test_insert
		local
			p : PERSON
		do
			assert ("Empty list", list2.elements = 0)
			assert ("Empty List", list2.is_empty)
			create p.make ("javier", "velilla")
			list2.push (p)
			create p.make ("placido", "domingo")
			list2.push (p)
			create p.make ("jose", "gimenez")
			list2.push (p)
			assert ("three elements list", list2.elements = 3)
			create p.make ("joshua", "bell")
			list2.insert (p, 2)
			assert ("four elements list", list2.elements =4)
			assert ("First Element", list2.value (1).first_name.is_equal ("javier"))
			assert ("Second Element", list2.value (2).first_name.is_equal ("joshua"))
			assert ("Third Element", list2.value (3).first_name.is_equal ("placido"))
		end

	test_insert_string
		do
			assert ("Empty list", list1.elements = 0)
			assert ("Empty List", list1.is_empty)
			list1.push ("element1")
			list1.push ("element2")
			list1.push ("element3")
			assert ("three elements list", list1.elements = 3)
			list1.insert ("insert", 2)
			assert ("four elements list", list1.elements =4)
			assert ("First Element", list1.value (1).is_equal ("element1"))
			assert ("Second Element", list1.value (2).is_equal ("insert"))
			assert ("Third Element", list1.value (3).is_equal ("element2"))
		end

	test_shift
		local
			p : PERSON
		do
			assert ("Empty list", list2.elements = 0)
			assert ("Empty List", list2.is_empty)
			create p.make ("javier", "velilla")
			list2.push (p)
			create p.make ("placido", "domingo")
			list2.push (p)
			create p.make ("jose", "gimenez")
			list2.push (p)
			assert ("three elements list", list2.elements = 3)
			list2.shift
			assert ("two elements list", list2.elements = 2)
			assert ("First Element", list2.value (1).first_name.is_equal ("placido"))
			assert ("Last Shift", list2.last_shift.first_name.is_equal ("javier"))
		end

	test_shift_string
		do
			assert ("Empty list", list1.elements = 0)
			assert ("Empty List", list1.is_empty)
			list1.push ("element1")
			list1.push ("element2")
			list1.push ("element3")
			assert ("three elements list", list1.elements = 3)
			list1.shift
			assert ("two elements list", list1.elements = 2)
			assert ("First Element", list1.value (1).is_equal ("element2"))
			assert ("Last Shift", list1.last_shift.is_equal ("element1"))
		end


	test_remove
		local
			p : PERSON
		do
			assert ("Empty list", list2.elements = 0)
			assert ("Empty List", list2.is_empty)
			create p.make ("javier", "velilla")
			list2.push (p)
			create p.make ("placido", "domingo")
			list2.push (p)
			create p.make ("jose", "gimenez")
			list2.push (p)
			assert ("three elements list", list2.elements = 3)
			list2.remove (2)
			assert ("Two elements list", list2.elements = 2)
			assert ("Second Element", list2.value (2).first_name.is_equal ("jose"))
			assert ("Last remove", list2.last_remove.first_name.is_equal ("placido"))
		end

	test_remove_string
		do
			assert ("Empty list", list1.elements = 0)
			assert ("Empty List", list1.is_empty)
			list1.push ("Element1")
			list1.push ("Element2")
			list1.push ("Element3")
			assert ("three elements list", list1.elements = 3)
			list1.remove (2)
			assert ("Two elements list", list1.elements = 2)
			assert ("Second Element", list1.value (2).is_equal ("Element3"))
			assert ("Last remove", list1.last_remove.is_equal ("Element2"))
		end

	test_over
		local
			p : PERSON
		do
			assert ("Empty list", list2.elements = 0)
			assert ("Empty List", list2.is_empty)
			create p.make ("javier", "velilla")
			list2.push (p)
			create p.make ("placido", "domingo")
			list2.push (p)
			create p.make ("jose", "gimenez")
			list2.push (p)
			assert ("three elements list", list2.elements = 3)
			create p.make ("Luciano", "Pavarotti")
			list2.over (p, 2)
			assert ("three elements list", list2.elements = 3)
			assert ("Second Element", list2.value (2).first_name.is_equal ("Luciano"))
		end


	test_over_string
		do
			assert ("Empty list", list1.elements = 0)
			assert ("Empty List", list1.is_empty)
			list1.push ("Element1")
			list1.push ("Element2")
			list1.push ("Element3")
			assert ("three elements list", list1.elements = 3)
			list1.over ("NewElement2", 2)
			assert ("three elements list", list1.elements = 3)
			assert ("Second Element", list1.value (2).is_equal ("NewElement2"))
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

	test_pop_string
		local
			p : PERSON
		do
			assert ("Empty list", list1.elements = 0)
			list1.push ("Element1")
			list1.push ("Element2")
			assert ("two elements list", list1.elements = 2)
			list1.pop
			assert ("One element", list1.elements = 1)
			assert ("Last pop element Element2", list1.last_pop.is_equal ("Element2"))
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
	list1: LIST_API [STRING]
		-- string list
	list2: LIST_API [PERSON]
end
