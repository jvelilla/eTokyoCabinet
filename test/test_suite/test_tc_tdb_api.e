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
	TC_MAP_API
		undefine
			default_create
		end
	TC_LIST_API
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

	test_tune_operation
		local
			b : BOOLEAN
		do
			b := tctdbtune (tdb, -1, -1, -1, tlarge.bit_or (tbzip).as_natural_8)
			assert ("Tune true",b)
		end


	test_tune_operation_database_is_open
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			b := tctdbtune (tdb, -1, -1, -1, tlarge.bit_or (tbzip).as_natural_8)

			assert ("Tune FALSE",not b)
			assert ("Expected error code 2", tctdbecode (tdb) = 2)
		end

	test_set_cache
		local
			b : BOOLEAN
		do
			b := tctdbsetcache (tdb, -1,-1,-1)
			assert ("Cache set true",b)
		end

	test_set_cache_database_is_open
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			b := tctdbsetcache (tdb, -1,-1,-1)

			assert ("Set cache FALSE",not b)
			assert ("Expected error code 2", tctdbecode (tdb) = 2)
		end

	test_genuid
		local
		do
			assert ("Id expected -1",tctdbgenuid (tdb) = -1)
		end

	test_genuid_writer_mode
		local
			name : C_STRING
			b : BOOLEAN
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			assert ("Id expected >= 1",tctdbgenuid (tdb) >= 1)

		end

	test_genuid_reader_mode
		local
			name : C_STRING
			b : BOOLEAN
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as READER
			b:= tctdbopen (tdb,name.item,oreader)
			assert ("Id expected = -1",tctdbgenuid (tdb) = -1)

		end

	test_file_size
		local
		do
			assert ("File does not exist, expected size 0",tctdbfsiz (tdb) = 0)
		end

	test_file_size_exist
		local
			b : BOOLEAN
			name: C_STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			assert ("File exist, expected size > 0",tctdbfsiz (tdb) > 0)
		end

	test_file_size_database_closed
		local
			b : BOOLEAN
			name: C_STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)
			assert ("File exist, expected size  0",tctdbfsiz (tdb) = 0)
		end

	test_db_optimize
		local
			b : BOOLEAN
		do
			b := tctdboptimize (tdb, -1, -1, -1, tlarge.as_natural_8)
			assert ("Optimize False",not b)
			assert ("Expected error code 2", tctdbecode (tdb) = 2)
		end


	test_db_optimize_read_mode
		local
			b : BOOLEAN
			name: C_STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as READER
			b:= tctdbopen (tdb,name.item,oreader)

			assert("open",b)
			b := tctdboptimize (tdb, -1, -1, -1, tlarge.as_natural_8)
			assert ("Optimize False",not b)
			assert ("Expected error code 2", tctdbecode (tdb) = 2)
		end

	test_db_optimize_writer_mode
		local
			b : BOOLEAN
			name: C_STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			b := tctdboptimize (tdb, -1, -1, -1, tlarge.as_natural_8)
			assert ("Optimize True", b)
		end



	test_vanish
		local
			b : BOOLEAN
		do
			b := tctdbvanish (tdb)
			assert ("Vanish False",not b)
			assert ("Expected error code 2", tctdbecode (tdb) = 2)
		end


	test_vanish_read_mode
		local
			b : BOOLEAN
			name: C_STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as READER
			b:= tctdbopen (tdb,name.item,oreader)

			assert("open",b)
			b := tctdbvanish (tdb)
			assert ("Vanish False",not b)
			assert ("Expected error code 2", tctdbecode (tdb) = 2)
		end

	test_vanish_writer_mode
		local
			b : BOOLEAN
			name: C_STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			b := tctdbvanish (tdb)
			assert ("Vanish True", b)
		end

	test_copy
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("copydb.tct")
			b := tctdbcopy (tdb, name.item)
			assert ("Copy False",not b)
			assert ("Expected error code 2", tctdbecode (tdb) = 2)
		end


	test_copy_read_mode
		local
			b : BOOLEAN
			name: C_STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as READER
			b:= tctdbopen (tdb,name.item,oreader)

			assert("open",b)
			create name.make ("copydb.tct")
			b := tctdbcopy (tdb, name.item)
			assert("Copy True",b)
		end


	test_copy_to_same_file
		local
			b : BOOLEAN
			name: C_STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as READER
			b:= tctdbopen (tdb,name.item,oreader)

			b := tctdbcopy (tdb, name.item)
			assert("Copy True", b)
		end


	test_copy_writer_mode
		local
			b : BOOLEAN
			name: C_STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			create name.make ("copydb.tct")
			b := tctdbcopy (tdb, name.item)
			assert("Copy True",b)
		end


	test_path
		local
			r : POINTER
		do
			r := tctdbpath (tdb)
			assert ("File does not exist", r = default_pointer)
			assert ("Expected error code 2", tctdbecode (tdb) = 2)
		end


	test_path_read_mode
		local
			b : BOOLEAN
			name: C_STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as READER
			b:= tctdbopen (tdb,name.item,oreader)
			assert("open",b)
			assert ("Expected file name casket.tct",(create {STRING}.make_from_c( tctdbpath (tdb))).is_equal("casket.tct"))
		end


	test_path_write_mode
		local
			b : BOOLEAN
			name: C_STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			assert ("Expected file name casket.tct",(create {STRING}.make_from_c( tctdbpath (tdb))).is_equal("casket.tct"))
		end


	test_set_xmsiz
		local
			b : BOOLEAN
		do

			b := tctdbsetxmsiz (tdb, -1)
			assert ("Set extra mapped memory true",b)
		end

	test_set_xmsiz_database_is_open
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			b := tctdbsetxmsiz (tdb, -1)

			assert ("Set extra mapped memory false",not b)
			assert ("Expected error code 2", tctdbecode (tdb) = 2)
		end


	test_set_dfunit
		local
			b : BOOLEAN
		do

			b := tctdbsetdfunit (tdb, -1)
			assert ("Set auto defragmentation true",b)
		end

	test_set_dfunit_database_is_open
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			b := tctdbsetxmsiz (tdb, -1)

			assert ("Set auto defragmentation false",not b)
			assert ("Expected error code 2", tctdbecode (tdb) = 2)
		end


	test_open_write_create
		local
			b : BOOLEAN
			name: C_STRING
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
		end

	test_open_write_truncate
		local
			b : BOOLEAN
			name: C_STRING
			ec : INTEGER
			msg : STRING
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (otrunc) )
			if not b then
				ec := tctdbecode (tdb)
				create msg.make_from_c(tctdberrmsg (ec))
				assert ("file not found", msg.is_equal("file not found"))
				-- require file exist
			end
			-- Open as WRITER and CREATE
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as WRITER and TRUNCATE but now the file exist
			b:= tctdbopen (tdb,name.item,owriter.bit_or (otrunc) )
            assert("Open as write truncate mode true, file exist", b = True)
		end


	test_open_write_syncronize
		local
			b : BOOLEAN
			name: C_STRING
			ec : INTEGER
			msg : STRING
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (otsync) )
			if not b then
				ec := tctdbecode (tdb)
				create msg.make_from_c(tctdberrmsg (ec))
				assert ("file not found", msg.is_equal("file not found"))
				-- require file exist
			end
			-- Open as WRITER and CREATE
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as WRITER and SYNCRONIZE but now the file exist
			b:= tctdbopen (tdb,name.item,owriter.bit_or (otsync) )
            assert("Open as write syncronize mode true, file exist", b = True)
		end

	test_open_write_no_locking
		local
			b : BOOLEAN
			name: C_STRING
			ec : INTEGER
			msg : STRING
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (onolck) )
			if not b then
				ec := tctdbecode (tdb)
				create msg.make_from_c(tctdberrmsg (ec))
				assert ("file not found", msg.is_equal("file not found"))
				-- require file exist
			end
			-- Open as WRITER and CREATE
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as WRITER and NO LOCKING but now the file exist
			b:= tctdbopen (tdb,name.item,owriter.bit_or (onolck) )
            assert("Open as write no locking mode true, file exist", b = True)
		end

	test_open_write_no_blocking
		local
			b : BOOLEAN
			name: C_STRING
			ec : INTEGER
			msg : STRING
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (olcknb) )
			if not b then
				ec := tctdbecode (tdb)
				create msg.make_from_c(tctdberrmsg (ec))
				assert ("file not found", msg.is_equal("file not found"))
				-- require file exist
			end
			-- Open as WRITER and CREATE
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as WRITER and LOCKING NO BLOCKING but now the file exist
			b:= tctdbopen (tdb,name.item,owriter.bit_or (olcknb) )
            assert("Open as write locking no blocking mode true, file exist", b = True)
		end

	test_open_reader
		local
			b : BOOLEAN
			name: C_STRING
			ec: INTEGER
			msg : STRING
		do
			-- Open as READER
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,oreader)
			if not b then
				ec := tctdbecode (tdb)
				create msg.make_from_c(tctdberrmsg (ec))
				assert ("file not found", msg.is_equal("file not found"))
				-- require file exist
			end
			-- Open as WRITER and CREATE
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as READER but now the file exist
			b:= tctdbopen (tdb,name.item,oreader)
            assert("Open as read mode true, file exist", b = True)
		end

	test_open_reader_no_locking
		local
			b : BOOLEAN
			name: C_STRING
			ec: INTEGER
			msg : STRING
		do
			-- Open as READER
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,oreader.bit_or (onolck))
			if not b then
				ec := tctdbecode (tdb)
				create msg.make_from_c(tctdberrmsg (ec))
				assert ("file not found", msg.is_equal("file not found"))
				-- require file exist
			end
			-- Open as WRITER and CREATE
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as READER AND NO LOCKING but now the file exist
			b:= tctdbopen (tdb,name.item,oreader.bit_or (onolck))
            assert("Open as read and no locking mode true, file exist", b = True)
		end

	test_open_reader_no_blocking
		local
			b : BOOLEAN
			name: C_STRING
			ec: INTEGER
			msg : STRING
		do
			-- Open as READER
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,oreader.bit_or (olcknb))
			if not b then
				ec := tctdbecode (tdb)
				create msg.make_from_c(tctdberrmsg (ec))
				assert ("file not found", msg.is_equal("file not found"))
				-- require file exist
			end
			-- Open as WRITER and CREATE
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as READER LOCKING NOT BLOCKING but now the file exist
			b:= tctdbopen (tdb,name.item,oreader.bit_or (olcknb))
            assert("Open as read locking no blocking mode true, file exist", b = True)
		end

	test_open_writer
		local
			b : BOOLEAN
			name: C_STRING
			ec: INTEGER
			msg : STRING
		do
			-- Open as WRITER
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter)
			if not b then
				ec := tctdbecode (tdb)
				create msg.make_from_c(tctdberrmsg (ec))
				assert ("file not found", msg.is_equal("file not found"))
				-- require file exist
			end
			-- Open as WRITER and CREATE
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as WRITER but now the file exist
			b:= tctdbopen (tdb,name.item,oreader)
            assert("Open as writer mode true, file exist", b = True)
		end


	test_out2_database_is_closed
		local
			name : C_STRING
			key : C_STRING
			val : C_STRING
			b : BOOLEAN
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")

			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

            create key.make ("key")
            create val.make ("value")

            b := tctdbput3 (tdb, key.item, val.item)
            assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			b:=tctdbout2 (tdb, key.item)
			assert("Remove Element False", not b)
			assert ("Expected error code 2",tctdbecode (tdb)=2) -- Invalid Operation
		end


	test_out2_read_mode
		local
			name : C_STRING
			key : C_STRING
			val : C_STRING
			b : BOOLEAN
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")

			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

            create key.make ("key")
            create val.make ("value")

            b := tctdbput3 (tdb, key.item, val.item)
            assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			--Open as READER		
			b:= tctdbopen (tdb,name.item, oreader )
			b:=tctdbout2 (tdb, key.item)
			assert("Remove Element False", not b)
			assert ("Expected error code 2",tctdbecode (tdb)=2) -- Invalid Operation
		end

	test_sync_read_mode
		local
			name : C_STRING
			key : C_STRING
			val : C_STRING
			b : BOOLEAN
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")

			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

            create key.make ("key")
            create val.make ("value")

            b := tctdbput3 (tdb, key.item, val.item)
            assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			--Open as READER		
			b:= tctdbopen (tdb,name.item, oreader )
			b:=tctdbsync (tdb)
			assert("could no sync False", not b)
			assert ("Expected error code 2",tctdbecode (tdb)=2) -- Invalid Operation
		end

	test_sync_database_closed
		local
			name : C_STRING
			key : C_STRING
			val : C_STRING
			b : BOOLEAN
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")

			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

            create key.make ("key")
            create val.make ("value")

            b := tctdbput3 (tdb, key.item, val.item)
            assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			b:=tctdbsync (tdb)
			assert("could no sync False", not b)
			assert ("Expected error code 2",tctdbecode (tdb)=2) -- Invalid Operation
		end


	test_sync_database
		local
			name : C_STRING
			key : C_STRING
			val : C_STRING
			b : BOOLEAN
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")

			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

            create key.make ("key")
            create val.make ("value")

            b := tctdbput3 (tdb, key.item, val.item)
            assert ("Expected true", b = true)

			b:=tctdbsync (tdb)
			assert("could  sync False",b)
		end

	test_vsize2_database_closed
		local
			name : C_STRING
			key : C_STRING
			val : C_STRING
			b : BOOLEAN
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")

			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

            create key.make ("key")
            create val.make ("value")

            b := tctdbput3 (tdb, key.item, val.item)
            assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			assert("Expected -1",tctdbvsiz2 (tdb, key.item)=-1)
			assert ("Expected error code 2",tctdbecode (tdb)=2) -- Invalid Operation
		end



	test_vsize2_value_not_exist
		local
			name : C_STRING
			key : C_STRING
			b : BOOLEAN
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")

			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

            create key.make ("key")

			assert("Expected -1",tctdbvsiz2 (tdb, key.item)=-1)
			assert ("Expected error code 22",tctdbecode (tdb)=22) -- No record found
		end


	test_open_reader_put3
		local
			name : C_STRING
			key : C_STRING
			val : C_STRING
			b : BOOLEAN
			ec : INTEGER
			msg : STRING
		do
			-- Open as WRITER and CREATE
			create name.make ("casket.tct")

			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)
			b:=tctdbclose (tdb)

			-- Open again as READER but now the file exist
			b:= tctdbopen (tdb,name.item,oreader)
            assert("Open as read mode true, file exist", b = True)

            create key.make ("key")
            create val.make ("value")

            b := tctdbput3 (tdb, key.item, val.item)

			if not b then
				ec := tctdbecode (tdb)
				create msg.make_from_c(tctdberrmsg (ec))
				assert ("invalid operation", msg.is_equal("invalid operation"))
				-- put is not applicable when the open mode is read or read no locking or read locking no blocking
				-- so, put is applicable when the db is open in (writer modes)
			end
		end

	test_insert
		local
			k : C_STRING
			v : C_STRING
			name : C_STRING
			b : BOOLEAN
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			map := tcmapnew
			create k.make ("name")
			create v.make ("javier")
			tcmapput2 (map, k.item, v.item)
			create k.make ("age")
			create v.make ("30")
			tcmapput2 (map, k.item, v.item)
			create k.make ("lang")
			create v.make ("en,es")

			create k.make ("key")
			b:=tctdbput (tdb, k.item, k.count, map)
			assert ("Expected true", b = true)
			assert ("One Element", tctdbrnum (tdb) = 1)
		end

	test_search
		local
			k : C_STRING
			v : C_STRING
			name : C_STRING
			b : BOOLEAN
			qry : TC_TDB_QUERY
			tc_qry : POINTER
		do
			create name.make ("casket.tct")
			b:= tctdbopen (tdb,name.item,owriter.bit_or (ocreat) )
			assert ("Expected true", b = true)

			map := tcmapnew
			create k.make ("name")
			create v.make ("javier")
			tcmapput2 (map, k.item, v.item)
			create k.make ("age")
			create v.make ("30")
			tcmapput2 (map, k.item, v.item)
			create k.make ("lang")
			create v.make ("en,es")
			tcmapput2 (map, k.item, v.item)

			create k.make ("key")
			b:=tctdbput (tdb, k.item, k.count, map)
			assert ("Expected true", b = true)
			assert ("One Element", tctdbrnum (tdb) = 1)

			create k.make ("name")
			create v.make ("lara")
			tcmapput2 (map, k.item, v.item)
			create k.make ("age")
			create v.make ("3")
			tcmapput2 (map, k.item, v.item)
			create k.make ("lang")
			create v.make ("es")
			tcmapput2 (map, k.item, v.item)

			create k.make ("key1")
			b:=tctdbput (tdb, k.item, k.count, map)
			assert ("Expected true", b = true)
			assert ("Two Elements", tctdbrnum (tdb) = 2)


			create k.make ("name")
			create v.make ("pedro")
			tcmapput2 (map, k.item, v.item)
			create k.make ("age")
			create v.make ("24")
			tcmapput2 (map, k.item, v.item)
			create k.make ("lang")
			create v.make ("en,es,it")
			tcmapput2 (map, k.item, v.item)

			create k.make ("key2")
			b:=tctdbput (tdb, k.item, k.count, map)
			assert ("Expected true", b = true)
			assert ("Three Element", tctdbrnum (tdb) = 3)

            create qry
            tc_qry := qry.tctdbqrynew (tdb)

            create k.make ("age")
			create v.make ("20")
            qry.tctdbqryaddcond (tc_qry, k.item, qry.qcnumge, v.item)


            create k.make ("lang")
			create v.make ("en,es")
            qry.tctdbqryaddcond (tc_qry, k.item, qry.qcstror,v.item)

			create k.make ("name")
			qry.tctdbqrysetorder(tc_qry, k.item, qry.qostrasc)
            qry.tctdbqrysetlimit (tc_qry, 10,0)

    		list := qry.tctdbqrysearch (tc_qry)
    		assert ("Expected two elements", tclistnum (list) = 2)
		end

