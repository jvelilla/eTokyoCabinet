class
	TOKYO_EXAMPLES

create
	make
feature -- Initialization

	make
		local
			l_tdb_example : TABLE_DATABASE_EXAMPLE
			tc_database_performace : TC_DATABASE_PERFORMANCE
			l_btree_example : BTREE_DATABASE_EXAMPLE
		do
			create l_tdb_example
			l_tdb_example.example
			create tc_database_performace
			tc_database_performace.hash_table_performance
			tc_database_performace.btree_table_performance
			tc_database_performace.table_table_performance
			tc_database_performace.fixed_db_performance

			create  l_btree_example
			l_btree_example.example
--			print ("%N================ Abstract Database Example ======================%N")
--			adb_example
--			print ("%N================ Fixed Database Example ======================%N")
--			fdb_example
--			print ("%N================ B-Tree Database Example ======================%N")
--			bdb_example
--			print ("%N================ Hash Database Example ======================%N")
--			hdb_example
--			print ("%N================ Table Database Example ======================%N")
--			tdb_example
		end

	adb_example
		-- Abstract Database Example
		local
			adb : ADB_API
			l_key : STRING
		do
			create adb.make

			print ("%N================ open database ======================%N")
			adb.open ("casket.tch")
			check not adb.has_error	end

			print ("%N================ store records ======================%N")
			adb.put ("foo", "hop")
			check not adb.has_error	end
			adb.put ("bar", "step")
			check not adb.has_error	end
			adb.put ("baz", "jump")
			check not adb.has_error	end

			print ("%N================ retrieve records ======================%N")
			print ("%Nkey: foo  -- value:" + adb.retrieve ("foo") )
			check adb.retrieve ("notexist") = Void end


			print ("%N================ traverse records ======================%N")
			from
				adb.iterator_init
				l_key := adb.iterator_next
			until
				l_key = Void
			loop
				print ("%NKey :" + l_key)
				print ("%NValue:" + adb.retrieve (l_key) )
				l_key := adb.iterator_next
			end

			adb.close
			adb.delete
			check not adb.has_error end
		end


	fdb_example
		-- Fixed Database Example
		local
			fdb : FDB_API
			l_key : STRING
		do
			create fdb.make

			print ("%N================ open database ======================%N")
			fdb.open_writer("casket.tcf")
			check not fdb.has_error	end

			print ("%N================ store records ======================%N")
			fdb.put ("1", "hop")
			check not fdb.has_error	end
			fdb.put ("2", "step")
			check not fdb.has_error	end
			fdb.put ("3", "jump")
			check not fdb.has_error	end

			print ("%N================ retrieve records ======================%N")
			print ("%Nkey: foo  -- value:" + fdb.retrieve ("1") )
			check fdb.retrieve ("4") = Void end


			print ("%N================ traverse records ======================%N")
			from
				fdb.iterator_init
				l_key := fdb.iterator_next
			until
				l_key = Void
			loop
				print ("%NKey :" + l_key)
				print ("%NValue:" + fdb.retrieve (l_key) )
				l_key := fdb.iterator_next
			end

			fdb.close
			fdb.delete
			check not fdb.has_error end
		end

	bdb_example
		-- B-tree Database Example
		local
			bdb : BDB_API
			l_key : STRING
		do
			create bdb.make

			print ("%N================ open database ======================%N")
			bdb.open_writer ("casket.tcb")
			check not bdb.has_error	end

			print ("%N================ store records ======================%N")
			bdb.put ("foo", "hop")
			check not bdb.has_error	end
			bdb.put ("bar", "step")
			check not bdb.has_error	end
			bdb.put ("baz", "jump")
			check not bdb.has_error	end

			print ("%N================ retrieve records ======================%N")
			print ("%Nkey: foo  -- value:" + bdb.retrieve ("foo") )
			check bdb.retrieve ("notexist") = Void end


			print ("%N================ traverse records ======================%N")
			from
				bdb.iterator_init
				l_key := bdb.iterator_next
			until
				l_key = Void
			loop
				print ("%NKey :" + l_key)
				print ("%NValue:" + bdb.retrieve (l_key) )
				l_key := bdb.iterator_next
			end

			bdb.close
			bdb.delete
			check not bdb.has_error end
		end


	hdb_example
		-- Hash Database Example
		local
			hdb : HDB_API
			l_key : STRING
		do
			create hdb.make

			print ("%N================ open database ======================%N")
			hdb.open_writer_create ("casket2.tch")
			check not hdb.has_error	end

			print ("%N================ store records ======================%N")
			hdb.put ("foo", "hop")
			check not hdb.has_error	end
			hdb.put ("bar", "step")
			check not hdb.has_error	end
			hdb.put ("baz", "jump")
			check not hdb.has_error	end

			print ("%N================ retrieve records ======================%N")
			print ("%Nkey: foo  -- value:" + hdb.retrieve ("foo") )
			check hdb.retrieve ("notexist") = Void end


			print ("%N================ traverse records ======================%N")
			from
				hdb.iterator_init
				l_key := hdb.iterator_next
			until
				l_key = Void
			loop
				print ("%NKey :" + l_key)
				print ("%NValue:" + hdb.retrieve (l_key) )
				l_key := hdb.iterator_next
			end

			hdb.close
			hdb.delete
			check not hdb.has_error end
		end


	tdb_example
		-- Table Database Example
		local
			tdb : TDB_API
			l_key : STRING
		do
			create tdb.make

			print ("%N================ open database ======================%N")
			tdb.open_writer_create ("casket.tct")
			check not tdb.has_error	end

			print ("%N================ store records ======================%N")
			tdb.put ("foo", "hop")
			check not tdb.has_error	end
			tdb.put ("bar", "step")
			check not tdb.has_error	end
			tdb.put ("baz", "jump")
			check not tdb.has_error	end

			print ("%N================ retrieve records ======================%N")
			print ("%Nkey: foo  -- value:" + tdb.retrieve ("foo") )
			check tdb.retrieve ("notexist") = Void end


			print ("%N================ traverse records ======================%N")
			from
				tdb.iterator_init
				l_key := tdb.iterator_next
			until
				l_key = Void
			loop
				print ("%NKey :" + l_key)
				print ("%NValue:" + tdb.retrieve (l_key) )
				l_key := tdb.iterator_next
			end

			tdb.close
			tdb.delete
			check not tdb.has_error end
		end
end -- class TOKYO_EXAMPLES
