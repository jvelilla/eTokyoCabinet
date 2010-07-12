note
	description: "Summary description for {WRAPPER_BASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	revision: "$Revision$"

deferred class
	WRAPPER_BASE

feature -- Remove	

	free (a_object: POINTER)
			-- Delete c object
		external
			"C inline use %"eif_lmalloc.h%""
		alias
			"eif_free((void *)$a_object)"
		end
	
end -- class WRAPPER_BASE

