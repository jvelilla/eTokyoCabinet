note
	description: "Summary description for {TABLE_DATABASE_EXAMPLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TABLE_DATABASE_EXAMPLE

feature

	example
		local
			tdb : TDB_API
			qry : TDB_QUERY
			key : STRING
			map : HASH_TABLE[STRING,STRING]
			list_of_keys : LIST [STRING]
		do
			--	create the object
		    create tdb.make

			--  open the database
			tdb.open_writer_create ("tabledb.tct")

			-- remove all records
			tdb.vanish

			check -- database is empty
				tdb.records_number = 0
			end


			-- Create a table with arbitrary data.
			-- Unlike relational database, table database  does  not  need  to
			-- be based on a  schema and can contain arbitrary data


			-- Store records
			key := tdb.generate_unique_id.out  -- generate a unique Id

			-- Create a map
			create map.make(3)
			map.put ("juan","name")
			map.put ("50","age")
			map.put ("male","sex")

			tdb.put_map (key, map)

			-- Store other record
			create map.make (4)
			map.put ("elena","name")
			map.put ("12","age")
			map.put ("female","sex")
			map.put ("en,es,it","lang")
			tdb.put_map ("pk1", map)

			-- Now we have two records
			check
				tdb.records_number = 2
			end

			-- Query table for age >= 18 and order by name asc

			-- SELECT *
			-- FROM tabledb.tct
			-- WHERE age >= 18
			-- Order_by name asc

			-- Create a query object
			qry := tdb.query
			qry.add_condition ("age", qry.qcnumge,"18")
			qry.set_order ("name", qry.qostrasc)

			-- excecute query
			list_of_keys := qry.search

			-- Find one element
			check
				list_of_keys.count = 1
			end

			-- Show element
			map := tdb.retrieve_map (list_of_keys.at (1))
			print ("%Nname:" + map.at ("name"))
			print ("%Nage :" + map.at ("age"))


			--close the database
			tdb.close
		end

end
