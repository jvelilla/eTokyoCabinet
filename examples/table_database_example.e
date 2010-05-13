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
			map : MAP_API[STRING,STRING]
			list_of_keys : LIST_API [STRING]
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
			create map.make
			map.put ("name", "juan")
			map.put ("age", "50")
			map.put ("sex", "male")

			tdb.put_map (key, map)

			-- Store other record
			create map.make
			map.put ("name", "elena")
			map.put ("age", "12")
			map.put ("sex", "female")
			map.put ("lang", "en,es,it")
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
			create qry.make_by_pointer (tdb.tdb)
			qry.add_condition ("age", qry.qcnumge,"18")
			qry.set_order ("name", qry.qostrasc)

			-- excecute query
			create list_of_keys.make_by_pointer (qry.search)

			-- Find one element
			check
				list_of_keys.elements = 1
			end

			-- Show element
			create map.make_by_pointer (tdb.get_map (list_of_keys.value (1)))
			print ("%Nname:" + map.get ("name"))
			print ("%Nage :" + map.get ("age"))


			--close the database
			tdb.close
		end

end
