note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_ADB_API

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
		end

	on_clean
			-- <Precursor>
		do
		end

feature -- Test routines



	test_fwd_matching_keys
		-- Abstract Database Example
		local
			adb : ADB_API
			l_key : STRING
			l_list : LIST[STRING]
		do
			create adb.make
			adb.open ("casket.tch")
			adb.put ("foo", "hop")
			adb.put ("bar", "step")
			adb.put ("baz", "jump")
			adb.put ("test", "stky")

			l_list := adb.forward_matching_keys ("ba")
			l_list.compare_objects
			assert("expected 2 items", l_list.count = 2)
			assert("Has element", l_list.has ("baz"))
		end

end


