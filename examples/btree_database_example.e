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
			l_list : LIST[STRING]
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
			bdb.put_string("apples", "red")
			bdb.put_string("ant", "build")


			-- retrive all records
			print ("%N Retrieve all records by key %N")
			l_list := bdb.list_string ("key1")
			from
				i := 1
			until
				i > l_list.count
			loop
				print ("%N Index:" + i.out + ":Value:" +l_list.at (i))
				i := i + 1
			end

			-- range query, find all matching keys
			print ("%N Range query %N")
			l_list:= bdb.range_string("key1", true, "key3", true)
			from
				i := 1
			until
				i > l_list.count
			loop
				print ("%N Index:" + i.out + ":Key:" +l_list.at (i))
				i := i + 1
			end


			-- forward matching keys,
			print ("%N Forward matching 'a'%N")
			l_list := bdb.forward_matching_string_keys ("a")
			from
				i := 1
			until
				i > l_list.count
			loop
				print ("%N Index:" + i.out + ":Key:" +l_list.at (i))
				i := i + 1
			end


			print ("%N Forward matching 'an'%N")
			l_list := bdb.forward_matching_string_keys ("an")
			from
				i := 1
			until
				i > l_list.count
			loop
				print ("%N Index:" + i.out + ":Key:" +l_list.at (i))
				i := i + 1
			end

			print ("%N Forward matching 'e'%N")
			l_list := bdb.forward_matching_string_keys ("e")
			from
				i := 1
			until
				i > l_list.count
			loop
				print ("%N Index:" + i.out + ":Key:" +l_list.at (i))
				i := i + 1
			end
		end

feature {NONE} -- Implementation
	bdb : BDB_API
end
