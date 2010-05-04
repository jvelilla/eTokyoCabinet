note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_TC_TDB_API

inherit
	EQA_TEST_SET
		redefine
			on_prepare,
			on_clean
		end
	TC_TDB_API
		undefine
			default_create
		end

feature {NONE} -- Events

	on_prepare
			-- <Precursor>
		do
			tdb := tctdbnew
		end

	on_clean
			-- <Precursor>
		local
			b : BOOLEAN
		do
			b:= tctdbclose (tdb)
			assert ("Expected true", b = true)
			tctdbdel (tdb)
		end
feature -- Test Open Database

	test_open_database
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
		end




feature -- Implementation
	tdb : POINTER
		-- Table Database Object
end


