note
	description: "Summary description for {BTREE_DATABASE_EXAMPLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BTREE_DATABASE_EXAMPLE

feature -- Example

	example
		local
			l_list : LIST_API[STRING]
			i : INTEGER
		do
			print ("%N ===================== BTREE DATABASE EXAMPLE  =========================%N")
			--	create the object
			create bdb.make


			-- open the database
			bdb.open_writer_create ("tabledb.tcb")

			-- remove all records
			bdb.vanish

			-- store records in the database, allowing duplicates
			bdb.put_dup_string("key1", "value1")
			bdb.put_dup_string("key1", "value2")
			bdb.put_string("key2", "value3")
			bdb.put_string("key3", "value4")

			-- retrive all records
			print ("%N Retrieve all records by key %N")
			create l_list.make_by_pointer (bdb.list_string ("key1"))
			from
				i := 1
			until
				i > l_list.elements
			loop
				print ("%N Index:" + i.out + ":Value:" +l_list.value (i))
				i := i + 1
			end

			-- range query, find all matching keys
			print ("%N Range query %N")
			create l_list.make_by_pointer (bdb.range_string("key1", true, "key3", true))
			from
				i := 1
			until
				i > l_list.elements
			loop
				print ("%N Index:" + i.out + ":Key:" +l_list.value (i))
				i := i + 1
			end

		end

feature {NONE} -- Implementation
	bdb : BDB_API
end