feature -- Implementation
	tdb : POINTER
		-- Table Database Object

	map : POINTER
		-- Map Object

	list : POINTER
		-- List Object

--OPEN MODES
--	OREADER : INTEGER is 1
--		-- open mode: open as a reader

--	OWRITER : INTEGER is 2
--		-- open mode: open as a writer

--	OCREAT : INTEGER is 4
--		-- open mode: writer creating

--	OTRUNC : INTEGER is 8
--		-- open mode: writer truncating

--	ONOLCK : INTEGER is 16
--		-- open mode: open without locking

--	OLCKNB : INTEGER is 32
--		-- open mode: lock without blocking

--	OTSYNC : INTEGER is 64
--		-- open mode: synchronize every transaction



--DEFINITION

--	
-- `TDBOWRITER                                                                                     open_writer : 			require file_exist

--	`TDBOCREAT', which means it creates a new database if not exist                                open_write_create        ensure : file_exist
--	`TDBOTRUNC'  which means it creates a new database regardless if one exists  ---->             open_writer_truncate  	require file_exist
--	`TDBOTSYNC', which means every transaction synchronizes updated contents with the device.      open_writer_syncronize	require file_exist
--	`TDBONOLCK', which means it opens the database file without file locking.                      open_writer_no_locking   require file_exist
--	`TDBOLCKNB', which means locking is performed without blocking.                                open_writer_no_blocking  require file_exist
--
--
--`TDBOREADER'
--	`TDBONOLCK', which means it opens the database file without file locking.                      open_reader               require file_exist
--	`TDBOLCKNB', which means locking is performed without blocking.                                open_reader_no_locking	 require file_exist
--                                                                                                 open_reader_no_blocking   require file_exist		

--	valid_open_modes : {as_writer, as_writer_create,as_writer_truncate,as_writer_syncronize,as_writer_no_bloking, as_reader,as_reader_no_locking,as_reader_no_bloking}
--	current_open_mode : set the current open mode
--  is_valid_open_mode : true if the open mode is in valid_open_modes, false in other case


-- table
-- feature name           ---      required open modes

end


