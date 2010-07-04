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
			assert ("NOT IMPLEMENTED", TRUE)
		end

	on_clean
		do
			assert ("NOT IMPLEMENTED", TRUE)
		end

feature -- Test

end
