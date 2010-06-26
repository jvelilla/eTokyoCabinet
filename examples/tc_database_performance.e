note
	description: "Summary description for {TC_DATABASE_PERFORMANCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_DATABASE_PERFORMANCE

feature -- HAST TABLE

	hash_table_performance
		local
			hdb : HDB_API
			key: STRING
			value : STRING
			i : INTEGER
			l_start_time, l_finish_time : TIME
		do
			create hdb.make
			hdb.optimize (-1, -1, -1, hdb.tbzip.as_natural_8)
			hdb.open_writer_create ("hash.tch")
			hdb.vanish
			create l_start_time.make_now
			from
				i :=1
			until
				i > 1000
			loop
				key := i.out
				hdb.put_string (key,key)
				i := i + 1
			end
			create l_finish_time.make_now
			print ("%NHashDatabase Performance :"+ (l_finish_time - l_start_time).duration.out)
		end



	btree_table_performance
		local
			bdb : BDB_API
			key: STRING
			i : INTEGER
			l_start_time, l_finish_time : TIME
		do
			create bdb.make
			bdb.open_writer_create ("btree.tcb")
			bdb.vanish
			create l_start_time.make_now
			from
				i :=1
			until
				i > 1000
			loop
				key := i.out
				bdb.put_string (key,key)
				i := i + 1
			end
			create l_finish_time.make_now
			print ("%NBtreeDatabase Performance :"+ (l_finish_time - l_start_time).duration.out)
		end


	table_table_performance
		local
			tdb : TDB_API
			key: STRING
			i : INTEGER
			l_start_time, l_finish_time : TIME
		do
			create tdb.make
			tdb.open_writer_create ("table.tct")
			tdb.vanish
			create l_start_time.make_now
			from
				i :=1
			until
				i > 1000
			loop
				key := i.out
				tdb.put_string (key,key)
				i := i + 1
			end
			create l_finish_time.make_now
			print ("%NTableDatabase Performance :"+ (l_finish_time - l_start_time).duration.out)
		end

	fixed_db_performance
		local
			fdb : FDB_API
			key: STRING
			i : INTEGER
			l_start_time, l_finish_time : TIME
		do
			create fdb.make
			fdb.open_writer_create ("fixed.tcf")
			fdb.vanish
			create l_start_time.make_now
			from
				i :=1
			until
				i > 1000
			loop
				key := i.out
				fdb.put_string (key,key)
				i := i + 1
			end
			create l_finish_time.make_now
			print ("%NFixedDatabase Performance :"+ (l_finish_time - l_start_time).duration.out)
		end

end
