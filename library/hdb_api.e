note
	description: "Summary description for {HDB_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HDB_API
		inherit
			TC_HDB_API

create
	make
feature {NONE} -- Initialization
	make
		-- Create a hash database object
		do
			hdb := tchdbnew
			is_open := False
		end
feature -- Access

	is_open : BOOLEAN
		-- is the hdb open?

feature  -- Change Element

	open ( a_path : STRING; an_omode : INTEGER )
		-- to open a database file `a_path' and connect a hash database object
		-- using an specific mode of connection `an_omode'
		require
			database_is_closed : is_open = False
			valid_path : (a_path /= Void) and (not a_path.is_empty)
			--valid_connection_mode :
		local
			l_boolean : BOOLEAN
			l_path : C_STRING
		do
			create l_path.make (a_path)
			l_boolean := tchdbopen (hdb, l_path.item, an_omode)
			if l_boolean = True then
				is_open := True
			else
				--handle error
			end

		ensure
			database_opened : is_open = True
		end
		
feature  -- Close Database Conection

	delete
		-- 	the current database object is deleted
		do
			tchdbdel (hdb)
			is_open := False
		ensure
			database_closed : is_open = False
		end


feature {NONE} -- Implementation

	hdb : POINTER
		-- hash database object
invariant
	hasd_database_created: hdb /= default_pointer

end
