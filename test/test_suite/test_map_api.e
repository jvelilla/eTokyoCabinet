note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_MAP_API

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
			create map_string.make
			create map.make
		end

	on_clean
			-- <Precursor>
		do
			map_string.clear
			map.clear
		end

feature -- Test routines
	test_clear
		do
			assert ("Empty Map", map_string.elements = 0)
			assert ("Empty Map", map_string.is_empty)
			map_string.put ("key1", "value1")
			map_string.put ("key2", "value2")
			assert ("two records", map_string.elements = 2)
			assert ("Not empty map", not map_string.is_empty)
		end

	test_remove_string
		do
			assert ("Empty Map", map_string.elements = 0)
			assert ("Empty Map", map_string.is_empty)
			map_string.put ("key1", "value1")
			map_string.put ("key2", "value2")
			assert ("two records", map_string.elements = 2)
			assert ("Not empty map", not map_string.is_empty)
			map_string.remove ("key1")
			assert ("one records", map_string.elements = 1)
		end

	test_remove
			-- New test routine
		local
			p : PERSON
		do
			assert ("Empty Map", map.elements = 0)
			create p.make ("javier", "velilla")
			map.put (p, "value")
			create p.make ("manuel", "ginobili")
			map.put (p, "value2")
			assert ("Map with two element", map.elements = 2)
			assert ("Expected value", map.get (p).is_equal ("value2"))
			map.remove (p)
			assert ("Map with one element", map.elements = 1)
		end

	test_put_cat_string
		do
			assert ("Empty Map", map_string.elements = 0)
			assert ("Empty Map", map_string.is_empty)
			map_string.put ("key1", "value1")
			map_string.put ("key2", "value2")
			assert ("two records", map_string.elements = 2)
			assert ("Not empty map", not map_string.is_empty)
			map_string.put_cat ("key2", "_added this")
			assert ("two records", map_string.elements = 2)
			assert ("Concat value",map_string.get ("key2").is_equal ("value2_added this"))

		end

	test_put_string
			-- New test routine
		do
			assert ("Empty Map", map_string.elements = 0)
			map_string.put ("key", "value")
			assert ("Map with one element", map_string.elements = 1)
			assert ("Expected value", map_string.get ("key").is_equal ("value"))
			map_string.put ("key", "value1")
			assert ("Map with one element", map_string.elements = 1)
			assert ("Expected value", map_string.get ("key").is_equal ("value1"))
		end

	test_put
			-- New test routine
		local
			p : PERSON
		do
			assert ("Empty Map", map.elements = 0)
			create p.make ("javier", "velilla")
			map.put (p, "value")
			assert ("Map with one element", map.elements = 1)
			assert ("Expected value", map.get (p).is_equal ("value"))
			create p.make ("javier", "velilla")
			map.put (p, "value2")
			assert ("Map with one element", map.elements = 1)
			assert ("Expected value", map.get (p).is_equal ("value2"))
		end

	test_keys
			-- New test routine
		local
			l_list : LIST_API [PERSON]
			p : PERSON
		do
			assert ("Empty Map", map.elements = 0)
			create p.make ("javier", "velilla")
			map.put (p, "value")
			create p.make ("manuel", "fangio")
			map.put (p, "value")
			assert ("Map with one element", map.elements = 2)
			assert ("Expected value", map.get (p).is_equal ("value"))
			l_list := map.map_keys
			assert ("Expected Value Javier", l_list.value (1).first_name.is_equal ("javier"))
		end

	test_keys_string
			-- New test routine
		local
			l_keys : LIST_API [STRING]
		do
			assert ("Empty Map", map_string.elements = 0)
			map_string.put ("key1", "value1")
			map_string.put ("key2", "value2")
			map_string.put ("key3", "value3")
			map_string.put ("key4", "value4")
			assert ("Map with for elements", map_string.elements = 4)
			l_keys := map_string.map_keys
			assert ("Expected Value key1", l_keys.value (1).is_equal ("key1"))
			assert ("Expected Value key4", l_keys.value (4).is_equal ("key4"))
		end


	test_values_string
			-- New test routine
		local
			l_values : LIST_API [STRING]
		do
			assert ("Empty Map", map_string.elements = 0)
			map_string.put ("key1", "value1")
			map_string.put ("key2", "value2")
			map_string.put ("key3", "value3")
			map_string.put ("key4", "value4")
			assert ("Map with for elements", map_string.elements = 4)
			l_values := map_string.map_values

		end

feature -- Implementation
	map_string : MAP_API [STRING,STRING]
	map        : MAP_API [STRING,PERSON]

end


