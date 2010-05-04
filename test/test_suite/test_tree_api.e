note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TREE_API

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
			create tree.make
		end

	on_clean
			-- <Precursor>
		do
			tree.clear
			assert ("empty tree", tree.is_empty)
		end

feature -- Test routines

	test_put
			-- New test routine
		do
			assert ("Empty tree", tree.elements = 0)
			assert ("Is empty ", tree.is_empty)
			assert ("Memory Size",tree.memory_size >= 0)
			tree.put ("key1", "value1")
			assert ("Not Empty tree", tree.elements = 1)
			assert ("Is not empty ", not tree.is_empty)
		end


	test_put_has_key
			-- New test routine
		do
			assert ("Empty tree", tree.elements = 0)
			assert ("Is empty ", tree.is_empty)
			tree.put ("key1", "value1")
			assert ("Not Empty tree", tree.elements = 1)
			assert ("Is not empty ", not tree.is_empty)
			assert ("Has key", tree.has_key ("key1"))
			assert ("Value", tree.found_element.is_equal ("value1"))
			tree.put ("key1", "newvalue")
			assert ("Not Empty tree", tree.elements = 1)
			assert ("Expected value", tree.get ("key1").is_equal ("newvalue"))
		end


	test_remove
		do
			assert ("Empty tree", tree.elements = 0)
			assert ("Is empty ", tree.is_empty)
			tree.put ("key1", "value1")
			tree.put ("key2", "value2")
			tree.put ("key3", "value3")
			tree.put ("key4", "value4")
			tree.put ("key5", "value5")
			assert ("Not Empty tree", tree.elements = 5)
			assert ("Is not empty ", not tree.is_empty)
			tree.remove ("key4")
			assert ("Not Has key", not tree.has_key ("key4"))
			assert ("Not Empty tree", tree.elements = 4)
		end


	test_tree_keys
		local
			l_keys : LIST_API [STRING]
		do
			assert ("Empty tree", tree.elements = 0)
			assert ("Is empty ", tree.is_empty)
			tree.put ("key1", "value1")
			tree.put ("key2", "value2")
			tree.put ("key3", "value3")
			tree.put ("key4", "value4")
			tree.put ("key5", "value5")
			assert ("Not Empty tree", tree.elements = 5)
			assert ("Is not empty ", not tree.is_empty)
			l_keys := tree.tree_keys
			assert ("Five keys",l_keys.elements = 5)
			assert ("First key",l_keys.firt_element.is_equal ("key1"))
		end


	test_tree_values
		local
			l_values : LIST_API [STRING]
		do
			assert ("Empty tree", tree.elements = 0)
			assert ("Is empty ", tree.is_empty)
			tree.put ("key1", "value1")
			tree.put ("key2", "value2")
			tree.put ("key3", "value3")
			tree.put ("key4", "value4")
			tree.put ("key5", "value5")
			assert ("Not Empty tree", tree.elements = 5)
			assert ("Is not empty ", not tree.is_empty)
			l_values := tree.tree_values
			assert ("Five values",l_values.elements = 5)
			assert ("First value",l_values.firt_element.is_equal ("value1"))
		end
feature -- Implementation
	tree : TREE_API [STRING,STRING]

end


